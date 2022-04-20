({
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemReboot_Yes" });        
        cmpEvent.fire(); 
	},
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");    
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemReboot_No" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemReboot_Back" });        
        cmpEvent.fire(); 
	},
    CloseButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "Modal_Close" });        
        cmpEvent.fire(); 
	}
})