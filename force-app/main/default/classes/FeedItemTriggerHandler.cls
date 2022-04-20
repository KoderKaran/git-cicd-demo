public class FeedItemTriggerHandler {
    
    public static void createShadowObject(Map<Id,FeedItem> feeditemMap){
        
        List<FeedItem> fItemList = feeditemMap.values();
        Set<Id> fiIds = new Set<Id>();
        for(FeedItem fi: fItemList){
            if(fi.ParentId != null && fi.NetworkScope == System.label.NetworkId){
                fiIds.add(fi.id);
            }
        }
        if(fiIds.size() > 0){
            
            List<Feed_Item_Holder__c> feedItemList = new List<Feed_Item_Holder__c>();
            List <Feed_Item_Holder__c> feedHolder = [SELECT id,FeedItem_Id__c,Is_Lock__c FROM Feed_Item_Holder__c WHERE feedItem_Id__c =: fiIds];

            system.debug('!!! feedHolder.size() >> '+  feedHolder.size());
            
            if(feedHolder.size() == 0){
                
                for(Id feedholderID : fiIds){
                    Feed_Item_Holder__c feedHolder1 = new Feed_Item_Holder__c();
                    feedHolder1.Is_Lock__c = false;
                    feedHolder1.FeedItem_Id__c = feedholderID;
                    feedItemList.add(feedHolder1);
                    
                }
                Insert feedItemList;
            }            
        }           
        
       
        
    }
    public static void onAfterInsert(Map<Id,FeedItem> feeditemMap){
        

        List<User> usr = [SELECT id,name,subscribeGroup__c FROM USER WHERE Id=:UserInfo.getUserId()];
        FeedItem fItemList = [SELECT id,ParentId,Body,CreatedById,Title,NetworkScope FROM FeedItem WHERE Id=:feeditemMap.keySet() LIMIT 1];
        
        if(fItemList.ParentId != null && fItemList.NetworkScope == System.label.NetworkId){
            
            String feedBody = fItemList.Body;
            if(feedBody == null){
                feedBody = '';
            }
            
            String feedTitle = fItemList.Title;
            if(feedTitle == null){
                feedTitle = fItemList.Body;
                feedBody= '';
            }
            
            User userName = [SELECT id,name,subscribeGroup__c FROM USER WHERE Id=:fItemList.CreatedById LIMIT 1];
            CollaborationGroup colGroup = [SELECT name,Description FROM CollaborationGroup WHERE id=:fItemList.ParentId];
            NetworkMember ntwrk = [SELECT networkID,network.Name FROM NetworkMember WHERE memberID = :UserInfo.getUserId() LIMIT 1]; 
            
            
            
            String commURL;
            String ifProd = URL.getSalesforceBaseUrl().toExternalForm();
            //https://fullsandb-c4community.cs22.force.com/
            
            //Full Sandbox
            if(ifProd.contains('full') || ifProd.contains('Full')){
                commURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ntwrk.network.Name.toLowerCase() + '/';
            }
            //Production
            else{
                commURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' ;
            }
            
            List<User> usrList = new List<User>();
            List<String> emailss = new List<String>();
            for(User u : [SELECT id,Name,subscribeGroup__c,hasSubscribeGroup__c,email FROM USER where isActive= true AND hasSubscribeGroup__c =true]){
                if(u.subscribeGroup__c.contains(fItemList.ParentId)){
                    usrList.add(u);
                    emailss.add(u.email);
                }
            }
            if(usrList.size()> 0){
				OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'do_not_reply@control4.com'];
                List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                String subject = 'Discussions: ' + feedTitle;
                String mBodyLink = commURL + 's/feed/' + fItemList.id;
                mail.setBccAddresses(emailss);
                mail.setReplyTo('support@control4.com');
                if(owea.size() > 0){
				mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                //mail.setSenderDisplayName('Salesforce Support');  
                
                mail.setSubject(subject);
                String htmlBody='<html> '+
                    '<b>' + userName.Name + '</b> asked a question in <b>' + colGroup.name + '</b> <br/><br/>'+ 
                    '<b>' + feedTitle + '</b> <br/>' +
                    '<br/>' + feedBody + '<br/>' + 
                    '<h3> <a href="'+mBodyLink+'"><button type="button" style="font-size:15px;border-radius:4px;background-color:#147DBE;color:white;height:40px;border:none;text-decoration:none;cursor:pointer;">'+ 'View/Comment' +'</button></a>'+
                    ' '+'or reply to this email</h3>'+
                    '</html>';
                
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
                
                Messaging.sendEmail(mails);
            }
            
        }
        
    }

}