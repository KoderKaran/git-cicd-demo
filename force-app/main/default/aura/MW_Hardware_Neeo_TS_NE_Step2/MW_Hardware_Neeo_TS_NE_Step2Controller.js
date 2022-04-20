({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNEStep2_Back" });        
        cmpEvent.fire(); 
	},
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNEStep2_Y" });        
        cmpEvent.fire(); 
	},
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNEStep2_N" });        
        cmpEvent.fire(); 
	} 
})