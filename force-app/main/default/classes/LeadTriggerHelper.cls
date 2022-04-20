/*
*       Description: Trigger helper for lead. This contains the methods run by the handler in its order of execution.
*
*       Sr.No.  Version     Author          Date(dd.MON.yyyy)       Description
*  
*       1       1.0         Team Simplus    16.AUG.2018             Initial Draft
*/

public with sharing class LeadTriggerHelper {
    
    public static Boolean isRunBeforeInsert = false;
    public static Boolean isRunBeforeUpdate = false;
    public static Boolean isRunAfterInsert = false;
    public static Boolean isRunAfterUpdate = false;

    public static Map<String, Schema.RecordTypeInfo> leadRecordTypes = Schema.SObjectType.Lead.getRecordTypeInfosByName();
    public static Map<String, Schema.RecordTypeInfo> accRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByName();
    public static Map<String, Schema.RecordTypeInfo> oppRecordTypes = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();

    //Auto-Populate Email for Lead
    public static void getAccountEmail(Map<Id, Lead> oldLeadMap, List<Lead> leadList) {
        
        Set<ID> AccId = new Set<ID>();
        Set<ID> AccId2 = new Set<ID>();   
        Set<ID> AccId3 = new Set<ID>(); 
        
        Set<ID> setAcctId = new Set<ID>();    
        Map<Lead,List<Id>> mapAcctId = new Map<Lead,List<Id>>();  
        For (Lead l: leadList) {  
            
            If (l.Dealer__c != null) {
                setAcctId.add(l.Dealer__c);
            }
            If (l.Dealer_2__c != null) {
                setAcctId.add(l.Dealer_2__c);
            }
            If (l.Dealer_3__c != null) {
                setAcctId.add(l.Dealer_3__c);
            }
        }
        
        Map<Id, Account> accountEntries = new Map<Id, Account>([SELECT Id, Dealer_Lead_Primary_Contact_Email__c, (SELECT ID, Primary_User__c, email, AccountId FROM Contacts) FROM Account WHERE Id in :setAcctId]);
        
        Map<String, EmailTemplate> emailTemplateMap = new Map<String, EmailTemplate>();
        for(EmailTemplate et : [SELECT Id, Name FROM EmailTemplate WHERE Name IN ('Lead has been assigned 1','Lead has been assigned 2','Lead has been assigned 3')]) {
            emailTemplateMap.put(et.Name, et);
        }
        
        List<String> usedThisTemplate = new List<String>();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        
        
        for (Lead l: leadList) {
            if(!oldLeadMap.containsKey(l.Id)) {
                continue ;
            }
            Lead oldLeadDetail = oldLeadMap.get(l.Id);
            
            List<string> dealers = new List<string>();
            if(l.Dealer__c != oldLeadDetail.Dealer__c){
                if(l.Dealer__c != null && l.OppOptOutEmail__c == FALSE){
                    dealers.add(l.Dealer__c);
                    usedThisTemplate.add(emailTemplateMap.get('Lead has been assigned 1').Id);
                }
            }
            
            if(l.Dealer_2__c != oldLeadDetail.Dealer_2__c){
                if(l.Dealer_2__c != null && l.OppOptOutEmail__c == FALSE){
                    dealers.add(l.Dealer_2__c);
                    usedThisTemplate.add(emailTemplateMap.get('Lead has been assigned 2').Id);
                }
            }
            
            if(l.Dealer_3__c != oldLeadDetail.Dealer_3__c ){
                if(l.Dealer_3__c != null && l.OppOptOutEmail__c == FALSE){
                    dealers.add(l.Dealer_3__c);
                    usedThisTemplate.add(emailTemplateMap.get('Lead has been assigned 3').Id);
                }
            }
            
            //For Dealer 1
            if (dealers.size() > 0) {
                for(integer i=0 ; i < dealers.size() ;i++){
                    Account acc = accountEntries.get(dealers[i]);
                    string currentTemplate = usedThisTemplate[i];
                    List<string> toaddress = new List<string>();
                    if (acc.Dealer_Lead_Primary_Contact_Email__c != null){
                        toaddress =acc.Dealer_Lead_Primary_Contact_Email__c.split(';');
                    }
                    else {
                        String accountId = acc.id;
                        List<Contact> accContacts = new List<Contact>();
                        for(Contact c: acc.Contacts){
                            if(c.AccountId == accountId){
                                accContacts.add(c);
                            }
                        }
                        
                        for(Contact c: accContacts){
                            if(c.Primary_User__c){
                                //l.Dealer1_Email__c = c.Email;
                                toaddress.add(c.Email);
                            }
                        }
                        
                    }
                    if(toaddress.size() > 0){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateID(currentTemplate); 
                        mail.setSaveAsActivity(false);
                        mail.setToAddresses(toaddress);
                        mail.setTargetObjectId(l.id);
                        mail.setTreatTargetObjectAsRecipient(false);
                        allmsg.add(mail);
                    }
                }
            }
        }
        Messaging.sendEmail(allmsg,false);
    }

    public static void assignLeadToTerritory(Map<Id, Lead> oldMap, List<Lead> leadList) {
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        for(Lead newLead : leadList) {
            if(!oldMap.containsKey(newLead.Id)) {
                continue ;
            }
            if(newLead.Run_Lead_Assignment__c && !oldMap.get(newLead.Id).Run_Lead_Assignment__c) {            
                leadMap.put(newLead.Id, newLead);
            }
            if(newLead.Lead_Queue_Name__c == 'Telesales') {
            newLead.Run_Lead_Assignment__c = true;}
            
        }
        
        if(leadMap.keyset().size() > 0) {
            List<Territory_Setup__c> leadTerrSetups = [SELECT Id, Next_Mass_Update_Date_Lead__c, Status__c 
                                                        FROM Territory_Setup__c 
                                                        ORDER BY LastModifiedDate DESC LIMIT 1];
            if(leadTerrSetups.size() > 0 && leadTerrSetups[0].Status__c == 'on') {  
                String strFields = '';
                for(String strField : Schema.SObjectType.Lead.fields.getMap().keySet()) {
                    //added an exclusion for geocodeaccuracy as it returns an error
                    if (strfield != 'geocodeaccuracy'){
                        strFields += strField + ', ';
                    }
                }
                String m_strAllLeadFields = strFields.substring(0, strFields.length()-2);
                String strFilterInQuery = 'WHERE Id IN (';
                for(Id leadId : leadMap.keyset()) {
                    strFilterInQuery += '\'' + leadId + '\', ';
                }
                strFilterInQuery = strFilterInQuery.substring(0, strFilterInQuery.length()-2);
                strFilterInQuery += ')';
                String strQuery = 'SELECT ' + m_strAllLeadFields + ' FROM Lead ' + strFilterInQuery;
                system.debug('@@@ '+strQuery);
                if (!System.isBatch()&&!Test.isRunningTest()) {
                    ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadMap);
                    Database.executeBatch(reassignLeadBatchJob, 1);
                }else{/* returns an error "Methods defined as TestMethod do not support Web service callouts"
                    if (Test.isRunningTest()) { 
                        ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadMap);
                        Database.executeBatch(reassignLeadBatchJob, 200);   
                    }   
                    */
                }
            }       
        }
    }

    public static void leadTracking(Map<Id, Lead> oldMap, List<Lead> newList) {
        Id telesalesRecordTypeId = leadRecordTypes.get('Telesales').getRecordTypeId();
        for(Lead newLead : newList) {
            if(!oldMap.containsKey(newLead.Id)) {
                continue ;
            }
            Lead oldLead = oldMap.get(newLead.Id);
            if(newLead.Status != oldLead.Status && newLead.RecordTypeId == telesalesRecordTypeId) {
                if(oldLead.Status == 'Sent To Dealer'){
                    newLead.Sent_To_Dealer_End_Date__c = Date.today();
                }

                if(oldLead.Status == 'Opportunity Created'){
                    newLead.Opportunity_Created_End_Date__c = Date.today();
                }

                if(oldLead.Status == 'Installed'){
                    newLead.Installed_End_Date__c = Date.today();
                }

                if(oldLead.Status == 'Term Lead'){
                    newLead.Term_Lead_End_Date__c = Date.today();
                }

                if(oldLead.Status == 'Renewed Interest'){
                    newLead.Renewed_Interest_End_Date__c = Date.today();
                }

                if(oldLead.Status == 'New'){
                    newLead.New_End_Date__c = Date.today();
                }

                if(oldLead.Status == 'Attempting Contact') {
                    newLead.Attempting_Contact_End_Date__c = Date.today();
                }

                if(newLead.Status == 'Attempting Contact') {
                    newLead.Status_Previous_Value__c = oldLead.Status;
                    newLead.Attempting_Contact_Start_Date__c  = Date.today();
                }

                if(newLead.Status == 'Sent To Dealer') {
                    newLead.Status_Previous_Value__c = oldLead.Status;
                    newLead.Sent_To_Dealer_Start_Date__c  = Date.today();
                }

                if(newLead.Status == 'Opportunity Created') {
                    newLead.Status_Previous_Value__c = oldLead.Status;
                    newLead.Opportunity_Created_Start_Date__c  = Date.today();
                }

                if(newLead.Status == 'Installed') {
                    newLead.Status_Previous_Value__c = oldLead.Status;
                    newLead.Installed_Start_Date__c  = Date.today();
                }

                if(newLead.Status == 'Term Lead') {
                    newLead.Status_Previous_Value__c = oldLead.Status;
                    newLead.Term_Lead_Start_Date__c  = Date.today();
                }

                if(newLead.Status == 'Renewed Interest') {
                    newLead.Status_Previous_Value__c = oldLead.Status;
                    newLead.Renewed_Interest_Start_Date__c  = Date.today();
                }
            }
        }
    }

    public static void leadToOppConvert(Map<Id, Lead> oldMap, List<Lead> newList) {
        //Set up the ID trackers
        Set<ID> setLeadIds = new Set<ID>();
        Set<ID> setDealerIds = new Set<ID>();

        //Map the Lead IDs from the Trigger
        for(Lead newLead : newList) {
            if(newLead.Status == 'Committed') {
                setLeadIds.add(newLead.Id);
                setDealerIds.add(newLead.Dealer__r.ID);
            }
        }

        //Get all the opportunities
        for (Opportunity op : [SELECT Id, AccountID, Associated_Lead__c, StageName FROM Opportunity WHERE Associated_Lead__r.Id IN : setLeadIds]) {
            op.StageName = 'Closed Lost';
            update op;
        }
    }
