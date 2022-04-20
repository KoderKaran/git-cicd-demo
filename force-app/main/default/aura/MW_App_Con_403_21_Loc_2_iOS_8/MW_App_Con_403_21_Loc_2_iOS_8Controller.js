({
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "MW_App_Con_403_21_Loc_2_iOS_8Y" });        
        cmpEvent.fire(); 
	},
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");    
        cmpEvent.setParams({"ComponentAction" : "MW_App_Con_403_21_Loc_2_iOS_8N" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "MW_App_Con_403_21_Loc_2_iOS_8_Back" });        
        cmpEvent.fire(); 
	}
})