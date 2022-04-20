({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWAppContactDealer_Back" });        
        cmpEvent.fire(); 
	}
})