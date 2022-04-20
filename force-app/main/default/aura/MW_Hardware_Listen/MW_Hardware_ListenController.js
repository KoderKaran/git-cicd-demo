({
    EntertainmentGuideClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "EntertainmentGuideClick" });        
        cmpEvent.fire(); 
	},
    NoSoundClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "NoSoundClick" });        
        cmpEvent.fire(); 
	},
    MusicServicesClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MusicServicesClick" });        
        cmpEvent.fire(); 
	},
    HoverEGImage : function(component, event, helper) {      
        component.set("v.ImageToggle","EG");   
	},
    HoverNSImage : function(component, event, helper) {      
        component.set("v.ImageToggle","NS");   
	},
    HoverMSImage : function(component, event, helper) {      
        component.set("v.ImageToggle","MS");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	}, 
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareListen_Back" });        
        cmpEvent.fire(); 
	}
})