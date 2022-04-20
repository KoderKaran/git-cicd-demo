({
    NeeoTSNEClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'NeeoTSNEClick'});       
        cmpEvent.fire();
	},
    NeeoTSARClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'NeeoTSARClick'});       
        cmpEvent.fire();
	},
    NeeoTSOtherClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'NeeoTSOtherClick'});       
        cmpEvent.fire();
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MSHardwareNeeoTS_Back" });        
        cmpEvent.fire(); 
	}
})