/*
	//commented out as it was mentioned that there is no instance tthat a lead is converted to a person account
	public static void leadToPersonAccount(List<Lead> newList) {
        Set<String> leadEmails = new Set<String>();
        Set<String> leadPhones = new Set<String>();
        List<Lead> newLeads = new List<Lead>();
        
        //Get record type ids here. DO NOT HARD CODE RECORD TYPE IDs
        Id designServicesId = leadRecordTypes.get('Design Services').getRecordTypeId();
        
        Id personAccountRecordTypeId = accRecordTypes.get('Person Account').getRecordTypeId();
        Id csPersonAccountRecordTypeId = accRecordTypes.get('CS Person Account').getRecordTypeId();
        Id csCaseAccountRecordTypeId = accRecordTypes.get('CS Case').getRecordTypeId();

        List<Id> acceptedRecordTypeIds = new List<Id> {
            personAccountRecordTypeId,
            csPersonAccountRecordTypeId, 
            csCaseAccountRecordTypeId
        };

        // Get all the new leads
        for (Lead newLead : newList) {
            if(newLead.Email != Null || newLead.Phone != Null){
                newLeads.add(newLead);
                leadEmails.add(newLead.Email);
                leadPhones.add(newLead.Phone);
            }
        }
        system.debug('@@@ entered leadToPersonAccount');
        //Make some maps of account and email addresses 
        List<Account> accountList = [SELECT Id, RecordTypeId, PersonEmail, Phone, OwnerId FROM Account WHERE PersonEmail IN :leadEmails AND PersonEmail != null AND RecordTypeId IN :acceptedRecordTypeIds LIMIT 1];
        List<Account> accountListPH = [SELECT Id, RecordTypeId, PersonEmail, Phone, OwnerId FROM Account WHERE Phone IN :leadPhones AND Phone != null AND RecordTypeId IN :acceptedRecordTypeIds LIMIT 1];
        Map<Id, String> peAccounts = new Map<Id, String>();
        Map<Id, String> peAccountsph = new Map<Id, String>();
        Map<Id, Id> peAccountsOwner = new Map<Id, Id>();
        Map<Id, Id> peAccountsOwnerph = new Map<Id, Id>();
        
        // Generic map for preventing loss of Ids
        for(Account a : accountList) {
            peAccounts.put(a.Id, a.PersonEmail);
            peAccountsOwner.put(a.Id, a.OwnerId);
        }
        for(Account a : accountListPH) {
            peAccountsph.put(a.Id, a.Phone);
            peAccountsOwnerph.put(a.Id, a.OwnerId);   
        }
        
        // We will need this to get the Id from the email address
        Map<String, Id> peAccountsFlipped = new Map<String, Id>();
        Map<String, Id> peAccountsFlippedph = new Map<String, Id>();
        for(Id i : peAccounts.keyset()) {
            peAccountsFlipped.put(peAccounts.get(i), i);
        }
        for(Id i : peAccountsph.keyset()) {
            peAccountsFlippedph.put(peAccountsph.get(i), i);
        }
        
        //System Conversion Requirements 
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        Database.LeadConvert lc;
        
        //Configuring Payload 
        
        for (Lead nl : newLeads) {
            system.debug('RODNEY NEWLEAD '+nl);
            Boolean didConvert = false;
            if(nl.Email != Null && nl.Company == Null && nl.RecordTypeId != designServicesId && !nl.From_Balihoo__c) {
                // Check to see if account already exists
                if(!peAccounts.isEmpty())
                {
                    if(peAccountsFlipped.get(nl.Email)!=null)
                    {
                        If(nl.IsConverted != True && nl.Id != NULL )
                        {
                            lc = new Database.LeadConvert();
                            lc.setLeadId(nl.id);
                            lc.setOverwriteLeadSource(false);
                            lc.setConvertedStatus('Installed');
                            lc.setAccountId(peAccountsFlipped.get(nl.Email));
                            lc.setOwnerId(peAccountsOwner.get(peAccountsFlipped.get(nl.Email)));
                            lc.setDoNotCreateOpportunity(true);
                            leadConverts.add(lc);
                            // Fire Payload
                            //Database.LeadConvertResult[] lcr = Database.convertLead(leadConverts);
                            //System.debug(LoggingLevel.INFO, lcr);
                            didConvert = true;
                        }
                    }
                }
            }
            if(didConvert == false && nl.Phone != Null && nl.Company == Null && nl.RecordTypeId != designServicesId && !nl.From_Balihoo__c) {
                // Check to see if account already exists
                if(!peAccountsph.isEmpty()) {
                    if(peAccountsFlippedph.get(nl.Phone)!=null) {
                        if(nl.IsConverted != True && nl.Id != NULL) {
                            lc = new Database.LeadConvert();
                            lc.setLeadId(nl.id);
                            lc.setOverwriteLeadSource(false);
                            lc.setConvertedStatus('Installed');
                            lc.setAccountId(peAccountsFlippedph.get(nl.Phone));
                            lc.setOwnerId(peAccountsOwnerph.get(peAccountsFlippedph.get(nl.Phone)));
                            lc.setDoNotCreateOpportunity(true);
                            leadConverts.add(lc);
                            // Fire Payload
                            //Database.LeadConvertResult[] lcr = Database.convertLead(leadConverts);
                            //System.debug(LoggingLevel.INFO, lcr);
                        }
                    }
                }
            }
        }
        system.debug('RODNEY LEAD CONVERTS '+leadConverts);
        // Logic to be able to convert more than 100 leads
        if(!leadConverts.isEmpty()){
            for(Integer i = 0; i <= leadConverts.size()/100 ; i++){
                list<Database.LeadConvert> tempList = new list<Database.LeadConvert>();
                Integer startIndex = i*100;
                Integer endIndex = ((startIndex+100) < leadConverts.size()) ? startIndex+100: leadConverts.size();
                for(Integer j=startIndex;j<endIndex;j++){
                    tempList.add(leadConverts[j]);
                }
                Database.LeadConvertResult[] lcrList = Database.convertLead(tempList, false);
                for(Database.LeadConvertResult lcr : lcrList){
                    System.assert(lcr.isSuccess(), 'LCR failed:'+lcr);
                    for(Lead l : newLeads) {
                        if(l.Id == lcr.getLeadId()) {
                            System.debug('error lead: ' + l);
                        }
                    }
                }
                    
            }
        }
    }
	*/
    //method to assign appropriate User, Queue or Group based on an active assignment rule - commented out as this was merged to leadToDealerOpp
    /*public static void runLeadAssignmentRule(List<Lead> listLeads){
        // Get an Active Lead Assignement Rule Id
        Id leadAssignmentRuleId = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Lead' AND Active = true][0].Id;
        
        // Set Assignment Rule Header with an active assignment rule id
        Database.DMLOptions dmlOptInst = new Database.DMLOptions();
        dmlOptInst.assignmentRuleHeader.assignmentRuleId = leadAssignmentRuleId;
        
        // Set to hold Id's for Leads recently inserted
        Set<Id> setLeadId = new Set<Id>();
        
        // List of Leads to update
        List<Lead> listLeadToUpdate = new List<Lead>();
        
        // Get set of Lead ids
        for(Lead objLead : listLeads) {
            setLeadId.add(objLead.Id);
        }
        
        // Query on Leads to get all the Leads in the set and update the list of Leads
        for(Lead objLead : listLeads) {
            Lead l = objLead.clone(true, true, true, true);
            objLead.setOptions(dmlOptInst);
            listLeadToUpdate.add(l);
        }
        
        // Carry out update activity on Leads
        TriggerHandler.bypass('LeadTriggerHandler');
        Database.update(listLeadToUpdate);
        TriggerHandler.clearBypass('LeadTriggerHandler');
    }
    */
    // The one method your master trigger will call
    public static void recordLeadInfoToAccount(Map<Id, Lead> oldMap, List<Lead> newList) {
        //call handler.after method
        List<Id> accountIds=new list<ID>();
        for(Lead lead: newList) {
            if(lead.IsConverted==true && lead.ConvertedAccountid!=null) {
                accountIds.add(lead.ConvertedAccountId);
            } 
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Converted_from_Lead__c FROM Account WHERE Id IN :accountIds]);
        System.debug('Account Map: ' + accountMap.Size());
        List<Account> updateAccount=new list<Account>();
        for(Lead l: newList) {
            System.debug('Old Vlaue: ' + oldMap.get(l.Id).IsConverted);
            if(l.IsConverted==true && oldMap.get(l.Id).IsConverted==false && l.ConvertedAccountid!=null)
            {
                System.debug(l.ConvertedDate);
                Date ConvertDate=l.ConvertedDate;
                if(convertDate==null) ConvertDate=Date.Today();
                accountMap.get(l.ConvertedAccountid).Converted_from_Lead__c=convertDate;
                Date createdDate=l.CreatedDate.Date();
                accountMap.get(l.ConvertedAccountid).Time_to_sell__c = createdDate.daysBetween(convertDate);
                updateAccount.add(accountMap.get(l.ConvertedAccountid));
            }
        }       
        //update updateAccount;//converted to map to prevent duplicate IDs
        Map <id, account> updateAccountMap = new Map <id, account> ();
        if (updateAccount.size()>0){
            for(Account a: updateAccount){
                updateAccountMap.put(a.id,a);        
            }
            update updateAccountMap.values();            
        } 
        
        
    }

    //Lead to dealer opp
    public static void leadToDealerOpp(List<Lead> newList) {
        //Get the Opportunity lists
        list<Opportunity> oppList = new list<Opportunity>();
        Map<Id,Lead> leadsToUpdate = new Map<Id,Lead>();
        
        // Get an Active Lead Assignement Rule Id. - Merged from runLeadAssignmentRule.
        Id leadAssignmentRuleId = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Lead' AND Active = true][0].Id;
        
        // Set Assignment Rule Header with an active assignment rule id - Merged from runLeadAssignmentRule.
        Database.DMLOptions dmlOptInst = new Database.DMLOptions();
        dmlOptInst.assignmentRuleHeader.assignmentRuleId = leadAssignmentRuleId;
        
        // Process updated leads and check for the need to create new Opportunities
        for(Lead ld : newList) {
            // Create new instance of lead to allow updating again
            system.debug('RODNEY BEFORE CLONE '+ld.id+ld.Opportunity_Created__c);
            Lead l = ld.clone(true, true, true, true);
            
            system.debug('RODNEY BEFORE CLONE '+l.id+l.Opportunity_Created__c);
            // Don't make changes to converted leads because the system gets angry
            if(l.IsConverted == false){
                
                // If we have a new Dealer 1 that hasn't been processed before, then create the new Opp and tag the lead as processed
                if(l.Dealer__c != Null  && l.Opportunity_Created__c == false)
                {
                    oppList.add(createOppFromLead(l, l.Dealer__c));
                    l.Opportunity_Created__c = true;
                    l.Status = 'Opportunity Created';
                    leadsToUpdate.put(l.Id, l);
                }
                
                // If we have a new Dealer 2 that hasn't been processed before, then create the new Opp and tag the lead as processed
                if(l.Dealer_2__c != Null  && l.Opportunity_Created_2__c == false)
                {
                    oppList.add(createOppFromLead(l, l.Dealer_2__c));
                    l.Opportunity_Created_2__c = true;
                    l.Status = 'Opportunity Created';
                    leadsToUpdate.put(l.Id, l);
                }
                // If we have a new Dealer 3 that hasn't been processed before, then create the new Opp and tag the lead as processed
                if(l.Dealer_3__c != Null  && l.Opportunity_Created_3__c == false)
                {
                    oppList.add(createOppFromLead(l, l.Dealer_3__c));
                    l.Opportunity_Created_3__c = true;
                    l.Status = 'Opportunity Created';
                    leadsToUpdate.put(l.Id, l);
                }
            }
            //- Merged from runLeadAssignmentRule.
            //l.setOptions(dmlOptInst);
            leadsToUpdate.put(l.Id, l);
        }
        
        if(oppList.size() > 0)
            Database.insert(oppList);
        
        if(leadsToUpdate.size() > 0) {
            TriggerHandler.bypass('LeadTriggerHandler');
            Database.update(leadsToUpdate.values());
            TriggerHandler.clearBypass('LeadTriggerHandler');
        }
    }
    
    private static Opportunity createOppFromLead(Lead ld, Id dealerId) {
        //Create the opportunity based off lead information
        Opportunity lc = new Opportunity();
        if(ld.From_Balihoo__c){
            lc.RecordTypeId = oppRecordTypes.get('Balihoo').getRecordTypeId();
        }else{
            lc.RecordTypeId = oppRecordTypes.get('Telesales').getRecordTypeId();
        }
        lc.Name = ld.Name == null? ld.FirstName + ' ' + ld.LastName : ld.Name;
        lc.Phone__c = ld.Phone;
        lc.City__c = ld.City;
        lc.Email__c = ld.Email;
        lc.State_Province__c = ld.State;
        lc.Country__c = ld.Country;
        lc.Zip_Postal_Code__c = ld.PostalCode;
        lc.Street__c = ld.Street;
        lc.Associated_Lead__c = ld.id;
        lc.AccountId = dealerId;
        lc.StageName = 'Sent to Dealer';
        lc.Entertainment__c = ld.Entertainment__c;
        lc.LightingSolutions__c = ld.Lighting__c;
        lc.Comfort_Convenience__c = ld.Comfort_Convenience__c;
        lc.Safety_Security__c = ld.Safety_Security__c;
        lc.Smart_Phone_User__c = ld.Smart_Phone_User__c;
        lc.Entertain_A_Lot__c = ld.Entertain_A_Lot__c;
        lc.Physical_Limitations__c = ld.Physical_Limitations__c;
        lc.Energy_Efficient__c = ld.Energy_Efficient__c;
        lc.Control4_Interest__c = ld.Control4_Interest__c;
        lc.Away_from_Home_Often__c = ld.Away_from_Home_Often__c;
        lc.Approximate_Home_Value__c = ld.Approximate_Home_Value__c;
        lc.Square_Footage__c = ld.Square_Footage__c;
        lc.Number_Of_Bathrooms__c = ld.Number_Of_Bathrooms__c;
        lc.Number_Of_Bedrooms__c = ld.Number_Of_Bedrooms__c;
        lc.Project_Spaces__c = ld.Project_Spaces__c;
        lc.Time_Frame__c = ld.Time_Frame__c;
        lc.Automation_Objective__c = ld.Automation_Objective__c;
        lc.Home_Entertainment__c = ld.Home_Entertainment__c;
        lc.Climate_Comfort__c = ld.Climate_Comfort__c;
        lc.Communication__c = ld.Communication__c;
        lc.Security_Monitoring__c = ld.Security_Monitoring__c;
        lc.Control_Objective__c = ld.Control_Objective__c;
        lc.Lighting__c = ld.LightingSolutions__c;
        lc.Music__c = ld.Music__c;
        lc.Subject__c = ld.Lead_Subject__c;
        lc.Description = ld.Description;
        lc.Balihoo_Comments__c = ld.Lead_Message__c;
        lc.CloseDate = System.today().addDays(180);
        return lc;
    }

    public static void updateLostOpps(List<Lead> newList) {
        //Set up the ID trackers
        Set<ID> leadid = new Set<ID>();
        //Map the Lead IDs from the Trigger
        for(Lead l : newList) {
            if(l.Status.equals('Installed'))
                leadid.add(l.Id);
        }
        //Get all the opportunities
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Opportunity op : [SELECT Id, AccountID, Associated_Lead__c,StageName FROM Opportunity WHERE Associated_Lead__r.id IN : leadid AND StageName != 'Closed Won']) {
            op.StageName = 'Closed Lost';
            op.Closed_Lost_Reasons__c = 'Associated lead status is installed.';
            oppsToUpdate.add(op);
        }
        if(oppsToUpdate.size() > 0) update oppsToUpdate;
    }

    // This method update Opportunity Name by Lead's Subject if Lead is converted and adds attachment to converted Opportunity.
    public static void updateOppNameToLeadSubject(List<Lead> newLeadList) {
        List<Lead> leadList = new List<Lead>();
        
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id,Lead> convertedConIdLeadObjMap = new Map<Id,Lead>();
        List<Attachment> insertAttachmentList = new List<Attachment>();
        
        // Method with trigger.new as parameter value to update Opportunities field 'Contact Name' with 
        // 'Lead Name' on Lead conversion
        // List to hold Opportunities to carry out update
        List<Opportunity> updateOppList = new List<Opportunity>();
        
        // Map of Opportunity Id and Lead Id
        Map<Id,Id> mapOppId_LeadId = new Map<Id,Id>();
        
        // Map of Lead id and index of list where Lead id is present in the list acquired as parameter
        Map<Id, Integer> mapLeadId_LeadIndex = new Map<Id, Integer>();
        
        // Added in version 1.1
        // Set of Attachments Id's from AttachmentIds__c field on Lead to be used by a query on Attachments
        Set<Id> attachmentIdSet = new Set<Id>();
        
        // Iterate on list of leads acquired in parameter add Lead Id and its index to map
        for(Integer index = 0; index < newLeadList.size(); index++){
            mapLeadId_LeadIndex.put(newLeadList[index].Id, index);
        }
        
        
        // Get record type Id for Lead for record type label 'Design Services'
        Id leadRecordTypeId = leadRecordTypes.get(Label.Lead_Design_Services).getRecordTypeId();
        
        // Added field AttachmentIds__c to Query in version 1.1
        // Check if the Lead is converted and is in the list obtained above    
        for(Lead leadObj : [Select 
                            Id,
                            LastName,
                            Name,
                            Status,
                            ConvertedOpportunityId,
                            ConvertedAccountId,
                            ConvertedContactId,
                            ConvertedOpportunity.Name,
                            Lead_Subject__c,
                            RecordTypeId,
                            Dealer_Name__r.OwnerId,
                            AttachmentIds__c
                            From Lead 
                            Where isConverted = true                                
                            And Id IN : newLeadList]) {
                                
            // Add obtained Leads to a list
            leadList.add(leadObj);
                                
            // Check if ConvertedOpportunityId is not empty or null
            if( leadObj.ConvertedOpportunityId != null &&
                String.isNotBlank(leadObj.ConvertedOpportunityId)) {
                // Check if ConvertedContactId not null if true then add it to a set and fill a map
                if(leadObj.ConvertedContactId != null){
                    contactIdSet.add(leadObj.ConvertedContactId);
                    convertedConIdLeadObjMap.put(leadObj.ConvertedContactId,leadObj);
                    // Set 'Contact Name' field with ConvertedContactId
                    leadObj.ConvertedOpportunity.Contact_Name__c = leadObj.ConvertedContactId;
                    
                    // If block added in version 1.1
                    // Check if AttachmentIds__c is not blank and add Attachment Id's to a set
                    // which will be used by a query later
                    if(leadObj.AttachmentIds__c != null && String.isNotEmpty(leadObj.AttachmentIds__c)){
                        attachmentIdSet.addAll( (List<Id>)leadObj.AttachmentIds__c.split(',') );
                    }
                }
                // To test exception handling while updating Opportunities
                if(Test.isRunningTest()){
                    // Check for Last Name as 'Test Lead Test Running' and set 
                    // Opportunities Name to null
                    // so that we can receive an error
                    if(leadObj.LastName.contains('Test Lead Test Running')){
                        leadObj.ConvertedOpportunity.Name = null;
                    }
                }
                                       
                //updateOppList.add(leadObj.ConvertedOpportunity);
                
                mapOppId_LeadId.put(leadObj.ConvertedOpportunityId, leadObj.Id);
                
                
                // Check if record type id queried is not null
                if(leadRecordTypeId != null){
                    
                    // If record type id for the record equals design services record type id
                    // then update converted Opportunities name with Leas Subject if Lead Subject is 
                    // not null or blank. Also update Opportunities Owner with Dealer's Owner Id
                    if(leadObj.RecordTypeId == leadRecordTypeId){
                        /* Commented as no approval received for the code's functionality
                        if(leadObj.Lead_Subject__c != null 
                        && String.isNotBlank(leadObj.Lead_Subject__c)){
                        leadObj.ConvertedOpportunity.Name = leadObj.Lead_Subject__c;
                        }
                        */
                        if(leadObj.Dealer_Name__c != null){
                            leadObj.ConvertedOpportunity.OwnerId = leadObj.Dealer_Name__r.OwnerId;
                        }                                               
                    }
                    
                }
                                       
                // Add the Opportunities to a list when criterias are met
                if((leadObj.Dealer_Name__c != null) || (leadObj.ConvertedOpportunity.Contact_Name__c != null)){
                    updateOppList.add(leadObj.ConvertedOpportunity);
                }
                                       
            }
        }
        
        // Check if list of Opportunities to update is not null
        if(updateOppList != null && !updateOppList.isEmpty()){
            try{
                // Update Opportunities for 'Contact Name' field
                update updateOppList;
            }catch(System.DMLException objExcep){
                
                // Get count of DML exceptions and add error to corresponding Lead 
                for(Integer index = 0; index < objExcep.getNumDml(); index++ ){
                    
                    // Check exception for index is not null
                    if(objExcep.getDmlId(index) != null){   
                        
                        // Check Id obtained is of Opportunity and map has this Opportunity Id
                        if( mapOppId_LeadId.containsKey(objExcep.getDmlId(index))){                               
                            // Add error to the Lead at a particular index of the acquired Lead's list
                            newLeadList[mapLeadId_LeadIndex.get(mapOppId_LeadId.get(objExcep.getDmlId(index)))].addError(objExcep.getDmlMessage(index));
                        }
                    }
                }
                
            }
        }
        // Replaced contactIdSet with attachmentIdSet in version 1.1
        // Get all the Attachments under id refrenced by ConvertedContactId
        for(Attachment attachmentObj : [SELECT Body,BodyLength,ContentType,Description,Id,IsDeleted,IsPrivate,Name,ParentId,Parent.Name
                                        FROM Attachment 
                                        WHERE Id IN : attachmentIdSet And IsDeleted = false ]){
            Attachment attachment = new Attachment();
            
            // Check if map contains parent id if true than clone the attachment record
            if(convertedConIdLeadObjMap.get(attachmentObj.ParentId) != null){
                attachment.Body = attachmentObj.Body;
                attachment.Name = String.valueOf(attachmentObj.Name);
                attachment.ParentId = 
                    convertedConIdLeadObjMap.get(attachmentObj.ParentId).ConvertedOpportunityId;
                attachment.ContentType = attachmentObj.ContentType;
                attachment.Description = attachmentObj.Description;
                attachment.IsPrivate = attachmentObj.IsPrivate;
                
                // Add new attachment to list of all attachments to insert
                insertAttachmentList.add(attachment);
            }
            
        }
        
        // Create new Attachments for Opportunities
        if(!insertAttachmentList.isEmpty()) {
            try{
                insert insertAttachmentList;
            }catch(System.DMLException objExcep)
            {
                // Get count of DML exceptions and add error to corresponding Lead 
                for(Integer index = 0; index < objExcep.getNumDml(); index++ ){
                    
                    // Check exception for index is not null
                    if(objExcep.getDmlId(index) != null){
                        
                        // Get Id from exception
                        Id objExcepAttchId = objExcep.getDmlId(index);
                        
                        // Check Id obtained is of Opportunity and map has this Opportunity Id
                        if( objExcepAttchId.getSObjectType() == Attachment.getSObjectType() 
                           && mapOppId_LeadId.containsKey(objExcepAttchId)){
                               
                           }
                        
                    } 
                }
                
            }
        }
    }

    public static void updateDesignerServices(List<Lead> newList) {  
        Set<ID> leadid = new Set<ID>();
        set<ID> oppId = new Set<ID>();
        system.debug('simplus test here');
        //string recordTypeId = [select Id from RecordType where SObjectType = 'Opportunity' AND DeveloperName = 'Design_Services'].Id;
        String designServicesRecordTypeIdOpp = oppRecordTypes.get('Design_Services').getRecordTypeId();
        String designServicesRecordTypeIdLead = leadRecordTypes.get('Design Services').getRecordTypeId();
        
        if (designServicesRecordTypeIdLead != null) {
            for(Lead l : newList){
                if(l.RecordTypeId == designServicesRecordTypeIdLead){
                    leadid.add(l.Id);
                    oppId.add(l.ConvertedOpportunityId);
                }
            }
            system.debug('sampleLead' + leadid);
            if(leadid.size() > 0){
                List<Opportunity> opplist = new List<Opportunity>();
                List<String> ismAccountOwner = new List<String>();
                system.debug('sampleopp' + opplist);
                for(Opportunity op : [SELECT Id, AccountID,Associated_Lead__c,StageName,recordtypeid, Account.ISM_Account_Owner__c, Account.ISM_Account_Owner__r.isactive ,OwnerId, Account.OwnerId FROM Opportunity WHERE id IN : oppId]) {
                    if(op.Account.ISM_Account_Owner__c != null && op.Account.ISM_Account_Owner__r.isactive){
                        op.OwnerId = op.Account.ISM_Account_Owner__c; 
                    }else{
                        op.OwnerId = op.Account.OwnerId;
                    }
                    op.RecordTypeId = designServicesRecordTypeIdOpp;
                    op.StageName = 'New Design Opportunity';
                    
                    opplist.add(op);
                }

                if(opplist.size() > 0 ) {
                    update opplist;
                }
            }
        }
    }

    public static void leadDesign(List<Lead> leadList){
        Id leadRT = leadRecordTypes.get('Design Services').getRecordTypeId(); 
        Map<String,Schema.RecordTypeInfo> designservicesRTList = Schema.SObjectType.Design_Services__c.getRecordTypeInfosByName();
        List<Design_Services__c> newDesignList = new List<Design_Services__c>();            
       
        for(Lead newLead:leadList){
            if(newLead.RecordTypeId == leadRT ){                
                if(newLead.Is_Theater_Filled__c == true){    
                    newDesignList.add(createRecord(newLead, designservicesRTList.get('Theater Design').getRecordTypeId(), 'Theater Design'));   
                }
                if(newLead.Is_Audio_Filled__c == true){                  
                    newDesignList.add(createRecord(newLead, designservicesRTList.get('Audio Design').getRecordTypeId(), 'Audio Design'));
                }
                if(newLead.Is_Lightning_Filled__c == true){
                    newDesignList.add(createRecord(newLead, designservicesRTList.get('Lighting Design').getRecordTypeId(), 'Lighting Design'));
                } 
                if(newLead.Is_Network_Filled__c == true){
                    newDesignList.add(createRecord(newLead, designservicesRTList.get('Network Design').getRecordTypeId(), 'Network Design'));                   
                }                                                      
            }
        }
        if(!newDesignList.isEmpty()){
            insert newDesignList;
        }
        
    }

    private static Design_Services__c createRecord(Lead leadRec, Id leadRT, String recTypeName ){
         
        Design_Services__c newDesignRecord = new Design_Services__c();         
        if(recTypeName=='Theater Design') {
            newDesignRecord.RecordTypeId = leadRT;
            newDesignRecord.Theater_Type__c = leadRec.Theater_Type__c;
            newDesignRecord.Theater_Floorplan__c = leadRec.Theater_Floorplan__c;
            newDesignRecord.Theater_Floor_Plan_Available__c = leadRec.Theater_Floor_Plan_Available__c;
            newDesignRecord.Theater_Dimensions__c = leadRec.Theater_Dimensions__c;
            newDesignRecord.Theater_Display__c = leadRec.Theater_Display__c;
            newDesignRecord.Theater_Display_Type__c = leadRec.Theater_Display_Type__c;
            newDesignRecord.Theater_Electronics__c = leadRec.Theater_Electronics__c;
            newDesignRecord.Theater_Ceiling_Depth__c = leadRec.Theater_Ceiling_Depth__c;
            newDesignRecord.Theater_Wall_Depth__c = leadRec.Theater_Wall_Depth__c;
            newDesignRecord.Theater_Seating__c = leadRec.Theater_Seating__c;
            newDesignRecord.Theater_Speaker_Placement__c = leadRec.Theater_Speaker_Placement__c;
            newDesignRecord.Theater_Speaker_Layout__c = leadRec.Theater_Speaker_Layout__c;
            newDesignRecord.Theater_Speaker_Line__c = leadRec.Theater_Speaker_Line__c;
            newDesignRecord.Theater_Max_Volume__c = leadRec.Theater_Max_Volume__c;
            newDesignRecord.Theater_Customer_Budget__c = leadRec.Theater_Customer_Budget__c;
            newDesignRecord.Theater_Challenges__c = leadRec.Theater_Challenges__c;
        }   
        if(recTypeName=='Audio Design') {
            newDesignRecord.RecordTypeId = leadRT;
            newDesignRecord.Audio_Zones_Qty__c = leadRec.Audio_Zones_Qty__c;
            newDesignRecord.Audio_Customer_Budget__c = leadRec.Audio_Customer_Budget__c;
            newDesignRecord.Audio_Room_Detail__c = leadRec.Audio_Room_Detail__c;
            newDesignRecord.Audio_Wall_Depth__c = leadRec.Audio_Wall_Depth__c;
            newDesignRecord.Audio_Ceiling_Depth__c = leadRec.Audio_Ceiling_Depth__c;
            newDesignRecord.Audio_Speaker_Pair_Qty__c = leadRec.Audio_Speaker_Pair_Qty__c;
            newDesignRecord.Audio_Speaker_Layout__c = leadRec.Audio_Speaker_Layout__c;
            newDesignRecord.Audio_Speaker_Placement__c = leadRec.Audio_Speaker_Placement__c;
            newDesignRecord.Audio_Speaker_Line__c = leadRec.Audio_Speaker_Line__c;
            newDesignRecord.Audio_Max_Volume__c = leadRec.Audio_Max_Volume__c;
            newDesignRecord.Audio_With_Tv__c = leadRec.Audio_With_Tv__c;
            newDesignRecord.Audio_Onscreen_Navigator__c = leadRec.Audio_Onscreen_Navigator__c;
            newDesignRecord.Audio_Tv_Input__c = leadRec.Audio_Tv_Input__c;
            newDesignRecord.Audio_Surround_Sound__c = leadRec.Audio_Surround_Sound__c;
            newDesignRecord.Audio_Stereo_Sound__c = leadRec.Audio_Stereo_Sound__c;
            newDesignRecord.Audio_Outdoor__c = leadRec.Audio_Outdoor__c;
            newDesignRecord.Audio_Ten_Inch_Portable__c = leadRec.Audio_Ten_Inch_Portable__c;
            newDesignRecord.Audio_Seven_Inch_Portable__c = leadRec.Audio_Seven_Inch_Portable__c;
            newDesignRecord.Audio_Seven_Inch_InWall__c = leadRec.Audio_Seven_Inch_InWall__c;
            newDesignRecord.Audio_Ten_Inch_InWall__c = leadRec.Audio_Ten_Inch_InWall__c;
            newDesignRecord.Audio_Configurable_Keypad__c = leadRec.Audio_Configurable_Keypad__c;
            newDesignRecord.Audio_Door_Stations__c = leadRec.Audio_Door_Stations__c;
            newDesignRecord.Audio_Touchscreen_Color__c = leadRec.Audio_Touchscreen_Color__c;
            newDesignRecord.Audio_Door_Station_Style__c = leadRec.Audio_Door_Station_Style__c;
            newDesignRecord.Audio_Thermostats__c = leadRec.Audio_Thermostats__c;
            newDesignRecord.Audio_Cameras__c = leadRec.Audio_Cameras__c;
            newDesignRecord.Audio_Electronics__c = leadRec.Audio_Electronics__c;
            newDesignRecord.Audio_Has_Surround_Sound__c = leadRec.Audio_Has_Surround_Sound__c;
            newDesignRecord.Audio_Home_Theater__c = leadRec.Audio_Home_Theater__c;
            newDesignRecord.Audio_Outdoor__c = leadRec.Audio_Outdoor__c;
            newDesignRecord.Audio_Floor_Plan_Available__c = leadRec.Audio_Floor_Plan_Available__c;
            newDesignRecord.Audio_Floor_Plan__c = leadRec.Audio_Floor_Plan__c;
            newDesignRecord.Audio_Challenges__c = leadRec.Audio_Challenges__c;     
        }
        if(recTypeName=='Lighting Design') {
            newDesignRecord.RecordTypeId = leadRT;
            newDesignRecord.Lighting_Design_Type__c = leadRec.Lighting_Design_Type__c;
            newDesignRecord.Lighting_Project_Size__c = leadRec.Lighting_Project_Size__c;     
            newDesignRecord.Lighting_Design_Overview__c = leadRec.Lighting_Design_Overview__c;     
            newDesignRecord.Dimming_Type__c = leadRec.Dimming_Type__c;     
            newDesignRecord.Total_Lighting_Zones__c = leadRec.Total_Lighting_Zones__c;     
            newDesignRecord.Total_Light_Loads__c = leadRec.Total_Lighting_Loads__c;     
            newDesignRecord.Total_Dimmable__c = leadRec.Total_Dimmable__c;     
            newDesignRecord.Lighting_Floor_Plan_Available__c = leadRec.Lighting_Floor_Plan_Available__c;     
            newDesignRecord.Lighting_Floor_Plan__c = leadRec.Lighting_Floor_Plan__c;     
            newDesignRecord.Lighting_Challenges__c = leadRec.Lighting_Challenges__c;     
            newDesignRecord.Central_Design_Special_Request__c = leadRec.Central_Design_Special_Request__c;     
            newDesignRecord.Central_Design_Type__c = leadRec.Central_Design_Type__c;     
        }
        if(recTypeName=='Network Design') {
            newDesignRecord.RecordTypeId = leadRT;
            newDesignRecord.Wireless_High_Throughput_Devices__c = leadRec.Wireless_High_Throughput_Devices__c;     
            newDesignRecord.Wireless_Low_Throughput_Devices__c = leadRec.Wireless_Low_Throughput_Devices__c;     
            newDesignRecord.Wired_High_Throughput_Devices__c = leadRec.Wired_High_Throughput_Devices__c;     
            newDesignRecord.Wired_Low_Throughput_Devices__c = leadRec.Wired_Low_Throughput_Devices__c;     
            newDesignRecord.Network_PoE__c = leadRec.Network_PoE__c;     
            newDesignRecord.Network_PoEPlus__c = leadRec.Network_PoEPlus__c;     
            newDesignRecord.Advanced_Management__c = leadRec.Advanced_Management__c;     
            newDesignRecord.Secondary_Switch__c = leadRec.Secondary_Switch__c;     
            newDesignRecord.Secondary_Managed_Switch__c = leadRec.Secondary_Managed_Switch__c;     
            newDesignRecord.Secondary_Switch_PoE__c = leadRec.Secondary_Switch_PoE__c;     
            newDesignRecord.Secondary_Switch_Qty__c = leadRec.Secondary_Switch_Qty__c;     
            newDesignRecord.Estimated_PoE_Wattage__c = leadRec.Estimated_PoE_Wattage__c;     
            newDesignRecord.Network_Aesthetic__c = leadRec.Network_Aesthetic__c;     
            newDesignRecord.Home_Size_Unit__c = leadRec.Home_Size_Unit__c;     
            newDesignRecord.Interior_Wall_Material__c = leadRec.Interior_Wall_Material__c;     
            newDesignRecord.Home_Size__c = leadRec.Home_Size__c;     
            newDesignRecord.Ceiling_Material__c = leadRec.Ceiling_Material__c;     
            newDesignRecord.Environment__c = leadRec.Environment__c;     
            newDesignRecord.Floors__c = leadRec.Floors__c;     
            newDesignRecord.Outdoor__c = leadRec.Outdoor__c;     
            newDesignRecord.Network_Challenges__c = leadRec.Network_Challenges__c;     
            newDesignRecord.Network_Speed__c = leadRec.Network_Speed__c;     
            newDesignRecord.Network_Speed_Unit__c = leadRec.Network_Speed_Unit__c;     
            newDesignRecord.Network_Peak_Usage__c = leadRec.Network_Peak_Usage__c;     
            newDesignRecord.Network_Floorplan_Available__c = leadRec.Network_Floorplan_Available__c;     
            newDesignRecord.Network_Floorplan__c = leadRec.Network_Floorplan__c;         
        }
        newDesignRecord.Lead__c = leadRec.Id;
        return newDesignRecord;    
    }

    public static void checkLeadFields(List<Lead> leadList){
        for(Lead newLead:leadList){
            if(!(newLead.Theater_Type__c == null) || !(newLead.Theater_Dimensions__c== null) || !(newLead.Theater_Display__c==null) || !(newLead.Theater_Ceiling_Depth__c==null) || !(newLead.Theater_Wall_Depth__c==null) || !(newLead.Theater_Speaker_Placement__c==null) || !(newLead.Theater_Speaker_Line__c==null) || !(newLead.Theater_Max_Volume__c==null) || !(newLead.Theater_Customer_Budget__c==null) || !(newLead.Theater_Floorplan__c==null) || !(newLead.Theater_Display__c==null) || !(newLead.Theater_Display_Type__c==null) || !(newLead.Theater_Electronics__c==null) || !(newLead.Theater_Seating__c ==null) || !(newLead.Theater_Speaker_Layout__c==null) || !(newLead.Theater_Challenges__c==null)){
                    newLead.Is_Theater_Filled__c = true;
            }
            if(!(newLead.Audio_Zones_Qty__c  == null) || !(newLead.Audio_Customer_Budget__c == null) || !(newLead.Audio_Room_Detail__c==null) || !(newLead.Audio_Wall_Depth__c ==null) || !(newLead.Audio_Ceiling_Depth__c ==null) || !(newLead.Audio_Speaker_Pair_Qty__c ==null) || !(newLead.Audio_Speaker_Layout__c ==null) || !(newLead.Audio_Speaker_Placement__c ==null) || !(newLead.Audio_Speaker_Line__c ==null) || !(newLead.Audio_Max_Volume__c ==null)|| !(newLead.Audio_With_Tv__c ==null)|| !(newLead.Audio_Onscreen_Navigator__c ==null) || !(newLead.Audio_Tv_Input__c ==null)|| !(newLead.Audio_Surround_Sound__c  ==null)|| !(newLead.Audio_Stereo_Sound__c ==null)|| !(newLead.Audio_Outdoor__c ==null) || !(newLead.Audio_Ten_Inch_Portable__c==null)|| !(newLead.Audio_Seven_Inch_Portable__c==null) || !(newLead.Audio_Seven_Inch_InWall__c==null)|| !(newLead.Audio_Ten_Inch_InWall__c==null) || !(newLead.Audio_Configurable_Keypad__c==null)|| !(newLead.Audio_Door_Stations__c==null) || !(newLead.Audio_Touchscreen_Color__c==null)|| !(newLead.Audio_Door_Station_Style__c==null) || !(newLead.Audio_Thermostats__c==null)|| !(newLead.Audio_Cameras__c==null) || !(newLead.Audio_Electronics__c==null)|| !(newLead.Audio_Floor_Plan__c==null) || !(newLead.Audio_Challenges__c==null)|| !(newLead.Audio_Floor_Plan__c==null) || (newLead.Audio_Has_Surround_Sound__c) || (newLead.Audio_Home_Theater__c) || (newLead.Audio_Has_Outdoor__c) || (newLead.Audio_Floor_Plan_Available__c)){
                    newLead.Is_Audio_Filled__c = true;
            }
            if(!(newLead.Lighting_Design_Type__c == null) || !(newLead.Lighting_Project_Size__c== null) || !(newLead.Lighting_Design_Overview__c==null) || !(newLead.Dimming_Type__c==null) || !(newLead.Total_Lighting_Zones__c==null) || !(newLead.Total_Lighting_Loads__c==null) || !(newLead.Total_3_Way_Light_Loads__c==null) || !(newLead.Total_Dimmable__c==null) || !(newLead.Lighting_Floor_Plan__c==null) || !(newLead.Lighting_Challenges__c==null) || !(newLead.Central_Design_Special_Request__c==null) || !(newLead.Central_Design_Type__c==null) || (newLead.Lighting_Floor_Plan_Available__c)){
                    newLead.Is_Lightning_Filled__c = true;
            }
            if(!(newLead.Wireless_High_Throughput_Devices__c == null) || !(newLead.Wireless_Low_Throughput_Devices__c== null) || !(newLead.Wired_High_Throughput_Devices__c==null) || !(newLead.Wired_Low_Throughput_Devices__c==null) || !(newLead.Network_POE__c==null) || !(newLead.Network_PoEPlus__c==null) || !(newLead.Secondary_Switch_Qty__c==null) || !(newLead.Estimated_PoE_Wattage__c==null) || !(newLead.Network_Aesthetic__c==null) || !(newLead.Home_Size__c==null) || !(newLead.Home_Size_Unit__c==null) || !(newLead.Interior_Wall_Material__c==null) || !(newLead.Ceiling_Material__c==null) || !(newLead.Environment__c==null) || !(newLead.Floors__c==null) || !(newLead.Network_Challenges__c==null) || !(newLead.Network_Speed__c==null) || !(newLead.Network_Speed_Unit__c==null) || !(newLead.Network_Peak_Usage__c==null) || !(newLead.Network_Floorplan__c == null) || (newLead.Advanced_Management__c) || (newLead.Secondary_Switch__c) || (newLead.Secondary_Managed_Switch__c) || (newLead.Secondary_Switch_PoE__c) || (newLead.Outdoor__c) || (newLead.Network_Floorplan_Available__c)){
                    newLead.Is_Network_Filled__c = true;
            }
        }
    }

    public static void convertedUpdField(List<Lead> leadList){
        Map<Id, Lead> leadIds = new Map<Id,Lead>();
        List<Design_Services__c> leadDesingList = new List<Design_Services__c>();
        for(Lead newLead:leadList){
            if(newLead.ConvertedOpportunityId != null){
                leadIds.put(newLead.Id, newLead);
            }
        }
        for(Design_Services__c desRec : [SELECT Id, Opportunity__c, Lead__c FROM Design_Services__c WHERE Lead__c IN: leadIds.keySet()]){
            leadDesingList.add(new Design_Services__c(Id = desRec.Id,Opportunity__c = leadIds.get(desRec.Lead__c).ConvertedOpportunityId));
        }
        if(!leadDesingList.isEmpty()){
            update leadDesingList;
        }
    }

    //This method is derived from the Process "Lead - Customer Contact Attempts"
    public static void recordCustomerContactAttempts(List<Lead> leadList) {
        for(Lead l : leadList) {
            String cca = l.Customer_Contact_Attempts__c;
            if(cca == '0') {
                l.Next_Call_Time__c = DateTime.now();
            }
        }
    }

    //This method is derived from the Process "Lead - Customer Contact Attempts"
    public static void recordCustomerContactAttempts(Map<Id, Lead> oldMap, List<Lead> leadList) {
        for(Lead l : leadList) {
            String cca = l.Customer_Contact_Attempts__c;
             if(oldMap.get(l.Id).Customer_Contact_Attempts__c != cca
                    && (l.Status == 'New'
                    || l.Status == 'Attempting contact'
                    || l.Status == 'Renewed Interest')) {
                if(cca == '1' || cca == '2' || cca == '3' || cca == '4' || cca == '5') {
                    l.Last_Call_Time__c = DateTime.now();
                    l.Next_Call_Time__c = DateTime.now().addDays(4/24);
                }
                else if(cca == '6') {
                    l.Last_Call_Time__c = DateTime.now();
                    l.Status = 'Term lead';
                }
            }
        }
    }

    // This method is derived from the Process "Lead: Create Process"
    // the process "Lead: Pardot Lead Record Type" has similar processes with this one so I'll merge the logic to avoid
    // building up cpu time.
    public static void assignPardotTypeToBuilder(List<Lead> leadList) {
        Id builderLeadRT = leadRecordTypes.get('Builder Lead').getRecordTypeId();
        Id dealerLeadRT = leadRecordTypes.get('Control4 Dealer Lead').getRecordTypeId();
        for(Lead l : leadList) {
            if(l.Pardot_Lead_Record_Type__c != null && l.Pardot_Lead_Record_Type__c.containsIgnoreCase('builder')) {
                l.RecordTypeId = builderLeadRT;
            }
            if(Trigger.isUpdate) {
                if(l.RecordTypeId == builderLeadRT) {
                    l.Builder_Lead_Record_Type_Conversion__c = 'Builder Lead';
                    l.Pardot_Lead_Record_Type__c = 'Builder';
                }
                if(l.RecordTypeId == dealerLeadRT) {
                    l.Pardot_Lead_Record_Type__c = 'Control4 Dealer Lead';
                }
            }
        }
    }

    //This method is derived from the Process "Lead: Create Process"
    public static void designServicesCreated(List<Lead> leadList) {
        Map<String, EmailTemplate> emailTemplateMap = new Map<String, EmailTemplate>();
        for(EmailTemplate et : [SELECT Id, Name FROM EmailTemplate WHERE Name IN ('Design Services lead is created','Send email to control4 design team')]) {
            emailTemplateMap.put(et.Name, et);
        }

        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        for(Lead l : leadList) {
            if(l.RecordTypeId == leadRecordTypes.get('Design Services').getRecordTypeId()) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(emailTemplateMap.get('Design Services lead is created').Id); 
                mail.setSaveAsActivity(false);
                mail.setToAddresses(new List<String>{l.Email});
                mail.setTargetObjectId(l.Id);
                mail.setTreatTargetObjectAsRecipient(false);
                mail.setReplyTo('designservicesteam@control4.com');
                mail.setSenderDisplayName('Design Services Team');
                allmsg.add(mail);

                Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
                mail2.setTemplateID(emailTemplateMap.get('Send email to control4 design team').Id); 
                mail2.setSaveAsActivity(false);
                mail2.setToAddresses(new List<String>{l.Design_Services_Email__c});
                mail2.setTargetObjectId(l.Id);
                mail2.setTreatTargetObjectAsRecipient(false);
                mail2.setReplyTo('do_not_reply@control4.com');
                mail2.setSenderDisplayName('Do Not Reply');
                allmsg.add(mail2);
            }
        }
        
        Messaging.sendEmail(allmsg, false);
    }

    //This method is derived from the Process "Lead: Record Type"
    public static void mapRecordTypeFromPardot(Map<Id, Lead> oldMap, List<Lead> leadList) {
        Id dealerLeadRT = leadRecordTypes.get('Control4 Dealer Lead').getRecordTypeId();
        Id upgradeRT = leadRecordTypes.get('Upgrade').getRecordTypeId();
        Id certShowRT = leadRecordTypes.get('Certified Showroom').getRecordTypeId();
        Id c4RT = leadRecordTypes.get('C4Yourself Event').getRecordTypeId();
        Id designServicesRT = leadRecordTypes.get('Design Services').getRecordTypeId();
        
        Id hospitalityRecordType = leadRecordTypes.get('Hospitality/MDU').getRecordTypeId();
        Id builderLeadRecordType = leadRecordTypes.get('Builder Lead').getRecordTypeId();
        Id telesalesRecordType = leadRecordTypes.get('Telesales').getRecordTypeId();
        
        Date currentDate = date.today();
        List<Group> queueList = [SELECT Id 
                                    FROM Group 
                                 WHERE Type = 'Queue' 
                                 AND (DeveloperName = 'C4Yourself_Event' 
                                      OR DeveloperName = 'Design_Service_Queue')
                                 ORDER BY DeveloperName ASC];
        for(Lead l : leadList) {
            //if(l.pi__created_date__c!=null){//check first if the pardot date is not null
                dateTime pardotCreatedDateTime = system.now();            
                if(l.pi__created_date__c!=null){
                    pardotCreatedDateTime = l.pi__created_date__c;            
                }
                boolean PardotLeadRecordTypeChanged = false;
                
                String TempPardotLeadRecordType = '';//this will hold the old PardotLeadRecordType, will hold the new if there is no old value (i.e. on create).
                
                
                if (oldMap.get(l.id)!=null){
                    if (oldMap.get(l.id).Pardot_Lead_Record_Type__c!=null&&l.Pardot_Lead_Record_Type__c!=null){
                        TempPardotLeadRecordType = oldMap.get(l.id).Pardot_Lead_Record_Type__c;
                        if (oldMap.get(l.id).Pardot_Lead_Record_Type__c != l.Pardot_Lead_Record_Type__c ){
                            PardotLeadRecordTypeChanged = true;    
                        }
                    }   
                }else{
                    TempPardotLeadRecordType = l.Pardot_Lead_Record_Type__c;    
                }
                
                Date pardotCreatedDate = date.newinstance(pardotCreatedDateTime.year(), pardotCreatedDateTime.month(), pardotCreatedDateTime.day());
                //Date pardotCreatedDate6Months = pardotCreatedDate.addMonths(6);
                
                Integer monthsBetween = pardotCreatedDate.monthsBetween(currentDate);
                
                boolean restrictLaneChangeDate = false;//used to check if the lane should change based on the dates
                
                
                
                if(l.Pardot_Last_Form_Completed__c != null && l.Pardot_Last_Form_Completed__c.containsIgnoreCase('upgrade')) {
                    l.RecordTypeId = upgradeRT;
                }
                if(l.Pardot_Lead_Record_Type__c != null) { 
                        If((monthsBetween < 6||l.override_6_month_pardot_creation_check__c||l.pi__created_date__c==null)&&(!TempPardotLeadRecordType.containsIgnoreCase('Telesales'))){
                            restrictLaneChangeDate = true;    
                        }                   
                    //if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('Control4 Dealer') && (monthsBetween < 6||l.override_6_month_pardot_creation_check__c||l.pi__created_date__c==null) && l.Status != 'Term lead') 
                    if(TempPardotLeadRecordType.containsIgnoreCase('Control4 Dealer') && restrictLaneChangeDate == true && l.Status != 'Term lead') {
                        l.RecordTypeId = dealerLeadRT;
                        system.debug('-----------isControl4 Dealer');
                    }
                    else if(TempPardotLeadRecordType.containsIgnoreCase('MDU/Hospitality') && restrictLaneChangeDate == true && l.Status != 'Term lead'){ 
                    //if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('MDU/Hospitality') && (monthsBetween < 6||l.override_6_month_pardot_creation_check__c||l.pi__created_date__c==null) && l.Status != 'Term lead')
                        l.RecordTypeId = hospitalityRecordType;
                        system.debug('-----------isHospitality/MDU');
                    }
                    else if(TempPardotLeadRecordType.containsIgnoreCase('Builder Lead') && restrictLaneChangeDate == true && l.Status != 'Term lead'){ 
                        //if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('Builder Lead') && (monthsBetween < 6||l.override_6_month_pardot_creation_check__c ||l.pi__created_date__c==null) && l.Status != 'Term lead')
                        l.RecordTypeId = builderLeadRecordType;
                        system.debug('-----------isBuilder Lead');
                    }
                    //else if(TempPardotLeadRecordType.containsIgnoreCase('Telesales')){ 
                    //if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('Telesales'))
                    else if(TempPardotLeadRecordType.containsIgnoreCase('Telesales')){ //allow change if from telesales
                        //l.RecordTypeId = telesalesRecordType;
                        system.debug('-----------isTelesales');
                        if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('Control4 Dealer')){
                            l.RecordTypeId = dealerLeadRT;    
                        }else if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('MDU/Hospitality')){
                            l.RecordTypeId = hospitalityRecordType;
                        }else if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('Builder Lead')) {
                            l.RecordTypeId = builderLeadRecordType;
                        }
                        
                        

                    }
                    /*else if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('Certified Showroom') && !oldMap.containsKey(l.Id) ) {
                            if(!oldMap.get(l.Id).Pardot_Lead_Record_Type__c.containsIgnoreCase('Certified Showroom')){
                                l.RecordTypeId = certShowRT;
                                system.debug('-----------isCertified Showroom');
                            }
                        }*/
                    else if(TempPardotLeadRecordType.containsIgnoreCase('C4 Yourself Event')){ 
                    //if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('C4 Yourself Event'))
                        l.RecordTypeId = c4RT;
                        
                    }    
                    
                    if (restrictLaneChangeDate == true && l.Status != 'Term lead'&& !l.Pardot_Lead_Record_Type__c.containsIgnoreCase('Telesales')){//keep the old Pardot_Lead_Record_Type__c
                        l.Pardot_Lead_Record_Type__c = TempPardotLeadRecordType;
                    }
                    /*
                    else if(l.Pardot_Lead_Record_Type__c.containsIgnoreCase('C4 Yourself Event')
                            && (oldMap.containsKey(l.Id) )) {
                                if(!oldMap.get(l.Id).Pardot_Lead_Record_Type__c.containsIgnoreCase('C4 Yourself Event')){
                                
                                    if(oldMap.get(l.Id).Status != 'Installed' && l.Status == 'Installed'){
                                        l.RecordTypeId = c4RT;
                                        system.debug('-----------isC4Yourself Event');
                                        
                                    }
                                    if(queueList.size() > 0) {
                                        l.OwnerId = queueList[0].Id;
                                    }
                                }
                            }*/
                }
            //}
            if(l.LeadSource == 'Inbound Email'
                && (!oldMap.containsKey(l.Id) || oldMap.get(l.Id).LeadSource != 'Inbound Email')) {
                l.RecordTypeId = designServicesRT;
                if(queueList.size() > 0) {
                    l.OwnerId = queueList[1].Id;
                }
                l.Opportunity_Created_Start_Date__c = Date.today();
                //l.Lead_ID__c = l.Id;
            }
        }
    }

    //This method is derived from the process "Lead: Lead Owner"
    public static void determineLeadOwner(Map<Id, Lead> oldMap, List<Lead> leadList) {
        Id telesalesRT = leadRecordTypes.get('Telesales').getRecordTypeId();

        Map<String, Group> queueMap = new Map<String, Group>();
        for(Group q : [SELECT Id, Name, DeveloperName 
                        FROM Group 
                        WHERE Type = 'Queue']) {
            queueMap.put(q.DeveloperName, q);
        }

        Set<Id> dealerIds = new Set<Id>();
        for(Lead l : leadList) {
            dealerIds.add(l.Dealer_Name__c);
        }

        Map<Id, Account> leadDealerInfo = new Map<Id, Account>();
        List<Account> aList = new List<Account>([SELECT Id, Name FROM Account WHERE Id IN :dealerIds]);
        if (aList.size()>0){
            for(Account ac:aList ){
                leadDealerInfo.put(ac.id,ac);    
            }
        }
        
        
        for(Lead l : leadList) {
            /*Lead Update to Telesales
            if(l.RecordTypeId == telesalesRT) {
                if(l.OwnerId == queueMap.get('Telesales_Archive').Id) { 
                    l.OwnerId = queueMap.get('Telesales').Id;
                }
            }*/
            //Term Lead Renewed
            if(l.OwnerId == queueMap.get('Term_Lead_Queue').Id) {
                if(oldMap.containsKey(l.Id)) {
                    //From the process "Lead: Field Updates"
                    if(oldMap.get(l.Id).OwnerId != l.OwnerId) {
                        l.Status = 'Term Lead';
                    }
                    if(oldMap.get(l.Id).Pardot_Last_Form_Completed__c != l.Pardot_Last_Form_Completed__c) {
                        l.Status = 'Renewed Interest';
                        l.OwnerId = queueMap.get('Telesales').Id;
                    }
                }
            }
            //Leads: Move Leads to International
            if(l.RecordTypeId == telesalesRT && l.Phone != null && (l.Phone.startsWith('0') || l.Phone.startsWith('+')) && l.Country == null) {
                Lead oldRecord = oldMap.get(l.Id);
                if(oldRecord != null) {
                    if(!(oldRecord.RecordTypeId == telesalesRT && oldRecord.Phone != null && (oldRecord.Phone.startsWith('0') || oldRecord.Phone.startsWith('+')) && oldRecord.Country != null)) { //subsequent changes only
                        l.OwnerId = queueMap.get('Telesales_International').Id;
                    }
                }
                else {
                    l.OwnerId = queueMap.get('Telesales_International').Id;
                }
            }
            // Term Dealer Leads
            if(l.Status == 'Term - Denied' || l.Status == 'Term - Not Interested') {
                Lead oldRecord = oldMap.get(l.Id);
                if(oldRecord != null) {
                    if(!(oldRecord.Status == 'Term - Denied' || oldRecord.Status == 'Term - Not Interested')) { //subsequent changes only
                        l.OwnerId = queueMap.get('Dealer_Term_Lead').Id;
                    }
                }
            }

            /* Became a Dealer
            if(l.Status == 'Became a Dealer' && (oldMap.get(l.Id) == null || oldMap.get(l.Id).Status != 'Became a Dealer')) { //subsequent changes only
                l.OwnerId = queueMap.get('Became_Dealer_from_Lead').Id;
            }*/

            // Term Lead
            if(l.Status == 'Term lead' && (oldMap.get(l.Id) == null || oldMap.get(l.Id).Status != 'Term lead')) { //subsequent changes only
                l.OwnerId = queueMap.get('Term_Lead_Queue').Id;
            }

            //Dealer Name
            if(l.Dealer_Name__c != null) {
                if(leadDealerInfo.containsKey(l.Dealer_Name__c)) {
                    l.Company = leadDealerInfo.get(l.Dealer_Name__c).Name;
                }
            }

            //Record Type Name
            if(l.RecordTypeId != null) {
                for(String leadRTName : leadRecordTypes.keySet()) {
                    if(leadRecordTypes.get(leadRTName).getRecordTypeId() == l.RecordTypeId) {
                        l.RecordTypeName__c = leadRTName;
                        break;
                    }
                }
                
            }

            //Capture Lead Owner
            if(l.OwnerId == queueMap.get('Telesales').Id || l.OwnerId == queueMap.get('Telesales_International').Id || l.OwnerId == queueMap.get('Telesales_UK').Id) {
                if(l.RecordTypeId == telesalesRT && !l.IsConverted) {
                    l.Telesales_Date__c = Date.today();
                }
            }

            //Lead Queue Name
            for(String queueName : queueMap.keySet()) {
                if(l.OwnerId == queueMap.get(queueName).Id) {
                    if(l.Lead_Queue_Name__c == 'Term Lead Queue' && queueMap.get(queueName).Name == 'Telesales') {
                        l.Terminated_Queue_Telesales_Date__c = DateTime.now();
                    }
                    l.Lead_Queue_Name__c = queueMap.get(queueName).Name;
                }
            }

            //These two ifs was derived from the process called 'New Dealer Process'
            if(l.RecordTypeId == leadRecordTypes.get('Control4 Dealer Lead').getRecordTypeId()) {
                l.IsNewDealerType__c = true;
            }

            if(oldMap.get(l.Id) != null && oldMap.get(l.Id).Status != l.Status) {
                l.Last_Status_Change_Date__c = Date.today();
            }
        }
    }
}