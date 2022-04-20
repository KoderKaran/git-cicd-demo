({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "AccountForgotPassword_Back" });        
        cmpEvent.fire(); 
	},	
    ResetPasswordButtonClick : function(component, event, helper) {

    	//http://services.control4.com/ConsumerPortal/api/useraction/requestpasswordrecovery?emailAddress={0}    	
		helper.getPasswordResetResponse(component,document.getElementById("text-input-id-1").value);
     //   document.getElementById("text-input-id-1").value = "";    
        
		// bubble the click event to capture analytics
        var cmpEvent = component.getEvent("bubblingEvent");    
        cmpEvent.setParams({"ComponentAction" : "ResetPasswordButtonClick" });        
        cmpEvent.fire();         
	}
})