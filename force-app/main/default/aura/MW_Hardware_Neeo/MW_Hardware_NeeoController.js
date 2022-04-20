({
    NeeoGuideClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'MWHardwareNeeoGuideClick' });       
        cmpEvent.fire();
    },
    LearnMoreClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'MWHardwareNeeoLearnMoreClick' });       
        cmpEvent.fire();
    },
    TroublshootingClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'MWHardwareNeeoTSClick' });       
        cmpEvent.fire();
    },
    QuickTipsClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'MWHardwareNeeoQTClick' });       
        cmpEvent.fire();
    },
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareNeeo_Back" });        
        cmpEvent.fire(); 
	},    
    GuideImage : function(component, event, helper) {      
        component.set("v.ImageToggle","G");   
	},
    LearnMoreImage : function(component, event, helper) {      
        component.set("v.ImageToggle","LM");   
	},
    TSImage : function(component, event, helper) {      
        component.set("v.ImageToggle","TS");   
	},
    QuickTimesImage : function(component, event, helper) {      
        component.set("v.ImageToggle","QT");   
	},
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	} 
})