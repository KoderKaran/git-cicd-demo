({
    ElectricianClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "ElectricianClick" });        
        cmpEvent.fire(); 
	},	
    HVACClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Close Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "HVACClick" });        
        cmpEvent.fire(); 
	},
    HoverElectricianImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Electrician");   
	},
    HoverHVACImage : function(component, event, helper) {      
        component.set("v.ImageToggle","HVAC");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},    
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "BackToGuidesStartPage_Back" });        
        cmpEvent.fire(); 
	}
})