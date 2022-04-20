({
    Skip2ButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNE_Skip2" });        
        cmpEvent.fire(); 
	},
    Skip3ButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNE_Skip3" });        
        cmpEvent.fire(); 
	}, 
    Skip4ButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNE_Skip4" });        
        cmpEvent.fire(); 
	}, 
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTSNE_Back" });        
        cmpEvent.fire(); 
	},
    NextButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoNENext" });        
        cmpEvent.fire(); 
	}   
})