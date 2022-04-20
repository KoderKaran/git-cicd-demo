trigger ContactTrigger on Contact (before insert, after insert, before update, after update, before delete, after delete, after undelete)

{
    if (Trigger.isBefore) 
    {
        if (Trigger.isInsert) 
        {
            if(ContactRecursionCheck.RunOnceCheck())
            {                   
                ContactTriggerHandler.checkPrimary(Trigger.new);                

            }
        } 
        if (Trigger.isUpdate) 
        {
            if(ContactRecursionCheck.RunOnceCheck())
            {  
                ContactTriggerHandler.checkPrimary(Trigger.new);
            }             

        }
        if (Trigger.isDelete) 
        {
        }
    }
        
    if (Trigger.IsAfter) 
    {
        if (Trigger.isInsert) 
        {
            MasterContactObjectManager masterContactObj = new MasterContactObjectManager();
            masterContactObj.CreateMasterContact(Trigger.new);
        } 
        if (Trigger.isUpdate)
        { 
        }
        if (Trigger.isDelete)
        {
        }
        if(Trigger.isUndelete)
        {
        }
    }
}