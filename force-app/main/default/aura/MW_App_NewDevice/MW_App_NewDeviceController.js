({
    IOSButtonClick : function(component, event, helper) {
	    window.open('https://itunes.apple.com/us/app/control4/id734435367?ls=1&mt=8','_blank');
	},	    
    AndroidButtonClick : function(component, event, helper) {
    	window.open('https://play.google.com/store/apps/details?id=com.control4.app','_blank');
	},   
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");     
        cmpEvent.setParams({"ComponentAction" : "AppNewDevice_Back" });        
        cmpEvent.fire(); 
	},	
    YesButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "DNAClickFromNewDevices" });        
        cmpEvent.fire(); 
	}
})