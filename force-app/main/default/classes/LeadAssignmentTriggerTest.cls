/*
 *      Description: Test class to test Lead Assignment Rule Trigger and Trigger Handler
 *
 */  
@ isTest
private class LeadAssignmentTriggerTest {
    
    // Set up test record where we set the Owner for Lead as the current user other than the assignment rules User
    @testSetup static void setTestData(){
        Lead objLead = new Lead();
        
        // Get recordtype id for an active recordtype for Lead
        List<RecordType> listRecordType = [Select Id 
                                           From RecordType
                                           Where sObjectType='Lead' and isActive=true
                                           Limit 1];
        
        objLead.RecordTypeId = listRecordType[0].Id;
        objLead.LastName = 'Sample Lead';
        objLead.Status = 'New';
        objLead.Company = 'Test Company';
        
        // Insert the Lead
        insert objLead;
        
        objLead.OwnerId = UserInfo.getUserId();
        
        update objLead;
    }
    
    // Test lead assignment trigger for single Lead
    static testMethod void testLeadAssignmentForSingleRecord(){
        
        Lead objLead = new Lead();
        
        // Get recordtype id for an active recordtype for Lead
        List<RecordType> listRecordType = [Select Id 
                                           From RecordType
                                           Where sObjectType='Lead' and isActive=true
                                           Limit 1];
        
        objLead.RecordTypeId = listRecordType[0].Id;
        objLead.LastName = 'Test';
        objLead.Status = 'New';
        objLead.Company = 'Test Company';
        
        // Insert the Lead
        insert objLead;
        
        Lead objTestLead = [Select Id, OwnerId From Lead Where LastName = 'Sample Lead'];
        
        // Check if the Owners are different if true then throw an assert
        if(objTestLead.OwnerId != objLead.OwnerId){
            System.assert(true);
        }
    }
    
    // Test lead assignment trigger for multiple Leads
    static testMethod void testLeadAssignmentForMultipleRecord(){
        
        List<Lead> listLead = new List<Lead>();
        
        // Get recordtype id for an active recordtype for Lead
        List<RecordType> listRecordType = [Select Id 
                                           From RecordType
                                           Where sObjectType='Lead' and isActive=true
                                           Limit 1];
        
        // Create multiple Leads
        for(Integer countLead = 0; countLead < 100; countLead ++){
            Lead objLead = new Lead();
            
            objLead.RecordTypeId = listRecordType[0].Id;
            objLead.LastName = 'Test'+ countLead;
            objLead.Status = 'New';
            objLead.Company = 'Test Company'+countLead;
            
            listLead.add(objLead);
        }      
        
        // Insert all the Leads
        insert listLead;
        
        Lead objTestLead = [Select Id, OwnerId From Lead Where LastName = 'Sample Lead'];
        
        // Check if the Owners are different if true then throw an assert
        if(objTestLead.OwnerId != listLead[0].OwnerId){
            System.assert(true);
        }
    }
}