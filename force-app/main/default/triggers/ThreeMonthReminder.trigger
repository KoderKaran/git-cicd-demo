trigger ThreeMonthReminder on Case (After Update) 
{
    //Set the paramenters for running the task
    List<Case> cslist = [SELECT ID, Subject, OwnerID, Status,Reminders_Sent__c, BOM_Status__c,X3_Month_Reminder__c, X3_Week_Reminder__c, Account.OwnerID, MSRP_Amount__c, Account.AccountNumber, CaseNumber, RecordTypeID FROM Case WHERE ID in :Trigger.new];
    for(Case cs : cslist)
    {
        if(cs.RecordTypeID =='012500000005I5BAAU' 
           && cs.Status =='Closed' 
           && cs.BOM_Status__c == 'Pending'
           //This field is set by a Time Trigger Rule to 'True' after Three Months
           && cs.X3_Month_Reminder__c == False 
           && cs.X3_Week_Reminder__c == True && cs.Reminders_Sent__c != True)
        {
            //Bringing up the Task information
            list<Task> taskList = new list<Task>();
            
            //Setting the Task information
            Task tsk = new Task();
            tsk.IsReminderSet = True;
            tsk.OwnerID = cs.OwnerId;
            //Setting the reminder in minutes even though this accepts hours, Days
            tsk.ReminderDateTime = System.now();
            tsk.Subject = 'For Case#'+ cs.CaseNumber +'is 3 Weeks old, check status on Win/Loss/Pending';
            tsk.ActivityDate = System.today();
            tsk.Description = ''+ cs.Subject + cs.MSRP_Amount__c + cs.Account.AccountNumber;
            taskList.add(tsk);
            
            if(taskList.size() > 0)
            {
                insert taskList;
            }
        }Else{
            if(cs.RecordTypeID =='012500000005I5BAAU' 
               && cs.Status =='Closed' 
               && cs.BOM_Status__c =='Pending' 
               //This field is set by a Time Trigger Rule to 'True' after Three Months
               && cs.X3_Month_Reminder__c == True 
               && cs.X3_Week_Reminder__c == True && cs.Reminders_Sent__c != True)
            {
                //Bringing up the Task information
                list<Task> taskList = new list<Task>();
                
                //Setting the Task information
                Task tsk = new Task();
                tsk.IsReminderSet = True;
                tsk.OwnerID = cs.OwnerId;
                //Setting the reminder in minutes even though this accepts hours, Days
                tsk.ReminderDateTime = System.now();
                tsk.Subject = 'For Case#'+ cs.CaseNumber +'is two months old, check status on Win/Loss/Pending';
                tsk.ActivityDate = System.today();
                tsk.Description = ''+ cs.Subject + cs.MSRP_Amount__c + cs.Account.AccountNumber;
                taskList.add(tsk);
                
                if(taskList.size() > 0)
                {
                    insert taskList;
                }
            }
        }
    }
}