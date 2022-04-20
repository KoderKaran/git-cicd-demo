trigger FeedItemTrigger on FeedItem (after insert,after update) {
    if (Trigger.IsAfter) {
        if (Trigger.isInsert || Trigger.isUpdate){    

            FeedItemTriggerHandler.onAfterInsert(Trigger.newMap);
            if (Trigger.isInsert) {
                FeedItemTriggerHandler.createShadowObject(Trigger.newMap);
            }
        } 
    }
}