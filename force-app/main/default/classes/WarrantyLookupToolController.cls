public without sharing class WarrantyLookupToolController {
    
    @AuraEnabled // called from a lightning component
    public static String GetWarrantyInformation (string url)
    {  
        //req.setEndpoint('https://erp.control4.com/C4Test/query/GetWarrantyTitleInformation.aspx?MACID=000FFF609380'); // for testing
        HttpRequest req = new HttpRequest();       
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('content-type','application/json');  
        req.setHeader('Accept','application/json');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('steve:steve')));
        
        // Send the request, and return a response		
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        return res.getBody();
    }    
    
    @InvocableMethod // called from a process builder   
    public static void GetWarrantyLatestSObySKU (List<string> caseProductIds)
    {  
        GetWarrantyLatestSObySKU_CallOut(caseProductIds);
    }
    
    @future(callout = true) 
    public static void GetWarrantyLatestSObySKU_CallOut (List<string> caseProductIds)
    {  
        string caseID = ''; // caseID for debugging
        
        try
        {
            List<CaseProduct__c> cpList = [SELECT Id, Case__r.SAP_ACCOUNT_ID__c, Item__r.ProductCode FROM CaseProduct__c WHERE Id = :caseProductIds]; 
            
            List<CaseProduct__c> updateList = new List<CaseProduct__c>();       
            for (CaseProduct__c cp : cpList)
            { 
                caseID = cp.Id;
                
                //req.setEndpoint('https://erp.control4.com/C4Test/query/GetWarrantyLatestSObySKU.aspx?cardcode=EDG901&sku=LDZ-101-W'); // for testing
                string url = 'https://erp.control4.com/Default/query/GetWarrantyLatestSObySKU.aspx?cardcode=' + cp.Case__r.SAP_ACCOUNT_ID__c + '&sku=' + cp.Item__r.ProductCode;
               	system.debug('Url ' + url);
                HttpRequest req = new HttpRequest();       
                req.setEndpoint(url);
                req.setMethod('GET');
                req.setHeader('content-type','application/json');  
                req.setHeader('Accept','application/json');
                req.setTimeout(120000);
                req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('steve:steve')));
                
                // Send the request, and return a response		
                Http h = new Http();
                HttpResponse res = h.send(req);           
                
                // Format the JSON to deserialize properly
                string fixJSON1 = res.getBody().replace('@id','rowID').replace('@name','columnName').replace('@alias','columnAlias').replace('@type','columnType').replace('@key','columnKey');       
                string fixJSON2 = fixJSON1.replace('@','');   
                LatestSalesOrderJSONtoApex salesData = LatestSalesOrderJSONtoApex.parse(fixJSON2);       
                string salesOrderNumber = salesData.response.payload.querydata.data.row.fm_finops_serial_number_transaction_order_id;
                system.debug('Sales Order Number ' + salesOrderNumber);
                if (salesOrderNumber != '')
                {
                    cp.Sales_Order_Number__c = salesOrderNumber;
                    cp.Sales_Order_Populated_Via_Automation__c = true;
                    updateList.Add(cp);
                }
            }
            
            update updateList;
        }
        catch (Exception ex)
        {
			new ApexDebugLog().createLog(new ApexDebugLog.Error('WarrantyLookupToolController', 'GetWarrantyLatestSObySKU_CallOut', caseID, ex));
        }
    }   
}