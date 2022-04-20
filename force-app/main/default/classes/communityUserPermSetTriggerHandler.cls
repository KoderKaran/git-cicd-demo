public class communityUserPermSetTriggerHandler {
    
    public static boolean hasRun2 = false; 
    public static void onAfterInsert(Map<Id,User> userMap){
        system.debug('!! 1st Recurssion Flag checker >>'+ hasRun2);
        
        List<User> userList = userMap.values();

        
        if (!hasRun2){
             system.debug('!! 2nd Recurssion Flag checker >>'+ hasRun2);
            set<Id> setAcctId = new set<Id>();
            for (User usr : userList) {
                if(usr.accountId != null) {
                    setAcctId.add(usr.accountId);
                }
            }
            
            set<Id> pId = new set<Id>();
            for (Account aacc: [SELECT id,ParentId FROM Account WHERE id =:setAcctId]){
                if (aacc.ParentId !=null){
                    //Child
                    pId.add(aacc.ParentId);
                }else{
                    pId.add(aacc.id);
                }
            }
            system.debug('@@@ Get Current AccountId >>' + setAcctId);
            system.debug('@@@ Current Parent AccountId >>' + pId);
            
            Set<id> accountToAddPermission = new Set<id>();
            Set<id> accountToRemovePermission = new Set<id>();
            for(Account parentAccnt : [SELECT Id,Dealer_Type2__c,ParentId,(SELECT Id,Dealer_Type2__c,ParentId FROM ChildAccounts) FROM Account WHERE Id =:pId]){
                if(parentAccnt.ChildAccounts.size() > 0){
                    if(parentAccnt.Dealer_Type2__c == 'Control4' || parentAccnt.Dealer_Type2__c == 'Control4 + SnapAV'){
                        accountToAddPermission.add(parentAccnt.Id);
                        for(Account ca: parentAccnt.ChildAccounts){
                            accountToAddPermission.add(ca.Id);
                        }
                    } else {
                        Boolean isChildAutomation = false;

                        for(Account childAccnt: parentAccnt.ChildAccounts){
                            if(childAccnt.Dealer_Type2__c == 'Control4' || childAccnt.Dealer_Type2__c == 'Control4 + SnapAV'){
                                isChildAutomation = true;
                            }
                        }
                        if(isChildAutomation){
                            Set<id> addChildIds = new Map<Id,Account>(parentAccnt.ChildAccounts).keyset();
                            accountToAddPermission.addAll(addChildIds);
                            accountToAddPermission.add(parentAccnt.ChildAccounts[0].ParentId); 
                        } else {
                            Set<id> removeChildIds = new Map<Id,Account>(parentAccnt.ChildAccounts).keyset();
                            accountToRemovePermission.addAll(removeChildIds);
                            accountToRemovePermission.add(parentAccnt.ChildAccounts[0].ParentId); 
                        }
                    }
                } else {
                    
                    // Account with no Child
                    if(parentAccnt.Dealer_Type2__c == 'Control4' || parentAccnt.Dealer_Type2__c == 'Control4 + SnapAV'){
                        accountToAddPermission.add(parentAccnt.Id);
                    } else {
                        accountToRemovePermission.add(parentAccnt.Id);
                    }
                    
                }
            }

            Set<id> userToAddPermission = new Set<id>();
            Set<id> userToRemovePermission = new Set<id>();
            Set<id> accountsToProcess = new Set<id>();
			accountstoProcess.addAll(accountToAddPermission);
			accountsToProcess.addAll(accountToRemovePermission);
            system.debug('### accountToAddPermission >>' + accountToAddPermission);
            system.debug('### accountToRemovePermission >>' + accountToRemovePermission);
            
            if (accountsToProcess.size()> 0){
                for(User usr : [SELECT Id,Name,Contact.AccountId,AccountId FROM User WHERE Contact.AccountId IN:accountsToProcess]) {
                    if(accountToAddPermission.contains(usr.AccountId)){
                   	 userToAddPermission.add(usr.id);
                    }
                    if(accountToRemovePermission.contains(usr.AccountId)){
                     userToRemovePermission.add(usr.id);   
                    }
                }
            }
            
            PermissionSet ps = [SELECT id,name FROM PermissionSet WHERE name='AutomationDataCategory' LIMIT 1];
            
            set<Id> psaId = new Set<Id>();  // stores the user that already has Permission set assign
            
            for(PermissionSetAssignment ps1:[SELECT Id,PermissionSetId,AssigneeId from PermissionSetAssignment WHERE PermissionSetId =:ps.Id AND AssigneeId=:userToAddPermission]){
                psaId.add(ps1.AssigneeId);
            }
            system.debug('!! permissionset assignment Id >>' + psaId);
            
            List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
            for(Id u:userToAddPermission){
                if(!psaId.contains(u)){
                    PermissionSetAssignment psa = new PermissionSetAssignment();
                    psa.PermissionSetId = ps.id;
                    psa.AssigneeId = u;
                    psaList.add(psa);
                }
            }
            
            if(psaList.size()>0){
                insert psaList;
                hasRun2 = true;
            }   
        }
    }
    
    public static boolean hasRun = true; 
    public static void onAfterUpdate(Map<Id,User> userMap){
        
        List<User> usrList = [SELECT Id,name,subscribeGroup__c,hasSubscribeGroup__c FROM User WHERE Id IN:userMap.keySet()];
        List<User> userToUpdate = new List<User>();
        for(User u: usrList){
            if (string.isNotBlank(u.subscribeGroup__c)){
                u.hasSubscribeGroup__c = true;
            }else{
                u.hasSubscribeGroup__c = false;
            }
            userToUpdate.add(u);
        }
        if(hasRun){
            if(userToUpdate.size() > 0){
                hasRun = false;
                update userToUpdate;    
                
            }
        }        
        
    }
}