({
 	doInit : function(component, event, helper) {       
    	 component.set("v.FirstLoad", true); 
        // Get the recordId if you are not running this in flow     
         component.set("v.rmaFormURL", " "); 
                
        if (component.get("v.caseId") == undefined)
        {
            component.set("v.caseId", component.get("v.recordId"));            
        }
        
        var caseId = component.get("v.caseId");   
        component.set("v.rmaFormURL", '/apex/RMAFormV2?caseId=' + caseId + "&errorStyle=0" + "#view=fit");               
	},
    
    newPopup : function(component, event, helper){   
        
        if (component.get('v.FirstLoad') == false)
            {   
                var forceIframeToReload = component.get("v.rmaFormURL") + "&UID=" + Math.floor((Math.random()*1000000)+1)  + "#view=fit"; 
                component.set("v.rmaFormURL", forceIframeToReload); 
            }
        
        component.set("v.FirstLoad", false); 

        
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        
        var action = component.get('c.createRMA');
       	// var caseId = component.get("v.recordId");  
       	var caseId = component.get("v.caseId"); 
        action.setParams({
            'caseId': caseId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
                component.set('v.RMAInfo',response.getReturnValue());                
                var asdf = component.get('v.RMAInfo').ToEmail;
                console.log(asdf);  
            }
            else if (state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if(errors[0] && error[0].message){
                        console.log('Error Message: ' + errors[0].message);
                    }
                }
                else{
                    console.log('Unknown Error');
                }
            }
        });
        $A.enqueueAction(action);       
    },
    
    closeNewModal : function(component, event, helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },
     sendMail: function(component, event, helper) {
        // when user click on Send button 
        // First we get all 3 fields values 
        component.set("v.disableSendButton",true);	
        var toEmail = component.get("v.RMAInfo.ToEmail");
        var ccEmail = component.get("v.RMAInfo.CcEmail");
        var bccEmail = component.get("v.RMAInfo.BccEmail"); 
        var subjectEmail = component.get("v.RMAInfo.SubjectEmail");         
         
        // check if Email field is Empty or not contains @ so display a alert message 
        // otherwise call call and pass the fields value to helper method    
        if ($A.util.isEmpty(toEmail) || !toEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        }
        if (!$A.util.isEmpty(ccEmail) && !ccEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        }
        if (!$A.util.isEmpty(bccEmail) && !bccEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        }
        else {
            //console.log('ToEmail: ' + toEmail + ' ccEmail: ' + ccEmail + ' bccEmail: ' + ' subjectEmail: ' + subjectEmail);
            helper.sendHelper(component, toEmail, ccEmail, bccEmail, subjectEmail);
        }
    },
 
    // when user click on the close buttton on message popup ,
    // hide the Message box by set the mailStatus attribute to false
    // and clear all values of input fields.   
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.mailErrorStatus", false);      
        
        // This is from closeNewModal method
        component.set("v.accForm",{'LastName':''});
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        
        // Reload the page so that the RMA has sent updates in the UI.
        $A.get('e.force:refreshView').fire(); 
    }
})