@isTest
private class AssignToLeadTerritoryTriggerTest {

    @isTest
    static void updateLeadTest() {
        Lead testLead = new Lead(
            LastName = 'acme', 
            Status = 'open', 
            Company = 'acme', 
            PostalCode = '1500',
            Deal_Stage__c = 'Qualified', 
            AppJam_Presenter__c = true, 
            AnnualRevenue = 100000, 
            Estimated_Close_Date__c = Date.today(),
            No_Mass_Update__c = true,
            DatetimeField__c = Datetime.now(),
            Run_Lead_Assignment__c = true
        );
        insert testLead;

        Territory_Setup__c setup = new Territory_Setup__c(
            Next_Mass_Update_Date_Lead__c = Date.today(),
            Status__c = 'on'
        );
        insert setup;

        Test.startTest();
        testLead.Run_Lead_Assignment__c = true;
        update testLead;
        Test.stopTest();
        System.assert(testLead.Run_Lead_Assignment__c != null);
    }
}