({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNEStep3_Back" });        
        cmpEvent.fire(); 
	},
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNEStep3_Y" });        
        cmpEvent.fire(); 
	},
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNEStep3_N" });        
        cmpEvent.fire(); 
	} 
})