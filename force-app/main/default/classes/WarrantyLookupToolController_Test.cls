@isTest
public class WarrantyLookupToolController_Test 
{

    static testMethod void GetWarrantyInformationTest()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String res = WarrantyLookupToolController.GetWarrantyInformation('https://erp.control4.com/C4Test/query/GetWarrantyTitleInformation.aspx?MACID=000FFF609380');        
    }

    static testMethod void GetWarrantyLatestSObySKU_Test()
    {
        Account a = new Account();
        a.Name = 'TestAccount';
        a.SAP_ACCOUNT_ID__c = 'TestCardCode';
        insert a;
        
        Case c = new Case();
        c.AccountId = a.Id;
        insert c;
                    
        Product2 p = new Product2();
        p.Name = 'TestProduct';
        p.ProductCode = 'TestProductCode';
        p.IsActive = true;
        insert p;
        
        CaseProduct__c cp = new CaseProduct__c();
        cp.Item__c = p.Id;
        cp.Case__c = c.Id;
        insert cp;        
       
        List<string> cpIdList = new List<string>();
        cpIDList.Add(string.ValueOf(cp.Id));
        
        WarrantyLookupToolController.GetWarrantyLatestSObySKU(cpIDList);
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest req) {
    		// Create a fake response
    		HttpResponse res = new HttpResponse();
    		res.setHeader('Content-Type', 'application/json');
    		res.setBody('{"status":"success"}');
    		res.setStatusCode(200);
    		return res; 
		}
	}
    
    
    
    
    
}