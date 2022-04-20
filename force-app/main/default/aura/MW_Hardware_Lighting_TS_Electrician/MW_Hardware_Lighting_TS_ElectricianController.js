({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareLightingTSElectrician_Back" });        
        cmpEvent.fire(); 
	}
})