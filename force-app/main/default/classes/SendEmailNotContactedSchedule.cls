global class SendEmailNotContactedSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        // Implement any logic to be scheduled
       
        // We now call the batch class to be scheduled
        SendEmailNotContacted b = new SendEmailNotContacted ();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,9);
    }
   
}