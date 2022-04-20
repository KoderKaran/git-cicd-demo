@isTest 
private class WP_sRMA_Controller_Test {
    
    static testMethod void GetReasonCodesTest() 
    {        
        List<String> resasonCodes = WP_sRMA_Controller.GetReasonCodes();
        System.assert(resasonCodes.Size() > 0);
    }
    
    static testMethod void ValidateProductSKUTest() 
    {  
        Product2 p = new product2();
        p.RecordTypeId = '0121T00000024FLQAY';  
        p.ProductCode = 'ValidateProductSKUTest';
        p.Name = 'ValidateProductSKUTest';
        p.IsActive = true;
        insert p;
        
        string result = WP_sRMA_Controller.ValidateProductSKU('ValidateProductSKUTest');

        System.assertEquals(result, 'Success');
    
    }
    
    static testMethod void CreateCaseProductTest() 
    {
        Product2 p = new product2();
        p.RecordTypeId = '0121T00000024FLQAY';  
        p.ProductCode = 'ValidateProductSKUTest';
        p.Name = 'ValidateProductSKUTest';
        p.IsActive = true;
        insert p;
        
        Case c = new Case();        
        insert c;
        
        string json = '[{"sobjectType":"CaseProduct__c","KeyField":"2","SalesNumber":"1882021","SalesDate":"10/07/2020","SKU":"ValidateProductSKUTest","Reason":"Sales Key Error","Quantity":"1","MaxQuantity":"5","UnitPrice":"33.62","TotalPrice":"33.62"}]';
		string result = WP_sRMA_Controller.CreateCaseProduct(json, c.Id, true, false, true, 'This is a note');

        System.assertEquals('Success', 'Success');        
    }
    
