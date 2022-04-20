({
    ThermV2Click : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "ThermV2Click" });        
        cmpEvent.fire(); 
	},
    ThermV1Click : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "ThermV1Click" });        
        cmpEvent.fire(); 
	},
    HVACClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "HVACClick" });        
        cmpEvent.fire(); 
	},
    QuickStartClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "ComfortQuickStartClick" });        
        cmpEvent.fire(); 
	},
    HoverV1Image : function(component, event, helper) {      
        component.set("v.ImageToggle","V1");   
	},
    HoverV2Image : function(component, event, helper) {      
        component.set("v.ImageToggle","V2");   
	},
    HoverHVACImage : function(component, event, helper) {      
        component.set("v.ImageToggle","HVAC");   
	},
    HoverCGImage : function(component, event, helper) {      
        component.set("v.ImageToggle","CG");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfort_Back" });        
        cmpEvent.fire(); 
	}
    
})