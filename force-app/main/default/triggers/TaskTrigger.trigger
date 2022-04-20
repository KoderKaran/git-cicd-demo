/**
 *=====================================================================================================================================
    Date                Author               Comment
  =====================================================================================================================================
    June-3-2015        Lochan Karle          Trigger for the handler TaskTriggerHandler  
                                             When Activity gets created/inserted then copy
                                             Task.Disposition__c values into itz Lead.Lead_Disposition__c field.
 */

trigger TaskTrigger on Task (after insert , after update) {
    if(Trigger.isAfter && Trigger.isInsert ){
        TaskTriggerHandler.onBeforeInsertActivity(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        
        List<Task> lstTask = new List<Task>();
        
        for(Task objTask : Trigger.New){
        
            Task objOldTask = Trigger.OldMap.get(objTask.Id);
            
            if(objTask.Disposition__c != objOldTask.Disposition__c ){
            
                lstTask.add(objTask);
            }
        }
        if(lstTask.size() > 0 && lstTask != null)
        {
            //system.debug('!!!!!!!!!!!lstTask'+lstTask);
            TaskTriggerHandler.onBeforeInsertActivity(lstTask);
        }
    }
}