({
    APD120Click : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "APD120Click" });        
        cmpEvent.fire(); 
	},
    KD120Click : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "KD120Click" });        
        cmpEvent.fire(); 
	},
    LDZ101Click : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "LDZ101Click" });        
        cmpEvent.fire(); 
	},
    K6Click : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "K6Click" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareLightingTS_Back" });        
        cmpEvent.fire(); 
	}
})