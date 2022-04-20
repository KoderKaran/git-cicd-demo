({
	doInit : function(component, event, helper) {

        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", userId);

        helper.getUserPhoto(component, event);

        helper.getFeedItem(component, event);

        helper.getFeedComments(component, event);

        /*helper.getTopics(component, event);*/
        helper.getFeedAttach(component,event);
        helper.updateViews(component,event);
    },

    upvoteComment : function(component, event, helper) {
    	var feedCommentId = event.currentTarget.id;
        var commentVote = event.currentTarget.name;
        helper.upvoteFeedComment(component, feedCommentId, commentVote, helper, event);
    },

    downvoteComment : function(component, event, helper) {
        var feedCommentId = event.currentTarget.id;
        var commentVote = event.currentTarget.name;
        helper.downvoteFeedComment(component, feedCommentId, commentVote, helper, event);
    },

    upvoteFeedItem : function(component, event, helper) {
        var feedCommentId = event.currentTarget.id;
        var commentVote = event.currentTarget.name;
        helper.upvoteFeedItem(component, feedCommentId, commentVote);        
    },

    downvoteFeedItem : function(component, event, helper) {
        var feedItemId = event.currentTarget.id;
        var feedItemVote = event.currentTarget.name;
        helper.downvoteFeedItem(component, feedItemId, feedItemVote);
    },

    submitComment : function(component, event, helper) {

        if (document.getElementById("message-input").value.trim() != '') {
            var files  = component.get("v.fileToBeUploaded");

            if (files != null) {
                var file = files[0][0];
                var fileName = file.name;
                var fileFormat = file.type; 

                var fr = new FileReader();

                fr.onloadend = $A.getCallback(function() {
                    var fileBody = fr.result;
                    var base64Mark = 'base64,';
                    var dataStart = fileBody.indexOf(base64Mark) + base64Mark.length;

                    fileBody = fileBody.substring(dataStart);

                    console.log(fileBody);
                    console.log(fileName);
                    console.log(fileFormat);
                    var action = component.get("c.submitThisCommentWithAttachment");
                    action.setParams({
                        'contentType' : 'application/json',
                        'feedElementId' : component.get("v.recordId"),
                        'commentText' : document.getElementById("message-input").value,
                        "fileBody" : fileBody,
                        "fileName" : fileName,
                        "fileFormat" : fileFormat
                    });

                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {

                            $A.get('e.force:refreshView').fire();
                        } else 
                        if (state === "ERROR") {

                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type": "error",
                                "message": "Oops, something went wrong, try again in a minute"
                            });
                            toastEvent.fire();
                        }
                    });
                    $A.enqueueAction(action);
                });

                fr.readAsDataURL(file);
            } else {
                var action = component.get("c.submitThisCommentWithoutAttachment");
                action.setParams({
                    'feedElementId' : component.get("v.recordId"),
                    'commentText' : document.getElementById("message-input").value
                });
                action.setCallback(this, function(response) {
                    var votes = response.getReturnValue();
                    helper.getFeedComments(component, event);
                    document.getElementById("message-input").value = '';
                });

                $A.enqueueAction(action);
            }
            component.set("v.fileToBeUploaded", null);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "message": "Please, add some message to the answer!"
            });
            toastEvent.fire();
        }
        
    },

    uploadPreviewAttachment : function(component, event, helper) { 
        var files  = component.get("v.fileToBeUploaded");

        var file = files[0][0];
        var reader = new FileReader();

        reader.onload = function(e) {
            component.set("v.uploadedFileURL", e.target.result);
            component.set("v.uploadedFileName", file.name);
        }

        reader.readAsDataURL(file);
    },

    bestCommentUpdate : function (component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var createdById = component.get("v.feed").feedItem.CreatedById;
        console.log(userId);
        console.log(createdById);
        if (createdById.includes(userId)) {
            console.log(true);
            var action = component.get("c.updateBestComment");
            var commentId = event.currentTarget.id;
            action.setParams({
                'feedItemId' : component.get("v.recordId"),
                'feedCommentId' : commentId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.getFeedItem(component, event);
                    //helper.getFeedComments(component, event);
                } else 
                if (state === "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "message": "Oops, something went wrong, try again in a minute"
                    });
                    toastEvent.fire();
                }
            });

            $A.enqueueAction(action);
        }
    },

    redirectToProfilePage :function(component, event, helper) {
        var userId = event.currentTarget.id;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/profile/" + userId
        });
        urlEvent.fire();
    }

})