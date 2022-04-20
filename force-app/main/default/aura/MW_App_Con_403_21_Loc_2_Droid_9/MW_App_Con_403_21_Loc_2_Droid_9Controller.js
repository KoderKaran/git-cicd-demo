({
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "MW_App_Con_403_21_Loc_2_Droid_9Y" });        
        cmpEvent.fire(); 
	},
    NoButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");    
        cmpEvent.setParams({"ComponentAction" : "MW_App_Con_403_21_Loc_2_Droid_9N" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MW_App_Con_403_21_Loc_2_Droid_9_Back" });        
        cmpEvent.fire(); 
	}
})