/**
 *=====================================================================================================================================
    Date                Author               Comment
  =====================================================================================================================================
    June-3-2015        Lochan Karle          When Activity gets created/inserted then copy
                                             Task.Disposition__c values into itz Lead.Lead_Disposition__c field.
                                               
    
*/    

public with sharing class TaskTriggerHandler{
    public static void onBeforeInsertActivity(List <Task> listTask){
    
        map <Id,Task> mapLeadIdTask = new map<Id,Task>();
        map <Id,Task> mapTaskLeadAct = new map<Id,Task>();
    
        for(Task objTask : listTask){
            if(objTask.whoId!=null){
                mapLeadIdTask.put(objTask.whoId,objTask);
            }
            
            if(objTask.WhoId != NULL){
                String leadId = String.valueOf(objTask.WhoId);
                if(leadId.contains('00Q') && objTask.CreatedById != System.Label.Automated_Id ){
                    //put filter
                    mapTaskLeadAct.put(objTask.whoId,objTask);
                }
            }
            //end if
        }// end for
        
        
       if(mapLeadIdTask !=null && mapLeadIdTask.size() > 0 && !mapLeadIdTask.isEmpty()){
            map <Id,Lead> mapLead = new map <Id,Lead>([SELECT Id,
                                                          Lead_Disposition__c       
                                                       FROM Lead
                                                       WHERE Id IN : mapLeadIdTask.keySet() 
                                                       ]);
    
           List<Lead> listLead = new List<Lead>();
           for(Lead objLead  : mapLead.values()){
               if(mapLeadIdTask.containskey(objLead.Id) && mapLeadIdTask.get(objLead.Id).Disposition__c != null){   
                 //system.debug('====Lead_Disposition__c'+objLead.Lead_Disposition__c);
                  objLead.Lead_Disposition__c = mapLeadIdTask.get(objLead.Id).Disposition__c;
                 //system.debug('====Lead_Disposition__c'+objLead.Lead_Disposition__c); 
                  listLead.add(objLead);
               }//end if
           }//end for
           if(listLead != null && listLead.size() > 0){
               update listLead;
           }//end if
      }//end if     
      
      if(mapLeadIdTask !=null && mapTaskLeadAct.size() > 0 && !mapTaskLeadAct.isEmpty()){
            Id telesalesId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Telesales').getRecordTypeId();
            map <Id,Lead> mapLead = new map <Id,Lead>([SELECT Id,
                                                          First_Activity_Date__c,
                                                          RecordtypeId       
                                                       FROM Lead
                                                       WHERE Id IN : mapTaskLeadAct.keySet() 
                                                       ]);
    
           List<Lead> listLead = new List<Lead>();
           for(Lead objLead  : mapLead.values()){
               if(mapTaskLeadAct.containskey(objLead.Id) && objLead.First_Activity_Date__c == null && telesalesId == objLead.RecordtypeId){   
                 objLead.First_Activity_Date__c = mapTaskLeadAct.get(objLead.Id).ActivityDate;
                 listLead.add(objLead);
               }//end if
           }//end for
           if(listLead != null && listLead.size() > 0){
               update listLead;
           }//end if
      }    
    
   }
}