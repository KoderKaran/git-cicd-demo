({    	
    Get4SightNowButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : "Get4SightNow" });        
        cmpEvent.fire(); 
	},
    Cancel4SightButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "Account4SightCancel" });        
        cmpEvent.fire(); 
	},
    CreditCardButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "Account4SightCreditCard" });        
        cmpEvent.fire(); 
	},    
    TaxErrorButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "Account4SightTaxError" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "Account4Sight_Back" });        
        cmpEvent.fire(); 
	}   
})