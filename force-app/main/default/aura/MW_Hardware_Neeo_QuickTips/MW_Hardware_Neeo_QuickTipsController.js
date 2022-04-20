({
    NeeoFAQClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'MSHardwareNeeoQTFAQ'});       
        cmpEvent.fire();
	},   
    RestartClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'MSHardwareNeeoQTRestart'});       
        cmpEvent.fire();
	},
    ResetClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'MSHardwareNeeoQTReset'});       
        cmpEvent.fire();
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoQuickTips_Back" });        
        cmpEvent.fire(); 
	},    
    HoverFAQImage : function(component, event, helper) {      
        component.set("v.ImageToggle","FAQ");   
	},
    HoverRestartImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Restart");   
	}, 
    HoverResetImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Reset");   
	}, 
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	}
})