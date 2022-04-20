@isTest
public class SendEmailNotContactedTest {
    static testMethod void testMethod1() 
    {
        List<Opportunity> lstOpp= new List<Opportunity>();
        for(Integer i=0 ;i <10;i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name ='Name'+i;
            opp.ASM_email__c = 'test@gmail.com';
            opp.StageName = 'Closed Won';
            opp.ForecastCategoryName = 'Pipeline';
            opp.Date_when_Stage_not_contacted__c = system.today() - 7;
            opp.CloseDate = system.today();
            lstOpp.add(opp);
        }
       
        
        insert lstOpp;
        
        Contact tc = new Contact();
        tc.LastName = 'Test Simplus Batch';
        tc.email = 'noreply@salesforce.com';
        
        insert tc;
        
        Test.startTest();
        
        SendEmailNotContacted obj = new SendEmailNotContacted();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
    
    static testmethod void forSchedulable(){
        List<Opportunity> lstOpp= new List<Opportunity>();
        for(Integer i=0 ;i <5;i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name ='Name'+i;
            opp.ASM_email__c = 'test@gmail.com';
            opp.StageName = 'Closed Won';
            opp.ForecastCategoryName = 'Pipeline';
            opp.Date_when_Stage_not_contacted__c = system.today() - 7;
            opp.CloseDate = system.today();
            lstOpp.add(opp);
        }
       
        
        insert lstOpp;
        
        Contact tc = new Contact();
        tc.LastName = 'Test Simplus Batch';
        tc.email = 'noreply@salesforce.com';
        
        insert tc;
        Test.startTest();
        SendEmailNotContactedSchedule sh1 = new SendEmailNotContactedSchedule();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Schedulable', sch, sh1); 
        Test.stopTest();
    }
}