    static testMethod void GetSalesOrderInformationTest() 
    {   
        Account a = new Account();
        a.Name = 'TestAccount';
        a.SAP_ACCOUNT_ID__c   = 'S401773';
        insert a;
        
        Case c = new Case();
		c.AccountId = a.Id;        
        insert c;


        Test.startTest();        
        	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        	string res = WP_sRMA_Controller.GetSalesOrderInformation(c.Id, '', '2020-05-13', '2020-11-09');
	    Test.stopTest();
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest req) {
    		// Create a fake response
    		HttpResponse res = new HttpResponse();
    		res.setHeader('Content-Type', 'application/json');
    		//res.setBody('{"status":"success"}');
    		res.setBody('{"response":{"@requestType":"schema","uri":"/Default/query/SALESFORCE_GetRMAinfo.aspx?CardCode=S401773&orderNumber=&beginDate=2020-05-13&endDate=2020-11-09","status":"OK","payload":{"@schemaDigest":"553FBB7AFCF3D4634AFDB09D9C1ADF53","querydata":{"@queryName":"/query//SALESFORCE_GetRMAinfo.aspx?beginDate=2020-05-13&CardCode=S401773&endDate=2020-11-09&orderNumber=","columns":{"column":[{"@name":"KeyField","@alias":"KeyField","@type":"Int64","@key":"false"},{"@name":"ORDR_DocNum","@alias":"DocNum","@type":"Int32","@key":"false","@objType":"oOrders"},{"@name":"ODLN_DocNum","@alias":"DocNum","@type":"Int32","@key":"false","@objType":"oDeliveryNotes"},{"@name":"ORDR_DocDate","@alias":"ORDR_DocDate","@type":"String","@key":"false"},{"@name":"RDR1_Quantity","@alias":"RDR1_Quantity","@type":"Int32","@key":"false"},{"@name":"RDR1_Quantity_5","@alias":"Quantity","@type":"Decimal","@key":"false"},{"@name":"DLN1_ItemCode","@alias":"ItemCode","@type":"String","@key":"false"},{"@name":"DLN1_Dscription","@alias":"Dscription","@type":"String","@key":"false"},{"@name":"ODLN_DocDate","@alias":"ODLN_DocDate","@type":"String","@key":"false"},{"@name":"DLN1_Quantity","@alias":"DLN1_Quantity","@type":"Int32","@key":"false"},{"@name":"DLN1_Price","@alias":"DLN1_Price","@type":"Decimal","@key":"false"},{"@name":"DLN1_LineTotal","@alias":"DLN1_LineTotal","@type":"Decimal","@key":"false"},{"@name":"DLN1_LineNum","@alias":"LineNum","@type":"Int32","@key":"true"}]},"data":{"row":[{"@id":"1","KeyField":"1","ORDR_DocNum":"1882021","ODLN_DocNum":"3073831","ORDR_DocDate":"10/07/2020","RDR1_Quantity":"1","RDR1_Quantity_5":"1.000000","DLN1_ItemCode":"SM-RBX-8-WH","DLN1_Dscription":"Strong VersaBox - Recessed Flat Panel Solution ","ODLN_DocDate":"10/08/2020","DLN1_Quantity":"5","DLN1_Price":"33.62","DLN1_LineTotal":"33.62","DLN1_LineNum":"0"},{"@id":"2","KeyField":"2","ORDR_DocNum":"1882021","ODLN_DocNum":"3073831","ORDR_DocDate":"10/07/2020","RDR1_Quantity":"1","RDR1_Quantity_5":"1.000000","DLN1_ItemCode":"SM-RBX-8-WH","DLN1_Dscription":"Strong VersaBox - Recessed Flat Panel Solution ","ODLN_DocDate":"10/08/2020","DLN1_Quantity":"5","DLN1_Price":"33.62","DLN1_LineTotal":"33.62","DLN1_LineNum":"0"},{"@id":"3","KeyField":"3","ORDR_DocNum":"1882021","ODLN_DocNum":"3073831","ORDR_DocDate":"10/07/2020","RDR1_Quantity":"1","RDR1_Quantity_5":"1.000000","DLN1_ItemCode":"SM-RBX-8-WH","DLN1_Dscription":"Strong VersaBox - Recessed Flat Panel Solution - 8","ODLN_DocDate":"10/08/2020","DLN1_Quantity":"5","DLN1_Price":"33.62","DLN1_LineTotal":"33.62","DLN1_LineNum":"0"}]}}},"error":""}}');
            res.setStatusCode(200);
    		return res; 
		}
	}

    static testMethod void GetSalesOrderInformationTestSingleRow() 
    {   
        Account a = new Account();
        a.Name = 'TestAccount2';
        a.SAP_ACCOUNT_ID__c   = 'S401773';
        insert a;
        
        Case c = new Case();
		c.AccountId = a.Id;        
        insert c;


        Test.startTest();        
        	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_SingleRow());
        	string res = WP_sRMA_Controller.GetSalesOrderInformation(c.Id, '', '2020-05-13', '2020-11-09');
	    Test.stopTest();
    }
    
    public class MockHttpResponseGenerator_SingleRow implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest req) {
    		// Create a fake response
    		HttpResponse res = new HttpResponse();
    		res.setHeader('Content-Type', 'application/json');
    		//res.setBody('{"status":"success"}');
            res.setBody('{"response":{"@requestType":"schema","uri":"/Default/query/SALESFORCE_GetRMAinfo.aspx?CardCode=S401773&orderNumber=&beginDate=2020-05-13&endDate=2020-11-09","status":"OK","payload":{"@schemaDigest":"553FBB7AFCF3D4634AFDB09D9C1ADF53","querydata":{"@queryName":"/query//SALESFORCE_GetRMAinfo.aspx?beginDate=2020-05-13&CardCode=S401773&endDate=2020-11-09&orderNumber=","columns":{"column":[{"@name":"KeyField","@alias":"KeyField","@type":"Int64","@key":"false"},{"@name":"ORDR_DocNum","@alias":"DocNum","@type":"Int32","@key":"false","@objType":"oOrders"},{"@name":"ODLN_DocNum","@alias":"DocNum","@type":"Int32","@key":"false","@objType":"oDeliveryNotes"},{"@name":"ORDR_DocDate","@alias":"ORDR_DocDate","@type":"String","@key":"false"},{"@name":"RDR1_Quantity","@alias":"RDR1_Quantity","@type":"Int32","@key":"false"},{"@name":"RDR1_Quantity_5","@alias":"Quantity","@type":"Decimal","@key":"false"},{"@name":"DLN1_ItemCode","@alias":"ItemCode","@type":"String","@key":"false"},{"@name":"DLN1_Dscription","@alias":"Dscription","@type":"String","@key":"false"},{"@name":"ODLN_DocDate","@alias":"ODLN_DocDate","@type":"String","@key":"false"},{"@name":"DLN1_Quantity","@alias":"DLN1_Quantity","@type":"Int32","@key":"false"},{"@name":"DLN1_Price","@alias":"DLN1_Price","@type":"Decimal","@key":"false"},{"@name":"DLN1_LineTotal","@alias":"DLN1_LineTotal","@type":"Decimal","@key":"false"},{"@name":"DLN1_LineNum","@alias":"LineNum","@type":"Int32","@key":"true"}]},"data":{"row":{"@id":"1","KeyField":"1","ORDR_DocNum":"1882021","ODLN_DocNum":"3073831","ORDR_DocDate":"10/07/2020","RDR1_Quantity":"1","RDR1_Quantity_5":"1.000000","DLN1_ItemCode":"SM-RBX-8-WH","DLN1_Dscription":"Strong VersaBox - Recessed Flat Panel Solution","ODLN_DocDate":"10/08/2020","DLN1_Quantity":"5","DLN1_Price":"33.62","DLN1_LineTotal":"33.62","DLN1_LineNum":"0"}}}},"error":""}}');
            res.setStatusCode(200);
    		return res; 
		}
	}

}