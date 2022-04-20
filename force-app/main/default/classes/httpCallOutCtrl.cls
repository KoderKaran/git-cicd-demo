public class httpCallOutCtrl {
    @AuraEnabled    
    public static String customerSupportForgotPassword (String url)
    {
        // Instantiate a new http object
		Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
		HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
		req.setMethod('POST');
        req.setHeader('Content-Type','application/json');       
        req.setHeader('Content-Length','0');

        // Send the request, and return a response		
		HttpResponse res = h.send(req);
        
       
        
        return res.getBody();
    }

}