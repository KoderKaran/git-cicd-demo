({
    Con40321Click : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "Con40321Click" });        
        cmpEvent.fire(); 
	},
    Con500Click : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "Con500Click" });        
        cmpEvent.fire(); 
	},
    DNAClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "DNAClick" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "AppCon_Back" });        
        cmpEvent.fire(); 
	}
})