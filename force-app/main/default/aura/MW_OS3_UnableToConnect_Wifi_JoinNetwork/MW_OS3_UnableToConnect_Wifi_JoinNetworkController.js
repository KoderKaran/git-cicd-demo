({
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "BackClick" });        
        cmpEvent.fire(); 
	},
    WifiHomeClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "WifiHomeClick" });        
        cmpEvent.fire(); 
	},
    WifiAwayClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "WifiAwayClick" });        
        cmpEvent.fire(); 
	}
    
})