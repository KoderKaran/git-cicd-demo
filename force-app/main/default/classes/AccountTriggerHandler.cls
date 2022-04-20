public class AccountTriggerHandler {  
    public void getCoreCity(List<Account> lstAccounts){
        Map<String,Core_City__c> mapCoreCity = new Map<String,Core_City__c>();
        Map<String, Account> mapAccount = new Map<String, Account>();
        
        List<Account> lstBusinessAccounts = new List<Account>();
        List<String> lstZip = new List<String>();
        
        Id accRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        for(Account acc: lstAccounts){
            if(acc.RecordTypeId == accRT && acc.Core_City_Manual_Override__c == false){
                lstBusinessAccounts.add(acc);
            }
        }
        
        if(!lstBusinessAccounts.isEmpty()){            
            for(Account acc: lstBusinessAccounts){
                lstZip.add(acc.ShippingPostalCode);
            }
            List<Core_City__c> lstCoreCity= [SELECT Id, City__c, Zip_Code__c FROM Core_City__c WHERE Zip_Code__c IN :lstZip];
            for(Core_City__c core: lstCoreCity){
                mapCoreCity.put(core.Zip_Code__c, core);
            }
            
            for(Account insertAccount: lstBusinessAccounts){
                if(mapCoreCity.containsKey(insertAccount.ShippingPostalCode)){
                    insertAccount.Core_City__c = mapCoreCity.get(insertAccount.ShippingPostalCode).Id;
                }
            }
        }
    }
    
    public static boolean hasRun = false; 
    public void updateUserPermissionSet(List<Account> lstAccounts){
        system.debug('!! First Recurssion Flag checker>>'+ hasRun);
        
        if (!hasRun){
             system.debug('!! 2nd Recurssion Flag checker >>'+ hasRun);
            set<Id> setAcctId = new set<Id>();
            for (Account acc : lstAccounts) {
                setAcctId.add(acc.Id);
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
            for(Account parentAccnt : [SELECT Id,Dealer_Type2__c,(SELECT Id,Dealer_Type2__c,ParentId FROM ChildAccounts) FROM Account WHERE Id =:pId]){
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
            if(userToAddPermission.size() >0){
                insertUserPermission(userToAddPermission,ps.id);
            }
            if(userToRemovePermission.size() >0){
                deleteUserPermission(userToRemovePermission,ps.id);
            }
            
            
        }
    }
    
       
        
    
    
    @future
    private static void insertUserPermission(Set<Id> uIds, Id ps){
        List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
        for(Id u:uIds){
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.PermissionSetId = ps;
            psa.AssigneeId = u;
            psaList.add(psa);
        }
        if(psaList.size() >0 ){
            Database.insert(psaList, false);
        }
        hasRun = True;
    }
    
    @future
    private static void deleteUserPermission(Set<Id> uIds, Id ps){
        Database.Delete([SELECT Id,PermissionSetId,AssigneeId from PermissionSetAssignment WHERE AssigneeId IN :uIds and PermissionSetId =: ps], false);
        hasRun = True;
    }
    
    public static Boolean isRun = false;
    public static Boolean runAfter(){
        if(isRun){
            return false;
        }
        return isRun=true;
    }
    
    
}