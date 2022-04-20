@isTest
private class SmartHomeBuilderTest {
    
@isTest public static void saveSmartRecordsTest() {
    Lead ld = new Lead(FirstName='Name', LastName='LName', Phone='1234567890');
    insert ld;

    HomeBuilder__c homeBuilder = new HomeBuilder__c(
        Lead__c = ld.Id, 
        Value_category__c='Starter', 
        Project_type__c='New Home',
        Budget__c='$3-5K',
        Square_Footage__c=600,
        Potential_value__c=2000);

    List<String> listTv = new List<String>{'5','Single Remote', '5', '1000','', '', '5000'};
    List<String> listClimate = new List<String>{'7', '2450'};
    List<String> listSmartRecords = new List<String>{'','Main Living Areas','','Porch/Garage','Bedroom(s)','7'};
    List<String> listMusicRecords = new List<String>{'','Main Living Areas','','Outdoor areas','Bedroom(s)','6','9'};
    List<String> listSecurityRecords = new List<String>{'Smart Locks','900','Cameras','2000','Doorbell Camera','1800'};
    List<String> listOtherHomeRecords = new List<String>{'tests'};

    Test.startTest();
    ApexPages.standardController objStandController = new ApexPages.standardController(ld);
    smartHomeBuilderController smartHomeBuilderContInst = new smartHomeBuilderController(objStandController);
    SmartHomeBuilderController.saveSmartRecords(ld.Id, homeBuilder, listClimate, listTv, listSmartRecords, listMusicRecords, listSecurityRecords, listOtherHomeRecords);
    Test.stopTest();
    }
}