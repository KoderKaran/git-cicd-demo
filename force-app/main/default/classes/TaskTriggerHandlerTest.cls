/**
 *=====================================================================================================================================
    Date                Author               Comment
  =====================================================================================================================================
    June-3-2015        Lochan Karle          Test Class for TaskTriggerHandler Class .Lead_Disposition__c from Most Recent Activity 
                                             Disposition__c will be Updated to Lead.Lead_Disposition__c .
    
 */
@isTest
private class TaskTriggerHandlerTest {
    
  // This method is for testing for Updating Lead Lead_Disposition__c field from Most Recent Activity Disposition__c.(Task Insert)
    
    static testMethod void singleLeadActivityTest() {
        Lead objLead = new Lead ();
        objLead.LastName = 'Test';
        objLead.Company = 'TestCompany';
        objLead.Lead_DISPOSITION__C = 'CallBack';
        insert objLead;
    
        Task objTask = new Task();
        objTask.DISPOSITION__C = 'Installed';
        objTask.Priority = 'Normal';
        objTask.Subject = 'Call';
        objTask.Status = 'Completed';
        objTask.WhoId = objLead.Id;
        insert objTask;
    
        Lead obLead = [Select Id ,Lead_DISPOSITION__C
                        From Lead where Id =:objLead.Id];
                        
        system.assertEquals('Installed', obLead.Lead_DISPOSITION__C);
    }
    
    // This method is for testing for bulk Updating Lead Lead_Disposition__c field from itz Most Recent Activity Disposition__c.
       static testMethod void bulkLeadActivityTest() {
        List <Lead> lstLead = new  List <Lead> ();
        
        for(Integer i = 0; i < 20; i++){
            Lead objLead = new Lead ();
            objLead.LastName = 'Test'+i;
            objLead.Company = 'TestCompany'+i;
            objLead.Lead_DISPOSITION__C = 'CallBack';
            lstLead.add(objLead);
        }
        insert lstLead;
    
        List <Task> lstTask = new  List <Task> ();
    
        for(Integer i = 0; i < 20; i++){
            Task objTask = new Task();
            objTask.DISPOSITION__C = 'Installed'+i;
            objTask.Priority = 'Normal';
            objTask.Subject = 'Call';
            objTask.Status = 'Completed';
            objTask.WhoId = lstLead[i].Id;
            lstTask.add(objTask);
        }
        insert lstTask;
    
         List<Lead> listLead = [Select Id ,Lead_DISPOSITION__C
                               From Lead where Id =:lstLead];
         for(Integer i = 0; i < listLead.size(); i++){               
             system.assertEquals('Installed'+i, listLead[i].Lead_DISPOSITION__C);
    
    
         }
       }
      // This method is for testing for Updating Lead Lead_Disposition__c field from Most Recent Activity Disposition__c.(Task update)
    
       static testMethod void singleLeadActivityUpdateTest() {
        Lead objLead = new Lead ();
        objLead.LastName = 'Test';
        objLead.Company = 'TestCompany';
        objLead.Lead_DISPOSITION__C = 'CallBack';
        insert objLead;
    
        Task objTask = new Task();
        objTask.DISPOSITION__C = 'Installed';
        objTask.Priority = 'Normal';
        objTask.Subject = 'Call';
        objTask.Status = 'Completed';
        objTask.WhoId = objLead.Id;
        insert objTask;
    
        objTask.DISPOSITION__C = 'Wrong Number';
        update objTask;
    
        Lead obLead = [Select Id ,Lead_DISPOSITION__C
                        From Lead where Id =:objLead.Id];
    
        system.assertEquals('Wrong Number', obLead.Lead_DISPOSITION__C);
    }
    
}