({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "Account4SightGetNow_Back" });        
        cmpEvent.fire(); 
	},	
    CloseButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Close Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "Modal_Close" });        
        cmpEvent.fire(); 
	}
})