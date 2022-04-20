@isTest
public class FutureApexCallout_Test {
	
    @isTest 
	static void UploadProfilePhotoTest() 
    {  
   		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());    
        HttpResponse res = FutureApexCallout.GetBinaryPhoto('https://res.cloudinary.com/control4/image/upload/avatar/20180407_111142_vucvzz');
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