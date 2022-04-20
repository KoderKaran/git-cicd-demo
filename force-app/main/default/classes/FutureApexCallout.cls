public class FutureApexCallout {

@future(Callout=true)
public static void UploadProfilePhoto(string avatarURL, string userId, string profileId)
	{      	
        //if (profileId == '00e38000000jTN2AAM' && String.isNotBlank(avatarURL)) // 00e38000000jTN2AAM is the 'Technician Community User' profile
        if (String.isNotBlank(avatarURL))
        {
            HttpResponse http = FutureApexCallout.GetBinaryPhoto(avatarURL);            
            ConnectApi.BinaryInput binaryPhoto = new ConnectApi.BinaryInput(http.getBodyAsBlob(), 'image/jpg', 'AvatarImg');            
        	ConnectApi.UserProfiles.setPhoto('0DB380000004CS8GAM', userId, binaryPhoto);  // 0DB380000004CS8GAM is the Technicial Community network ID (select id, name from network) 
  		}
	}
    
    public static HttpResponse GetBinaryPhoto(string avatarURL)
    {
                
        Http h = new Http(); 
        HttpRequest req = new HttpRequest(); 
        string firstImageURL = avatarURL;        
        firstImageURL = firstImageURL.replace(' ', '%20'); //Replace any spaces with %20 
        req.setEndpoint(firstImageURL); 
        req.setMethod('GET');        
        req.setHeader('Content-Type', 'image/jpg'); //If you want to get a PDF file the Content Type would be 'application/pdf' 
        req.setCompressed(true); 
        req.setTimeout(60000); 
        HttpResponse res = null; 
        res = h.send(req); 
        // responseValue: Shows you the actual response for dealing with error situations 
        string responseValue = ''; 
        responseValue = res.getBody(); 
        //system.debug('Response Body for File: ' + responseValue); 
        
        //This is the line that does the magic. This gets the blob of the file.        
        return res;
    }
}