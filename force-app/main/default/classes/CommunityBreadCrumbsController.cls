public without sharing class CommunityBreadCrumbsController {
    
    @AuraEnabled
    public static wrapperClass communityURL(Id recId,String urlString){
        
        
        NetworkMember ntwrk = [SELECT networkID,network.Name FROM NetworkMember WHERE memberID = :UserInfo.getUserId() LIMIT 1];
        
        Boolean LicenseType = False;
        Id profileId = userInfo.getProfileId();    
        Profile prof = [SELECT id,UserLicense.Name FROM Profile WHERE Id=:profileId];
        if (prof.UserLicense.Name == 'Salesforce') LicenseType = true;
        
        String commURL;
        String ifProd = URL.getSalesforceBaseUrl().toExternalForm();
        
        //Full Sandbox
        if(ifProd.contains('full') || ifProd.contains('Full') || ifProd.contains('simplusdev')){
            if(LicenseType){
                commURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'technician' + '/';
            }else{
                commURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ntwrk.network.Name.toLowerCase() + '/'; 
            }
        }
        //Production
        else{
            commURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' ;
        }
        
        wrapperClass wc = new wrapperClass();
        
        wc.baseURL       = commURL;
        wc.isHome        = true;
        wc.isGroupURL    = false;
        wc.isFeedURL     = false;
        wc.isFilter		 = false;
        
        if(recId ==null){
            
            if(urlString.contains('view=sincelastvisit') || urlString.contains('view=Since')){
                wc.discussionURL = commURL + 's/discussions';
                wc.isHome        = false;
                wc.isFilter   	 = true;
                wc.testURL = 'Since Last Visit';
            }
            if(urlString.contains('view=today') || urlString.contains('view=Today')){
                wc.discussionURL = commURL + 's/discussions';
                wc.isHome        = false;
                wc.isFilter   	 = true;
                wc.testURL = 'Today';
            }
            if(urlString.contains('view=trending') || urlString.contains('view=Trending')){
                wc.discussionURL = commURL + 's/discussions';
                wc.isHome        = false;
                wc.isFilter   	 = true;
                wc.testURL = 'Trending';
            }
        }

        if(recId != null){
            
            if(String.valueOf(recId).startsWith('0F9')){
                
                CollaborationGroup cg = [SELECT Name FROM CollaborationGroup WHERE Id =: recId];
                
                wc.discussionURL = commURL + 's/discussions';
                wc.groupURL      = ''; //commURL + String.valueOf(recId)
                
                wc.groupName     = cg.Name;
                wc.isHome        = false;
                wc.isGroupURL    = true;
                
            } else if(String.valueOf(recId).startsWith('0D5')){
                
                FeedItem fdItm = [SELECT Title,Body,ParentId,Parent.Name,CreatedBy.Name FROM FeedItem WHERE Id =: recId];
                 
                wc.discussionURL = commURL + 's/discussions';
                wc.groupURL      = commURL + String.valueOf(fdItm.ParentId);
                wc.feedURL       = ''; //commURL + String.valueOf(recId)
                
                wc.groupName     = fdItm.Parent.Name;
                
                if(String.isBlank(fdItm.Title) && fdItm.Body == null){
                    wc.feedBody = String.valueOf(fdItm.CreatedBy.Name).stripHtmlTags() + ' shared a post'; 
                }else{
                    if(String.isBlank(fdItm.Title)){
                        wc.feedBody      = String.valueOf(fdItm.Body).stripHtmlTags();
                    }else{
                        wc.feedBody      = String.valueOf(fdItm.Title).stripHtmlTags();
                    }
                    
                }
                if(wc.feedBody.length() > 40){
                    wc.feedBody = wc.feedBody.substring(0,40) + '...';
                }
                
                wc.isHome        = false;
                wc.isGroupURL    = false;
                wc.isFeedURL     = true;
                
            }
        }
        /*else{
            if(commURL.contains('view')){
                 wc.isFilter = true;
            }

        }*/
        return wc;
    }
    
    public class wrapperClass{
        
        @AuraEnabled public String baseURL     		{get;set;}
        @AuraEnabled public String discussionURL    {get;set;}
        @AuraEnabled public String groupURL    		{get;set;}
        @AuraEnabled public String feedURL     		{get;set;}
        
        @AuraEnabled public String groupName   		{get;set;}
        @AuraEnabled public String feedBody    		{get;set;}
        @AuraEnabled public String testURL    		{get;set;}
        
        @AuraEnabled public Boolean isGroupURL 		{get;set;}
        @AuraEnabled public Boolean isFeedURL  		{get;set;}
        @AuraEnabled public Boolean isHome          {get;set;}
        @AuraEnabled public Boolean isFilter        {get;set;}   
    }
}