({
	AlexaClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'AlexaClick' });       
        cmpEvent.fire();
	},    
    GoogleAssistantClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'GoogleAssistantClick' });       
        cmpEvent.fire();
	},   
    GoogleAssistantSolidImage : function(component, event, helper) {      
        component.set("v.ImageToggle","googleAssistant");   
	},
    AlexaSolidImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Alexa");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},
    BackButtonClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('K6Click Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'Modal_Close' });       
        cmpEvent.fire();
    }    
})