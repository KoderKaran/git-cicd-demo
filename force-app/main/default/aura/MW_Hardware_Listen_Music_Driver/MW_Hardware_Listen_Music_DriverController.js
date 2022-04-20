({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareListenMusicDriver_Back" });        
        cmpEvent.fire(); 
	},
})