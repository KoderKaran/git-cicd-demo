({
	SolutionGuidesClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'SolutionGuidesClick' });       
        cmpEvent.fire();
	},
    IntercomAnywhereClick : function(component, event, helper) {       
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'IntercomAnywhereClick' });       
        cmpEvent.fire();
	},
    EndUserClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'EndUserClick' });       
        cmpEvent.fire();
	},
    VoiceControlClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'VoiceControlClick' });       
        cmpEvent.fire();
	},
    ElectricianHVACClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'ElectricianHVACClick' });       
        cmpEvent.fire();
	},
    HoverOS2Image : function(component, event, helper) {      
        component.set("v.ImageToggle","OS2");   
	},
    HoverIntercomImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Intercom");   
	},
    HoverAutomationsImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Automations");   
	},
    HoverAlexaImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Alexa");   
	},   
    HoverProImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Pro");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},
    BackButtonClick : function(component, event, helper) { 
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'Modal_Close' });       
        cmpEvent.fire();
	}
    
})