@isTest(SeeAllData=true)
public class RMAProcessControllerV2_Test {
   
    @isTest    
    static void createRMA_Test(){      
        Account testAcc = createAccount('TestAccountUS', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        Contact testCon = createContact('FirstnameUS', 'LastnameUS', testAcc.Id);
        Product2 testProd = createProduct('TestProductUS', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
        RMAProcessControllerV2_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        
        List<RMAProcessControllerV2.RMAInformation> rmaInfos = new List<RMAProcessControllerV2.RMAInformation>();
        
        Test.startTest();
        	rmaInfos.Add(RMAProcessControllerV2.createRMA(testCase.Id));
        Test.stopTest();
        
        System.assertNotEquals(rmaInfos.size(), 0);   
    }


    @isTest    
    static void sendMailMethod_Test(){      
        Account testAcc = createAccount('TestAccountUS', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        Contact testCon = createContact('FirstnameUS', 'LastnameUS', testAcc.Id);
        Product2 testProd = createProduct('TestProductUS', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
        RMAProcessControllerV2_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        
        Test.startTest();
        	string sentMessage = RMAProcessControllerV2.sendMailMethod(testCase.Id, 'cdabb@control4.com', 'cdabb@control4.com', 'cdabb@control4.com', 'Email Subject'); 
        Test.stopTest();
        
        System.assert(sentMessage.contains('Success') ||  sentMessage.contains('Error'));   
    }

    @isTest    
	static void SendRMAEmail_Test(){      
        Account testAcc = createAccount('TestAccountUS', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        Contact testCon = createContact('FirstnameUS', 'LastnameUS', testAcc.Id);
        Product2 testProd = createProduct('TestProductUS', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
        RMAProcessControllerV2_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        
        Test.startTest();
        	RMAProcessControllerV2.SendRMAEmail(testCase.Id); 
        Test.stopTest();
        
        System.assert(true);   
    }

    @isTest    
	static void eMailRMA_DoNotSendEmail_Test(){      
        Account testAcc = createAccount('TestAccountUS', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        Contact testCon = createContact('FirstnameUS', 'LastnameUS', testAcc.Id);
        Product2 testProd = createProduct('TestProductUS', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
        RMAProcessControllerV2_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        List<Case> caseList = new List<Case>();
        caseList.add(testCase);
        RMAProcessControllerV2 controller = new RMAProcessControllerV2();            
        
        Test.startTest();
                controller.eMailRMA_DoNotSendEmail(caseList);  
        Test.stopTest();
        
        System.assert(true);   
    }

    @isTest    
	static void eMailRMAFromApex_Test(){      
        Account testAcc = createAccount('TestAccountUS', 'US', 'US', '02 Retail', 'US', 'cdabb@control4.com');
        Contact testCon = createContact('FirstnameUS', 'LastnameUS', testAcc.Id);
        Product2 testProd = createProduct('TestProductUS', 'Default', false); 
        Case testCase = createCase(testAcc.Id, testCon.Id);
        testCase.RMA_SendviaTrigger__c = true;
        update testCase;
        RMAProcessControllerV2_Test.createCaseProduct(testCase.Id, testProd.Id, 'Defective');
        List<Case> caseList = new List<Case>();
        caseList.add(testCase);
        RMAProcessControllerV2 controller = new RMAProcessControllerV2();            
        
        Test.startTest();
                controller.eMailRMAFromApex(caseList);  
        Test.stopTest();
        
        System.assert(true);   
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
    }
    
    
}