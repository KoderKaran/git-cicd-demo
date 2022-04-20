@isTest
public class testReAssignLeadsBatch
{
    @isTest
    static void testBatch()
    {
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
        String strFields = '';
        for(String strField : Schema.SObjectType.Lead.fields.getMap().keySet())
        {
            strFields += strField + ', ';
        }
        String m_strAllLeadFields = strFields.substring(0, strFields.length()-2);
        String strFilterInQuery = 'where Id in (';
        strFilterInQuery += '\'' + testLt.Id + '\', ';
        strFilterInQuery = strFilterInQuery.substring(0, strFilterInQuery.length()-2);
        strFilterInQuery += ')';
        String strQuery = 'select ' + m_strAllLeadFields + ' from Lead ' + strFilterInQuery;
        Map<Id, Lead> leadmap = new Map<Id, Lead>();
        leadmap.put(testLead.Id, testLead);
        ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadmap);
        Database.executeBatch(reassignLeadBatchJob, 1);
    }
    
    @isTest
    static void testBatch2()
    {
        Lead_Territory__c testLt = new Lead_Territory__c(Name = 'Acme', Type__c = 'Standard', Assigned_To_Type__c = 'User', Assigned_To_ID__c = Userinfo.getUserId(), Assigned_To__c = userinfo.getUserName(), Order__c = 1);
        insert testLt;
        //AnnualRevenue
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria1 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'AppJam_Presenter__c', Value__c = 'true', Operator__c = 'not equal to', Lead_Territory__c = testLt.Id);
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria2 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'Deal_Stage__c', Value__c = 'Qualified', Operator__c = 'not equal to', Lead_Territory__c = testLt.Id);
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria3 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'AnnualRevenue', Value__c = '100000', Operator__c = 'not equal to', Lead_Territory__c = testLt.Id);
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria4 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'App_Map_First_Visit__c', Value__c = '9/8/2014', Operator__c = 'not equal to', Lead_Territory__c = testLt.Id);
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria5 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'Estimated_Close_Date__c', Value__c = '9/8/2014', Operator__c = 'not equal to', Lead_Territory__c = testLt.Id);
        
        insert new List<Lead_Territory_Field_Criteria__c> {testLeadFIeldCriteria1, testLeadFIeldCriteria2, testLeadFIeldCriteria3, testLeadFIeldCriteria4, testLeadFIeldCriteria5};
        String theDate = '9/8/2014';
        String[] dates = theDate.split('/');
        DateTime criteriaValue = DateTime.newInstance(Integer.valueOf(dates[2]), Integer.valueOf(dates[0]), Integer.valueOf(dates[1]));
        Date dealDate = Date.newInstance(Integer.valueOf(dates[2]), Integer.valueOf(dates[0]), Integer.valueOf(dates[1]));
        Lead_Territory_Geography__c testLeadGeo = new Lead_Territory_Geography__c(Lead_Territory__c = testLt.Id, Country__c = 'usa', State__c = 'ca', Zip_Start__c = '1000', Zip_End__c = '2000');
        insert testLeadGeo;
        Lead testLead = new Lead(LastName = 'acme', Status = 'open', Company = 'acme', PostalCode = '1500', Deal_Stage__c = 'Qualified', AppJam_Presenter__c = true, AnnualRevenue = 100000, App_Map_First_Visit__c = criteriaValue, Estimated_Close_Date__c = dealDate);
        insert testLead;
        String strFields = '';
        for(String strField : Schema.SObjectType.Lead.fields.getMap().keySet())
        {
            strFields += strField + ', ';
        }
        String m_strAllLeadFields = strFields.substring(0, strFields.length()-2);
        String strFilterInQuery = 'where Id in (';
        strFilterInQuery += '\'' + testLt.Id + '\', ';
        strFilterInQuery = strFilterInQuery.substring(0, strFilterInQuery.length()-2);
        strFilterInQuery += ')';
        String strQuery = 'select ' + m_strAllLeadFields + ' from Lead ' + strFilterInQuery;
        Map<Id, Lead> leadmap = new Map<Id, Lead>();
        leadmap.put(testLead.Id, testLead);
        ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadmap);
        Database.executeBatch(reassignLeadBatchJob, 1);
    }
    
    @isTest
    static void testBatch3()
    {
        Lead_Territory__c testLt = new Lead_Territory__c(Name = 'Acme', Type__c = 'Standard', Assigned_To_Type__c = 'User', Assigned_To_ID__c = Userinfo.getUserId(), Assigned_To__c = userinfo.getUserName(), Order__c = 1);
        insert testLt;
        //AnnualRevenue
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria1 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'App_Map_First_Visit__c', Value__c = '9/8/2014', Operator__c = 'not equal to', Lead_Territory__c = testLt.Id);
        
        insert new List<Lead_Territory_Field_Criteria__c> {testLeadFIeldCriteria1};
        String theDate = '9/8/2014';
        String[] dates = theDate.split('/');
        DateTime criteriaValue = DateTime.newInstance(Integer.valueOf(dates[2]), Integer.valueOf(dates[0]), Integer.valueOf(dates[1]));
        Lead_Territory_Geography__c testLeadGeo = new Lead_Territory_Geography__c(Lead_Territory__c = testLt.Id, Country__c = 'usa', State__c = 'ca', Zip_Start__c = '1000', Zip_End__c = '2000');
        insert testLeadGeo;
        Lead testLead = new Lead(LastName = 'acme', Status = 'open', Company = 'acme', PostalCode = '1500', Deal_Stage__c = 'Qualified', AppJam_Presenter__c = true, AnnualRevenue = 100000, App_Map_First_Visit__c = criteriaValue);
        insert testLead;
        String strFields = '';
        for(String strField : Schema.SObjectType.Lead.fields.getMap().keySet())
        {
            strFields += strField + ', ';
        }
        String m_strAllLeadFields = strFields.substring(0, strFields.length()-2);
        String strFilterInQuery = 'where Id in (';
        strFilterInQuery += '\'' + testLt.Id + '\', ';
        strFilterInQuery = strFilterInQuery.substring(0, strFilterInQuery.length()-2);
        strFilterInQuery += ')';
        String strQuery = 'select ' + m_strAllLeadFields + ' from Lead ' + strFilterInQuery;
        Map<Id, Lead> leadmap = new Map<Id, Lead>();
        leadmap.put(testLead.Id, testLead);
        ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadmap);
        Database.executeBatch(reassignLeadBatchJob, 1);
    }
    
    @isTest
    static void testBatch4()
    {
        Lead_Territory__c testLt = new Lead_Territory__c(Name = 'Acme', Type__c = 'Standard', Assigned_To_Type__c = 'User', Assigned_To_ID__c = Userinfo.getUserId(), Assigned_To__c = userinfo.getUserName(), Order__c = 1);
        insert testLt;
        //AnnualRevenue
        Lead_Territory_Field_Criteria__c testLeadFIeldCriteria1 = new Lead_Territory_Field_Criteria__c(Lead_Field__c = 'Estimated_Close_Date__c', Value__c = '9/8/2014', Operator__c = 'not equal to', Lead_Territory__c = testLt.Id);        
        insert new List<Lead_Territory_Field_Criteria__c> {testLeadFIeldCriteria1};
        String theDate = '9/8/2014';
        String[] dates = theDate.split('/');
        Date dealDate = Date.newInstance(Integer.valueOf(dates[2]), Integer.valueOf(dates[0]), Integer.valueOf(dates[1]));
        Lead_Territory_Geography__c testLeadGeo = new Lead_Territory_Geography__c(Lead_Territory__c = testLt.Id, Country__c = 'usa', State__c = 'ca', Zip_Start__c = '1000', Zip_End__c = '2000');
        insert testLeadGeo;
        Lead testLead = new Lead(LastName = 'acme', Status = 'open', Company = 'acme', PostalCode = '1500', Deal_Stage__c = 'Qualified', AppJam_Presenter__c = true, AnnualRevenue = 100000, Estimated_Close_Date__c = dealDate);
        insert testLead;
        String strFields = '';
        for(String strField : Schema.SObjectType.Lead.fields.getMap().keySet())
        {
            strFields += strField + ', ';
        }
        String m_strAllLeadFields = strFields.substring(0, strFields.length()-2);
        String strFilterInQuery = 'where Id in (';
        strFilterInQuery += '\'' + testLt.Id + '\', ';
        strFilterInQuery = strFilterInQuery.substring(0, strFilterInQuery.length()-2);
        strFilterInQuery += ')';
        String strQuery = 'select ' + m_strAllLeadFields + ' from Lead ' + strFilterInQuery;
        Map<Id, Lead> leadmap = new Map<Id, Lead>();
        leadmap.put(testLead.Id, testLead);
        ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadmap);
        Database.executeBatch(reassignLeadBatchJob, 1);
    }

    @isTest
    static void testBatch5() {
        Lead testLead = new Lead(
            LastName = 'acme', 
            Status = 'open', 
            Company = 'acme', 
            PostalCode = '1500',
            Deal_Stage__c = 'Qualified', 
            AppJam_Presenter__c = true, 
            AnnualRevenue = 100000, 
            Estimated_Close_Date__c = Date.today()
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

        String query = 'SELECT Id, Name, Status, Company, PostalCode, Deal_Stage__c, AppJam_Presenter__c, AnnualRevenue, Estimated_Close_Date__c FROM Lead';
        Map<Id, Lead> leadmap = new Map<Id, Lead>();
        ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(query, leadmap);
        Database.executeBatch(reassignLeadBatchJob, 1);
    }
}