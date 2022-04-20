public class WP_dRMA_Warranty_Tool_Controller {
    
    @AuraEnabled // called from a lightning component
    public static String GetWarrantyInformation (string url)
    {  
        //req.setEndpoint('https://erp.control4.com/C4Test/query/GetWarrantyTitleInformation.aspx?MACID=000FFF609380'); // for testing
        //system.debug(url);
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
    
    @AuraEnabled // called from a lightning component
    public static Object GetWarrantyPeriod (string productID)
    {       
       	return [SELECT Id, Warranty__c FROM Product2 WHERE Id = :productID];        
    }
    
}