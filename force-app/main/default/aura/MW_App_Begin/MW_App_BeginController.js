({
    doInit : function(component, event, helper) {
//    var backbutton = document.getElementById("beginBackButton");
//    backbutton.blur();
    },   
	 ConnectionIssuesClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('EmailValidationClick Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'ConnectionIssuesClick' });       
        cmpEvent.fire();
	}, 
    NewDeviceClick : function(component, event, helper) {       
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('KD120Click Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'NewDeviceClick' });       
        cmpEvent.fire();
	},
    MusicServicesClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('LDZ101Click Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'MusicServicesClick' });       
        cmpEvent.fire();
	},
    IntercomAnywhereClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('K6Click Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'IntercomAnywhereClick' });       
        cmpEvent.fire();
	},
    PCMacClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        //console.log('K6Click Event fired: ' + cmpEvent);        
        cmpEvent.setParams({"ComponentAction" : 'PCMacClick' });       
        cmpEvent.fire();
	}, 
    HoverConnectionImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Connection");   
	},
    HoverNewDeviceImage : function(component, event, helper) {      
        component.set("v.ImageToggle","NewDevice");   
	},
    HoverMusicImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Music");   
	},
    HoverIntercomImage : function(component, event, helper) {      
        component.set("v.ImageToggle","Intercom");   
	},
    HoverAppImage : function(component, event, helper) {      
        component.set("v.ImageToggle","App");   
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