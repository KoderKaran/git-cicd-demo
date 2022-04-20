@isTest
private class SerialNumberTrackingControllerTest {
	
	@isTest
    public static void test_method_one() {
        PageReference pgRef = Page.SerialNumberTracking;
     	Test.setCurrentPage(pgRef);
        
        
        Contact con = new Contact();
        con.LastName = 'tester';
        insert con;
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
		Case c = new Case();
        c.Contact = con;
        c.Account = acc;
        c.Subject = 'testSubject 1';
        insert c;
        CaseProduct__c cp = new CaseProduct__c();
        	cp.Type__c = 'Hardware';
        	cp.Case__c =c.Id;
            cp.RecordTypeId = '0125000000059WR';
            cp.RMA__c = 'No';
            cp.Product_Type__c = 'HVAC';
        	cp.Product__c = 'Thermostat';
            cp.Issue__c = 'Cannot Connect';
        	cp.Version__c = '2.7.2';
            cp.MacID__c = '000FFF00001DD4B9';
            cp.Add_to_List__c  = false;
            cp.Product_Returned__c = false;
            cp.Quantity__c =5;
        insert cp;
        Test.startTest();
        ApexPages.StandardController stdcase = new ApexPages.StandardController(c);
        SerialNumberTrackingController snt = new SerialNumberTrackingController(stdcase);
        snt.queryCase();
        snt.CreateNewRecords();
        PageReference pg = snt.returnProd();
 		snt.itemNum = 1;
        pg = snt.returnProd();
        cp.Add_to_List__c = true;
        update cp;
        pg = snt.returnProd();
        snt.queryCase();
        snt.CreateNewRecords();
        cp.Product_Returned__c=true;
        cp.Quantity__c = 0;
        update cp;
        pg = snt.returnProd();
        snt.queryCase();
       snt.CreateNewRecords();     
         snt.updateMacId();
        Test.stopTest();
       
    }
    @isTest
    public static void testwithMultipleProducts() {
        PageReference pgRef = Page.SerialNumberTracking;
     	Test.setCurrentPage(pgRef);
        
        
        Contact con = new Contact();
        con.LastName = 'tester';
        insert con;
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
		Case c = new Case();
        c.Contact = con;
        c.Account = acc;
        c.Subject = 'testSubject 2';
        insert c;
        
 		Case c2 = new Case();
        c2.Contact = con;
        c2.Account = acc;
        c2.Subject = 'testSubject 2';
        insert c2;       
        
        
        CaseProduct__c cp = new CaseProduct__c();
        	cp.Type__c = 'Hardware';
        	cp.Case__c =c.Id;
            cp.RecordTypeId = '0125000000059WR';
            cp.RMA__c = 'No';
            cp.Product_Type__c = 'HVAC';
        	cp.Product__c = 'Thermostat';
            cp.Issue__c = 'Cannot Connect';
        	cp.Version__c = '2.7.2';
            cp.MacID__c = '000FFF00001DD4B9';
            cp.Add_to_List__c  = false;
            cp.Product_Returned__c = false;
            cp.Quantity__c =5;
        insert cp;
         CaseProduct__c cp2 = new CaseProduct__c();
        	cp2.Type__c = 'Hardware';
        	cp2.Case__c =c2.Id;
            cp2.RecordTypeId = '0125000000059WR';
            cp2.RMA__c = 'No';
            cp2.Product_Type__c = 'HVAC';
        	cp2.Product__c = 'WT-100';
            cp2.Issue__c = 'Cannot Connect';
        	cp2.Version__c = '2.7.2';
            cp2.MacID__c = '000FFF00001DD4B9';
            cp2.Add_to_List__c  = true;
            cp2.Product_Returned__c = true;
            cp2.Quantity__c =5;
        insert cp2; 
        
        Test.startTest();
        ApexPages.StandardController stdcase = new ApexPages.StandardController(c);
        SerialNumberTrackingController snt = new SerialNumberTrackingController(stdcase);
        snt.queryCase();
 
        snt.CreateNewRecords();
        PageReference pg = snt.returnProd();
 		snt.itemNum = 6;
        pg = snt.returnProd();
        cp.Add_to_List__c = true;
        update cp;
         cp2.Add_to_List__c = true;
         cp2.MacID__c = '000FFF00001DD4B9b';
        update cp2;
        pg = snt.returnProd();
        snt.queryCase();
        
        
        snt.updateMacId();
        Test.stopTest();
	}
 
}