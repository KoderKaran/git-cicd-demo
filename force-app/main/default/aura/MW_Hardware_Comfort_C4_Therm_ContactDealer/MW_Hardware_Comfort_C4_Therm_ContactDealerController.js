({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermContactDealer_Back" });        
        cmpEvent.fire(); 
	}
})