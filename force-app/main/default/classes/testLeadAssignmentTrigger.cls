@isTest
public class testLeadAssignmentTrigger
{
    @istest
    static void testTrigger()
    {
         Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Territory_Setup__c setup0 = new Territory_Setup__c(Status__c = 'On');
        insert setup0;
         Lead_Territory__c testLt = new Lead_Territory__c(Name = 'Acme', Type__c = 'Standard', Assigned_To_Type__c = 'User', Assigned_To_ID__c = Userinfo.getUserId(), Assigned_To__c = userinfo.getUserName(), Order__c = 1);
        insert testLt;
        //AnnualRevenue
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria1 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'AppJam_Presenter__c', Value__c = 'true', Operator__c = 'equals', Lead_Territory__c = testLt.Id);
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria2 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'Deal_Stage__c', Value__c = 'Qualified', Operator__c = 'equals', Lead_Territory__c = testLt.Id);
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria3 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'AnnualRevenue', Value__c = '100000', Operator__c = 'equals', Lead_Territory__c = testLt.Id);
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria4 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'App_Map_First_Visit__c', Value__c = '9/8/2014', Operator__c = 'equals', Lead_Territory__c = testLt.Id);
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria5 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'Estimated_Close_Date__c', Value__c = '9/8/2014', Operator__c = 'equals', Lead_Territory__c = testLt.Id);
        
        insert new List<Lead_Territory_Field_Criteria__c> {testLeadFIeldCriteria1, testLeadFIeldCriteria2, testLeadFIeldCriteria3, testLeadFIeldCriteria4, testLeadFIeldCriteria5};
        String theDate = '9/8/2014';
        String[] dates = theDate.split('/');
        DateTime criteriaValue = DateTime.newInstance(Integer.valueOf(dates[2]), Integer.valueOf(dates[0]), Integer.valueOf(dates[1]));
        Date dealDate = Date.newInstance(Integer.valueOf(dates[2]), Integer.valueOf(dates[0]), Integer.valueOf(dates[1]));
        Lead_Territory_Geography__c testLeadGeo = new Lead_Territory_Geography__c(Lead_Territory__c = testLt.Id, Country__c = 'usa', State__c = 'ca', Zip_Start__c = '1000', Zip_End__c = '2000');
        insert testLeadGeo;
        Lead testLead = new Lead(LastName = 'acme', Status = 'open', Company = 'acme', PostalCode = '1500', Deal_Stage__c = 'Qualified', AppJam_Presenter__c = true, AnnualRevenue = 100000, App_Map_First_Visit__c = criteriaValue, Estimated_Close_Date__c = dealDate);
        insert testLead;
        testLead.Run_Lead_Assignment__c = true;
        update testLead;
        Test.stopTest();
    }    
}