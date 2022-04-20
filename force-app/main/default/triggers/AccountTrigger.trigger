trigger AccountTrigger on Account (before insert, after insert, 
                                   before update, after update, 
                                   before delete, after delete, after undelete) 
{
   AccountTriggerHandler ath = new AccountTriggerHandler();
    if (Trigger.isBefore){
        if (Trigger.isInsert){
            //CJ Dabb. Creates Master Dealer Objects
            MasterDealerObjectManager manager = new MasterDealerObjectManager();
            manager.CreateMasterDealer(Trigger.new); 
            
            // This is a process from Simplus
            ath.getCoreCity(Trigger.new);
        } 
        if (Trigger.isUpdate){
            //CJ Dabb. For the New Dealer Process. This updates the stage in an opportunity based the SAP_ACCOUNT_ID__c field being updated in an account object
            UpdateOpportunityFromAccountChange uOpp = new UpdateOpportunityFromAccountChange();
            uOpp.UpdateOpportunityStage(Trigger.new, trigger.oldmap);
            
            // This is a process from Simplus
            ath.getCoreCity(Trigger.new);
        }
        if (Trigger.isDelete){
        }
    }
    
    if (Trigger.IsAfter){
        if (Trigger.isInsert){    
        } 
        if (Trigger.isUpdate && AccountTriggerHandler.runAfter()) { //
            ath.updateUserPermissionSet(Trigger.new);
        }
        if (Trigger.isDelete){
        }
        if(Trigger.isUndelete){
        }
    }
}