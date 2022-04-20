({
    sendHelper: function(component, toEmail, ccEmail, bccEmail, subjectEmail) {

        var action = component.get("c.sendMailMethod");
        //var caseId = component.get("v.recordId");
        var caseId = component.get("v.caseId"); 
        
        action.setParams({
            'caseId': caseId,
            'toEmail': toEmail,
            'ccEmail': ccEmail == undefined ? '' : ccEmail,
            'bccEmail': bccEmail == undefined ? '' : bccEmail,
            'subjectEmail': subjectEmail
        });        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();               
                if(result.includes("Success")){            
                    component.set("v.mailStatus", true);
                }
                else if (result.includes("Error"))  {
                    component.set("v.mailErrorStatus", true);
                    component.set("v.EmailErrorMessage", result);
                }
            }
            else {
                component.set("v.mailErrorStatus", true);
                component.set("v.EmailErrorMessage", "Unknown Error");
            }
        });    
        $A.enqueueAction(action);    	
    }
})