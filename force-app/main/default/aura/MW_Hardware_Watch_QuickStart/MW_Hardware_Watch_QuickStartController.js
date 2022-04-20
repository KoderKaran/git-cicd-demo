({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchQuickStart_Back" });        
        cmpEvent.fire(); 
	}
})