public with sharing class LeadAssignmentController {

    public static String ACCOUNT_RECORD_TYPE = 'Business Account';
    public static String SETTING_NAME = 'Dealer_Assignment_Settings';

    public Map<Id, Account> accountMap;

    public class DealerWrapper {

        public DealerWrapper(Account dealerAccount) {
            this.id = dealerAccount.Id;
            this.addressString1 = dealerAccount.BillingStreet == null ? '' : dealerAccount.BillingStreet.trim();
            this.addressString2 = dealerAccount.BillingCity == null ? '' : dealerAccount.BillingCity.trim();
            this.addressString3 = ((dealerAccount.BillingState == null ? '' : dealerAccount.BillingState)
                + ' ' + (dealerAccount.BillingCountry == null ? '' : dealerAccount.BillingCountry)
                + ' ' + (dealerAccount.BillingPostalCode == null ? '' : dealerAccount.BillingPostalCode)).trim();
            this.phone = dealerAccount.Dealer_Phone_for_Leads__c;
            this.milesFromLead = (dealerAccount.get('distance') != null) ? ((Decimal)dealerAccount.get('distance')).round() : 0;
            this.leadsSent = (dealerAccount.Opportunities != null) ? dealerAccount.Opportunities.size() : 0;
            this.isSelected = false;
            this.name = dealerAccount.Name;
            this.showroom = dealerAccount.Has_Certified_Showroom__c;
            this.level = dealerAccount.DealerLevel__c;
            this.score = Integer.valueOf(dealerAccount.DealerScore__c);
        }

        @AuraEnabled
        public String addressString1 { get;set; }

        @AuraEnabled
        public String addressString2 { get;set; }

        @AuraEnabled
        public String addressString3 { get;set; }

        @AuraEnabled
        public String addressString4 { get;set; }

        @AuraEnabled
        public String id { get;set; }

        @AuraEnabled
        public String phone { get;set; }

        @AuraEnabled
        public Decimal milesFromLead { get;set; }

        @AuraEnabled
        public Integer leadsSent { get;set; }
        
        @AuraEnabled
        public Boolean isSelected { get;set; }

        @AuraEnabled
        public String name { get;set; }

        @AuraEnabled
        public Boolean showroom { get;set; }

        @AuraEnabled
        public String level { get;set; }

        @AuraEnabled
        public Integer score { get;set; }
    }

    @AuraEnabled
    public static String getSettingURL(String leadId) {

        List<Dealer_Assignment__mdt> settings = [
            SELECT Id
            FROM Dealer_Assignment__mdt
            WHERE DeveloperName = :SETTING_NAME
        ];

        String settingURL;
        if (!settings.isEmpty()) {
            settingURL = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + settings[0].Id + '/e?retURL=%2Fapex%2FLeadAssignment%3Fid%3D' + leadId;
        }
        return settingURL;
    }

    @AuraEnabled
    public static List<DealerWrapper> getDealers(String leadId) {

        Id dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_RECORD_TYPE).getRecordTypeId();
			
        List<Dealer_Assignment__mdt> settings = [
            SELECT Leads_Sent_Time_Period__c
            FROM Dealer_Assignment__mdt
            WHERE DeveloperName = :SETTING_NAME
        ];
			system.debug('settings '+ settings);
        List<Lead> leads = [
            SELECT Country, State, City, Street, PostalCode,
                Latitude, Longitude
            FROM Lead
            WHERE Id = :leadId
        ];
	system.debug('leads >>>'+leads);
        List<DealerWrapper> wrappers = new List<DealerWrapper>();
        
        if (!settings.isEmpty() && !leads.isEmpty()) {

            Integer period = Integer.valueOf(settings[0].Leads_Sent_Time_Period__c);

            Double leadLatitude = leads[0].Latitude == null ? 0 : leads[0].Latitude;
            Double leadLongitude = leads[0].Longitude == null ? 0 : leads[0].Longitude;


            String query = 'SELECT Name, Dealer_Phone_for_Leads__c, BillingStreet, BillingCity, BillingCountry, BillingState, BillingPostalCode, Has_Certified_Showroom__c, DealerLevel__c, DealerScore__c,' +
                + ' BillingAddress, DISTANCE(BillingAddress, GEOLOCATION(' + leadLatitude + ',' + leadLongitude + '), \'mi\') distance,' +
                + ' (SELECT Id FROM Opportunities WHERE ConvertedFromLead__c = true AND CreatedDate = LAST_N_DAYS:' + period + ')' +
                + ' FROM Account WHERE RecordTypeId = \'' + dealerRecordTypeId + '\' AND BillingLatitude != null AND BillingLongitude != null AND Dealer_Type2__c = \'Control4\' AND Account_Status__c = \'Active\' AND DISTANCE(BillingAddress, GEOLOCATION(' + leadLatitude + ',' + leadLongitude + '), \'mi\') < 75' +
                + ' ORDER BY Has_Certified_Showroom__c desc, DISTANCE(BillingAddress, GEOLOCATION(' + leadLatitude + ',' + leadLongitude + '), \'mi\')' +
                + ' LIMIT 25';
	
            System.debug('Queeeeerrrry'+query);
			List<Account> acc = Database.query(query);
            for (Account dealer : acc) {
                system.debug('dealeraaaaaaa' + dealer);
                wrappers.add(new DealerWrapper(dealer));
            }
        }
		system.debug('wrappers>>>>>>>'+ wrappers);
        return wrappers;
    }

    @AuraEnabled
    public static void validateLead(String leadId) {

        List<Lead> leads = [
            SELECT City, State, Country, PostalCode
            FROM Lead
            WHERE Id = :leadId
        ];

        if (!leads.isEmpty()) {
            if ((String.isEmpty(leads[0].Country) || String.isEmpty(leads[0].State) || String.isEmpty(leads[0].City))
                && String.isEmpty(leads[0].PostalCode)) {

                throw new AuraHandledException('City, State, Country OR Zipcode are required!');
            }
        }
    }

    @AuraEnabled
    public static void sendLeadsToDealers(String leadId, String sendImmediatelyJson, String interval, String sendLaterJson) {

        List<DealerWrapper> sendImmediatelyList = (List<DealerWrapper>)JSON.deserialize(sendImmediatelyJson, List<DealerWrapper>.class);
        List<DealerWrapper> sendLaterList = (List<DealerWrapper>)JSON.deserialize(sendLaterJson, List<DealerWrapper>.class);
        system.debug('sendLaterList' + sendLaterList);
        
		
        LeadAssignmentScheduler sendImmediately = new LeadAssignmentScheduler(leadId, getAccountList(sendImmediatelyList), 0);
        sendImmediately.execute(null);

        if (!sendLaterList.isEmpty()) {

            LeadAssignmentScheduler sendLater = new LeadAssignmentScheduler(leadId, getAccountList(sendLaterList), Integer.valueOf(interval));

            Datetime currTime = Datetime.now();
            Integer hours = currTime.hour() + Integer.valueOf(interval);
            String hour = String.valueOf(Math.mod(hours, 24));
            String min = String.valueOf(currTime.minute());
            String ss = String.valueOf(currTime.second());        
            String cronExp = ss + ' ' + min + ' ' + hour + ' * * ?';

            System.schedule(LeadAssignmentScheduler.JOB_NAME + '_' + leadId + '_' + currTime.getTime(), cronExp, sendLater);
        }
    }

    private static List<Account> getAccountList(List<DealerWrapper> wrappers) {

        
        Set<Id> accIds = new Set<Id>();
        for (DealerWrapper wrapper : wrappers) {
            accIds.add(wrapper.id);  
        }
        List<Account> accList = [
            SELECT Id,Name, Dealer_Email_for_Leads__c, OwnerId, ISM_Account_Owner__c, ISM_Account_Owner__r.Email, Owner.Email
            FROM Account
            WHERE Id IN :accIds
        ];
        return accList;
    }
}