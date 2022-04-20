global class LeadAssignmentScheduler implements Schedulable {
    
    public static String JOB_NAME = 'LeadAssignmentJob';
    
    private List<Account> sendToList;
    private String leadId;
    private Integer hours;
    
    public LeadAssignmentScheduler(String leadId, List<Account> sendToList, Integer hours) {
        this.sendToList = sendToList;
        this.leadId = leadId;
        this.hours = hours;
    }
    
    global void execute(SchedulableContext sc) {
        
        sendLeadsToDealers();
        if (sc != null) {
            System.abortJob(sc.getTriggerId());
        }
    }
    
    public void sendLeadsToDealers() {
        
        if (hours != null && hours != 0) {
            
            Datetime createdBefore = Datetime.now().addHours(hours * (-1)).addSeconds(5);
            DateTime createdAfter = Datetime.now().addHours(hours * (-1)).addSeconds(-5);
            
            for (Opportunity opportunity : [SELECT StageName, CreatedDate FROM Opportunity WHERE Associated_Lead__c =: leadId]) {
                if (opportunity.CreatedDate > createdBefore || opportunity.CreatedDate < createdAfter) {
                    continue;
                }
                if (opportunity.StageName != 'New') {
                    return;
                }
            }
            
        }
        
        Lead lead = [SELECT Status, FirstName, LastName, Phone, Email, Street, City, State, PostalCode, Country, SDR_Notes__c FROM Lead WHERE Id = :leadId LIMIT 1 ][0];
        lead.Status = 'Sent to dealer';
        system.debug('sendToList>>>>>>>' + sendToList);
        List<Opportunity> opportunityToInsert = new List<Opportunity>();
        for (Account dealer : sendToList) {
        
            Opportunity opps = new Opportunity();
            opps.Name = dealer.Name + ' - ' + lead.LastName + ', ' + lead.FirstName;
            opps.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Telesales').getRecordTypeId();
            opps.StageName = lead.Status;
            opps.Street__c = lead.Street;
            opps.City__c = lead.City;
            opps.State_Province__c = lead.State;
            opps.Zip_Postal_Code__c = lead.PostalCode;
            opps.Country__c = lead.Country;
            opps.Phone__c = lead.Phone;
            opps.Associated_Lead_Email__c = lead.Email;
            opps.Email__c = lead.Email;
            opps.LeadGen_Notes__c = lead.SDR_Notes__c;
            opps.CloseDate = Date.today();
            opps.AccountId = dealer.Id;
            opps.ASM_User__c = dealer.OwnerId;
            opps.ISM_Account_Owner__c = dealer.ISM_Account_Owner__c;
            opps.ISM_Account_Owner_Email__c = dealer.ISM_Account_Owner__r.Email;
            opps.Associated_Lead__c = leadId;
            opps.ASM_Account_Owner_Email__c = dealer.Owner.Email;
            opps.ConvertedFromLead__c = true;
            opps.DealerLeadPrimaryContact__c = dealer.Dealer_Email_for_Leads__c;
            opps.LeadRecordTypeName__c = 'Design_Services';
            
            opportunityToInsert.add(opps);
        }
        
        if (lead != null){
            update lead;
            system.debug('lead' + lead);
        }
        
        if (opportunityToInsert.size() > 0){
            try {
                insert opportunityToInsert;
                system.debug('opportunityToInsert' + opportunityToInsert);
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        
    }
}