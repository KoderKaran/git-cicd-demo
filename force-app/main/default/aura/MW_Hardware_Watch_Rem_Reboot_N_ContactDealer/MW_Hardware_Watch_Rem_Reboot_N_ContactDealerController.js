({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemRebootNContactDealer_Back" });        
        cmpEvent.fire(); 
	}
})