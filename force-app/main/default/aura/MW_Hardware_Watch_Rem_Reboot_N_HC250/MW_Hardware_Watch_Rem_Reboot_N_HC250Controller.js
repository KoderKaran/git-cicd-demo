({
 	YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemRebootNHC250_Y" });        
        cmpEvent.fire(); 
	},	
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemRebootNHC250_N" });        
        cmpEvent.fire(); 
	},	
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemRebootNHC250_Back" });        
        cmpEvent.fire(); 
	}
})