trigger LeadToPeAccount on Lead (after insert, after update) 
{
    Set<String> leademails = new Set<String>();
    Set<String> leadphones = new Set<String>();
    List<Lead> newLeads = new List<Lead>();
    
    Id designServicesId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
    
    // Get all the new leads
    for(Lead l : system.trigger.new)
    {
        If(l.Email != Null || l.Phone != Null){
            newLeads.add(l);
            leademails.add(l.Email);
            leadphones.add(l.Phone);
        }
        
    }
    
    /* Make some maps of account and email addresses */
    List<Account> AccountList = [select Id, RecordTypeId, PersonEmail, Phone, OwnerId from Account where PersonEmail IN: leademails AND PersonEmail != Null AND(RecordTypeID ='012500000005Jxs' OR RecordTypeID = '012500000005e0f' OR RecordTypeID = '012500000005d8O') LIMIT 1 ];
    List<Account> AccountListph = [select Id, RecordTypeId, PersonEmail, Phone, OwnerId from Account where Phone IN: leadphones AND Phone != Null AND(RecordTypeID ='012500000005Jxs' OR RecordTypeID = '012500000005e0f' OR RecordTypeID = '012500000005d8O') LIMIT 1];
    Map<ID, String> peAccounts = new Map<ID, String>();
    Map<ID, String> peAccountsph = new Map<ID, String>();
    Map<ID, ID> peAccountsOwner = new Map<ID, ID>();
    Map<ID, ID> peAccountsOwnerph = new Map<ID, ID>();
    
    // Generic map for preventing loss of ids
    for(Account a : AccountList)
    {
        peAccounts.put(a.id, a.PersonEmail);
        peAccountsOwner.put(a.id, a.OwnerId);
    }
    for(Account a : AccountListph)
    {
        peAccountsph.put(a.id, a.Phone);
        peAccountsOwnerph.put(a.id, a.OwnerId);   
    }
    
    // We will need this to get the id from the email address
    Map<String, ID> peAccountsFlipped = new Map<String, ID>();
    Map<String, ID> peAccountsFlippedph = new Map<String, ID>();
    for(ID i : peAccounts.keyset())
    {
        peAccountsFlipped.put(peAccounts.get(i), i);
    }
    for(ID i : peAccountsph.keyset())
    {
        peAccountsFlippedph.put(peAccountsph.get(i), i);
    }
    
    /* System Conversion Requirements */
    List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
    Database.LeadConvert lc;
    
    /* Configuring Payload */
    
    for (Lead nl : newLeads) 
    {
        Boolean didConvert = false;
        if(nl.Email != Null && nl.Company == Null && nl.RecordTypeId != designServicesId && !nl.From_Balihoo__c)
        {
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
        if(didConvert == false && nl.Phone != Null && nl.Company == Null && nl.RecordTypeId != designServicesId && !nl.From_Balihoo__c  )
        {
            // Check to see if account already exists
            if(!peAccountsph.isEmpty())
            {
                if(peAccountsFlippedph.get(nl.Phone)!=null)
                {
                    If(nl.IsConverted != True && nl.Id != NULL)
                    {
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
            for(Database.LeadConvertResult lcr : lcrList)
                System.assert(lcr.isSuccess(), 'LCR failed:'+lcr);
        }
    }
    
    if(trigger.isInsert && trigger.isAfter){
        
        // Get an Active Lead Assignement Rule Id
        Id leadAssignmentRuleId = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Lead' AND Active = true][0].Id;
        
        // Call the handler by passing list of new Leads and Active Assignment Rule Id
        new LeadAssignmentTriggerHandler(trigger.new, leadAssignmentRuleId);
    }
}