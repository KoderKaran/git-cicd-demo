global class checkExpiryBatchSchedule implements Schedulable{
    global void execute(SchedulableContext SC) {
        
        checkExpiryBatch bp = new checkExpiryBatch();
        database.executeBatch(bp,100);
    }
}