({
    TroubleShootingClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "TroubleShootingClick" });        
        cmpEvent.fire(); 
	},
    ElectricianClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "ElectricianClick" });        
        cmpEvent.fire(); 
	},
    LightingSolutionsClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "LightingSolutionsClick" });        
        cmpEvent.fire(); 
	},
    HoverTSImage : function(component, event, helper) {      
        component.set("v.ImageToggle","TS");   
	},
    HoverEImage : function(component, event, helper) {      
        component.set("v.ImageToggle","E");   
	},
    HoverLGImage : function(component, event, helper) {      
        component.set("v.ImageToggle","LG");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},   
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareLighting_Back" });        
        cmpEvent.fire(); 
	}
})