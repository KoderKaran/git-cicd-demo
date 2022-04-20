@isTest
private class CustomLookUpCtrlTest {
	
	@isTest static void testFetchLookUpValues() {
		Account venue = new Account(Name = 'Test Venue');
	    insert venue;

	    List<sObject> resultList;

	    Test.startTest();
        resultList = CustomLookUpCtrl.fetchLookUpValues('Test', 'Account');
        Test.stopTest();
        
        System.assertEquals(1, resultList.size());
        System.assertEquals(venue, resultList[0]);
	}
}