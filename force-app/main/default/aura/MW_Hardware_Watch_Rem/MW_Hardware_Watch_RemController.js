({
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRem_Yes" });        
        cmpEvent.fire(); 
	},
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");    
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRem_No" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRem_Back" });        
        cmpEvent.fire(); 
	}
})