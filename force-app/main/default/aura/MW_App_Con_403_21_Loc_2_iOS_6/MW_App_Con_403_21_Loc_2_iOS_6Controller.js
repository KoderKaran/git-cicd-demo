({
    NextButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MW_App_Con_403_21_Loc_2_iOS_7" });        
        cmpEvent.fire(); 
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MW_App_Con_403_21_Loc_2_iOS_6_Back" });        
        cmpEvent.fire(); 
	}
})