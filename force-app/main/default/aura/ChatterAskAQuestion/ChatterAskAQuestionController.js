({
	doInit : function(component, event, helper) {

        var usrId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", usrId);
        helper.getUserPhoto(component, event);
        /*helper.getCommunityTopics(component, event);*/
        
    },

    setTopic : function(component, event, helper) {
    	var topics = component.get("v.selectedTopics");
        console.log(topics);
    	var curTopicId = event.target.id;
        if (!topics.includes(curTopicId)) {
    		topics.push(curTopicId); 
    	} else {
    		var index = topics.indexOf(curTopicId);
			if (index !== -1) {
			    topics.splice(index, 1);
              }
    	}
    	component.set("v.selectedTopics", topics);
    },

    changeColor:function(component, event, helper) {
        var id = event.target.closest('a').id;
        if (document.getElementById(id).style.backgroundColor === 'rgb(194, 194, 194)') {
            document.getElementById(id).style.backgroundColor = '#f0eeee';
        } else {
            document.getElementById(id).style.backgroundColor = '#c2c2c2';
        }
    },

    uploadPreviewAttachment : function(component, event, helper) { 
        var files  = component.get("v.fileToBeUploaded");
        var content = [];
        var file = files[0][0];
        var reader = new FileReader();

        reader.onload = function(e) {
            component.set("v.uploadedFileURL", e.target.result);
            component.set("v.uploadedFileName", file.name);
        }

        reader.readAsDataURL(file);
        // component.set("v.content", content);
        console.log(file);
    },

    sendQuestion : function(component, event, helper) {
        console.log(document.getElementById("message-title").value.trim());
    	if (document.getElementById("message-title").value.trim() != '') {

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
                var questionDetails = '';

                if (component.get("v.myVal") != null) {
                    questionDetails = component.get("v.myVal");
                    questionDetails = questionDetails.replace(/<br>/g, "\n");
                    questionDetails = questionDetails.replace(/<\/br>/g,"\n");
                }
                
                var action = component.get("c.saveQuestionWithAttach");
                action.setParams({
                    'userId' : $A.get("$SObjectType.CurrentUser.Id"),
                    'questionTitle' : document.getElementById("message-title").value,
                    'questionDetails' : questionDetails,
                    'topicIds' : component.get("v.selectedTopics"),
                    "fileBody" : fileBody,
                    "fileName" : fileName,
                    "fileFormat" : fileFormat,
                    "networkId" : ''
                });

                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {

                         var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                          "url": "/questions" 
                        });
                        urlEvent.fire();


                    } else 
                    if (state === "ERROR") {

                        var errors = response.getError();

                        var toastEvent = $A.get("e.force:showToast");

                        var errorMessage = 'Something went wrong';

                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                errorMessage = errors[0].message;
                            }
                        }

                        toastEvent.setParams({
                            "type": "error",
                            "message": "Error message: " + errorMessage
                        });
                        
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(action);
                });

                fr.readAsDataURL(file);
            } 
            else {
            	var action = component.get("c.saveQuestion");

        		var questionDetails = '';

        		if (component.get("v.myVal") != null) {

        			questionDetails = component.get("v.myVal");
                    questionDetails = questionDetails.replace(/<br>/g, " ");
                    questionDetails = questionDetails.replace(/<\/br>/g," ");
        		}

                action.setParams({
                	'userId' : $A.get("$SObjectType.CurrentUser.Id"),
                    'questionTitle' : document.getElementById("message-title").value,
                    'questionDetails' : questionDetails,
                    'topicIds' : component.get("v.selectedTopics"),
                    'networkId' : ''
                });

                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                    	
                    	var result = response.getReturnValue();
                      
                        var urlEvent = $A.get("e.force:navigateToURL");
    			        urlEvent.setParams({
    			          "url": "/question/" + result
    			        });
    			        urlEvent.fire();
    			       
                    } else 
                    if (state === "ERROR") {

                        var errors = response.getError();

                        var toastEvent = $A.get("e.force:showToast");

                        var errorMessage = 'Something went wrong';

                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                errorMessage = errors[0].message;
                            }
                        }

                        toastEvent.setParams({
                            "type": "error",
                            "message": "Error message: " + errorMessage
                        });
                        
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(action);
            } 
        }
        else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "message": "Please, add some question!"
            });
            toastEvent.fire();
        }
    }
    
})