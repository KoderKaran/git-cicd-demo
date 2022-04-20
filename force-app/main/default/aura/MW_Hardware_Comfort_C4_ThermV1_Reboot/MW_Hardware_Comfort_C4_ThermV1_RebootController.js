({
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermV1Reboot_Y" });        
        cmpEvent.fire(); 
	},	
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermV1Reboot_N" });        
        cmpEvent.fire(); 
	},	
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermV1Reboot_Back" });        
        cmpEvent.fire(); 
	}
})