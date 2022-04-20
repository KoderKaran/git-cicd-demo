({
    RemoteTroubleshootingClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Back Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "RemoteTroubleshootingClick" });        
        cmpEvent.fire(); 
	},	
    NewDeviceClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Close Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "NewDeviceClick" });        
        cmpEvent.fire(); 
	},	
    QuickStartClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Close Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "QuickStartClick" });        
        cmpEvent.fire(); 
	},
    HoverTSImage : function(component, event, helper) {      
        component.set("v.ImageToggle","TS");   
	},
    HoverNDImage : function(component, event, helper) {      
        component.set("v.ImageToggle","ND");   
	},
    HoverQSGImage : function(component, event, helper) {      
        component.set("v.ImageToggle","QSG");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	}, 
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('Close Button clicked: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatch_Back" });        
        cmpEvent.fire(); 
	}
})