@isTest

public class WP_dRMA_Warranty_Tool_Controller_Test {
    
    public static testMethod void subprodRMATestMethod() {
        //Creating the account for testing
        List<Account> AccList = new List<Account>();
        account a1 = new account(name = 'test'); 
        a1.SAP_Instance__c = 'SAP_US';
        a1.Account_Group__c = '02 Retail';
        a1.SAP_ACCOUNT_ID__c = '0001';
        AccList.add(a1);
        account a2 = new account(name = 'test1'); 
        a2.SAP_Instance__c = 'SAP_UK';
        a2.Account_Group__c = '03 Retail';
        a2.SAP_ACCOUNT_ID__c = '0002';
        AccList.add(a2);
        account a3 = new account(name = 'test2'); 
        a3.SAP_Instance__c = 'SAP_AU';
        a3.Account_Group__c = '04 Retail';
        a3.SAP_ACCOUNT_ID__c = '0003';
        AccList.add(a3);
        
        insert AccList;
        
        //Creating the Contact w/email
        List<Contact> conList = new List<Contact>();
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        conList.add(con);
       
        
        insert conList;
        List<Case> caseList = new List<Case>();
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(AccountId = a1.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        
        Insert caseList;
        
        List<Product2> pdList = new List<Product2>();
        //Creating a product for the RMA
        Product2 pd = New Product2(Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - Black', ProductCode = 'TEST1234', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd);
        //Creating a product for the RMA
        Product2 pd2 = New Product2(Name = 'Remote Control', ProductCode = 'TEST123', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd2);
        //Creating a product for the RMA
        Product2 pd3 = New Product2(Name = 'Batteries for remote commander', ProductCode = 'TEST12', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd3);
        
        Insert pdList;
        
        
        Test.startTest();
        
            Test.setMock(HttpCalloutMock.class, new YourHttpCalloutMockImpl());    
            
            WP_dRMA_Warranty_Tool_Controller.GetWarrantyInformation('https://erp.control4.com/C4Test/query/GetWarrantyTitleInformation.aspx?MACID=000FFF609380');
            WP_dRMA_Warranty_Tool_Controller.GetWarrantyPeriod('pdList[0].Id');
        
        Test.stopTest();
    }
    
    public class YourHttpCalloutMockImpl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
    
            // Create a fake response.
            // Set response values, and 
            // return response.
        }
	}


}