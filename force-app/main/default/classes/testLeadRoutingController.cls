@isTest
private class testLeadRoutingController {
	
	@testSetup static void setup() {
		User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'Owner1',
             Email = 'test@1.com',
             Username = 'test@1.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
        );

        insert u;

	 	List<Lead_Territory__c> leadTerrs = new List<Lead_Territory__c>{
	 		new Lead_Territory__c(
	 			Name = 'testLeadTerr1',
	 			OwnerId = u.Id
	 		),
	 		new Lead_Territory__c(
	 			Name = 'testLeadTerr2',
	 			OwnerId = u.Id
	 		),
	 		new Lead_Territory__c(
	 			Name = 'testLeadTerr3',
	 			OwnerId = u.Id
	 		)
	 	};
	 	insert leadTerrs;

	 	insert new List<Lead_Territory_Geography__c>{
	 		new Lead_Territory_Geography__c(
	 			Lead_Territory__c = leadTerrs.get(0).Id
	 		),
	 		new Lead_Territory_Geography__c(
	 			Lead_Territory__c = leadTerrs.get(0).Id
	 		),
	 		new Lead_Territory_Geography__c(
	 			Lead_Territory__c = leadTerrs.get(0).Id
	 		)
	 	};

	 	insert new List<Lead_Territory_Field_Criteria__c>{
	 		new Lead_Territory_Field_Criteria__c(
	 			Lead_Territory__c = leadTerrs.get(0).Id
	 		),
	 		new Lead_Territory_Field_Criteria__c(
	 			Lead_Territory__c = leadTerrs.get(0).Id
	 		),
	 		new Lead_Territory_Field_Criteria__c(
	 			Lead_Territory__c = leadTerrs.get(0).Id
	 		)
	 	};
 	}

	@isTest
    static void test_getLeadTerritories() {
    	List<Lead_Territory__c> leadTerrs = new List<Lead_Territory__c>();

    	Test.startTest();
    	leadTerrs = LeadRoutingController.getLeadTerritories();
    	Test.stopTest();

    	System.assertEquals(3, leadTerrs.size());
    }

    @isTest
    static void test_getGeographies() {
    	Lead_Territory__c leadTerr1 = [SELECT Id FROM Lead_Territory__c WHERE Name = 'testLeadTerr1' LIMIT 1];
    	Lead_Territory__c leadTerr2 = [SELECT Id FROM Lead_Territory__c WHERE Name != 'testLeadTerr1' LIMIT 1];
    	List<Lead_Territory_Geography__c> leadGeogrs1 = new List<Lead_Territory_Geography__c>();
    	List<Lead_Territory_Geography__c> leadGeogrs2 = new List<Lead_Territory_Geography__c>();

    	Test.startTest();
    	leadGeogrs1 = LeadRoutingController.getGeographies(leadTerr1.Id);
    	leadGeogrs2 = LeadRoutingController.getGeographies(leadTerr2.Id);
    	Test.stopTest();

    	System.assertEquals(3, leadGeogrs1.size());
    	System.assertEquals(null, leadGeogrs2);
    }

    @isTest
    static void test_getCriterias() {
    	Lead_Territory__c leadTerr1 = [SELECT Id FROM Lead_Territory__c WHERE Name = 'testLeadTerr1' LIMIT 1];
    	Lead_Territory__c leadTerr2 = [SELECT Id FROM Lead_Territory__c WHERE Name != 'testLeadTerr1' LIMIT 1];
    	List<Lead_Territory_Field_Criteria__c> leadGeogrs1 = new List<Lead_Territory_Field_Criteria__c>();
    	List<Lead_Territory_Field_Criteria__c> leadGeogrs2 = new List<Lead_Territory_Field_Criteria__c>();

    	Test.startTest();
    	leadGeogrs1 = LeadRoutingController.getCriterias(leadTerr1.Id);
    	leadGeogrs2 = LeadRoutingController.getCriterias(leadTerr2.Id);
    	Test.stopTest();

    	System.assertEquals(3, leadGeogrs1.size());
    	System.assertEquals(null, leadGeogrs2);
    }

    @isTest
    static void test_removeGeography() {
    	Lead_Territory__c terr = [SELECT Id FROM Lead_Territory__c WHERE Name = 'testLeadTerr1' LIMIT 1];
    	Lead_Territory_Geography__c leadGeogrs = [SELECT Id FROM Lead_Territory_Geography__c WHERE Lead_Territory__c = :terr.Id LIMIT 1];

    	String answ1;
    	String answ2;

    	Test.startTest();
    	answ1 = LeadRoutingController.removeGeography(leadGeogrs.Id);
    	answ2 = LeadRoutingController.removeGeography(null);
    	Test.stopTest();

    	System.assertEquals('Deleted', answ1);
    	System.assertEquals(null, answ2);
    }

    @isTest
    static void test_removeCriteria() {
    	Lead_Territory__c terr = [SELECT Id FROM Lead_Territory__c WHERE Name = 'testLeadTerr1' LIMIT 1];
    	Lead_Territory_Field_Criteria__c leadCriteria = [SELECT Id FROM Lead_Territory_Field_Criteria__c WHERE Lead_Territory__c = :terr.Id LIMIT 1];

    	String answ1;
    	String answ2;

    	Test.startTest();
    	answ1 = LeadRoutingController.removeCriteria(leadCriteria.Id);
    	answ2 = LeadRoutingController.removeCriteria(null);
    	Test.stopTest();

    	System.assertEquals('Deleted', answ1);
    	System.assertEquals(null, answ2);
    }

    @isTest
    static void test_getValueByField() {
    	Test.startTest();
    	LeadRoutingController.GetValueByFieldWrapper answ1 = LeadRoutingController.getValueByField('FirstName');
    	LeadRoutingController.GetValueByFieldWrapper answ2 = LeadRoutingController.getValueByField('Salutation');
    	LeadRoutingController.GetValueByFieldWrapper answ3 = LeadRoutingController.getValueByField('LastTransferDate');
    	Test.stopTest();

    	//System.assert(answ1.isText);
    	//System.assert(answ2.isPicklist);
    	//System.assert(answ3.isDate);
    }

    @isTest
    static void test_getTerritoryTypes() {
    	List<String> answ1 = new List<String>();

    	Test.startTest();
    	answ1 = LeadRoutingController.getTerritoryTypes();
    	Test.stopTest();

    	System.assertEquals(2, answ1.size());
    }
    
    @isTest
    static void test_getAssignTypes() {
    	List<String> answ1 = new List<String>();

    	Test.startTest();
    	answ1 = LeadRoutingController.getAssignTypes();
    	Test.stopTest();

    	System.assertEquals(2, answ1.size());
    }

    @isTest
    static void test_getLeadFields() {
    	List<Map<String, String>> answ1 = new List<Map<String, String>>();

    	Test.startTest();
    	answ1 = LeadRoutingController.getLeadFields();
    	Test.stopTest();

    	System.assertNotEquals(null, answ1);
    }

    @isTest
    static void test_getLookupValue() {
    	List<SObject> answ1 = new List<SObject>();
    	List<SObject> answ2 = new List<SObject>();
    	List<SObject> answ3 = new List<SObject>();

    	Test.startTest();
    	answ1 = LeadRoutingController.getLookupValue('User', '');
    	answ2 = LeadRoutingController.getLookupValue('Lead Queue', '');
    	answ3 = LeadRoutingController.getLookupValue('Nonexistent', '');
    	Test.stopTest();

    	System.assert(!answ1.isEmpty());
    	System.assert(!answ2.isEmpty());
    	System.assertEquals(null, answ3);
    }

    @isTest
    static void test_upsertTerritory() {
    	Lead_Territory__c leadTerr1 = [SELECT Name FROM Lead_Territory__c LIMIT 1];
    	Lead_Territory__c leadTerr2 = new Lead_Territory__c();

    	leadTerr1.Name = 'newTempName';

    	Id answ1;
    	Id answ2;

    	Test.startTest();
    	answ1 = LeadRoutingController.upsertTerritory(leadTerr1);
    	Test.stopTest();

    	System.assert(String.isNotBlank(String.valueOf(answ1)));
    }

    @isTest
    static void test_upsertGeography() {
    	Lead_Territory__c terr = [SELECT Id FROM Lead_Territory__c WHERE Name = 'testLeadTerr1' LIMIT 1];

    	Lead_Territory_Geography__c leadGeogrs1 = [SELECT Id FROM Lead_Territory_Geography__c WHERE Lead_Territory__c = :terr.Id LIMIT 1];
    	Lead_Territory_Geography__c leadGeogrs2 = new Lead_Territory_Geography__c();

    	Id answ1;
    	Id answ2;

    	Test.startTest();
    	answ1 = LeadRoutingController.upsertGeography(leadGeogrs1);
    	answ2 = LeadRoutingController.upsertGeography(leadGeogrs2);
    	Test.stopTest();

    	System.assert(String.isNotBlank(String.valueOf(answ1)));
    	System.assertEquals(null, answ2);
    }

    @isTest
    static void test_upsertCriteria() {
    	Lead_Territory__c terr = [SELECT Id FROM Lead_Territory__c WHERE Name = 'testLeadTerr1' LIMIT 1];

    	Lead_Territory_Field_Criteria__c leadCriteria1 = [SELECT Id FROM Lead_Territory_Field_Criteria__c WHERE Lead_Territory__c = :terr.Id LIMIT 1];
    	Lead_Territory_Field_Criteria__c leadCriteria2 = new Lead_Territory_Field_Criteria__c();

    	Id answ1;
    	Id answ2;

    	Test.startTest();
    	answ1 = LeadRoutingController.upsertCriteria(leadCriteria1);
    	Test.stopTest();

    	System.assert(String.isNotBlank(String.valueOf(answ1)));
    }

    @isTest
    static void test_updateTerritories() {
    	List<Lead_Territory__c> terrs = [SELECT Name FROM Lead_Territory__c];
    	terrs.get(0).Name = 'tmpTestName1';
    	terrs.get(1).Name = 'tmpTestName2';
    	terrs.get(2).Name = 'tmpTestName3';

    	Boolean answ1;
    	Boolean answ2;

    	Test.startTest();
    	answ1 = LeadRoutingController.updateTerritories(terrs);
    	Test.stopTest();

    	System.assert(answ1);
    }

    @isTest
    static void test_setupStatus() {
    	Test.startTest();
    	LeadRoutingController.setupStatus('On');
    	System.assert([SELECT Status__c FROM Territory_Setup__c LIMIT 1].Status__c == 'On');

    	delete [SELECT Id FROM Territory_Setup__c LIMIT 1];

    	insert new Territory_Setup__c(
	 		Next_Mass_Update_Date_Lead__c = Date.newInstance(2025, 12, 5),
	 		Status__c = 'Off'
 		);
 		LeadRoutingController.setupStatus('On');
 		System.assert([SELECT Status__c FROM Territory_Setup__c LIMIT 1].Status__c == 'On');
    	Test.stopTest();
    }

    @isTest
    static void test_getLeadTerritorySetup() {
    	insert new Territory_Setup__c(
	 		Next_Mass_Update_Date_Lead__c = Date.newInstance(2025, 12, 5),
	 		Status__c = 'Off'
 		);

    	Test.startTest();
    	Territory_Setup__c setup = LeadRoutingController.getLeadTerritorySetup();
    	Test.stopTest();

    	System.assert(setup.Status__c == 'Off');
    }

    @isTest
    static void test_saveMassUpdatedDate() {
    	Territory_Setup__c setup = new Territory_Setup__c(
	 		Next_Mass_Update_Date_Lead__c = Date.newInstance(2025, 12, 5),
	 		Status__c = 'Off'
 		);
    	insert setup;

    	Boolean answ1;
    	Boolean answ2;

    	Test.startTest();
    	answ1 = LeadRoutingController.saveMassUpdatedDate(setup.Id, '6/12/2025', setup.Status__c);
    	answ2 = LeadRoutingController.saveMassUpdatedDate(null, '6/12/2025', 'On');
    	Test.stopTest();

    	System.assert(!answ1);
    	System.assert(answ2);
    }

    @isTest
    static void test_massUpdateTerritoriesImmed() {
    	Territory_Setup__c setup = new Territory_Setup__c(
	 		Next_Mass_Update_Date_Lead__c = Date.newInstance(2025, 12, 5),
	 		Status__c = 'Off'
 		);
    	insert setup;

    	Boolean answ1;
    	Boolean answ2;

    	Test.startTest();
    	answ1 = LeadRoutingController.massUpdateTerritoriesImmed(setup.Id, '6/12/2025', setup.Status__c);
    	answ2 = LeadRoutingController.massUpdateTerritoriesImmed(null, '6/12/2025', 'On');
    	Test.stopTest();

    	System.assert(!answ1);
    	System.assert(answ2);
    }

    @isTest
    static void test_insertNewLeadTerritoryGeosByCSV() {
    	Lead_Territory__c terr = [SELECT Id FROM Lead_Territory__c LIMIT 1];
    	List<Lead_Territory_Geography__c> result1 = new List<Lead_Territory_Geography__c>();
    	List<Lead_Territory_Geography__c> result2 = new List<Lead_Territory_Geography__c>();
    	
    	Test.startTest();
    	result1 = LeadRoutingController.insertNewLeadTerritoryGeosByCSV(terr.Id, 'USA,NY,12,321');
    	result2 = LeadRoutingController.insertNewLeadTerritoryGeosByCSV(null, '');
    	Test.stopTest();
    }

}