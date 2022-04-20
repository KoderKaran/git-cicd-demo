({
	EmailValidationClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");
        console.log('EmailValidationClick Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'EmailValidationClick' });       
        cmpEvent.fire();
	},
    ForgotPasswordClick : function(component, event, helper) {       
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('KD120Click Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'ForgotPasswordClick' });       
        cmpEvent.fire();
	},
    DealerOfRecordClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('LDZ101Click Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'DealerOfRecordClick' });       
        cmpEvent.fire();
	},
    Sight4Click : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('K6Click Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'Sight4Click' });       
        cmpEvent.fire();
	},
    HoverPasswordImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Password");   
	}, 
    HoverProImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Pro");   
	}, 
    Hover4SightImage : function(component, event, helper) {      
        component.set("v.ImageToggle","4Sight");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},    
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "Modal_Close" });        
        cmpEvent.fire(); 
	}	
})