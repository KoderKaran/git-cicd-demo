({
	helperMethod : function() {
		
	},
    
    getPasswordResetResponse: function(component, email){
        
        component.set("v.passwordResetMessage", "");  
        
        // create a server side action.        
        var action = component.get("c.customerSupportForgotPassword");
        var url = 'http://services.control4.com/ConsumerPortal/api/useraction/requestpasswordrecovery?emailAddress=' + email;
        //var url = 'https://customer.control4.com/services/UserService.svc/RequestPasswordReset';
        
        // set the url parameter for getCalloutResponseContents method (to use as endPoint) 
        action.setParams({
            "url": url
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();  
                console.log(result);   
                document.getElementById("text-input-id-1").value = "";
                result = result.substring(result.indexOf("Message:"), result.length);                   
                result = result.replace("Message:","");
                
                if(result.includes("true")){
                //if(true) {
                    component.set("v.passwordResetMessage", "An email with password reset instructions has been sent to the email address associated with your account.");
                    component.set("v.passwordResetStatus", "Success");  
                }
                else {
                	component.set("v.passwordResetMessage", result);   
                    component.set("v.passwordResetStatus", "Error");
                }  
            }
            else {
                component.set("v.passwordResetMessage", "Unable to reset password.");
                component.set("v.passwordResetStatus", "Error");
            }
            component.set("v.emailAddress", "");
        }); 
        $A.enqueueAction(action); 
        
    }
})