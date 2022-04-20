({
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareLightingTSAPD120_Success" });        
        cmpEvent.fire(); 
	},
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareLightingTSAPD120_ContactDealer" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareLightingTSAPD120_Back" });        
        cmpEvent.fire(); 
	}  
})