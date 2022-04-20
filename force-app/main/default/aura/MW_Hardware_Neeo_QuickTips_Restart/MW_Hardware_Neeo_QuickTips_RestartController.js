({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoQuickTipsRestart_Back" });        
        cmpEvent.fire(); 
	}
})