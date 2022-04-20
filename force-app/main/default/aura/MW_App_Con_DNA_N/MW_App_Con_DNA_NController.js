({
    Con40321Click_500WasTriedFirst : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        console.log('asdfsadf Button clicked: ' + cmpEvent);
        cmpEvent.setParams({"ComponentAction" : "Con40321Click" });        
        cmpEvent.fire(); 
	},
    Con500Click_500WasTriedFirst : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        console.log('asdfsadf Button clicked: ' + cmpEvent);
        cmpEvent.setParams({"ComponentAction" : "Con500Click" });        
        cmpEvent.fire(); 
	},  

    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");  
        console.log('asdfsadf Button clicked: ' + cmpEvent);
        cmpEvent.setParams({"ComponentAction" : "MW_App_DNA_N_Back" });        
        cmpEvent.fire(); 
	}
})