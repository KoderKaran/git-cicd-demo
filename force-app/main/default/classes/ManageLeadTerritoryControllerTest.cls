@isTest
public class ManageLeadTerritoryControllerTest{
    
    @isTest static void testManageLeadTerritoryController(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        ManageLeadTerritoryController controller = new ManageLeadTerritoryController();
        controller.getLeadFields();
        
        Lead_Territory__c newTerritory = new Lead_Territory__c(
            Name = 'test method', Type__c = 'Standard', Assigned_To__c = 'Brett',
            Assigned_To_ID__c = '005800000069KB5', Assigned_To_Type__c = 'User');
        
        // 1. Error lead territory creating
        Lead_Territory__c errorTerritory = new Lead_Territory__c();
        controller.leadTerritory = errorTerritory;
        controller.createLeadTerritory();
        Lead_Territory__c errorTerritory2 = newTerritory.clone();
        errorTerritory2.Name = '12345678901';
        controller.leadTerritory = errorTerritory2;
        controller.createLeadTerritory();
        
        // 2. Correct lead territory creating
        
        // Create the first lead territory
        controller.leadTerritory = newTerritory;
        controller.createLeadTerritory();
        // Create the second lead territory
        newTerritory.Assigned_To_Type__c = 'Lead Queue';
        controller.leadTerritory = newTerritory;
        controller.createLeadTerritory();
        // Validate if the lead territories are saved.
        //System.assert(controller.leadTerritories.size() == 2);
        
        // 3. Error lead territory editing
        Test.setCurrentPage(new PageReference('/apex/test?id=' + controller.leadTerritories[0].Id));
        controller.leadTerritories[0].Name = '';
        controller.editLeadTerritory();
        controller.leadTerritories[0].Name = '12345678901';
        controller.editLeadTerritory();
        
        // 4. Correct lead territory editing
        controller.leadTerritories[0].Name = 'test method record 2';
        controller.editLeadTerritory();
        
        // 5. Test geographic criteria creating and editing
        controller.jsonCriteria = '{}';
        controller.createGeographicCriteria();
        controller.jsonCriteria = '{"Country__c":"US","State__c":"CA","Zip_Start__c":"95000"}';
        controller.createGeographicCriteria();
        controller.jsonCriteria = '{"Country__c":"US","State__c":"CA","Zip_End__c":"95000"}';
        controller.createGeographicCriteria();
        controller.jsonCriteria = '{"Country__c":"US","State__c":"CA","Zip_Start__c":"95000","Zip_End__c":"95100","Lead_Territory__c":"'
            + controller.leadTerritories[0].Id + '"}';
        controller.createGeographicCriteria();
        System.assert(controller.leadTerritories[0].Lead_Territory_Geographies__r.size() == 1);
        // Test multiple geographic criteria creating
        controller.addMoreLeadTerritoryGeos();
        controller.newLeadTerritoryGeos[0].Country__c = 'US';
        controller.newLeadTerritoryGeos[0].State__c = 'CA';
        controller.newLeadTerritoryGeos[0].Zip_Start__c = '95000';
        controller.newLeadTerritoryGeos[0].Zip_End__c = '95100';
        controller.CurrentTerritoryId = controller.leadTerritories[0].Id;
        controller.insertNewLeadTerritoryGeos();
        controller.AssignmentsCSV = 'US, CA, 95000, 95100\nUS, CA, 95000, 95100';
        controller.insertNewLeadTerritoryGeosByCSV();
        
        // 6. Test lead field criteria creating and editing
        controller.jsonCriteria = '{}';
        controller.createLeadFieldCriteria();
        controller.jsonCriteria = '{"Lead_Field__c":"Name","Operator__c":"Equals","Value__c":"test method","Lead_Territory__c":"'
            + controller.leadTerritories[0].Id + '"}';
        controller.createLeadFieldCriteria();
        //System.assert(controller.leadTerritories[0].Lead_Territory_Field_Criteria__r.size() == 1);
        
        // 7. Test user searching and order saving 
        controller.userinfo = 'br';
        controller.searchUser();
        controller.territoryOrder = controller.leadTerritories[1].Id + '_order' + controller.leadTerritories[0].Id;
        controller.saveOrder();
        
        // 8. Test removing
        controller.removedType = 'geography';
        controller.removedId = controller.leadTerritories[1].Lead_Territory_Geographies__r[0].Id;
        controller.remove();
        controller.removedType = 'leadField';
        controller.removedId = controller.leadTerritories[1].Lead_Territory_Field_Criteria__r[0].Id;
        controller.remove();
        controller.removedType = 'territory';
        controller.removedId = controller.leadTerritories[0].Id;
        controller.remove();
    }

    @isTest
    static void checkCustomerTpsStatusTest() {
        ManageLeadTerritoryController controller = new ManageLeadTerritoryController();
        Test.setCurrentPage(new PageReference('/apex/test'));
        System.assert(controller.checkCustomerTpsStatus() != null);
    }

    @isTest
    static void refreshDIsplayRecordsTest() {
        Lead_Territory__c leadTerritory = new Lead_Territory__c(
            Name = 'test method', 
            Type__c = 'Standard', 
            Assigned_To__c = 'Test',
            Assigned_To_ID__c = '005800000069KB5', 
            Assigned_To_Type__c = 'User'
        );
        insert leadTerritory;

        Lead_Territory_Field_Criteria__c fieldCriteria = new Lead_Territory_Field_Criteria__c(
            Lead_Territory__c = leadTerritory.id
        );
        insert fieldCriteria;

        Lead_Territory_Geography__c geography = new Lead_Territory_Geography__c(
            Lead_Territory__c = leadTerritory.Id
        );
        insert geography;

        ManageLeadTerritoryController controller = new ManageLeadTerritoryController();
        controller.CurrentTerritoryId = leadTerritory.Id;
        controller.refreshDIsplayRecords();
        System.assert(controller.DisplayGeos.size() > 0);
        System.assert(controller.DisplayFcs.size() > 0);
    }


    @isTest
    static void setupStatusTest() {
        Territory_Setup__c setup = new Territory_Setup__c(
            Next_Mass_Update_Date_Lead__c = Date.today(),
            Status__c = 'Off'
        );
        insert setup;
        ManageLeadTerritoryController.setupStatus('Off');
    }

    @isTest
    static void saveMassUpdatedDateTest() {
        ManageLeadTerritoryController controller = new ManageLeadTerritoryController();
        Territory_Setup__c setup = new Territory_Setup__c(
            Next_Mass_Update_Date_Lead__c = Date.today(),
            Status__c = 'Off'
        );
        insert setup;
        controller.rerenderId = '';
        controller.tmp = '';
        controller.searchType = '';
        controller.leadObject = new Lead();
        controller.DisplayGeos = new List<Lead_Territory_Geography__c>();
        controller.DisplayFcs = new List<Lead_Territory_Field_Criteria__c>();
        controller.saveMassUpdatedDate();
    }
}