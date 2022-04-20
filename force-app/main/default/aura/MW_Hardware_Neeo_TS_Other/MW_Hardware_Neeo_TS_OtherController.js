({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSOther_Back" });        
        cmpEvent.fire(); 
	}
})