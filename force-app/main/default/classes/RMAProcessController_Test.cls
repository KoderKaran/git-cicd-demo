@isTest(SeeAllData=true)
public class RMAProcessController_Test {
    
//    @isTest
//    static void hasRMATest() {
        
//        string caseId = [
//            SELECT Id
//            FROM Case
//            //where Subject = 'Test Case Fantastic Case' 
//            LIMIT 1
//        ].Id;
        
//        Test.startTest();
//        Boolean bool = RMAProcessController.hasRMA(caseId);
//        Test.stopTest();
        
//        System.assertEquals(bool, false);         
//    }
   
    @isTest    
    static void rmaTestUS(){      
      
        // Accounts to use for testing
        Account testAcc = createAccount('TestAccountUS', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        Account testAcc2 = createAccount('TestAccountUS', 'US', 'US', '19 Pakedge Dealer', 'US', 'cdabb@control4.com');
        Account testAcc3 = createAccount('TestAccountUS', 'US', 'US', '21 Triad Dealer', 'US', 'cdabb@control4.com'); 
        
        
        // All the tests can use the same Contact
        Contact testCon = createContact('FirstnameUS', 'LastnameUS', testAcc.Id);
        
         // These are Normal RMA's
        Product2 testProd = createProduct('TestProductUS', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
        Case testCase2 = createCase(testAcc2.Id, testCon.Id);
        Case testCase3 = createCase(testAcc3.Id, testCon.Id);      
		RMAProcessController_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        RMAProcessController_Test.createCaseProduct(testCase2.Id, testProd.Id, 'Defective');
        RMAProcessController_Test.createCaseProduct(testCase3.Id, testProd.Id, 'Defective');
        
        // These are Sales RMA's
        Product2 testProd_SalesRMA = createProduct('TestProductUS', 'Default', false);
        Case testCase4 = createCase(testAcc.Id, testCon.Id);
        Case testCase5 = createCase(testAcc2.Id, testCon.Id);
        Case testCase6 = createCase(testAcc3.Id, testCon.Id);       
 		RMAProcessController_Test.createCaseProduct(testCase4.Id, testProd_SalesRMA.Id, 'Sales');
        RMAProcessController_Test.createCaseProduct(testCase5.Id, testProd_SalesRMA.Id, 'Sales');
        RMAProcessController_Test.createCaseProduct(testCase6.Id, testProd_SalesRMA.Id, 'Sales');       
        
 
        // These are International RMA's
        Account testAcc4 = createAccount('TestAccountUS', 'US', 'International', '02 Retail', 'US', 'cdabb@control4.com');
        //Account testAcc5 = createAccount('TestAccountUS', 'US', 'International', '19 Pakedge Dealer', 'US', 'cdabb@control4.com');
        Account testAcc6 = createAccount('TestAccountUS', 'US', 'International', '21 Triad Dealer', 'US', 'cdabb@control4.com');        
        Case testCase7 = createCase(testAcc4.Id, testCon.Id);
        //Case testCase8 = createCase(testAcc5.Id, testCon.Id);
        Case testCase9 = createCase(testAcc6.Id, testCon.Id);
        RMAProcessController_Test.createCaseProduct(testCase7.Id, testProd.Id, 'Defective');       
        //RMAProcessController_Test.createCaseProduct(testCase8.Id, testProd.Id, 'Defective'); 
        RMAProcessController_Test.createCaseProduct(testCase9.Id, testProd.Id, 'Defective');       
        
        // run test
        List<RMAProcessController.RMAInformation> rmaInfos = new List<RMAProcessController.RMAInformation>();
        
        Test.startTest();
        	rmaInfos.Add(RMAProcessController.createRMA(testCase.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase2.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase3.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase4.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase5.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase6.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase7.Id));
        	//rmaInfos.Add(RMAProcessController.createRMA(testCase8.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase9.Id));
        Test.stopTest();
        
        System.assertNotEquals(rmaInfos.size(), 0);   
    }

    
    @isTest    
    static void rmaTestEmail(){      
      
        // Accounts to use for testing
        Account testAcc = createAccount('TestAccountUS', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        
        // All the tests can use the same Contact
        Contact testCon = createContact('FirstnameUS', 'LastnameUS', testAcc.Id);
        
         // These are Normal RMA's
        Product2 testProd = createProduct('TestProductUS', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);  
		RMAProcessController_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');         
    
        // run test
        List<RMAProcessController.RMAInformation> rmaInfos = new List<RMAProcessController.RMAInformation>();
        
        Test.startTest();
        	rmaInfos.Add(RMAProcessController.createRMA(testCase.Id));
        	string result = RMAProcessController.sendMailMethod(testCase.Id, 'cdabb@control4.com', 'cdabb@control4.com', 'cdabb@control4.com', 'Test Email Subject');
        Test.stopTest();
        
        System.assertNotEquals(rmaInfos.size(), 0);   
    } 
    

    @isTest     
    static void rmaTestUK(){      
      
        // Accounts to use for testing
        Account testAcc = createAccount('TestAccountUK', 'UK', 'UK', '02 Retail', 'UK', 'cdabb@control4.com');
        Account testAcc2 = createAccount('TestAccountUK', 'UK', 'UK', '19 Pakedge Dealer', 'UK', 'cdabb@control4.com');
        Account testAcc3 = createAccount('TestAccountUK', 'UK', 'UK', '21 Triad Dealer', 'UK', 'cdabb@control4.com'); 
        
        
        // All the tests can use the same Contact
        Contact testCon = createContact('FirstnameUK', 'LastnameUK', testAcc.Id);
        
         // These are Normal RMA's
        Product2 testProd = createProduct('TestProductUK', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
        Case testCase2 = createCase(testAcc2.Id, testCon.Id);
        Case testCase3 = createCase(testAcc3.Id, testCon.Id);      
		RMAProcessController_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        RMAProcessController_Test.createCaseProduct(testCase2.Id, testProd.Id, 'Defective');
        RMAProcessController_Test.createCaseProduct(testCase3.Id, testProd.Id, 'Defective');
        
        // These are Sales RMA's
        Product2 testProd_SalesRMA = createProduct('TestProductUK', 'Default', false);
        Case testCase4 = createCase(testAcc.Id, testCon.Id);
        Case testCase5 = createCase(testAcc2.Id, testCon.Id);
        Case testCase6 = createCase(testAcc3.Id, testCon.Id);       
 		RMAProcessController_Test.createCaseProduct(testCase4.Id, testProd_SalesRMA.Id, 'Sales');
        RMAProcessController_Test.createCaseProduct(testCase5.Id, testProd_SalesRMA.Id, 'Sales');
        RMAProcessController_Test.createCaseProduct(testCase6.Id, testProd_SalesRMA.Id, 'Sales');       
        
 
        // These are International RMA's
        Account testAcc4 = createAccount('TestAccountUK', 'UK', 'International', '02 Retail', 'UK', 'cdabb@control4.com');
        //Account testAcc5 = createAccount('TestAccountUK', 'UK', 'International', '19 Pakedge Dealer', 'UK', 'cdabb@control4.com');
        Account testAcc6 = createAccount('TestAccountUK', 'UK', 'International', '21 Triad Dealer', 'UK', 'cdabb@control4.com');        
        Case testCase7 = createCase(testAcc4.Id, testCon.Id);
        //Case testCase8 = createCase(testAcc5.Id, testCon.Id);
        Case testCase9 = createCase(testAcc6.Id, testCon.Id);
        RMAProcessController_Test.createCaseProduct(testCase7.Id, testProd.Id, 'Defective');       
        //RMAProcessController_Test.createCaseProduct(testCase8.Id, testProd.Id, 'Defective'); 
        RMAProcessController_Test.createCaseProduct(testCase9.Id, testProd.Id, 'Defective');       
        
        // run test
        List<RMAProcessController.RMAInformation> rmaInfos = new List<RMAProcessController.RMAInformation>();
        
        Test.startTest();
        	rmaInfos.Add(RMAProcessController.createRMA(testCase.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase2.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase3.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase4.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase5.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase6.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase7.Id));
        	//rmaInfos.Add(RMAProcessController.createRMA(testCase8.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase9.Id));
        Test.stopTest();
        
        System.assertNotEquals(rmaInfos.size(), 0);   
    } 

    
    @isTest     
    static void rmaTestGermany(){      
      
        // Accounts to use for testing
        Account testAcc = createAccount('TestAccountGermany', 'UK', 'UK', '02 Retail', 'Germany', 'cdabb@control4.com');
        Account testAcc2 = createAccount('TestAccountGermany', 'UK', 'UK', '19 Pakedge Dealer', 'Germany', 'cdabb@control4.com');
        Account testAcc3 = createAccount('TestAccountGermany', 'UK', 'UK', '21 Triad Dealer', 'Germany', 'cdabb@control4.com'); 
        
        
        // All the tests can use the same Contact
        Contact testCon = createContact('FirstnameGermany', 'LastnameGermany', testAcc.Id);
        
         // These are Normal RMA's
        Product2 testProd = createProduct('TestProductGermany', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
        Case testCase2 = createCase(testAcc2.Id, testCon.Id);
        Case testCase3 = createCase(testAcc3.Id, testCon.Id);      
		RMAProcessController_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        RMAProcessController_Test.createCaseProduct(testCase2.Id, testProd.Id, 'Defective');
        RMAProcessController_Test.createCaseProduct(testCase3.Id, testProd.Id, 'Defective');
        
        // These are Sales RMA's
        Product2 testProd_SalesRMA = createProduct('TestProductGermany', 'Default', false);
        Case testCase4 = createCase(testAcc.Id, testCon.Id);
        Case testCase5 = createCase(testAcc2.Id, testCon.Id);
        Case testCase6 = createCase(testAcc3.Id, testCon.Id);       
 		RMAProcessController_Test.createCaseProduct(testCase4.Id, testProd_SalesRMA.Id, 'Sales');
        RMAProcessController_Test.createCaseProduct(testCase5.Id, testProd_SalesRMA.Id, 'Sales');
        RMAProcessController_Test.createCaseProduct(testCase6.Id, testProd_SalesRMA.Id, 'Sales');       
        
 
        // These are International RMA's
        Account testAcc4 = createAccount('TestAccountGermany', 'UK', 'International', '02 Retail', 'Germany', 'cdabb@control4.com');
        //Account testAcc5 = createAccount('TestAccountGermany', 'UK', 'International', '19 Pakedge Dealer', 'Germany', 'cdabb@control4.com');
        Account testAcc6 = createAccount('TestAccountGermany', 'UK', 'International', '21 Triad Dealer', 'Germany', 'cdabb@control4.com');        
        Case testCase7 = createCase(testAcc4.Id, testCon.Id);
        //Case testCase8 = createCase(testAcc5.Id, testCon.Id);
        Case testCase9 = createCase(testAcc6.Id, testCon.Id);
        RMAProcessController_Test.createCaseProduct(testCase7.Id, testProd.Id, 'Defective');       
        //RMAProcessController_Test.createCaseProduct(testCase8.Id, testProd.Id, 'Defective'); 
        RMAProcessController_Test.createCaseProduct(testCase9.Id, testProd.Id, 'Defective');       
        
        // run test
        List<RMAProcessController.RMAInformation> rmaInfos = new List<RMAProcessController.RMAInformation>();
        
        Test.startTest();
        	rmaInfos.Add(RMAProcessController.createRMA(testCase.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase2.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase3.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase4.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase5.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase6.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase7.Id));
        	//rmaInfos.Add(RMAProcessController.createRMA(testCase8.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase9.Id));
        Test.stopTest();
        
        System.assertNotEquals(rmaInfos.size(), 0);   
    } 

    @isTest     
    static void rmaTestAUS(){      
      
        // Accounts to use for testing
        Account testAcc = createAccount('TestAccountAUS', 'UK', 'UK', '02 Retail', 'AUS', 'cdabb@control4.com');
        
        // All the tests can use the same Contact
        Contact testCon = createContact('FirstnameAUS', 'LastnameUK', testAcc.Id);
        
         // These are Normal RMA's
        Product2 testProd = createProduct('TestProductAUS', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
   
		RMAProcessController_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        
        // These are Sales RMA's
        Product2 testProd_SalesRMA = createProduct('TestProductAUS', 'Default', false);
        Case testCase4 = createCase(testAcc.Id, testCon.Id);    
 		RMAProcessController_Test.createCaseProduct(testCase4.Id, testProd_SalesRMA.Id, 'Sales');
   
        
 
        // These are International RMA's
        Account testAcc4 = createAccount('TestAccountUK', 'UK', 'International', '02 Retail', 'Germany', 'cdabb@control4.com');
        Case testCase7 = createCase(testAcc4.Id, testCon.Id);
        RMAProcessController_Test.createCaseProduct(testCase7.Id, testProd.Id, 'Defective');       
    
        
        // run test
        List<RMAProcessController.RMAInformation> rmaInfos = new List<RMAProcessController.RMAInformation>();
        
        Test.startTest();
        	rmaInfos.Add(RMAProcessController.createRMA(testCase.Id));
            rmaInfos.Add(RMAProcessController.createRMA(testCase4.Id));
        	rmaInfos.Add(RMAProcessController.createRMA(testCase7.Id));
        Test.stopTest();
        
        System.assertNotEquals(rmaInfos.size(), 0);   
    } 
  
    @isTest     
    static void rmaTestRMALocationSLC(){      
      
        // Accounts to use for testing
        Account testAcc = createAccount('TestAccountRMALocationSLC', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        
        // All the tests can use the same Contact
        Contact testCon = createContact('FirstnameRMALocationSLC', 'LastnameRMALocationSLC', testAcc.Id);
        
         // These are Normal RMA's
        Product2 testProd = createProduct('TestProductRMALocationSLC', 'SLC', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
   
		RMAProcessController_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
   
        
        // run test
        List<RMAProcessController.RMAInformation> rmaInfos = new List<RMAProcessController.RMAInformation>();
        
        Test.startTest();
        	rmaInfos.Add(RMAProcessController.createRMA(testCase.Id));
        Test.stopTest();
        
        System.assertNotEquals(rmaInfos.size(), 0);   
    } 

    @isTest     
    static void rmaTestRMALocationYork(){      
      
        // Accounts to use for testing
        Account testAcc = createAccount('TestAccountRMALocationYork', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        
        // All the tests can use the same Contact
        Contact testCon = createContact('FirstnameRMALocationYork', 'LastnameRMALocationYork', testAcc.Id);
        
         // These are Normal RMA's
        Product2 testProd = createProduct('TestProductRMALocationYork', 'York', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
   
		RMAProcessController_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
   
        
        // run test
        List<RMAProcessController.RMAInformation> rmaInfos = new List<RMAProcessController.RMAInformation>();
        
        Test.startTest();
        	rmaInfos.Add(RMAProcessController.createRMA(testCase.Id));
        Test.stopTest();
        
        System.assertNotEquals(rmaInfos.size(), 0);   
    }  
    
    static Account createAccount(string name, string billingCountry, string region, string acctGroup, string sapInstance, string email)
    {
        Id dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        Account testAcc = new Account(
            Name = name,
            RecordTypeId = dealerRecordTypeId,
            BillingCountry = billingCountry, 
            Account_Region__c = region,
            Account_Group__c = acctGroup,
            SAP_Instance__c = sapInstance,
            RMA_CC_Email__c = email);
        
        insert testAcc;
        
        return testAcc;
    }
    
    static Contact createContact(string Firstname, string Lastname, string AccountId)
    {
            Contact testCon = new Contact(
            Firstname = Firstname,
            Lastname = Lastname,
            Email = '',
            MobilePhone = '',
            AccountId = AccountId,
            Description = '');
        
        insert testCon;        
        return testCon;
    }
    
    static Case createCase(string AccountId, string ContactId)
    {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Tech Support').getRecordTypeId();
        
        Case testCase = new Case(
            RecordTypeId = caseRecordTypeId,
            AccountId = AccountId,
            ContactId = ContactId,
            Subject = 'Test Case'    
        );
        
        insert testCase;       
        return testCase;
    }    
   
    static Product2 createProduct(string name, string rmaLocation, boolean scrap)
    {
            Product2 testProd = new Product2(
            Name = name,
            IsActive = true,
            Scrap__c =  scrap,   
            RMA_Location__c = rmaLocation // 1, Default, PDX, SLC, York
        );
        
        insert testProd;     
        return testProd;
    }     

    static void createCaseProduct(string caseId, string productId, string rmaType)
    {
        Id CaseProductRecordTypeId = Schema.SObjectType.CaseProduct__c.getRecordTypeInfosByName().get('Tech Support (C4)').getRecordTypeId();
        
        CaseProduct__c caseProduct = new CaseProduct__c(
            RecordTypeId = CaseProductRecordTypeId,          
            Case__c = caseId,
            Item__c = productId,
            Type__c = 'Hardware',
            Product_Type__c = 'C4 Audio Products',
            Product__c = 'Amplifier V1',
            Version__c = '2.10.6',
            RMA__c = 'Yes',
            RMA_Type__c = rmaType, //'Defective',
            RMA_Outcome__c = 'Repair - In Warranty',
            Return_Shipment_Priority__c = 'FedEx 3-Day',
            Subject__c = 'Test Subject',
            MacID__c = '123456',
            DOA__c = 'Yes'            
        );  
        
        insert caseProduct;  
        //return caseProduct;
    }  
    
    
    
}

//CASE(Account_Group__c, 
//"01 CI", "Control4",
//"02 Retail", "Control4",
//"03 Intl Distributor", "Control4",
//"04 Intl Dealer", "Control4",
//"05 Hospitality", "Control4",
//"06 Non C4 Emp Purch", "Control4",
//"08 Energy", "Control4",
//"09 C4IQ", "Control4",
//"10 Marketing", "Control4",
//"11 Vendor", "Control4",
//"12 Intercompany", "Control4",
//"13 IQ Partner", "Control4",
//"15 C4 Emp Purch Plan", "Control4",
//"16 Smart Cities", "Control4",
//"17 Online Partner", "Control4",
//"18 AUS Dealer", "Control4",
//"19 Pakedge Dealer", "Pakedge",
//"20 Pakedge Distrib.", "Pakedge",
//"21 Triad Dealer", "Triad",
//"22 Triad Distributor", "Triad",
//"23 Pakedge Intl Deal", "Pakedge",
//"24 Triad Intl Dist", "Triad",
//"25 Triad Intl Dealer", "Triad",
//"26 APAC Intl Dealer", "Control4",
//"Control4")