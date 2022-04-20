@isTest
public class httpCallOutCtrl_Test {
    
    @isTest
    static void CustomerSupportForgotPasswordTest()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String res = httpCallOutCtrl.customerSupportForgotPassword('http://services.control4.com/ConsumerPortal/api/useraction/requestpasswordrecovery?emailAddress=aldkjsf');
        
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