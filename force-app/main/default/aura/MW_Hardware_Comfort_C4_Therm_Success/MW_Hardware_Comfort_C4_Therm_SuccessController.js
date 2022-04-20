({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermSuccess_Back" });        
        cmpEvent.fire(); 
	}
})