({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "BackClick" });        
        cmpEvent.fire(); 
	},
    Step1ButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "ChooseControllerClick" });        
        cmpEvent.fire(); 
	},
})