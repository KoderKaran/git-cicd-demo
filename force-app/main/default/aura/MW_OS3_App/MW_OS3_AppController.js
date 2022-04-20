({
    AppIOSButtonClick : function(component, event, helper) {
	    window.open('https://itunes.apple.com/us/app/control4-for-os-3/id1320153814?ls=1&mt=8','_blank');
	},	    
    AppAndroidButtonClick : function(component, event, helper) {
    	window.open('https://play.google.com/store/apps/details?id=com.control4.phoenix','_blank');
	},      
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");     
        cmpEvent.setParams({"ComponentAction" : "BackClick" });        
        cmpEvent.fire(); 
	},
})