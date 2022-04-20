({
    SetupClick : function(component, event, helper) {       
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'SetupClick' });       
        cmpEvent.fire();
	},
    UsingClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'UsingClick' });       
        cmpEvent.fire(); 
    },
    FAQClick : function(component, event, helper) {  
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'FAQClick' });       
        cmpEvent.fire();
    },
    HoverSetupImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Setup");   
	},
    HoverUsingImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Using");   
	},
    HoverCFImage : function(component, event, helper) {      
        component.set("v.ImageToggle","CF");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	}, 
    BackButtonClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'MWVoiceControlGoogleAssistant_Back' });       
        cmpEvent.fire();
    }    
})