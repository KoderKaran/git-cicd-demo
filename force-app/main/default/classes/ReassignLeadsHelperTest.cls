@isTest
private class ReassignLeadsHelperTest {

    @isTest
    static void assignLeadTerrTest1() {
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
            DatetimeField__c = Datetime.now()
        );
        insert testLead;

        Lead_Territory__c leadTerritory = new Lead_Territory__c(
            Name = 'test method', 
            Type__c = 'Standard', 
            Assigned_To__c = 'Test',
            Assigned_To_ID__c = '005800000069KB5', 
            Assigned_To_Type__c = 'User'
        );
        insert leadTerritory;

        Lead_Territory_Geography__c geography_item1 = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        Lead_Territory_Geography__c geography_item2 = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        Lead_Territory_Geography__c geography_item3 = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        Lead_Territory_Geography__c geography_item4 = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        List<Lead_Territory_Geography__c> geographies = new List<Lead_Territory_Geography__c>{ geography_item1, geography_item2, geography_item3, geography_item4 };
        insert geographies;

        Lead_Territory_Field_Criteria__c fieldCriteria_item1 = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id,
            Lead_Field__c = 'Estimated_Close_Date__c',
            Operator__c = 'equals',
            Value__c = '9/8/2014'
        );
        insert fieldCriteria_item1;
        ReassignLeadsHelper.assignLeadTerr(testLead);

        Lead_Territory_Field_Criteria__c fieldCriteria_item2 = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id,
            Lead_Field__c = 'DatetimeField__c',
            Operator__c = 'equals',
            Value__c = '9/8/2014'
        );
        insert fieldCriteria_item2;
        ReassignLeadsHelper.assignLeadTerr(testLead);

        Lead_Territory_Field_Criteria__c fieldCriteria_item3 = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id,
            Lead_Field__c = 'AnnualRevenue',
            Operator__c = 'equals',
            Value__c = '200000'
        );
        insert fieldCriteria_item3;
        ReassignLeadsHelper.assignLeadTerr(testLead);

        delete new List<Lead_Territory_Field_Criteria__c>{ fieldCriteria_item1, fieldCriteria_item2, fieldCriteria_item3 };

        Lead_Territory_Field_Criteria__c fieldCriteria_item4 = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id,
            Lead_Field__c = 'No_Mass_Update__c',
            Operator__c = 'equals',
            Value__c = 'false'
        );
        insert fieldCriteria_item4;
        Lead leadResult = ReassignLeadsHelper.assignLeadTerr(testLead);

        System.assertEquals(false, leadResult.Run_Lead_Assignment__c);
    }

    @isTest
    static void assignLeadTerrTest2() {
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
            DatetimeField__c = Datetime.now()
        );
        insert testLead;

        Lead_Territory__c leadTerritory = new Lead_Territory__c(
            Name = 'test method', 
            Type__c = 'Standard', 
            Assigned_To__c = 'Test',
            Assigned_To_ID__c = '005800000069KB5', 
            Assigned_To_Type__c = 'User'
        );
        insert leadTerritory;

        Lead_Territory_Geography__c geography_item1 = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        Lead_Territory_Geography__c geography_item2 = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        Lead_Territory_Geography__c geography_item3 = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        Lead_Territory_Geography__c geography_item4 = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        List<Lead_Territory_Geography__c> geographies = new List<Lead_Territory_Geography__c>{ geography_item1, geography_item2, geography_item3, geography_item4 };
        insert geographies;

        Lead_Territory_Field_Criteria__c fieldCriteria_item1 = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id,
            Lead_Field__c = 'Estimated_Close_Date__c',
            Operator__c = 'not equal to',
            Value__c = '9/8/2014'
        );
        insert fieldCriteria_item1;
        ReassignLeadsHelper.assignLeadTerr(testLead);

        Lead_Territory_Field_Criteria__c fieldCriteria_item2 = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id,
            Lead_Field__c = 'DatetimeField__c',
            Operator__c = 'not equal to',
            Value__c = '9/8/2014'
        );
        insert fieldCriteria_item2;
        ReassignLeadsHelper.assignLeadTerr(testLead);

        Lead_Territory_Field_Criteria__c fieldCriteria_item3 = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id,
            Lead_Field__c = 'AnnualRevenue',
            Operator__c = 'not equal to',
            Value__c = '200000'
        );
        insert fieldCriteria_item3;
        ReassignLeadsHelper.assignLeadTerr(testLead);

        delete new List<Lead_Territory_Field_Criteria__c>{ fieldCriteria_item1, fieldCriteria_item2, fieldCriteria_item3 };

        Lead_Territory_Field_Criteria__c fieldCriteria_item4 = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id,
            Lead_Field__c = 'No_Mass_Update__c',
            Operator__c = 'not equal to',
            Value__c = 'false'
        );
        insert fieldCriteria_item4;
        Lead leadResult = ReassignLeadsHelper.assignLeadTerr(testLead);

        System.assertEquals(leadTerritory.Id, leadResult.Lead_Territory__c);
    }

    @isTest
    static void isInPostalRangeTest() {
        Boolean result = ReassignLeadsHelper.isInPostalRange('123666321', '123', '321');
        System.assertEquals(true, result);
    }
}