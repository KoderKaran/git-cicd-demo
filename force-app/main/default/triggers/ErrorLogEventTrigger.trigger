trigger ErrorLogEventTrigger on Error_Log_Event__e (after insert) {
    ErrorLogEventTriggerHandler.handleErrorLogEventInsert(Trigger.new);
}