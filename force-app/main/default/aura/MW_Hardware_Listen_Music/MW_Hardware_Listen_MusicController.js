({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareListenMusic_Back" });        
        cmpEvent.fire(); 
	},
    MoreInformationButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MusicServicesDriverClick" });        
        cmpEvent.fire(); 
	}
})