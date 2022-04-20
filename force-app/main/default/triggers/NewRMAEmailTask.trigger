trigger NewRMAEmailTask on CaseProduct__c (after Update) 
{
    //Listing the fileds from rma that need updated
    list<CaseProduct__c> rmaList = [select id, Number_of_Task_Sent__c, Time_Delayed_Task__c, New_Email_RMA_Sent__c, Case__c, Item__c, RMA__c,RMA_Type__c, Name, Case__r.CaseNumber, Case__r.OwnerId, Case__r.Update_RMA_Task__c    
                                    from CaseProduct__c 
                                    where ID in :trigger.new];

    {
     list<Task> taskList = new list<Task>();
    //Creating a task for the cases the email has not been sent to
        for(CaseProduct__c rma : rmaList)
        {
            
            If(rma.New_Email_RMA_Sent__c == False && rma.RMA__c == 'Yes' && rma.Time_Delayed_Task__c == False && rma.Case__r.Update_RMA_Task__c == False && rma.RMA_Type__c != 'Sales' && rma.Case__r.OwnerId != '00550000001iZiPAAU')
            {
                
                rma.Number_of_Task_Sent__c = + 1;
                rma.Time_Delayed_Task__c = True;
                
                Task tsk = new Task();
                tsk.IsReminderSet = True;
                tsk.OwnerID = rma.Case__r.OwnerId;
                tsk.ReminderDateTime = System.now().addMinutes(1);
                tsk.Subject = 'New RMA email has not been sent for Case #'+rma.Case__r.CaseNumber;
                tsk.ActivityDate = System.today();
                taskList.add(tsk);
                
            }
        }
        if(taskList.size() > 0)
        {
            update rmalist;
         	insert taskList;
        }
        
    }


}