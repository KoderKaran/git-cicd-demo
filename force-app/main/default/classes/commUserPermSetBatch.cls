global class commUserPermSetBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {

        //String query = 'SELECT Id,name, contactId,License_Type__c,isActive  FROM User WHERE contactId IN(SELECT id FROM Contact WHERE Account.Dealer_Type2__c =\'Control4\' OR Account.Dealer_Type2__c =\'Control4 + SnapAV\') ';
		String query = 'SELECT Id,Name,ParentId,Dealer_Type2__c FROM Account WHERE Dealer_Type2__c =\'Control4\' OR Dealer_Type2__c =\'Control4 + SnapAV\' ';

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        
        
        set<Id> parentWithChild = new set<Id>(); //store the value of the parent Account that has a child Account
        set<Id> ParentIds = new set<Id>(); //stores the value of the parent Account
        for (Account acct : scope){
            if(acct.ParentId != null) {
                parentWithChild.add(acct.ParentId);
            } else {
                ParentIds.add(acct.Id);
                
            }
        }
        
        set<Id> ChildIds = new set<Id>(); //stores the value of the Child Account
        system.debug('!!ParentIds  '+ ParentIds);
        system.debug('!!parentWithChild'+ parentWithChild);
        
        if (ParentIds.size() >0 ){
            
            for(Account acct1: [SELECT id,name,ParentId FROM Account WHERE ParentId=:ParentIds]){
                ChildIds.add(acct1.id);
            }
        }
        
        if (parentWithChild.size() >0){
            for(Account acct1: [SELECT id,name,ParentId FROM Account WHERE Id=:parentWithChild]){
                ChildIds.add(acct1.parentId);
            }
        }
        
        
        set<Id> IdsToUpdate = new set<Id>();
        if (ParentIds.size() > 0) IdsToUpdate.addall(ParentIds);
        if (parentWithChild.size() > 0) IdsToUpdate.addall(parentWithChild);
        if (ChildIds.size() > 0) IdsToUpdate.addall(ChildIds);
        system.debug('!!IdsToUpdate > '+ IdsToUpdate);

        set<Id> userToUpdate = new set<Id>();
        for(User usr : [SELECT Id,Name,AccountId,isActive,License_Type__c FROM User WHERE AccountId=:IdsToUpdate AND isActive=True AND License_Type__c ='Customer Community Login']) {
            userToUpdate.add(usr.id);
        }
        
        
        List <PermissionSetAssignment> psaList =  new List<PermissionSetAssignment>();
        PermissionSet pset = [SELECT id,name FROM PermissionSet WHERE name='AutomationDataCategory' LIMIT 1];
        List<PermissionSetAssignment> psassign = [SELECT Id,PermissionSetId,AssigneeId from PermissionSetAssignment WHERE PermissionSetId =:pset.Id AND AssigneeId=:userToUpdate];
         
        set<id> psaId = new Set<Id>();
        for(PermissionSetAssignment ps:psassign){
            psaId.add(ps.AssigneeId);
        }
        
        for(Id u: userToUpdate){
            if(!psaId.contains(u)){
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.PermissionSetId = pset.Id;
                psa.AssigneeId = u;
                psaList.add(psa);
            }
            
        }
        insert psaList;
        
        
        //DO NOT REMOVE
        //use this to remove permission set for the user
        /*
        Set<Id> accId = new Set<Id>();
        for (Account acct : scope){
            accId.add(acct.id);
        }
        Set<Id> uId = new Set<Id>();
        for(User usr : [SELECT Id,Name,AccountId FROM User WHERE AccountId=:accId]) {
            uId.add(usr.id);
        }
        
        PermissionSet Dpset = [SELECT id,name FROM PermissionSet WHERE name='AutomationDataCategory' LIMIT 1];
        //delete [SELECT Id,AssigneeId from PermissionSetAssignment WHERE PermissionSetId =:Dpset.Id AND AssigneeId = : uId];
        */
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}