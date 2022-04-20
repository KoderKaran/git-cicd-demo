({
	GettingStartedClick : function(component, event, helper) {      
        var cmpEvent = component.getEvent("bubblingEvent");   
        cmpEvent.setParams({"ComponentAction" : 'GettingStartedClick' });       
        cmpEvent.fire();
	},
    CustScreenNamesClick : function(component, event, helper) {       
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'CustScreenNamesClick' });       
        cmpEvent.fire();
	},
    QuickStartClick : function(component, event, helper) {      
        //window.open('https://www.control4.com/docs/product/alexa/quick-start-guide/english/latest/alexa-quick-start-guide-rev-b.pdf','_blank');       
	    
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'QuickStartGuideClick' });       
        cmpEvent.fire(); 
    },
    CustomerFAQsClick : function(component, event, helper) {  
        //window.open('https://www.control4.com/docs/product/alexa/frequently-asked-questions/english/latest/alexa-frequently-asked-questions-rev-f.pdf','_blank');
	
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : 'CustomerFAQsClick' });       
        cmpEvent.fire();
    },
    HoverGTImage : function(component, event, helper) {      
        component.set("v.ImageToggle","GT");   
	},
    HoverCSNImage : function(component, event, helper) {      
        component.set("v.ImageToggle","CSN");   
	},
    HoverQSGImage : function(component, event, helper) {      
        component.set("v.ImageToggle","QSG");   
	},
    HoverCFImage : function(component, event, helper) {      
        component.set("v.ImageToggle","CF");   
	},    
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},  
    BackButtonClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent"); 
        cmpEvent.setParams({"ComponentAction" : 'MWVoiceControlAlexa_Back' });       
        cmpEvent.fire();
    }    
})