public class OpportunityTriggerHandler {
    
    Map<Id, Opportunity> oldMap;
    Map<Id, Opportunity> newMap;
    public OpportunityTriggerHandler(
        Map<Id, Opportunity> oldTrigger, 
        Map<Id, Opportunity> newTrigger) {
            oldMap = oldTrigger;
            newMap = newTrigger;
        }
    
    public void opp(List<Opportunity> triggerNew){
        
        List<Opportunity> oppList = new List<Opportunity>();
        List<String> collectionList = new List<String>();
        for(Opportunity opps: triggerNew){
            if (!string.isBlank(opps.Showroom_Dealer_ID__c))                
            {
                collectionList.add(opps.Showroom_Dealer_ID__c);
            }
        }
        
        if (!collectionList.IsEmpty()) // If the user inputs a blank SAP ID this will be null/empty.            
        {        
            List<Account> getAccounts = [SELECT Id,SAP_Account_ID__c FROM Account WHERE SAP_Account_ID__c IN :collectionList];
            Map<String,Account> accountMap = new Map<String,Account>();
           
            for(Account curAccount:getAccounts){
                accountMap.put(curAccount.SAP_Account_ID__c,curAccount);
            }
            
            for(Opportunity opps: triggerNew){
                Id filterRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Showroom Event').getRecordTypeId(); 
                if(opps.RecordTypeId == filterRecordType){
                    Account acc = accountMap.get(opps.Showroom_Dealer_ID__c);
                    if (acc != null) // If the user inputs an incorrect SAP ID acc will be null.
                    {
                        opps.AccountId = acc.id;
                        oppList.add(opps);
                    }
                }
            }
        }
    }  
    
    public void insertOppTeam(boolean isUpdate){
        set<Id> userList = new set<id>();
        set<Id> userRoleId = new set<Id>();
        set<Id> parentRole = new set<Id>();
        set<Id> oppId = new set<Id>();
        set<Id> allUserId = new set<Id>();
        map<Id,Opportunity> oppHolderMap = new Map<Id,Opportunity>(newMap.values());
        //map<id,UserRole> collectionRole = new  map<id,UserRole>();
        for(Opportunity opp : newMap.values())
        {
            userList.add(opp.OwnerId);
            allUserId.add(opp.OwnerId);
            oppId.add(opp.Id);
        }
        Map<Id,User> collectionOfUser = new Map<Id,User>([select UserRoleId from User where id in: userList and UserRoleId != NULL]);
        for(User userRec: collectionOfUser.values()){
            userRoleId.add(userRec.UserRoleId);
        }
        Map<Id,UserRole> collectionRole = new  Map<Id,UserRole>([select Id , ParentRoleId from UserRole where id in:UserRoleId]);
        for(UserRole roleRec: collectionRole.values()){
            if(roleRec.ParentRoleId != null){
                parentRole.add(roleRec.ParentRoleId);
            }
        }
        Map<Id,List<User>> collectionOfParentUserMap = new Map<Id,List<User>>();
        if(parentRole != null){
            List<User> collectionOfParentUser =[select Id,UserRoleId from User where UserRoleId in: parentRole and IsActive = true];
            for(User userRec : collectionOfParentUser){
                List<User> userHolder = new List<User>();
                if(collectionOfParentUserMap.containsKey(userRec.UserRoleId)){
                    userHolder = collectionOfParentUserMap.get(userRec.UserRoleId);
                }
                userHolder.add(userRec);
                allUserId.add(userRec.Id);
                collectionOfParentUserMap.put(userRec.UserRoleId , userHolder);
            }
        }
        
        map<string,OpportunityTeamMember> oppTeamMap = new Map<string,OpportunityTeamMember>();
        map<string,List<OpportunityTeamMember>> oppTeamMapOpp = new Map<string,List<OpportunityTeamMember>>();
        List<OpportunityTeamMember > oppTeamExist = [select Id,OpportunityId,UserId,is_Generated__c from OpportunityTeamMember where OpportunityId in:oppId and is_Generated__c = true];
        if(oppTeamExist != null){
            for(OpportunityTeamMember curOppTeam: oppTeamExist){
                string currentId = curOppTeam.OpportunityId + ''+ curOppTeam.UserId;
                List<OpportunityTeamMember> oppTeamHolder = new List<OpportunityTeamMember>();
                if(oppTeamMapOpp.containsKey(curOppTeam.OpportunityId)){
                    oppTeamHolder = oppTeamMapOpp.get(curOppTeam.OpportunityId);
                }
                oppTeamHolder.add(curOppTeam);
                oppTeamMapOpp.put(curOppTeam.OpportunityId,oppTeamHolder);
                oppTeamMap.put(currentId,curOppTeam);
            }
        }
        List<OpportunityTeamMember > listofOpportunityTeam = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember > listofOpportunityTeamDelete = new List<OpportunityTeamMember>();
        for(Opportunity opp : newMap.values())
        {
            if(isUpdate){
                List<OpportunityTeamMember> allOppTeam = oppTeamMapOpp.get(opp.id);
                if(allOppTeam != null){
                    listofOpportunityTeamDelete.addAll(allOppTeam);
                }
            }
            User currentUser = collectionOfUser.get(opp.OwnerId);
            if (currentUser != null)
            {
                UserRole currentRole = collectionRole.get(currentUser.UserRoleId);
                if(currentRole.ParentRoleId != null)
                {
                    List<User> parentUser =  collectionOfParentUserMap.get(currentRole.ParentRoleId);
                    if(parentUser != null)
                    {
                        for(User userRec : parentUser){
                            string currentId = opp.Id + ''+ userRec.Id;
                            if(!oppTeamMap.containsKey(currentId)){
                                OpportunityTeamMember otm = new OpportunityTeamMember(OpportunityId = opp.Id, UserId =userRec.Id , is_Generated__c = true);
                                listofOpportunityTeam.add(otm);
                            }
                        }
                    }
                }
            }
            
        }
        if(listofOpportunityTeamDelete != null){
            delete listofOpportunityTeamDelete;
        }
        if(listofOpportunityTeam != null){
            insert listofOpportunityTeam;
        }
    }

    public void transferLeadMessage(List<Opportunity> opportunities) {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        Map<Id, Opportunity> mapOppToLead = new Map<Id, Opportunity>();
        Map<Id, String> noteReplacementsForOpportunities = new Map<Id, String>();

        Opportunity oldOpportunity;

        for (Opportunity opportunity : opportunities) {

            if (opportunity.Associated_Lead__c == null) {
                continue;
            }

            mapOppToLead.put(opportunity.Associated_Lead__c, opportunity);

        }

        for (Lead lead : [
            SELECT SDR_Notes__c
            FROM Lead
            WHERE Id IN :mapOppToLead.keySet()
        ]) {

            oldOpportunity = mapOppToLead.get(lead.Id);

            if (oldOpportunity.LeadGen_Notes__c == lead.SDR_Notes__c) {
                continue;
            }

            noteReplacementsForOpportunities.put(oldOpportunity.Id, lead.SDR_Notes__c);

        }

        for (Opportunity opportunityToUpdate : [
            SELECT LeadGen_Notes__c
            FROM Opportunity
            WHERE Id IN :noteReplacementsForOpportunities.keySet()
        ]) {

            opportunityToUpdate.LeadGen_Notes__c = noteReplacementsForOpportunities.get(opportunityToUpdate.Id);
            opportunitiesToUpdate.add(opportunityToUpdate);

        }

        update opportunitiesToUpdate;

    }
    
}