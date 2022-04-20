({
    NeeoClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'NeeoClick' });       
        cmpEvent.fire();
	},
    
	WatchClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'WatchClick' });       
        cmpEvent.fire();
	},
    ListenClick : function(component, event, helper) {       
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'ListenClick' });       
        cmpEvent.fire();
	},
    LightingClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'LightingClick' });       
        cmpEvent.fire();
	},
    ComfortClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : 'ComfortClick' });       
        cmpEvent.fire();
	},
    HoverNeeoImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Neeo");   
	},
    HoverWatchImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Watch");   
	},
    HoverListenImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Listen");   
	},
    HoverLightingImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Lighting");   
	},
    HoverComfortImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Comfort");   
	},   
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "Modal_Close" });        
        cmpEvent.fire(); 
	}
})