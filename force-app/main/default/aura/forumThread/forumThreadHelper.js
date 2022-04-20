({
    initiate : function(component, event, helper, idUrl,commURL,isThread) {
        var recId = idUrl;
        
        if($A.util.isUndefinedOrNull(isThread)){
            isThread = 'default';
        }
        var holdFeedItems =[];
        var action = component.get("c.getFeedItem");
        action.setParams({
            'collabId' : recId,
            'isThread': isThread
        });
        action.setCallback(this, function(response){
            var state = response.getState();            
            if (component.isValid() && state === "SUCCESS"){
                holdFeedItems = response.getReturnValue();
                //	var xxx = holdFeedItems.Length;
                component.set("v.feedItemHolderList", holdFeedItems.feedItemHolderList);                
                helper.lockHelper(component, event, helper, holdFeedItems.feedItemList, recId, holdFeedItems.feedCommentMap,commURL);
            }
        });
        $A.enqueueAction(action);         
        
    },
    
    setIntevalCheckNew : function(component, event, helper){
        var urlString = window.location.href;
        var parts = urlString.substring(urlString.indexOf('/group') + 1);
        var collaborationGroupId = parts.slice(6,24);
        var totalSize = component.get("v.totalSize");
        var collabGroupFeeds = component.get("v.collabList");
        var ids = [];
        collabGroupFeeds.forEach(function(collabGroupFeed) {
            ids.push(collabGroupFeed.Id);
        });
        
        setInterval(function(){
            var action = component.get("c.getNewCollaborationGroupFeeds");
            action.setParams({
                'collaborationGroupId' : collaborationGroupId,
                'existingCollaborationGroupIds' : ids
            });
            action.setCallback(this, function(response){
                var state = response.getState();            
                if (component.isValid() && state === "SUCCESS"){
                    var newItemCount = response.getReturnValue();
                    
                    if(newItemCount != 0){   
                        $A.get('e.force:refreshView').fire();
                    }
                }
            });
            $A.enqueueAction(action);
        }, 3000);
    },
    
    getCollaborationGroupFeedList: function(component, event, helper, collaborationGroupId, communityURL, filter) {
        if($A.util.isUndefinedOrNull(filter)){
            filter = 'default';
        }
        
        var action = component.get("c.getCollaborationGroupFeeds");
        action.setParams({
            'collaborationGroupId' : collaborationGroupId,
            'filter': filter
        });
        action.setCallback(this, function(response){
            var state = response.getState();            
            if (state === "SUCCESS"){
                var collaborationGroupFeedWrapperList = response.getReturnValue();
                var collaborationGroupFeedList = [];
                var countPinned = 0;
                var wrapperLength = collaborationGroupFeedWrapperList.length;
                var isAdminUser = component.get("v.isAdminOnly");
                var userSubscriptions = component.get("v.subscriptions");
                
                collaborationGroupFeedWrapperList.forEach(function(collaborationGroupFeedWrapper) {
                    let collaborationGroupFeed = collaborationGroupFeedWrapper.collaborationGroupFeed;
                    collaborationGroupFeed.hasCustomFeedItemHolder = collaborationGroupFeedWrapper.hasCustomFeedItemHolder;
                    if (collaborationGroupFeed.Type == 'AdvancedTextPost' && $A.util.isUndefinedOrNull(collaborationGroupFeed.Body)){
                        collaborationGroupFeed.Body = collab.CreatedBy.Name  +' Shared a Post';
                    } else if (collaborationGroupFeed.Type == 'QuestionPost'){
                        collaborationGroupFeed.Body = collaborationGroupFeed.Title;
                    } else if (collaborationGroupFeed.Type == 'PollPost'){
                        collaborationGroupFeed.Body = collaborationGroupFeed.Body;
                    }
                    
                    if(!$A.util.isUndefinedOrNull(collaborationGroupFeed.Body)){
                        var newBody = collaborationGroupFeed.Body.toString().replace(/(<([^>]+)>)/ig, '');
                        collaborationGroupFeed.Body = newBody;
                    }
                    
                    if (collaborationGroupFeed.hasCustomFeedItemHolder) {
                        collaborationGroupFeed.isPinned = collaborationGroupFeedWrapper.feedItemHolder.Is_Pinned__c;
                        collaborationGroupFeed.isLocked = collaborationGroupFeedWrapper.feedItemHolder.Is_Lock__c;
                    }
                    
                    collaborationGroupFeed.isClosed = collaborationGroupFeedWrapper.feedItem.isClosed;
                    collaborationGroupFeed.Url = communityURL + 'feed/' + collaborationGroupFeed.Id;
                    
                    if (collaborationGroupFeed.isPinned) {
                        collaborationGroupFeed.pinnedOrder = ++countPinned;
                    }
                    
                    if(!collaborationGroupFeed.pinnedOrder){
                        collaborationGroupFeed.pinnedOrder = ++wrapperLength;
                    }
                    
                    collaborationGroupFeed.LastPostNum = 0;
                    collaborationGroupFeed.timeStampPost = collaborationGroupFeedWrapper.timeStampPost;
                    collaborationGroupFeed.collabName = collaborationGroupFeedWrapper.collabName;
                    let lastValue = 0;
                    let tempPost = collaborationGroupFeed.timeStampPost;
                    let tempType = tempPost.substr(tempPost.length - 1, tempPost.length);
                    let tempValue = tempPost.substr(0, tempPost.length - 1);
                    switch (tempType) {
                        case 's' :
                            lastValue = parseInt(tempValue);
                            break;
                        case 'm' :
                            lastValue = parseInt(tempValue) * 60;
                            break;
                        case 'h' :
                            lastValue = parseInt(tempValue) * 60 * 60;
                            break;
                        case 'd' :
                            lastValue = parseInt(tempValue) * 60 * 60 * 24;
                            break;
                    }
                    collaborationGroupFeed.forIcon = '';
                    collaborationGroupFeed.LastPostNum = lastValue;
                    
                    //Set icons
                    collaborationGroupFeed.icn = '';
                    collaborationGroupFeed.icn2 = '';
                    if (filter == 'default'){
                        if (collaborationGroupFeed.isPinned){
                            collaborationGroupFeed.icn = 'utility:pinned';
                        }
                    }
                    if (collaborationGroupFeed.isLocked) {
                        collaborationGroupFeed.icn2 = 'utility:lock';
                    }
                    
                    //Set row actions
                    collaborationGroupFeed.rowActions = [
                        { 'label': 'Forward', 'name': 'forward' },
                        { 'label': 'Get Link', 'name': 'getLink' }
                    ];
                    
                    if (isAdminUser) {
                        if (filter == 'default'){
                            if (collaborationGroupFeed.isPinned){
                                collaborationGroupFeed.rowActions.push({
                                    'label': 'Unpin',
                                    'name': 'unpin'
                                });
                            } else {
                                collaborationGroupFeed.rowActions.push({
                                    'label': 'Pin',
                                    'name': 'pin'
                                });
                            }
                        }
                        collaborationGroupFeed.rowActions.push({
                            'label': 'Delete',
                            'name': 'delete'
                        });
                        if (collaborationGroupFeed.isLocked) {
                            collaborationGroupFeed.rowActions.push({
                                'label': 'Unlock Thread',
                                'name': 'unlock'
                            });
                        }
                        
                        if ((collaborationGroupFeed.hasCustomFeedItemHolder && !collaborationGroupFeed.isLocked) || !collaborationGroupFeed.hasCustomFeedItemHolder) {
                            collaborationGroupFeed.rowActions.push({
                                'label': 'Lock Thread',
                                'name': 'lock'
                            });
                        }
                    }
                    
                    if ($A.util.isUndefinedOrNull(userSubscriptions) || userSubscriptions == ""){
                        collaborationGroupFeed.rowActions.push({
                            'label': 'Bookmark',
                            'name': 'subscribe'
                        });
                    } else {
                        if(userSubscriptions.includes(collaborationGroupFeed.Id)){
                            collaborationGroupFeed.rowActions.push({
                                'label': 'Remove Bookmark',
                                'name': 'unsubscribe'
                            });
                        }else{
                            collaborationGroupFeed.rowActions.push({
                                'label': 'Bookmark',
                                'name': 'subscribe'
                            });
                        }
                    }
                    
                    collaborationGroupFeedList.push(collaborationGroupFeed);
                });
                
                var collabListSorted = [];
                if(filter == 'default'){
                    collaborationGroupFeedList.sort(function(a, b){
                        return a.pinnedOrder-b.pinnedOrder
                    });
                }
                
                collabListSorted = collaborationGroupFeedList;
                
                component.set('v.collabList', collabListSorted);
                component.set("v.collabFeedList", collabListSorted);
                helper.setColumns(component, event, helper);
                helper.preparePagination(component, collabListSorted);
                helper.setIntevalCheckNew(component, event, helper);
            } else if (state === "ERROR") {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);  
    },
    
    setColumns: function(component, event, helper) {
        var device = $A.get("$Browser.formFactor");
        if (device == 'DESKTOP') {
            component.set('v.feedListCols', [
                { label: '', "fixedWidth": 32, fieldName: 'forIcon', hideDefaultActions: true,
                 type: 'Text',
                 cellAttributes: {
                     iconName: {
                         fieldName: "icn2"
                     }
                 }
                },            
                { label: 'Post', sortable: true,  fieldName: 'Url', type: 'url',
                 typeAttributes: {label: { fieldName: 'Body' }, target: '_parent'}, 
                 cellAttributes: {
                     iconName: {
                         fieldName: "icn"
                     }
                 }
                },
                { label: 'Category', "fixedWidth": 300, fieldName: 'collabName', 
                 type: 'Text', sortable: true,
                 cellAttributes: { alignment: 'left' }
                },
                { label: 'Last Post', "fixedWidth": 120, fieldName: 'timeStampPost', 
                 type: 'dateTime', sortable: true,
                 cellAttributes: { alignment: 'center' }
                },
                { label: 'Likes', "fixedWidth": 120, fieldName: 'LikeCount', type: 'number', 
                 sortable: true, cellAttributes: { alignment: 'center' } 
                },
                { label: 'Replies', "fixedWidth": 100, fieldName: 'CommentCount', 
                 type: 'number', sortable: true,
                 cellAttributes: { alignment: 'center' }
                },
                { type: 'action',
                 typeAttributes: { 
                     rowActions: { fieldName: "rowActions" }}
                }
            ]);
        } else {
            component.set('v.feedListCols', [
                { label: '', "fixedWidth": 32, fieldName: 'forIcon', hideDefaultActions: true,
                 type: 'Text',
                 cellAttributes: {
                     iconName: {
                         fieldName: "icn2"
                     }
                 }
                },            
                { label: 'Post', sortable: true,  fieldName: 'Url', type: 'url',
                 typeAttributes: {label: { fieldName: 'Body' }, target: '_parent'}, 
                 cellAttributes: {
                     iconName: {
                         fieldName: "icn"
                     }
                 }
                },
                { type: 'action',
                 typeAttributes: { 
                     rowActions: { fieldName: "rowActions" }}
                }
            ]);
        }
    },
    
    pinPost : function(component, event, helper, holdFeedItems){
        var getPinId = component.get("v.isPinId");
        var action = component.get("c.saveShadowObject");
        var urlString = window.location.href;
        var parts = urlString.substring(urlString.indexOf('/group') + 1);
        var idUrl = parts.slice(6,24);
        action.setParams({
            'feedId' : getPinId,
            'pinnedPost' : true
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                helper.initiate(component, event, helper, idUrl);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    getFeedName : function(component,event,helper){
        var recordId = component.get("v.feedRecId");
        var action = component.get("c.getFeedNameData");
        action.setParams({
            'recordId' : recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            { 
                var feedItem = response.getReturnValue(); 
                component.set("v.subject",feedItem);
            }
            ;
        });
        $A.enqueueAction(action);
    },
    
    getName : function(component, event, helper,idUrl){
        var isThread = component.get("v.threadFilter");
        if($A.util.isUndefinedOrNull(isThread)){
            isThread = 'default';
        }
        var action = component.get("c.getCollaborationData");
        action.setParams({
            'collabId' : idUrl
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var colName = response.getReturnValue();
                component.set("v.itemsFeedParent",response.getReturnValue());
            }else{
                if(isThread =='today'){
                    component.set("v.itemsFeedParent","Today");
                }
                if (isThread =='sincelastvisit'){
                    component.set("v.itemsFeedParent","Since Last Visit");
                }
                if (isThread =='trending'){
                    component.set("v.itemsFeedParent","Trending");
                }
            }
        });
        
        
        $A.enqueueAction(action);
    },
    unpinPost : function(component, event, helper, holdFeedItems){
        var getPinId = component.get("v.isPinId");
        var action = component.get("c.saveShadowObject");
        var urlString = window.location.href;
        var parts = urlString.substring(urlString.indexOf('/group') + 1);
        var idUrl = parts.slice(6,24);
        action.setParams({
            'feedId' : getPinId,
            'pinnedPost' : false
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                helper.initiate(component, event, helper, idUrl);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    getUser : function(component, event, helper){
        
        var action2 = component.get("c.fetchUser");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
            
            var profileId = component.get("v.userInfo.ProfileId");
            var DiscussionForumModerator = $A.get("$Label.c.Discussion_Forum_Moderator_Profile_ID");
            var SystemAdmin = $A.get("$Label.c.System_Admin_Profile_Id");
            if (profileId.includes(DiscussionForumModerator) || profileId.includes(SystemAdmin)){
                component.set("v.isAdminOnly",true);
            }
        });
        $A.enqueueAction(action2);
        
    },    
    helperMethodPagination :function(component, event, helper,pageNumber){
        var pageSize = component.get("v.pageSize");//Number Of Row Per Page
        var totalpage=Math.ceil(component.get("v.collabList").length/pageSize);//Number Of Total Pages
        var paginationPageNumb=[];
        var cont=1;
        /*---Pagination Logic Start--*/
        if(pageNumber<7){
            for(var i=1; i<= totalpage; i++){
                paginationPageNumb.push(i);
                if(cont>7){
                    paginationPageNumb.push('...');
                    paginationPageNumb.push(totalpage);
                    break;
                }
                cont++;
            }
        }
        else{
            paginationPageNumb.push('1');
            paginationPageNumb.push('2');
            paginationPageNumb.push('...');
            pageNumber=(pageNumber<=0)?2:((pageNumber>=totalpage)? (totalpage-3) :(( pageNumber==totalpage-1 )?(pageNumber = pageNumber-2):( (pageNumber==totalpage-2 ) ? (pageNumber-1):pageNumber ))) ;
            for(var i=pageNumber-2; i<=pageNumber+2 ; i++){
                paginationPageNumb.push(i);
            }
            paginationPageNumb.push('...');
            paginationPageNumb.push(totalpage);
        }
        component.set('v.paginationPageNumb', null);
        component.set('v.paginationPageNumb', paginationPageNumb);
    },
    copyTextHelper : function(component,event,text) {
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        // store target button label value
        var orignalLabel = event.getSource().get("v.label");
        // change button icon after copy text
        event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'Link Copied');
        component.set('v.isInputFieldActive',true);
        
        // set timeout to reset icon and label value after 700 milliseconds 
        /*
        setTimeout(function(){ 
            event.getSource().set("v.iconName" , 'utility:copy_to_clipboard'); 
            event.getSource().set("v.label" , orignalLabel);
        }, 2000);
        */
    },
    lockHelper : function(component, event, helper, holdFeedItems, recId, feedCommentMap,commURL){

        var isThread = component.get("v.threadFilter");
        if($A.util.isUndefinedOrNull(isThread)){
            isThread = 'default';
        }
        var action = component.get("c.getListCollaborationFeed");
        var holdfeedCommentMap = JSON.parse(JSON.stringify(feedCommentMap)); //parse map that holds latest comment's time
        var feedUrl = $A.get("$Label.c.feedItemsUrl");
        action.setParams({
            'collabId' : recId,
            'isThread': isThread
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                var collabListHolder = response.getReturnValue();
                collabListHolder.forEach(function(collab){
                    if(collab.Type == 'AdvancedTextPost' && $A.util.isUndefinedOrNull(collab.Body) ){
                        collab.Body = collab.CreatedBy.Name  +' Shared a Post';
                    }
                    if(collab.Type == 'QuestionPost'){
                        collab.Body = collab.Title;
                    }else if(collab.Type == 'PollPost'){
                        collab.Body = collab.Body;
                    }
                    holdFeedItems.forEach(function(feed){
                        if(collab.Id == feed.Id){
                            if(feed.IsClosed){
                                collab.IsClosed = true;
                            }
                        }
                        
                    });
                    
                    
                    collab.Url= commURL + 'feed/' + collab.Id;
                    console.log();
                });
                
                helper.isPinnedRecord(component, event, helper, collabListHolder, holdfeedCommentMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    isPinnedRecord: function(component, event, helper, collabListHolder, holdfeedCommentMap){   
           
        var isThread = component.get("v.threadFilter");
        if($A.util.isUndefinedOrNull(isThread)){
            isThread = 'default';
        }
        
        var feedItemHolderList = component.get("v.feedItemHolderList");
        var countPinned = 0;
        
        feedItemHolderList.forEach(function(FeedItemHolder){                       
            FeedItemHolder.pinnedOrder = ++countPinned;           
        });
        var getFeedItemHolderLen = feedItemHolderList.length;
        collabListHolder.forEach(function(collab){ 
            
            feedItemHolderList.forEach(function(FeedItemHolder){
                
                if(collab.Id == FeedItemHolder.FeedItem_Id__c){
                    if(FeedItemHolder.Is_Pinned__c){
                        collab.isPinned = true;
                        collab.pinnedOrder = FeedItemHolder.pinnedOrder;
                    } else {
                        collab.isPinned = false;
                    }
                }
                
            });
            if(!collab.pinnedOrder){
                collab.pinnedOrder = ++getFeedItemHolderLen;
            }
            
            
        });
        if(isThread == 'default'){
            collabListHolder.sort(function(a, b){
                return a.pinnedOrder-b.pinnedOrder
            });
        }
        var actions = [];
        var device = $A.get("$Browser.formFactor");
        if (device == 'DESKTOP') {
            component.set('v.feedListCols', [
                { label: '', "fixedWidth": 32, fieldName: 'forIcon', hideDefaultActions: true,
                 type: 'Text',
                 cellAttributes: {
                     iconName: {
                         fieldName: "icn2"
                     }
                 }
                },            
                { label: 'Post', sortable: true,  fieldName: 'Url', type: 'url',
                 typeAttributes: {label: { fieldName: 'Body' }, target: '_parent'}, 
                 cellAttributes: {
                     iconName: {
                         fieldName: "icn"
                     }
                 }
                },
                { label: 'Last Post', "fixedWidth": 120, fieldName: 'timeStampPost', 
                 type: 'dateTime', sortable: true,
                 cellAttributes: { alignment: 'center' }
                },
                { label: 'Likes', "fixedWidth": 120, fieldName: 'LikeCount', type: 'number', 
                 sortable: true, cellAttributes: { alignment: 'center' } 
                },
                { label: 'Replies', "fixedWidth": 100, fieldName: 'CommentCount', 
                 type: 'number', sortable: true,
                 cellAttributes: { alignment: 'center' }
                },
                { type: 'action',
                 typeAttributes: { 
                     rowActions: { fieldName: "rowActions" }}
                }
            ]);
        } else {
            component.set('v.feedListCols', [
                { label: '', "fixedWidth": 32, fieldName: 'forIcon', hideDefaultActions: true,
                 type: 'Text',
                 cellAttributes: {
                     iconName: {
                         fieldName: "icn2"
                     }
                 }
                },            
                { label: 'Post', sortable: true,  fieldName: 'Url', type: 'url',
                 typeAttributes: {label: { fieldName: 'Body' }, target: '_parent'}, 
                 cellAttributes: {
                     iconName: {
                         fieldName: "icn"
                     }
                 }
                },
                { type: 'action',
                 typeAttributes: { 
                     rowActions: { fieldName: "rowActions" }}
                }
            ]);
        }
        
        var isAdminComp = component.get("v.isAdminOnly");
        var userSubscribe = component.get("v.subscriptions");
        var isLock = component.get("v.lockfeedAttribute");
        collabListHolder.forEach(function(itm){
            itm.hasCustomFeedItemHolder = false;
            itm.isLocked = false;
            itm.icn = '';
            itm.icn2 = '';
            itm.rowActions = [];
            itm.rowActions.push({
                'label': 'Forward',
                'name': 'forward'
            });
            itm.rowActions.push({
                'label': 'Get Link',
                'name': 'getLink'
            });
            if(isThread == 'default'){
                if(itm.isPinned){
                    itm.icn = 'utility:pinned';
                }
            }
            feedItemHolderList.forEach(function(FeedItemHolder){
                if(itm.Id == FeedItemHolder.FeedItem_Id__c){
                    itm.hasCustomFeedItemHolder = true;
                    itm.isLocked = FeedItemHolder.Is_Lock__c;
                }
            });
            if(isAdminComp) {
                if(isThread == 'default'){
                    if(itm.isPinned){
                        itm.rowActions.push({
                            'label': 'Unpin',
                            'name': 'unpin'
                        });
                    } else {
                        itm.rowActions.push({
                            'label': 'Pin',
                            'name': 'pin'
                        });
                    }
                }
                itm.rowActions.push({
                    'label': 'Delete',
                    'name': 'delete'
                });
                if (itm.isLocked) {
                    itm.rowActions.push({
                        'label': 'Unlock Thread',
                        'name': 'unlock'
                    });
                }
                
                if ((itm.hasCustomFeedItemHolder && !itm.isLocked) || !itm.hasCustomFeedItemHolder) {
                    itm.rowActions.push({
                        'label': 'Lock Thread',
                        'name': 'lock'
                    });
                }
            }
            
            if (itm.isLocked) {
                itm.icn2 = 'utility:lock';
            }
            
            //-----------------------------------
            //-----------------------------------
            
            if(userSubscribe == null){
                itm.rowActions.push({
                    'label': 'Bookmark',
                    'name': 'subscribe'
                });
            }else {
                if(userSubscribe.includes(itm.Id)){
                    itm.rowActions.push({
                        'label': 'Remove Bookmark',
                        'name': 'unsubscribe'
                    });
                }else{
                    itm.rowActions.push({
                        'label': 'Bookmark',
                        'name': 'subscribe'
                    });
                }
            }
            
        });
        helper.checkForTimeStamp(component ,event, helper,  holdfeedCommentMap, collabListHolder);
    },
    
    checkForTimeStamp: function(component, event, helper, holdfeedCommentMap, collabListHolder){        
        var pageSize = component.get("v.pageSize");
        var collabListSorted = [];
        var paginationList = [];
        var tempPost = '';
        var tempType = '';
        var tempValue = '';
        var lastValue = 0;
        
        
        collabListHolder.forEach(function(collab){
            console.log('***********************************');
            if(collab.Body !== null && collab.Body!== '' && collab.Body!== undefined){
                var str = collab.Body.toString().replace(/(<([^>]+)>)/ig, '');
                collab.Body = str;
                //console.log('collab.Body===>'+collab.Body);
            }
            
            if(holdfeedCommentMap[collab.Id]){  
                
                collab.LastPostNum = 0;
                tempPost = String(holdfeedCommentMap[collab.Id]);
                tempType = tempPost.substr(tempPost.length - 1, tempPost.length);
                tempValue = tempPost.substr(0, tempPost.length - 1);
                switch (tempType) {
                        
                    case 's' :
                        lastValue = parseInt(tempValue);
                        break;
                    case 'm' :
                        lastValue = parseInt(tempValue) * 60;
                        break;
                    case 'h' :
                        lastValue = parseInt(tempValue) * 60 * 60;
                        break;
                    case 'd' :
                        lastValue = parseInt(tempValue) * 60 * 60 * 24;
                        break;
                }
                collab.timeStampPost = holdfeedCommentMap[collab.Id];
                collab.forIcon = '';
            }
            collab.LastPostNum = lastValue;
        });
        collabListHolder.forEach(function(collabHolder) {
            
            if (collabHolder.isPinned) {
                collabListSorted.push(collabHolder);
            }
            else {
                collabListSorted.push(collabHolder);
            }
            
        });
        
        component.set('v.collabList', collabListSorted);
        component.set("v.totalSize", component.get("v.collabList").length);
        
        component.set("v.start",0);
        component.set("v.end",pageSize-1);
        
        
        if(collabListHolder.length < pageSize){
            paginationList=collabListSorted;
        }
        else{
            for(var i=0; i< pageSize; i++){
                paginationList.push(collabListSorted[i]);
            }
        }                
		component.set("v.collabFeedList" ,collabListHolder);
        helper.preparePagination(component,collabListHolder);
        //helper.helperMethodPagination(component, event, helper,'1');
        helper.setIntevalCheck(component, event, helper);
        
        
    },
    
    sortData : function(component,fieldName,sortDirection,varType){

        var isThread = component.get("v.threadFilter");
        if($A.util.isUndefinedOrNull(isThread)){
            isThread = 'default';
        }
        
        var checkPinned = component.get("v.collabFeedList");
        var data = [];
        var pinnedData = [];
        
        //function to return the value stored in the field
        checkPinned.forEach(function(recToSort) {
            if(isThread == 'default'){
                if(!recToSort.isPinned){
                    data.push(recToSort);
                } else {
                    pinnedData.push(recToSort);
                }
            }else {
                data.push(recToSort);
            }
        });
        var key = function(a) {
            if(fieldName == 'timeStampPost')  {
                fieldName = 'LastPostNum';
                
                return a[fieldName];
            }
            else if (fieldName == 'Url') {
                fieldName = 'Body';
            }
                else {
                    return a[fieldName];
                }  
        }
        var reverse = sortDirection == 'asc' ? 1: -1;
        let parser = (v) => v;
        
        // to handel number/currency type fields 
        if(fieldName == 'LikeCount'  || fieldName == 'CommentCount' || fieldName == 'timeStampPost'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        
        pinnedData.push.apply(pinnedData, data);
        //set sorted data to accountData attribute
        component.set("v.collabFeedList",pinnedData);
        console.log("data>>" + data);

        let countTotalPage = Math.ceil(data.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        // component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
        
    },
    
    closeAll: function(component, event, helper){
        component.set("v.isOpen", false);
        component.set("v.newPostOpen", false);
        component.set("v.isDelete", false);
        component.set("v.isOpenEdit", false);
        component.set("v.isGetLink", false);
        component.set('v.isInputFieldActive',false);
        component.set("v.isSendMessage", false);
        component.set("v.isManageUser", false);
        component.set("v.isDelete", false);
    },
    
    sendHelper: function(component, getEmail, eSubject,getSubject, getbody, getUserName) {
        // call the server side controller method 	
        var action = component.get("c.sendMailMethod");
        var userName = component.get("v.userInfo.Name");
        action.setParams({
            'mMail': getEmail,
            'mSubject': getSubject,
            'mBodyLink': getbody,
            'userName' : getUserName,
            'eSubject' : eSubject
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if state of server response is comes "SUCCESS",
                // display the success message box by set mailStatus attribute to true
                component.set("v.mailStatus", true);
            }
            
        });
        $A.enqueueAction(action);
    },
    delRecord : function(component,event,helper){
        var recordID = component.get("v.deleteGroupFeed");
        var action = component.get("c.deleteCollaborationGroupFeed");
        action.setParams({recordId : recordID });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var retResponse = component.set("v.collabfeedListDelete",response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Successfully Deleted.",
                    "type": "success"
                });
                toastEvent.fire();
                location.reload();
            }else if (state === "ERROR") {
                alert('ERROR');
            }
        });
        component.set("v.isDelete", false);
        $A.enqueueAction(action); 
        
    },
    
    setIntevalCheck : function(component, event, helper){
        
        var urlString = window.location.href;
        var parts = urlString.substring(urlString.indexOf('/group') + 1);
        var idUrl = parts.slice(6,24);
        //https://fullsandb-c4community.cs22.force.com/technician/s/
        
        
        var totalSize = component.get("v.totalSize");
        
        setInterval(function(){
            var action = component.get("c.getFeedItem1");
            action.setParams({
                'collabId' : idUrl,
                'currentList' : component.get("v.collabList")
            });
            action.setCallback(this, function(response){
                var state = response.getState();            
                if (component.isValid() && state === "SUCCESS"){
                    var holdFeedItems = response.getReturnValue();
                    
                    if(holdFeedItems.length != 0){ 
                        helper.initiate(component, event, helper, idUrl);  
                        $A.get('e.force:refreshView').fire();
                    }
                    
                    
                }
            });
            $A.enqueueAction(action);
            
        }, 3000);
        
        
        
    },
    
    subscribeToPost : function(component,event,helper,recordId){
        var action = component.get("c.updateUserSubscriptionPost");
        var usrId = component.get("v.userInfo.Id");
        action.setParams({
            'usrId': usrId,
            'recordId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                helper.initiate(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "You have added a bookmark for this post.",
                    "type": "success",
                    duration:5000
                });
                toastEvent.fire();
                location.reload();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    unsubscribeToPost : function(component,event,helper,recordId){
        var action = component.get("c.removeUserSubscriptionPost");
        var usrId = component.get("v.userInfo.Id");
        action.setParams({
            'usrId': usrId,
            'recordId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                helper.initiate(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "You have removed a bookmark for this post.",
                    "type": "success",
                    duration:5000
                });
                toastEvent.fire();
                location.reload();
            }
            
        });
        $A.enqueueAction(action);
        
    },
    getSubscriptions : function(component, event, helper){
        
        var action2 = component.get("c.getSubscriptions");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.subscriptions", storeResponse);
            }
        });
        $A.enqueueAction(action2);
        
    }, 
    preparePagination: function (component, collabFeedList) {
        let countTotalPage = Math.ceil(collabFeedList.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        var urlString = window.location.href;
        var url = new URL(urlString);
        var pageNumberInURL = url.searchParams.get("page");
        if($A.util.isUndefinedOrNull(pageNumberInURL)){
            component.set("v.currentPageNumber", 1);
        } else {
            var pageNumber =  parseInt(pageNumberInURL);
            if (totalPage >= pageNumber) {
                component.set("v.currentPageNumber", pageNumber);
            } else {
                component.set("v.currentPageNumber", 1);
            }
        }
        var itm = component.get("v.itemsFeedParent");
        this.setPageDataAsPerPagination(component,itm);
    },
    
    setPageDataAsPerPagination: function(component,item) {
        var isThread = component.get("v.threadFilter");
        if(isThread =='Today' || isThread =='today'){
            component.set("v.itemsFeedParent","Today");
        }
        if (isThread =='sincelastvisit' || isThread =='SinceLastVisit'){
            component.set("v.itemsFeedParent","Since Last Visit");
        }
        if (isThread =='Trending' || isThread =='trending'){
            component.set("v.itemsFeedParent","Trending");
        }
        
        
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let collabFeedList = component.get('v.collabFeedList');

        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (collabFeedList[x]) {
                data.push(collabFeedList[x]);
            }
        }
        
        var urlString = window.location.href;
        var url = new URL(urlString);
        var threadFilter = url.searchParams.get("view");

        if($A.util.isUndefinedOrNull(threadFilter)){
            //window.history.pushState({page: "page"}, null, "?page=" + pageNumber);
        } else {
            //window.history.pushState({page: "page"}, null, "?view=" +threadFilter+ "&page=" + pageNumber);
        }
        //window.history.pushState({page: "page"}, null, itm+"?page=" + pageNumber);
        component.set("v.filteredData", data);
        
        component.set("v.isPageNumbersReady", false);
        let totalPage = component.get("v.totalPages");
        let pageNumbers = [];
        var device = $A.get("$Browser.formFactor");
        if ((pageNumber - 2) >= 1 && device == 'DESKTOP') {
            pageNumbers.push(pageNumber - 2);
        }
        if ((pageNumber - 1) >= 1) {
            pageNumbers.push(pageNumber - 1);
        }
        pageNumbers.push(pageNumber);
        if ((pageNumber + 1) <= totalPage) {
            pageNumbers.push(pageNumber + 1);
        }
        if ((pageNumber + 2) <= totalPage && device == 'DESKTOP') {
            pageNumbers.push(pageNumber + 2);
        }
        component.set("v.pageNumbers", pageNumbers);
        component.set("v.isPageNumbersReady", true);
    },

    lockThread: function(component,event,helper,recordId){
        var action = component.get("c.lockFeedItem");
        var lockfeed = "true";
        action.setParams({
            'recordId': recordId,
            'lockfeed': lockfeed
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                helper.initiate(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": " ",
                    "message": "You have Locked a thread.",
                    "type": "success",
                    duration:5000
                });
                toastEvent.fire();
                location.reload();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    unlockThread: function(component,event,helper,recordId){
        var action = component.get("c.lockFeedItem");
        var lockfeed = "false";
        action.setParams({
            'recordId': recordId,
            'lockfeed': lockfeed
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                helper.initiate(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": " ",
                    "message": "You have UnLocked a category.",
                    "type": "success",
                    duration:5000
                });
                toastEvent.fire();
                location.reload();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    setFilterAndPageNumberInURL: function(component, event, helper, newPageNumber) {
        var urlString = window.location.href;
        var url = new URL(urlString);
        var viewInURL = url.searchParams.get("view");
        var pageNumberInURL = url.searchParams.get("page");

        if(!$A.util.isUndefinedOrNull(viewInURL)){
            window.history.pushState({page: "page"}, null, "?view=" + viewInURL + "&page=" + newPageNumber);
        } else {
            window.history.pushState({page: "page"}, null, "?page=" + newPageNumber);
        }
    }
})