@isTest
public class testEditLeadTerritory
{
    @isTest
    static void testEditLeadTerritory()
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
        Lead_Territory_Geography__c testLeadGeo = new Lead_Territory_Geography__c(Lead_Territory__c = testLt.Id, Country__c = 'usa', State__c = 'ca', Zip_Start__c = '1000', Zip_End__c = '2000');
        insert testLeadGeo;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PageReference testPage = new PageReference('/apex/EditLeadTerritory?id=' + testLt.Id);
        test.setCurrentPage(testPage);
        EditLeadTerritoryController controller = new EditLeadTerritoryController();
        controller.userinfo = userinfo.getUserName();
        controller.searchUser();
        Controller.addMoreLeadTerritoryGeos();
        Lead_Territory_Geography__c newLeadTerritoryGeo = controller.newLeadTerritoryGeos[0];
        newLeadTerritoryGeo.COuntry__c = 'CN';
        newLeadTerritoryGeo.State__c = 'BJ';
        newLeadTerritoryGeo.Zip_Start__c = '1000';
        newLeadTerritoryGeo.Zip_End__c = '2000';
        controller.insertNewLeadTerritoryGeos();
        COntroller.AssignmentsCSV = 'USA,CA,1000,2000\nUSA,CA,2000,4000';
        COntroller.insertNewLeadTerritoryGeosByCSV();
        system.assert(controller.getLeadFields() != null);
        controller.saveLeadTerritory();           
        Controller.jsonCriteria = '{"Lead_Territory__c":"' +  testLt.Id
                          + '","Country__c":"USA'
                          + '","State__c":"CS'
                          + '","Zip_Start__c":"10000'
                          + '","Zip_End__c":"20000'
                          + '"}';
      Controller.createGeographicCriteria();
      Controller.jsonCriteria = '{"Lead_Territory__c":"' +  testLt.Id
                          + '","Lead_Field__c":"Name'
                          + '","Operator__c":"equals' 
                          + '","Value__c":"Acme'
                          + '"}';
      Controller.createLeadFieldCriteria();
      Controller.removedType = 'leadField';
      Controller.removedId = testLeadFIeldCriteria1.Id;
      Controller.remove();
      Controller.removedType = 'geography';
      Controller.removedId = testLeadGeo.Id;
      Controller.remove();
      Test.stopTest();
    }
}