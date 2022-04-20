({
    UserGuide : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'NeeoUserGuide'});       
        cmpEvent.fire();
    },
    QuickStartGuide : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'NeeoQuickStartGuide'});       
        cmpEvent.fire();
    },   
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareNeeoGuide_Back" });        
        cmpEvent.fire(); 
	},   
})