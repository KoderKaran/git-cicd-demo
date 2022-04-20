({
 	YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemRebootNCA1_Y" });        
        cmpEvent.fire(); 
	},	
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemRebootNCA1_N" });        
        cmpEvent.fire(); 
	},	
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemRebootNCA1_Back" });        
        cmpEvent.fire(); 
	}
})