({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoQuickTipsReset_Back" });        
        cmpEvent.fire(); 
	}
})