@isTest
public class RMALookupToolController_Test {
    
    @isTest 
    static void GetRMAInformation_Test() 
    {
        string macID = '123456789';
        CaseProduct__c cp = new CaseProduct__c(MacID__c = macID);
        CaseProduct__c cp2 = new CaseProduct__c(MacID__c = macID);
        
        Test.startTest();
        	List<CaseProduct__c> cpList = RMALookupToolController.GetRMAInformation(macID);
        Test.stopTest();
        
        System.assertNotEquals(cpList.size(), 2);        
    }    
}