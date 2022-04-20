trigger CaseTrigger on Case (before insert, after insert, before update, after update, before delete, after delete, after undelete)
{
    Triggers_Configuration__mdt config = [SELECT ProcessName__c, isEnabled__c
                                              FROM Triggers_Configuration__mdt
                                              WHERE Trigger_API_Name__c = 'CaseTrigger' LIMIT 1];
    
    if (Trigger.isBefore) 
    {
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
            if (config.ProcessName__c == 'eMailRMAFromApex' && !config.isEnabled__c)
            {
                RMAProcessControllerV2 controller = new RMAProcessControllerV2();            
                controller.eMailRMA_DoNotSendEmail(Trigger.New);  
            }           
        }
        if (Trigger.isDelete) {}
    }
        
    if (Trigger.IsAfter) 
    {
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
            if(config.ProcessName__c == 'eMailRMAFromApex' && config.isEnabled__c)
            {
                RMAProcessControllerV2 controller = new RMAProcessControllerV2();            
                controller.eMailRMAFromApex(Trigger.New);                
            }
        } 

        if (Trigger.isDelete) {}
        if(Trigger.isUndelete) {}
    }
}