({
	VideosClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'VideosClick' });       
        cmpEvent.fire();
	},	
    GuidesClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'GuidesClick' });       
        cmpEvent.fire();
	},	
    AppClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'AppClick' });       
        cmpEvent.fire();
	},
    ConnectionClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'ConnectionClick' });       
        cmpEvent.fire();
	},
    HoverVideosImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Videos");   
	},   
    HoverGuideImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Guide");   
	}, 
    HoverAppImage : function(component, event, helper) {      
        component.set("v.ImageToggle","App");   
	}, 
    HoverConnectionImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Connection");   
	}, 
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "Modal_Close" });        
        cmpEvent.fire(); 
	}
})