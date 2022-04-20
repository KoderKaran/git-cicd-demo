({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000, //Chunk Max size 750Kb 
    
    initiate : function(component, event, helper) {
        
        var urlString = window.location.href;
        var urlSplitted = urlString.split("discussions");
        var commURL = urlSplitted[0];
        
        var collabId;
        var userID = component.get("v.userInfo.Id");
        var action = component.get("c.getCollaborations");
        var urlLabel = $A.get("$Label.c.collabGroupURL");
        var holdCollabItems = [];
        
        
        action.setCallback(this, function(data){
            var state = data.getState();
            
            if(state === 'SUCCESS'){
                var publicList = [];
                
                holdCollabItems = data.getReturnValue();
                var collaborationsList = data.getReturnValue();
                var tempPost = '';
                var tempType = '';
                var tempValue = '';
                //var lastValue = 0;
                
                var holdCollabCommentMap = JSON.parse(JSON.stringify(collaborationsList.collabItemMap));
                collaborationsList.collabList.forEach(function(Collaboration){
                    var lastValue = 0;
                    
                    Collaboration.AttachmentId = collaborationsList.attachmentList[Collaboration.Id];
                    Collaboration.profilePic = true;
                    collabId = Collaboration.Id;
                    
                    if(Collaboration.CollaborationType == "Public" || Collaboration.CollaborationType == "Private"){
                        if(!$A.util.isUndefinedOrNull(Collaboration.Feeds)){
                            Collaboration.FeedCount = Collaboration.Feeds.length;
                            var totalComment = 0;
                            Collaboration.Feeds.forEach(function(CollaborationFeed){
                                if(CollaborationFeed.ParentId == Collaboration.Id){
                                    if(holdCollabCommentMap[Collaboration.Id]){
                                        Collaboration.LastPostNum = 0;
                                        tempPost = String(holdCollabCommentMap[Collaboration.Id]);
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
                                        Collaboration.lastPostTimeStamp = holdCollabCommentMap[Collaboration.Id];
                                        Collaboration.LastPostNum = lastValue;
                                    }
                                }
                                totalComment += CollaborationFeed.CommentCount;
                            });
                            Collaboration.CommentCount = totalComment;
                            Collaboration.Url = commURL + 'group/' + Collaboration.Id;
                            
                            
                        }else{
                            Collaboration.FeedCount = 0;
                            Collaboration.CommentCount = 0;
                        }
                        //alert(Collaboration.FeedCount);
                        publicList[publicList.length] = Collaboration;
                        
                    }
                    Collaboration.Url= commURL + 'group/' + Collaboration.Id;
                    component.set("v.threadFiltercollabId", Collaboration.Id);
                    Collaboration.LastPostNumMobile = lastValue;
                });
                
                // row actions
                
                var isAdminComp = component.get("v.isAdminOnly");
                var userSubscribe = component.get("v.userInfo.subscribeGroup__c");
                var isCategoryLock = component.get("v.lockCategories");
                try{
                    collaborationsList.collabList.forEach(function(itm){
                        itm.isLocked = false;
                        itm.icn = '';
                        itm.rowActions = [];
                        
                        collaborationsList.customCollabList.forEach(function(custom){
                            if(custom.CollaborationGroupId__c == itm.Id){
                                itm.isLocked = custom.is_Lock__c;
                            }
                        }); 
                        
                        if(isAdminComp) {
                            itm.rowActions.push({
                                'label': 'Edit',
                                'name': 'edit'
                            });
                            itm.rowActions.push({
                                'label': 'Delete',
                                'name': 'delete'
                            });
                            itm.rowActions.push({
                                'label': 'Manage User',
                                'name': 'manage'
                            });
                            if (itm.isLocked) {
                                itm.rowActions.push({
                                    'label': 'Unlock Category',
                                    'name': 'unlock'
                                });
                            } else {
                                itm.rowActions.push({
                                    'label': 'Lock Category',
                                    'name': 'lock'
                                });
                            }
                        }
                        
                        if (itm.isLocked) {
                            itm.icn2 = 'utility:lock';
                        }
                        
                        if(userSubscribe == null){
                            itm.rowActions.push({
                                'label': 'Subscribe',
                                'name': 'subscribe'
                            });
                        }else{
                            if(userSubscribe.includes(itm.Id)){
                                itm.rowActions.push({
                                    'label': 'Unsubscribe',
                                    'name': 'unsubscribe'
                                });
                            }else{
                                itm.rowActions.push({
                                    'label': 'Subscribe',
                                    'name': 'subscribe'
                                });
                            }
                        }
                        
                        
                        
                    }); 
                } catch(err){
                    console.log('!@#Error' + err);
                }                         
                component.set('v.collabListPublic',publicList);
                this.sortDataMobile(component, 'LastPostNumMobile', 'asc');
                
                var device = $A.get("$Browser.formFactor");
                if (device == 'DESKTOP') {
                    component.set('v.collabListCols', [
                        { label: '', "fixedWidth": 30, fieldName: 'forIcon', hideDefaultActions: true,
                         type: 'dateTime',
                         cellAttributes: {
                             iconName: {
                                 fieldName: "icn2"
                             }
                         }
                        }, 
                        { label: 'Category', sortable: true, fieldName: 'Url', type: 'url', 
                         typeAttributes: {label: { fieldName: 'Name' }, target: '_parent'},
                         cellAttributes: {
                             iconName: {
                                 fieldName: "icn"
                             }
                         }
                        },
                        { label: 'Status', "fixedWidth": 120, fieldName: 'CollaborationType', type: 'text', sortable: true, 
                         cellAttributes: { alignment: 'left' } },
                        { label: 'Last Post', "fixedWidth": 120, fieldName: 'lastPostTimeStamp', type: 'dateTime', sortable: true, 
                         cellAttributes: { alignment: 'left' } },
                        { label: 'Topics', "fixedWidth": 100, fieldName: 'FeedCount', type: 'number', sortable: true,
                         cellAttributes: { alignment: 'left' }
                        },
                        { label: 'Posts', "fixedWidth": 100, fieldName: 'CommentCount', type: 'number', sortable: true, 
                         cellAttributes: { alignment: 'left' } },
                        { type: 'action',
                         typeAttributes: {
                             rowActions: { fieldName: "rowActions" }
                         }
                        }
                    ]);
                } else {
                    component.set('v.collabListCols', [
                        { label: '', "fixedWidth": 30, fieldName: 'forIcon', hideDefaultActions: true,
                         type: 'dateTime',
                         cellAttributes: {
                             iconName: {
                                 fieldName: "icn2"
                             }
                         }
                        }, 
                        { label: 'Category', "fixedWidth": '50%', sortable: true, fieldName: 'Url', type: 'url', 
                         typeAttributes: {label: { fieldName: 'Name' }, target: '_parent'},
                         cellAttributes: {
                             iconName: {
                                 fieldName: "icn"
                             }
                         }
                        },
                        { type: 'action',
                         typeAttributes: {
                             rowActions: { fieldName: "rowActions" }
                         }
                        }
                    ]);
                }
                helper.preparePagination(component, publicList);
            }else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": "Error.",
                    "type": "Warning"
                });
                toastEvent.fire();
            }
        });     
        
        $A.enqueueAction(action);
    },
    
    sortDataMobile: function (component, fieldName, sortDirection) {
        var collabList = component.get("v.collabListPublic");
        component.set("v.collabListMobile", collabList);
        
        var collabListNew = component.get("v.collabListMobile");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        collabListNew.sort(this.sortByMobile(fieldName, reverse));
        
        var collabListMobile = [];
        collabListNew.forEach(function(collabMobile) {
            if (collabMobile.CollaborationType == 'Private' && collabMobile.LastPostNumMobile != 0) {
                collabListMobile.push(collabMobile);
            }
        });
        collabListNew.forEach(function(collabMobile) {
            if (collabMobile.CollaborationType == 'Private' && collabMobile.LastPostNumMobile == 0) {
                collabListMobile.push(collabMobile);
            }
        });
        collabListNew.forEach(function(collabMobile) {
            if (collabMobile.CollaborationType == 'Public' && collabMobile.LastPostNumMobile != 0) {
                collabListMobile.push(collabMobile);
            }
        });
        collabListNew.forEach(function(collabMobile) {
            if (collabMobile.CollaborationType == 'Public' && collabMobile.LastPostNumMobile == 0) {
                collabListMobile.push(collabMobile);
            }
        });
        component.set("v.collabListMobile", collabListMobile);
    },
    
    sortByMobile: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    sortData : function(component,fieldName,sortDirection,varType){
        var data = component.get("v.collabListPublic");
        //function to return the value stored in the field
        var key = function(a) {
            if(fieldName == 'lastPostTimeStamp')  {
                fieldName = 'LastPostNum';
                return a[fieldName];
            } else if(fieldName == '')  {
                fieldName = 'CollaborationType';
                return a[fieldName];
            } else if (fieldName == 'Url') {
                fieldName = 'Name';
            } else {
                return a[fieldName];
            }  
        }
        var reverse = sortDirection == 'asc' ? 1: -1;
        let parser = (v) => v;
        
        // to handel number/currency type fields 
        if(fieldName == 'FeedCount'  || fieldName == 'CommentCount' || fieldName == 'lastPostTimeStamp'){ 
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
        //set sorted data to accountData attribute
        // component.set("v.collabListPublic",data);
        let countTotalPage = Math.ceil(data.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        this.setPageDataAsPerPagination(component);
    },
    
    setLastPost:function(component, event, helper, collabItemMap){
        var action = component.get("c.getCollaborations");
        var holdCollabCommentMap = JSON.parse(JSON.stringify(collabItemMap)); //parse map that holds latest comment's time
        alert(' '+ holdCollabCommentMap);
        
        
    },
    
    //added by Ren
    getFeedItemPerCollab : function(component, event, helper) {
        var recordID = component.get("v.recordId1");
        var action = component.get("c.getFeedItem");
        
        action.setParams({recordId : recordID });
        action.setCallback(this, function(response) {
            var state = response.getState();        
            if(state === 'SUCCESS'){
                var recordDetails = response.getReturnValue();
                
                console.log ('returnvalue' + recordDetails.IsClosed);
                console.log ('recordID' + recordID);
            }
            
            
        });
        $A.enqueueAction(action); 
        
    },
    
    delRecord : function(component,event,helper){
        var recordID = component.get("v.colabRecord");
        var action = component.get("c.deleteCollaborationGroup");
        action.setParams({recordId : recordID });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                //var retResponse = component.set("v.collabListPublic",response.getReturnValue());
                helper.initiate(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Successfully Deleted.",
                    "type": "success"
                });
                toastEvent.fire();
                component.set("v.isDelete", false);
                var recordID = component.get("v.colabRecord");
                helper.getCurrentMember(component, event, helper,recordID);
                
            }else if (state === "ERROR") {
                alert('ERROR');
            }
        });
        //location.reload();
        $A.enqueueAction(action); 
        
    }, 
    UsertoGroup : function(component,event,helper){
        var recordID =event.getSource().get("v.value");
        var colabRecord = component.get("v.colabRecord");
        var action = component.get("c.addUsertoGroup");
        
        action.setParams({"userId" : recordID, "groupId" :colabRecord});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var recordDetails = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "User Added to the Group.",
                    "type": "success"
                });
                toastEvent.fire();
                var recordID = component.get("v.colabRecord");
                helper.getCurrentMember(component, event, helper,recordID);
            }else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": "Owner or User is inactive.",
                    "type": "Warning"
                });
                toastEvent.fire();
                
            }
        });
        
        component.set("v.isManageUser", false);
        $A.enqueueAction(action); 
        
    }, 
    removeUsersToGroup : function(component,event,helper){
        var recordID =event.getSource().get("v.value");
        var colabRecord = component.get("v.colabRecord");
        var action = component.get("c.removeUserAccessToGroup");
        
        action.setParams({"userId" : recordID, "groupId" :colabRecord});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var recordDetails = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "User Removed to the Group.",
                    "type": "success"
                });
                toastEvent.fire();
                var recordID = component.get("v.colabRecord");
                helper.getCurrentMember(component, event, helper,recordID);
                
            }else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": "Owner or User is inactive.",
                    "type": "Warning"
                });
                toastEvent.fire();           
            }
        });
        component.set("v.isManageUser", false);
        $A.enqueueAction(action); 
        
    }, 
    getIsClosed : function(component,event,helper){
        var recordID = component.get("v.geFeedItemId");
        var action = component.get("c.getFeedItem");
        
        action.setParams({recordId : recordID });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var recordDetails = response.getReturnValue();
                if(recordDetails.IsClosed = true){
                    component.set("v.icon", 'utility:lock');
                    component.set("v.isUnlock", true);
                }else{
                    component.set("v.icon", 'utility:unlock');
                    component.set("v.isUnlock", false);
                }
                
                
            }else if (state === "ERROR") {
                alert('ERROR');
            }
        });
        $A.enqueueAction(action); 
        
    },
    editRecord : function(component,event,helper,recordId){
        var action = component.get("c.editCollaborationGroup");
        action.setParams({recordId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var recordDetails = response.getReturnValue();
                component.set("v.recordDetails",response.getReturnValue());
                component.set("v.name", recordDetails.CollaborationGroupName__c);
                component.set("v.description", recordDetails.CollaborationGroupDescription__c);
                component.set("v.collabType", recordDetails.CollaborationType__c);
                component.set("v.editIsAuto",recordDetails.IsAutomation__c );
                component.set("v.editIsLock",recordDetails.is_Lock__c );
            }else if (state === "ERROR") {
                alert('ERROR');
            }
        });
        //location.reload();
        //component.set("v.isDelete", false);
        $A.enqueueAction(action); 
        
    }, 
    saveEdit:function(component,event,helper){
        var recordId = component.get("v.colabRecord");
        var action = component.get("c.saveEdit");
        console.log('$$$ saveLock + '+ component.get("v.editIsLock"));
        action.setParams({
            "recordId" : recordId ,
            "saveName" : component.get("v.name") ,
            "saveDesc" : component.get("v.description"),
            "saveType" : component.get("v.collabType"),
            "saveAuto" : component.get("v.editIsAuto"),
            "saveLock" : component.get("v.editIsLock")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                //component.set("v.recordDetails",response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Successfully Edited.",
                    "type": "success"
                });
                toastEvent.fire();
                helper.initiate(component, event, helper);			
            }else if (state === "ERROR") {
                alert('ERROR');
            }
        });
        //location.reload();
        component.set("v.isOpenEdit", false);
        $A.enqueueAction(action); 
        
    },
    
    
    getCurrentMember : function(component, event, helper,recordId) {
        var action2 = component.get("c.ManageCollaborationGroupMember");
        action2.setParams({
            'recordId' : recordId,
        });
        action2.setCallback(this, function(response){
            
            var state = response.getState();
            if (state === "SUCCESS"){
                
                component.set("v.groupMembers",response.getReturnValue());
                var checkGM = component.get("v.groupMembers");
                
                helper.initiateUsers(component, event, helper,recordId);
                
            }
        });
        
        $A.enqueueAction(action2);
    },
    
    initiateUsers : function(component, event, helper,recordId) {
        //component.find("Id_spinner").set("v.class" , 'slds-show');
        var action = component.get("c.listUser");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword")
        })
        action.setCallback(this, function(response) {
            //component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var userList = response.getReturnValue();  //  List of all community User
                var checkGM = component.get("v.groupMembers"); // List of current group member
                
                if (userList.length == 0) {
                    component.set("v.Message", true);
                } else {
                    component.set("v.Message", false);
                }
                
                userList.forEach(function(user){
                    checkGM.forEach(function(groupmember){
                        if (user.Id == groupmember.MemberId){
                            user.isCurrentUser = true;
                        }
                    });
                });
                component.set("v.userNameList",userList);
                
            }else if (state === "ERROR") {
                alert('ERROR');
            }
        });
        
        $A.enqueueAction(action);
        
        
    },  
    SearchHelper: function(component, event) {
        // show spinner message
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var action = component.get("c.fetchuser");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword")
        });
        action.setCallback(this, function(response) {
            // hide spinner when response coming from server 
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                // if storeResponse size is 0 ,display no record found message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", true);
                } else {
                    component.set("v.Message", false);
                }
                
                // set numberOfRecord attribute value with length of return value from server
                component.set("v.TotalNumberOfRecord", storeResponse.length);
                
                // set searchResult list with return value from server.
                component.set("v.searchResult", storeResponse); 
                
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        var parentId = component.get("v.newCollabId");
        action.setParams({
            collabId: parentId,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "New Category Added.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    component.set("v.isOpenShadowObject", false);
                    component.set("v.showLoadingSpinner", false);
                    location.reload();
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    subscribeToGroup : function(component,event,helper,recordId){
        var action = component.get("c.updateUserSubscriptionGroup");
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
                    "message": "You have subscribed to a category.",
                    "type": "success",
                    duration:5000
                });
                toastEvent.fire();
                location.reload();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    unsubscribeToGroup : function(component,event,helper,recordId){
        var action = component.get("c.removeUserSubscriptionGroup");
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
                    "message": "You have unsubscribed to a category.",
                    "type": "success",
                    duration:5000
                });
                toastEvent.fire();
                location.reload();
            }
            
        });
        $A.enqueueAction(action);
        
    },
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        
        var device = $A.get("$Browser.formFactor");
        if (device == 'DESKTOP') {
            let collabListPublic = component.get('v.collabListPublic');
            let x = (pageNumber - 1) * pageSize;
            for (; x < (pageNumber) * pageSize; x++){
                if (collabListPublic[x]) {
                    data.push(collabListPublic[x]);
                }
            }
        } else {
            let collabListMobile = component.get('v.collabListMobile');
            let x = (pageNumber - 1) * pageSize;
            for (; x < (pageNumber) * pageSize; x++){
                if (collabListMobile[x]) {
                    data.push(collabListMobile[x]);
                }
            }
        }
        
        var urlString = window.location.href;
        var url = new URL(urlString);
        var threadFilter = url.searchParams.get("view");
        if($A.util.isUndefinedOrNull(threadFilter)){
            //window.history.pushState({page: "page"}, null, "discussions?page=" + pageNumber);
        } else {
            //window.history.pushState({page: "page"}, null, "discussions?view="+threadFilter+"&page=" + pageNumber);
        }
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
    preparePagination: function (component, collabListPublic) {
        console.log("collabListPublic>>" + collabListPublic);
        let countTotalPage = Math.ceil(collabListPublic.length/component.get("v.pageSize"));
        console.log("countTotalPage" + countTotalPage);
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
        
        this.setPageDataAsPerPagination(component);
    },
    
    lockCategory: function(component,event,helper,recordId){
        var action = component.get("c.lockCustomCollab");
        var lockcat = "true";
        action.setParams({
            'recordId': recordId,
            'lockcat': lockcat
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                helper.initiate(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": " ",
                    "message": "You have Locked a category.",
                    "type": "success",
                    duration:5000
                });
                toastEvent.fire();
                location.reload();
            }
            
        });
        $A.enqueueAction(action);
    },
    unlockCategory: function(component,event,helper,recordId){
        var action = component.get("c.lockCustomCollab");
        var lockcat = "false";
        action.setParams({
            'recordId': recordId,
            'lockcat': lockcat	
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                helper.initiate(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": " ",
                    "message": "You have Unlocked a category.",
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