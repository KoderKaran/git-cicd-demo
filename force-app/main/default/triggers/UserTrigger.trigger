trigger UserTrigger on User (before insert, after insert, 
                             before update, after update, 
                             before delete, after delete, after undelete) 
{
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            //CJ Dabb. Manages the users avatar
            AvatarManager manager = new AvatarManager();
            manager.AvatarManagerInsert(Trigger.new);
        } 
        if (Trigger.isUpdate) {
        }
        if (Trigger.isDelete) {
        }
    }
    
    if (Trigger.IsAfter) {
        if (Trigger.isInsert){    
            communityUserPermSetTriggerHandler.onAfterInsert(trigger.newMap);
        } 
        if (Trigger.isUpdate) {
            //CJ Dabb. Manages the users avatar
            AvatarManager manager = new AvatarManager();
            manager.AvatarManagerUpdate(Trigger.new, trigger.oldmap);
            
            //Simplus
            communityUserPermSetTriggerHandler.onAfterUpdate(Trigger.newMap);
        }
        if (Trigger.isDelete) {
        }
        if(Trigger.isUndelete){
        }
    }
}