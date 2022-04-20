public without sharing class forumCategoriesController {
    
    public static set<Id>sAllColabGroupId = new set<Id>();
    
    @AuraEnabled
    public static String saveRecord(String name, String colType, String description , Boolean isAuto, Boolean isLock){
        List<CollaborationGroup> cgroup = new  List<CollaborationGroup>();
        
        CollaborationGroup colGroup = new CollaborationGroup();
        colGroup.Name = name;
        colGroup.CollaborationType = colType;
        colGroup.Description = description;
        colGroup.NetworkId = System.Label.NetworkId;
        colGroup.isbroadcast = isLock;
        cgroup.add(colGroup);
        insert cgroup;
        
        createCustomCollab(cgroup,isAuto, isLock);
        return colGroup.id;
    }
   
    @AuraEnabled
    public static void saveShadowObject(String feedId, Boolean pinnedPost){
        List <Feed_Item_Holder__c> feedHolder = [select id, is_pinned__c from Feed_Item_Holder__c where feedItem_Id__c =: feedId];
        
        if(feedHolder.size() == 0){
            Feed_Item_Holder__c feedHolder1 = new Feed_Item_Holder__c();
            feedHolder1.FeedItem_Id__c = feedId;
            feedHolder1.is_Pinned__c = true;
            insert feedHolder1;
        }
        else{             
            if(pinnedPost){                                
                feedHolder[0].is_Pinned__c = true;                
            }
            else{
                feedHolder[0].Is_Pinned__c = false;                
            }
            update feedHolder;
        }
    }
    
    public static void callGetcollaborationRecord(){
        Set<Id> pIds = new Set<Id>();
        for (PermissionSet pp : [SELECT id,name FROM PermissionSet WHERE name='AutomationDataCategory']){
            pIds.add(pp.id);
        }
        List<PermissionSetAssignment> psa = [SELECT Id,PermissionSetId,AssigneeId from PermissionSetAssignment WHERE AssigneeId=:userInfo.getUserId() AND PermissionSetId=:pIds];
        Boolean isAuto;
        Boolean LicenseType = False;
        
        if(psa.size() == 0){
            Id profileId = userInfo.getProfileId();    
            Profile prof = [SELECT id,UserLicense.Name FROM Profile WHERE Id=:profileId];
            if (prof.UserLicense.Name == 'Salesforce') LicenseType = true;
        }
        
        if (psa.size() > 0 || LicenseType){
            isAuto = True;
        }else isAuto = False;
        
        set<Id> tempColabId = new set<Id>(); 
        for(CollaborationGroupMember colGmember: [SELECT id,MemberId,NetworkId,CollaborationGroupId,CollaborationRole 
                                                  FROM CollaborationGroupMember WHERE MemberId =:userInfo.getUserId()]){
                                                      tempColabId.add(colGmember.CollaborationGroupId);
                                                  }
        
        
        set<Id>tempID = new set<Id>();
        for (CollaborationGroupVisibility__c clv: [Select Name,CollaborationGroupId__c,
                                                   CollaborationGroupName__c,IsAutomation__c,CollaborationType__c,is_Lock__c From CollaborationGroupVisibility__c 
                                                   WHERE CollaborationGroupId__c !=null]){
                                                       if(isAUto){   
                                                           tempID.add(clv.CollaborationGroupId__c);  
                                                       }else {
                                                           if(clv.IsAutomation__c == False){
                                                               tempID.add(clv.CollaborationGroupId__c);  
                                                           }
                                                       }                                                       
                                                   }      
        
        //query all collabGroup Private type
        for(CollaborationGroup colG :[SELECT id,CollaborationType,NetworkId  FROM CollaborationGroup WHERE id=:tempColabId AND CollaborationType='Private' AND NetworkId !=null]){
            if (tempID.contains(colG.id)){
                sAllColabGroupId.add(colG.id);
            }
        }
        
        //query all collabGroup Public type
        for(CollaborationGroup colG :[SELECT id,CollaborationType,NetworkId  FROM CollaborationGroup WHERE CollaborationType='Public' AND NetworkId !=null]){
            if (tempID.contains(colG.id)){
                sAllColabGroupId.add(colG.id);
            }
            
        }
        
    }
    @AuraEnabled
    public static collabListWrapperClass getCollaborations(){

        callGetcollaborationRecord();
        collabListWrapperClass collabListWrapper = new collabListWrapperClass(); 
        collabListWrapper.collabList = [
            SELECT Id, Name, Description, CollaborationType, CreatedDate, 
            (SELECT Id, CommentCount, CreatedDate, LastModifiedDate FROM Feeds WHERE Type !='TrackedChange') 
            FROM CollaborationGroup 
            WHERE Id=:sAllColabGroupId
        ];
        
      	List<CollaborationGroup>  colList = [
            SELECT Id, Name, Description, CollaborationType, CreatedDate, 
            (SELECT Id, CommentCount, CreatedDate, LastModifiedDate FROM Feeds WHERE Type !='TrackedChange' ORDER BY CreatedDate DESC) 
            FROM CollaborationGroup 
            WHERE Id=:sAllColabGroupId 
            ORDER BY CollaborationType DESC
        ];
        
        collabListWrapper.collabList = colList;
        Set<Id> xxx = new set<Id>();
        for(CollaborationGroup test:  colList){
            xxx.add(test.id);
        }
        collabListWrapper.customCollabList = [Select Name,CollaborationGroupId__c,is_Lock__c From CollaborationGroupVisibility__c WHERE CollaborationGroupId__c =: xxx];
        
        List<Id> collabIds = new List<Id>();
        Map<Id, String> holdCollabItemMap = new Map<Id, String>();
        Map<Id, String> mobileSortMap = new Map<Id, String>();
        for(CollaborationGroup clg : colList){
            collabIds.add(clg.id);
            collabListWrapper.collabId = clg.Id;
            if(clg.Feeds.size() > 0){
                String getTime;
                getTime = getMinutes(clg.Feeds[0].CreatedDate);
                holdCollabItemMap.put(clg.Id, getTime);
            } else if(clg.CreatedDate != null){
                String getTime;
                getTime = getMinutes(clg.CreatedDate);
                system.debug('getTime' + getTime);
                holdCollabItemMap.put(clg.Id, getTime);
            }
        }
        collabListWrapper.collabItemMap = holdCollabItemMap;   
        List<Image_Banner__c> imageList = [Select Id,CollaborationGroupId__c From Image_Banner__c Where CollaborationGroupId__c IN: sAllColabGroupId];
        Map<String, Attachment> attachmentMap = new Map<String, Attachment>();
        for(Attachment att: [Select Name, ParentId From Attachment WHERE ParentId IN: imageList] ){
            attachmentMap.put(att.ParentId, att);
        }
        Map<String, String> attachmentIds = new Map<String, String>();
        for(Image_Banner__c imgRec: imageList){
            if(attachmentMap.containsKey(imgRec.Id)){
                Attachment attachmentRec = attachmentMap.get(imgRec.Id);
                attachmentIds.put(imgRec.CollaborationGroupId__c, attachmentRec.Id);
            }
            
        }
        collabListWrapper.attachmentList = attachmentIds;
        return collabListWrapper;
    }
    
    public class collabListWrapperClass{
        @AuraEnabled public List<CollaborationGroupVisibility__c> customCollabList;
        @AuraEnabled public List<CollaborationGroup> collabList;
        @AuraEnabled public Map<String, String> attachmentList;
        @AuraEnabled public Map<Id, String> collabItemMap;
        @AuraEnabled public Id collabId;
        @AuraEnabled public Map<Id, String> mobileSortMap;
    }
    
    @AuraEnabled
    public static String getFeedNameData(String recordId){
        FeedItem fdItm = [SELECT Title,Body,ParentId,Parent.Name,CreatedBy.Name FROM FeedItem WHERE Id =: recordId];
        String feedSub;
        
        if(String.isBlank(fdItm.Title) && fdItm.Body == null){
            feedSub = String.valueOf(fdItm.CreatedBy.Name).stripHtmlTags() + ' shared a post'; 
        }else{
            if(String.isBlank(fdItm.Title)){
               feedSub      = String.valueOf(fdItm.Body).stripHtmlTags();
            }else{
                feedSub     = String.valueOf(fdItm.Title).stripHtmlTags();
            }
            
        }
        if(feedSub.length() > 40){
            feedSub = feedSub.substring(0,40) + '...';
        }
        
        return feedSub;
        
    }
    
    @AuraEnabled
    public static String getCollaborationData(String collabId){
        CollaborationGroup collg = [Select Name From CollaborationGroup where id =: collabId LIMIT 1];
        return collg.Name;
    }
    @AuraEnabled
    public static Boolean deleteCollaborationGroup(Id recordId){
        Boolean isSuccess = true;
        try{
            List<CollaborationGroup> delCollabGroup = [Select Id, Name From CollaborationGroup WHERE id=:recordId];
            
            Set<String> colName =new Set<String>();
            for(CollaborationGroup cgdel :delCollabGroup ){
                colName.add(cgdel.Name);
            }
            List<CollaborationGroupVisibility__c> delCGV = [Select Id,CollaborationGroupId__c from CollaborationGroupVisibility__c Where CollaborationGroupId__c =:recordId];	
            delete delCGV;
            System.debug(delCollabGroup);
            delete delCollabGroup;
        }
        catch(exception e){
            isSuccess = false;
        }
        return isSuccess;
    }
    @AuraEnabled
    public static CollaborationGroupVisibility__c  editCollaborationGroup(Id recordId){

        CollaborationGroupVisibility__c delCollabGroup = [Select id, Name, CollaborationGroupId__c, CollaborationGroupName__c, IsAutomation__c, 
                                                          CollaborationType__c,CollaborationGroupDescription__c,is_Lock__c
                                                          From CollaborationGroupVisibility__c WHERE CollaborationGroupId__c=:recordId LIMIT 1];
        return delCollabGroup;
    }
    
    @AuraEnabled
    public static Boolean saveEdit(Id recordId, string saveName, string saveDesc,string saveType, boolean saveAuto, boolean saveLock){
        system.debug('$$$ saveLock + '+ saveLock);
        Boolean isSuccess = true;
        try{
            CollaborationGroup updateCollabGroup = [Select Name, Description,CollaborationType From CollaborationGroup WHERE id=:recordId LIMIT 1];
            updateCollabGroup.Name = saveName;
            updateCollabGroup.Description = saveDesc;
            updateCollabGroup.CollaborationType = saveType;
            updateCollabGroup.isbroadcast  = saveLock;
            update updateCollabGroup;
            
            CollaborationGroupVisibility__c updateCustomCollab = [Select CollaborationGroupName__c, CollaborationGroupDescription__c,IsAutomation__c,CollaborationType__c,CollaborationGroupId__c	
                                                    From CollaborationGroupVisibility__c WHERE CollaborationGroupId__c=:recordId];
			
            updateCustomCollab.Name = saveName;
            updateCustomCollab.CollaborationGroupName__c = saveName;
            updateCustomCollab.CollaborationGroupDescription__c = saveDesc;
            updateCustomCollab.CollaborationType__c =saveType;
            updateCustomCollab.IsAutomation__c = saveAuto;
            updateCustomCollab.is_Lock__c = saveLock;           
            update updateCustomCollab;
            
        }
        catch(exception e){
            isSuccess = false;
            System.debug('$$error: ' + e);
        }
        return isSuccess;
    }
    
    @AuraEnabled
    public static List<CollaborationGroupFeed> getListCollaborationFeed(String collabId, String isThread){	
        
        callGetcollaborationRecord();
        
        List<CollaborationGroupFeed> collGroupFeed = new List<CollaborationGroupFeed>();
        if(isThread =='default'){
            List<CollaborationGroupFeed> ldefaultcollGroupFeed = [Select Id,Body,Parent.Name, ParentId, LikeCount, CommentCount, InsertedById, 
                                                                InsertedBy.Name, CreatedDate, LastModifiedDate ,CreatedBy.Name, Type, Title
                                                                FROM CollaborationGroupFeed  WHERE ParentId =:collabId AND type !='TrackedChange'
                                                                ORDER BY LastModifiedDate DESC];
            collGroupFeed = ldefaultcollGroupFeed;
        }
        if(isThread =='today'){                                          
            Set<Id> stcgfId = new set<Id>();
            for(CollaborationGroupFeed tcg : [Select Id, ParentId,Parent.Name, CreatedDate, LastModifiedDate,(Select Id, CreatedDate FROM FeedComments WHERE CreatedDate>= TODAY) 
                                              From CollaborationGroupFeed  WHERE ParentId =:sAllColabGroupId AND type !='TrackedChange'
                                              ORDER BY LastModifiedDate DESC]){
                                                  if(!tcg.FeedComments.isEmpty()){
                                                      stcgfId.add(tcg.id);
                                                  }
                                                  if(tcg.CreatedDate >= System.today() -1 ){
                                                      stcgfId.add(tcg.id);
                                                  }
                                              }
            
            
            List<CollaborationGroupFeed> lTodaycollGroupFeed = [Select Id,Body,Parent.Name, ParentId, LikeCount, CommentCount, InsertedById, 
                                              InsertedBy.Name, CreatedDate, LastModifiedDate ,CreatedBy.Name, Type, Title 
                                              From CollaborationGroupFeed  WHERE Id=:stcgfId
                                              ORDER BY LastModifiedDate DESC];               
            collGroupFeed = lTodaycollGroupFeed;
        }
        
        if(isThread =='sincelastvisit' || isThread =='Since Last Visit'){
            Set<Id> sLastVcgfId = new set<Id>();
            
            DateTime userlastLog ;
            Filter_Since_Last_Visit__c forTesting = Filter_Since_Last_Visit__c.getValues('Internal Testing');
            
            String s1 = forTesting.Year__c + '-'+ forTesting.Month__c +'-'+ forTesting.Day__c;
            List<String> dateStringList =s1.split('-');
            Datetime userlastLogforTesting = DateTime.newInstance(Integer.valueOf(dateStringList[0]),Integer.valueOf(dateStringList[1]),Integer.valueOf(dateStringList[2]));
            
            
            User u = [SELECT LastLoginDate FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
            userlastLog = u.LastLoginDate.date();
            if(forTesting.is_Active__c){
            userlastLog = userlastLogforTesting;
            }
            system.debug('@@@ userlastLog '+ userlastLog);
            
            for(CollaborationGroupFeed cg: [Select Id,Parent.Name, ParentId, CreatedDate, LastModifiedDate,
                                            (Select Id, CreatedDate FROM FeedComments) 
                                            FROM CollaborationGroupFeed  
                                            WHERE ParentId =:sAllColabGroupId AND type !='TrackedChange' AND LastModifiedDate = LAST_N_DAYS:10
                                            ORDER BY LastModifiedDate ASC]){
                                                DateTime threadModified = cg.LastModifiedDate.date(); 
                                                Integer monthDiff = userlastLog.date().daysBetween(Date.valueOf(threadModified));
                                                if(monthDiff >= 0){
                                                    sLastVcgfId.add(cg.id);  
                                                    if(!cg.FeedComments.isEmpty()){
                                                        sLastVcgfId.add(cg.id);  
                                                    } 
                                                }
                                                threadModified = null;
                                            }
            
            List<CollaborationGroupFeed> lLastcollGroupFeed = [Select Id,Body,Parent.Name, ParentId, LikeCount, CommentCount, InsertedById, 
                                                               InsertedBy.Name, CreatedDate, LastModifiedDate ,CreatedBy.Name, Type, Title
                                                               FROM CollaborationGroupFeed  
                                                               WHERE Id =:sLastVcgfId AND type !='TrackedChange' AND CreatedDate = LAST_N_DAYS:10
                                                               ORDER BY LastModifiedDate ASC];
            
            collGroupFeed = lLastcollGroupFeed;
        }
        
        
        if(isThread =='trending'){
            List<CollaborationGroupFeed> lTrendingcollGroupFeed = [Select Id,Body,Parent.Name, ParentId, LikeCount, CommentCount, InsertedById, 
                                                                  InsertedBy.Name, CreatedDate, LastModifiedDate ,CreatedBy.Name, Type, Title
                                                                  FROM CollaborationGroupFeed  
                                                                  WHERE ParentId =:sAllColabGroupId AND type !='TrackedChange' AND CreatedDate = LAST_N_DAYS:30
                                                                  ORDER BY CommentCount DESC];
            collGroupFeed = lTrendingcollGroupFeed;
        }
       
        return collGroupFeed;
        
    }
    
    @AuraEnabled
    public static List<CollaborationGroupFeed> deleteCollaborationGroupFeed (Id recordId, String threadFilter){
        System.debug('recordId: '+recordId);
        List<CollaborationGroupFeed> delCollabGroupfeed = [Select Id,Body From CollaborationGroupFeed WHERE id=:recordId];

        //delCollabGroupfeed.Id = recordId;
        System.debug(delCollabGroupfeed);
        
        delete delCollabGroupfeed;
        return getListCollaborationFeed(recordId, threadFilter);
    }
    
    @AuraEnabled
    public static List<FeedComment> getFeedComments(Id recordId){
        return [Select Id, CreatedDate, FeedItemId From FeedComment WHERE FeedItemId =: recordId ];
    }
    
    @AuraEnabled
    public static List<FeedItem> getFeedItem1(String collabId, List<FeedItem> currentList){
        Return [SELECT id,ParentId  FROM FeedItem Where ParentId =:collabId AND ID NOT IN :currentList AND Type!='TrackedChange'];
    }
    
    @AuraEnabled
    public static Integer getNewCollaborationGroupFeeds(String collaborationGroupId, List<String> existingCollaborationGroupIds){
        return [SELECT COUNT() FROM FeedItem WHERE ParentId =:collaborationGroupId AND Id NOT IN :existingCollaborationGroupIds AND Type!='TrackedChange'];
    }
    
    @AuraEnabled
    public static List<CollaborationGroupFeedWrapper> getCollaborationGroupFeeds(String collaborationGroupId, String filter){
        List<CollaborationGroupFeedWrapper> collaborationGroupFeedWrapperList = new List<CollaborationGroupFeedWrapper>();
        List<CollaborationGroupFeed> collaborationGroupFeedList = new List<CollaborationGroupFeed>();
        
        callGetcollaborationRecord();
        
        //Generate the query based on the filter.
        String collabType = 'TrackedChange';
        String baseQuery = 'SELECT Id,Body,Parent.Name, ParentId, LikeCount, CommentCount, InsertedById, ' + 
            'InsertedBy.Name, CreatedDate, LastModifiedDate ,CreatedBy.Name, Type, Title ' + 
            'FROM CollaborationGroupFeed ' + 
            'WHERE Type !=: collabType ';
        if (filter == 'default') {
            baseQuery += 'AND ParentId =: collaborationGroupId ' +
                'ORDER BY LastModifiedDate DESC ';
        } else if (filter == 'today') {
            DateTime lastDay = System.now().addDays(-1);
            baseQuery += 'AND ParentId =: sAllColabGroupId ' + 
                'AND LastModifiedDate >=: lastDay ' +
                'ORDER BY LastModifiedDate DESC ';
        } else if (filter == 'trending') {
            baseQuery += 'AND ParentId =: sAllColabGroupId ' + 
                'AND LastModifiedDate = LAST_N_DAYS:30 ' +
                'ORDER BY CommentCount DESC ';
        } else if (filter == 'sincelastvisit' || filter == 'Since Last Visit') {
            LoginHistory recentLoginHistory;
            try {
                List<LoginHistory> loginHistories = [
                    SELECT Id, UserId, LoginTime, Status FROM LoginHistory 
                    WHERE UserId =: UserInfo.getUserId() 
                    ORDER BY LoginTime DESC OFFSET 1
                ];
                for(LoginHistory loginHistory : loginHistories) {
                    if (loginHistory.Status == 'Success') {
                        recentLoginHistory = loginHistory;
                        break;
                    }
                }
                /**recentLoginHistory = [
                    SELECT Id, UserId, LoginTime, Status FROM LoginHistory 
                    WHERE UserId =: UserInfo.getUserId() 
                    ORDER BY LoginTime DESC LIMIT 1 OFFSET 1
                ];*/
            } catch(Exception ex) {
                recentLoginHistory = null;
            }
            
            DateTime userlastLog ;
            Filter_Since_Last_Visit__c forTesting = Filter_Since_Last_Visit__c.getValues('Internal Testing');
            
            Datetime userlastLogforTesting = DateTime.newInstance(
                Integer.valueOf(forTesting.Year__c), 
                Integer.valueOf(forTesting.Month__c), 
                Integer.valueOf(forTesting.Day__c)
            );
            
            
            if (recentLoginHistory != null) {
                userlastLog = Date.valueOf(recentLoginHistory.LoginTime);
            } else {
                if(forTesting.is_Active__c){
                    userlastLog = userlastLogforTesting;
                } else {
                    userlastLog = Date.valueOf(System.today());
                }
            }
            
            baseQuery += 'AND ParentId =: sAllColabGroupId ' + 
                'AND LastModifiedDate >: userlastLog ' +
                'AND LastModifiedDate = LAST_N_DAYS:10 ' +
                'ORDER BY LastModifiedDate DESC ';
        }
        
        System.debug('baseQuery: ' + baseQuery);
        
        baseQuery += 'LIMIT 1000 ';
        
        collaborationGroupFeedList = Database.query(baseQuery);
        
        Set<String> collaborationGroupFeedIds = new Set<String>();
        for(CollaborationGroupFeed collaborationGroupFeedRecord : collaborationGroupFeedList) {
            collaborationGroupFeedIds.add(collaborationGroupFeedRecord.Id);
        }
        
        //Get all related Feed Item Holders
        List<Feed_Item_Holder__c> feedItemHolderList = [SELECT Id, FeedItem_Id__c, is_Pinned__c,Is_Lock__c FROM Feed_Item_Holder__c WHERE FeedItem_Id__c IN: collaborationGroupFeedIds];
        Map<Id, Feed_Item_Holder__c> feedItemHolderMap = new Map<Id, Feed_Item_Holder__c>();
        for(Feed_Item_Holder__c feedItemHolderRecord : feedItemHolderList) {
            feedItemHolderMap.put(feedItemHolderRecord.FeedItem_Id__c, feedItemHolderRecord);
        }
        
        //Get all related feed items.
        List<FeedItem> feedItemList = [
            SELECT id,IsClosed,Body, ParentId, CreatedDate,Type,likeCount,
            (SELECT Id, CreatedDate, FeedItemId FROM FeedComments ORDER BY CreatedDate DESC LIMIT 1) 
            FROM FeedItem
            WHERE Id IN: collaborationGroupFeedIds
        ];
        Map<Id, FeedItem> feedItemMap = new Map<Id, FeedItem>();
        for(FeedItem feedItemRecord : feedItemList) {
            feedItemMap.put(feedItemRecord.Id, feedItemRecord);
        }
        
        //Generate the wrapper class that will hold all the needed information in the front end.
        for(CollaborationGroupFeed collaborationGroupFeedRecord : collaborationGroupFeedList) {
            CollaborationGroupFeedWrapper collaborationGroupFeedWrapper = new CollaborationGroupFeedWrapper();
            collaborationGroupFeedWrapper.collaborationGroupFeed = collaborationGroupFeedRecord;
            collaborationGroupFeedWrapper.feedItem = feedItemMap.get(collaborationGroupFeedRecord.Id);
            collaborationGroupFeedWrapper.hasCustomFeedItemHolder = feedItemHolderMap.containsKey(collaborationGroupFeedRecord.Id);
            if (collaborationGroupFeedWrapper.hasCustomFeedItemHolder) {
                collaborationGroupFeedWrapper.feedItemHolder = feedItemHolderMap.get(collaborationGroupFeedRecord.Id);
            }   
            String feedItemTimeText = '';
            String collabNameHolder = '';
            if (collaborationGroupFeedWrapper.feedItem != null) {
                if(collaborationGroupFeedWrapper.feedItem.feedcomments.size() > 0){    
                    feedItemTimeText = getMinutes(collaborationGroupFeedWrapper.feedItem.feedComments[0].CreatedDate);
                    collabNameHolder = CollaborationGroupFeedWrapper.collaborationGroupFeed.Parent.Name;
                } else if(collaborationGroupFeedWrapper.feedItem.CreatedDate != null){
                    feedItemTimeText = getMinutes(collaborationGroupFeedWrapper.feedItem.CreatedDate);
                    collabNameHolder = CollaborationGroupFeedWrapper.collaborationGroupFeed.Parent.Name;
                }
            }
            collaborationGroupFeedWrapper.timeStampPost = feedItemTimeText;
            collaborationGroupFeedWrapper.collabName = collabNameHolder;
            
            collaborationGroupFeedWrapperList.add(collaborationGroupFeedWrapper);
        }
        
        return collaborationGroupFeedWrapperList;
    }
    
    public class CollaborationGroupFeedWrapper {
        @AuraEnabled public CollaborationGroupFeed collaborationGroupFeed;
        @AuraEnabled public FeedItem feedItem;
        @AuraEnabled public Feed_Item_Holder__c feedItemHolder;
        @AuraEnabled public Boolean hasCustomFeedItemHolder;
        @AuraEnabled public String timeStampPost;
        @AuraEnabled public String collabName;
    }
    
    
    @AuraEnabled
    public static feedItemWrapper getFeedItem(String collabId , String isThread){
        feedItemWrapper getFeedItemWrapper = new feedItemWrapper();
        List<FeedItem> feedItemList = new List<FeedItem>();
        
        if(isThread =='default'){
            List<FeedItem> feedItemListdefault = [
                SELECT id,IsClosed,Body, ParentId,CreatedDate,Type,likeCount,(Select Id, CreatedDate,FeedItemId From FeedComments ORDER BY CreatedDate DESC LIMIT 1) 
                FROM FeedItem 
                WHERE ParentId =:collabId AND Type!='TrackedChange'
            ];
            feedItemList = feedItemListdefault;
        } else if(isThread =='today') {
            List<FeedItem> feedItemListdefault = [
                SELECT id,IsClosed,Body, ParentId,CreatedDate,Type,likeCount,(Select Id, CreatedDate,FeedItemId From FeedComments ORDER BY CreatedDate DESC LIMIT 1) 
                FROM FeedItem 
                WHERE Type!='TrackedChange' AND CreatedDate = TODAY ORDER BY CreatedDate DESC LIMIT 500
            ];
            feedItemList = feedItemListdefault;
        } else {
            List<FeedItem> feedItemListFiltered = [
                SELECT id,IsClosed,Body, ParentId,CreatedDate,Type,likeCount,(Select Id, CreatedDate,FeedItemId From FeedComments ORDER BY CreatedDate DESC LIMIT 1) 
                FROM FeedItem 
                WHERE Type!='TrackedChange' AND CreatedDate = LAST_N_DAYS:30 ORDER BY CreatedDate DESC LIMIT 500
            ];
            feedItemList = feedItemListFiltered;
        }

        getFeedItemWrapper.feedItemList = feedItemList;
        
        List<Id> feedIds = new List<Id>();
        for(FeedItem feedItemIds : feedItemList){
            feedIds.add(feedItemIds.Id);
        }
        Map<Id, String> holdFeedCommentMap = new Map<Id, String>();
        for(FeedItem fdc : feedItemList){
            if(fdc.feedcomments.size() > 0){                
                String getTime;
                getTime = getMinutes(fdc.feedComments[0].CreatedDate);
                system.debug('getTime' + getTime);
                holdFeedCommentMap.put(fdc.Id, getTime);
            }
            else if(fdc.CreatedDate != null){
                String getTime;
                getTime = getMinutes(fdc.CreatedDate);
                system.debug('getTime' + getTime);
                holdFeedCommentMap.put(fdc.Id, getTime);
                
            }
        }
        
        getFeedItemWrapper.feedCommentMap = holdFeedCommentMap;
        List<Feed_Item_Holder__c> feedItemHolderList = [Select Id, FeedItem_Id__c, is_Pinned__c,Is_Lock__c, LastModifiedDate From Feed_Item_Holder__c Where FeedItem_Id__c IN:feedIds ORDER By LastModifiedDate DESC];
        getFeedItemWrapper.feedItemHolderList = feedItemHolderList;
        return getFeedItemWrapper;  
    }
    public class feedItemWrapper{
        @AuraEnabled public List<FeedItem> feedItemList;
        @AuraEnabled public List<Feed_Item_Holder__c> feedItemHolderList;
        @AuraEnabled public Map<Id, String> feedCommentMap;
        @AuraEnabled public Map<Id, String> feedItemMap;
        @AuraEnabled public Map<Id,Long> groufeedMap;
        @AuraEnabled public List<CollaborationGroupFeed> cgfList;
		@AuraEnabled public Map<Id, Long> cgfListUpvoteNumber;
    }
    
    @AuraEnabled
    public static List<Feed_Item_Holder__c> getFeedItemHolder(){
        List<Feed_Item_Holder__c> feedItemHolderList = [Select Id, FeedItem_Id__c, is_Pinned__c From Feed_Item_Holder__c];
        return feedItemHolderList;  
    }
    
    /*
    * @last modified on  : 12-02-2021
    * @last modified by  : Simplus
    * Modification       : Added LastLoginDate and Contact.Account.SAP_ACCOUNT_ID__c
    */
    @AuraEnabled 
    public static List<User> listUser(String searchKeyWord){
        String searchKey = '%'+ searchKeyWord + '%';
        List <User> returnList = new List<User>();
        List <User> lstOfUser = [select Id,Name,Email,AccountName__c,user.profile.name,LastloginDate,Contact.Account.SAP_ACCOUNT_ID__c  FROM user 
                                 Where Name LIKE :searchKey ORDER By Name ASC];
        for (User usr: lstOfUser) {
            returnList.add(usr);
        }
        Return returnList;
    }
    
    @AuraEnabled
    public static List<User> findByName(String searchKey) {
        String name = '%' + searchKey + '%';
        return [SELECT id, name from User WHERE name LIKE :name LIMIT 50];
    }
    
    @AuraEnabled 
    public static void addUsertoGroup(Id userId, Id groupId){                
        insert new CollaborationGroupMember(CollaborationGroupId = groupId, MemberId =userId);        
    }
    
    @AuraEnabled 
    public static void removeUserAccessToGroup(Id userId, Id groupId){ 
        delete [select id, MemberId, CollaborationGroupId from  CollaborationGroupMember where MemberId =: userId AND CollaborationGroupId =: groupId];
    }
    
    
    
    @AuraEnabled 
    public static User fetchUser(){
        return  [select id,Name,ProfileId,subscribeGroup__c,subscribePost__c from User where id =:userInfo.getUserId()];
    }
    

    @AuraEnabled
    public static List<CollaborationGroupMember> ManageCollaborationGroupMember(Id recordId) 
    {
        List<CollaborationGroupMember> mcgm = [SELECT id,MemberId,NetworkId,CollaborationGroupId,CollaborationRole 
                                               FROM CollaborationGroupMember WHERE CollaborationGroupId =:recordId];
        return mcgm;
        
    }
    
    @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject, String eSubject,String mBodyLink, String getUserName){
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = mMail.split(',|\\;');
        mail.setToAddresses(sendTo);
        mail.setReplyTo('support@control4.com');
        mail.setSenderDisplayName(getUserName);  
        
        mail.setSubject(eSubject);
        
        String htmlBody='<html> '+
            '<h3>'+ mSubject +' <br/>'+
            '<a href="'+mBodyLink+'"><button type="button" style="font-size:15px;border-radius:4px;background-color:#147DBE;color:white;height:40px;border:none;text-decoration:none;cursor:pointer;">'+ 'View/Comment' +'</button></a>'+
            ' '+'or reply to this email</h3>'+
            '</html>';
        
        mail.setHtmlBody(htmlBody);
        mails.add(mail);
        
        
        Messaging.sendEmail(mails);
    }  
    

    public static Integer getSeconds(dateTime holdCreatedDate){             
        return ((System.Now().getTime() - holdCreatedDate.getTime()) /(1000)).intValue();    
    }
    
    
    //get minute
    public static String getMinutes(DateTime holdCreatedDate){
        String finalTimeStamp = 'm';
        Integer min = ((System.Now().getTime() - holdCreatedDate.getTime())/(1000 * 60)).intValue();
        if(min == 0){
            //SECS
            min = getseconds(holdCreatedDate);
            finalTimeStamp= 's';
        }
        if(min > 60 && min < 1440){
            //HRS
            min = min/60;
            finalTimeStamp = 'h';
        }
        if(min >= 1440){
            //DAYS
            min = min/ (60*24);
            finalTimeStamp = 'd';
        }
        
        return (string.valueOf(min) + '' + finalTimeStamp);
    }
    
    @AuraEnabled
    public static Id saveChunk(String collabId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks
        
        if (fileId == '') {
            fileId = saveTheFile(collabId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
 
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(String collabId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Image_Banner__c imageBanner = new Image_Banner__c();
       	imageBanner.CollaborationGroupId__c = collabId;
        insert imageBanner;
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = imageBanner.Id;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        List<Attachment> a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 		
            For (Attachment att : a){
            String existingBody = EncodingUtil.base64Encode(att.Body);
            att.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        }
      
 
        update a;
    }
    
    @AuraEnabled
    public static void updateUserSubscriptionGroup(String recordId, String usrId){
        List<User> usrList = New List <User>();
        List<User> usr = [select Id,Name,subscribeGroup__c FROM user WHERE id=:usrId];
        for(User u: usr){
            if(String.isblank(u.subscribeGroup__c)){
                u.subscribeGroup__c = recordId;
            }else{
                u.subscribeGroup__c = u.subscribeGroup__c + ' '+ recordId;
            }
            
            usrList.add(u);
        }
        update usrList;
    }
    
    /* 
    @AuraEnabled
    public static void updateUserSubscriptionGroup(String recordId, String usrId){
        Set<Id> uIds = new Set<Id>(); 
        for(User u: [select Id,Name,subscribeGroup__c FROM user WHERE id=:usrId]){
            uIds.add(u.Id);
        }
        
        if(uIds.size() >0){
            updateUserSubscriptionGroupFuture(recordId,uIds);
        }
        
    }
    @future
    private static void updateUserSubscriptionGroupFuture(String recordId,Set<Id> uIds){
        List<User> usrList = New List <User>();
        for(User u: [select Id,Name,subscribeGroup__c FROM user WHERE id=:uIds]){
            if(String.isblank(u.subscribeGroup__c)){
                u.subscribeGroup__c = recordId;
            }else{
                u.subscribeGroup__c = u.subscribeGroup__c + ' '+ recordId;
            }
            usrList.add(u);
        }
        update usrList;
    }
    */
	@AuraEnabled
    public static void removeUserSubscriptionGroup(String recordId, String usrId){
        List<User> usrList = New List <User>();
        for(User u: [select Id,Name,subscribeGroup__c FROM user WHERE id=:usrId]){
            u.subscribeGroup__c = u.subscribeGroup__c.remove(recordId);
            usrList.add(u);
        }
        update usrList;
    }    

    @AuraEnabled
    public static void updateUserSubscriptionPost(String recordId, String usrId){

        if(!Test.isRunningTest()){
            ConnectApi.BookmarksCapability bookmark = ConnectApi.ChatterFeeds.updateFeedElementBookmarks(System.Label.NetworkId, recordId,true);
        }

        List<User> usrList = New List <User>();
        List<User> usr = [select Id,Name,subscribePost__c FROM user WHERE id=:usrId];
        
        String cfeIds = getSubscriptions();

        for(User u: usr){
            u.subscribePost__c = cfeIds;
            usrList.add(u);
            System.debug('!@#Contains? ' + u.subscribePost__c.contains(recordId));	
        }
        update usrList;
    }
    
    @AuraEnabled
    public static void removeUserSubscriptionPost(String recordId, String usrId){
        List<User> usrList = New List <User>();
		String cfeIds = getSubscriptions();
		
        for(User u: [select Id,Name,subscribePost__c FROM user WHERE id=:usrId]){
			u.subscribePost__c = cfeIds;
            u.subscribePost__c = u.subscribePost__c.remove(recordId);
            usrList.add(u);
        }
        update usrList;
        
        if(!Test.isRunningTest()){
            ConnectApi.BookmarksCapability bookmark = ConnectApi.ChatterFeeds.updateFeedElementBookmarks(System.Label.NetworkId, recordId,false);
        }
    }
    
    @AuraEnabled 
    public static String getSubscriptions(){
        
        String cfeIds = '';
        if(!Test.isRunningTest()){
            ConnectApi.FeedElementPage fep = ConnectApi.ChatterFeeds.getFeedElementsFromFeed(System.Label.NetworkId, ConnectApi.FeedType.Bookmarks, 'me');
            
            
            for(ConnectApi.FeedElement cFE : fep.elements){
                cfeIds = cfeIds + ' ' + cFE.Id;
            }
        }
        return cfeIds;
        
    }    
    @AuraEnabled
    public static List<CollaborationGroupVisibility__c> createCustomCollab(List<CollaborationGroup> cgroup,Boolean isauto,Boolean isLock){
        
        List<CollaborationGroupVisibility__c> cgv = new List<CollaborationGroupVisibility__c>();
        for(CollaborationGroup cgva : cgroup){
            CollaborationGroupVisibility__c cg = new CollaborationGroupVisibility__c();
            cg.CollaborationGroupName__c = cgva.Name;
            cg.Name = cgva.Name;
            cg.CollaborationGroupId__c	 = cgva.id;
            cg.CollaborationGroupDescription__c = cgva.Description;
            cg.CollaborationType__c = cgva.CollaborationType;
            cg.IsAutomation__c = isauto;
            cg.is_Lock__c = isLock;
            cgv.add(cg);
        }
        insert cgv;
        return cgv;
    }
    
    @AuraEnabled
    public static List<CollaborationGroupVisibility__c> lockCustomCollab(String recordId, String lockcat){

        Boolean isTrue = lockcat=='true' ? True: False;
        
        List<CollaborationGroup> lCollGroup = new List<CollaborationGroup>();
        for(CollaborationGroup cg: [SELECT id,isBroadcast FROM CollaborationGroup WHERE id=:recordId]){
            if(isTrue){
                cg.isBroadcast = true;
            }else{
                cg.isBroadcast = false;
            }
            lCollGroup.add(cg);
        }
        
        if(lCollGroup.size() > 0){
            update lCollGroup;
        }
        
        List<CollaborationGroupVisibility__c> lUpdateCustomCollab = new List<CollaborationGroupVisibility__c>();
        for(CollaborationGroupVisibility__c ccg: [Select Name,CollaborationGroupId__c, CollaborationGroupName__c,IsAutomation__c,
                                                 CollaborationType__c,is_Lock__c From CollaborationGroupVisibility__c WHERE CollaborationGroupId__c=:recordId]){
                                                     ccg.is_Lock__c = isTrue;
                                                     lUpdateCustomCollab.add(ccg);
                                                 }
        if(lUpdateCustomCollab.size() > 0){
            update lUpdateCustomCollab;
        }
        return lUpdateCustomCollab;
    }

    @AuraEnabled
    public static void lockFeedItem(String recordId, String lockfeed){
        Boolean isLocked = lockfeed=='true' ? True: False;
        
        Feed_Item_Holder__c feedItemHolder;
        try {
            feedItemHolder = [SELECT id,FeedItem_Id__c,Is_Lock__c FROM Feed_Item_Holder__c WHERE feedItem_Id__c =: recordId LIMIT 1];
        } catch (Exception ex) {
            feedItemHolder = null;
        }
        
        if (feedItemHolder != null) {
            feedItemHolder.Is_Lock__c = isLocked;
            update feedItemHolder;
        } else {
            Feed_Item_Holder__c newFeedItemHolder = new Feed_Item_Holder__c(
                Is_Lock__c = isLocked,
                FeedItem_Id__c = recordId
            );
            insert newFeedItemHolder;
        }
        
        if(!Test.isRunningTest()){
                ConnectApi.CloseCapability xxxx = ConnectApi.ChatterFeeds.setFeedElementIsClosed(System.Label.NetworkId, recordId, isLocked);
        }
    }
}