({   
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareLightingTSLightSolutions_Back" });        
        cmpEvent.fire(); 
	}
})