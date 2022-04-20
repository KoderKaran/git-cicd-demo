@isTest
private class LeadDesignTriggerHandlerTest{
    @isTest static void createLead(){
        List<Lead> leadList = new List<Lead>();
        
        for(Integer i=0;i<10;i++){
            Lead newLead = new Lead();
            newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
            newLead.LastName = 'Sample' + i;
            newLead.Stage__c = 'New';
            newLead.Theater_Type__c = 'Dedicated';
            newLead.Audio_Zones_Qty__c  = 1;
            newLead.Lighting_Design_Type__c = '1';
            newLead.Wireless_High_Throughput_Devices__c = 1;
            leadList.add(newLead);
        }      
        insert leadList;
    }  
    @isTest static void convertLead(){
      /*  Profile p = [select id 
                     from profile
                     WHERE UserType = 'Standard'
                     AND Name = 'System Administrator'
                     limit 1];           
        String testemail = 'test.simplus@simplus.test';
        User u = new User(profileId = p.id, username = testemail, email = testemail, 
                       emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                       languagelocalekey = 'en_US', timezonesidkey = 'America/Denver', 
                       alias='cspu', lastname='testlastname');
        insert u;
        Lead newLead = new Lead();
        newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
        newLead.LastName = 'TestClassSimplus';
        newLead.OwnerId = u.Id;
        newLead.Stage__c = 'New';
        newLead.Theater_Type__c = 'Dedicated';
        newLead.Audio_Zones_Qty__c  = 1;
        newLead.Lighting_Design_Type__c = '1';
        newLead.Wireless_High_Throughput_Devices__c = 1;
        
        insert newLead;
        
        Test.startTest();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(newLead.id);              
        leadStatus convertStatus = [SELECT Id, ApiName FROM LeadStatus WHERE IsConverted=true AND ApiName ='Became a Dealer'];
        lc.setConvertedStatus(convertStatus.ApiName);
        lc.setOwnerId(u.Id);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.stopTest();
    } */
        Profile p = [select id 
                     from profile
                     WHERE UserType = 'Standard'
                     AND Name = 'System Administrator'
                     limit 1];           
        String testemail = 'test.simplus@simplus.test';
        
         User u = new User(profileId = p.id, username = testemail, email = testemail, 
                       emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                       languagelocalekey = 'en_US', timezonesidkey = 'America/Denver', 
                       alias='cspu', lastname='testlastname');
        insert u;
        
    	Lead objLead = new Lead( FirstName = 'Test', LastName = 'Sample', Company = 'Testing Sample Co',OwnerId = u.Id);  
        insert objLead;  
          
        Database.LeadConvert lc = new database.LeadConvert();  
        lc.setLeadId( objLead.Id );  
        lc.setDoNotCreateOpportunity( true );  
        lc.setConvertedStatus( 'Closed - Converted' );
        lc.setOwnerId(u.Id);
          
        Database.LeadConvertResult lcr = Database.convertLead(lc, false);  
          
        system.debug( 'Errors are ' + lcr.getErrors() ); 
        
		
}
}