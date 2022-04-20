({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "BackClick" });        
        cmpEvent.fire(); 
	},
    Skip2ButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "WifiStep2NoClick" });        
        cmpEvent.fire(); 
	},
    Skip3ButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "ChooseControllerClick" });        
        cmpEvent.fire(); 
	},
    Step1ButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "WifiStep1Click" });        
        cmpEvent.fire(); 
	}
})