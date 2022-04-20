trigger DBAmpErrorTrigger on dbampErrors__c (before insert, after insert) {
    if (Trigger.isBefore && Trigger.isInsert){
        DBAmpErrorTriggerHandler.handleDbAmpErrorInsert(Trigger.new);
    }
}