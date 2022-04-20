({
    BackButtonClick : function(component, event, helper) {
		document.getElementById('getStartedVid').src = "https://fast.wistia.net/embed/iframe/8tamcreuw0?videoFoam=true"; // This stops the video from playing  
        var cmpEvent = component.getEvent("bubblingEvent");      
        cmpEvent.setParams({"ComponentAction" : "MWVoiceControlGetStarted_Back" });        
        cmpEvent.fire(); 
	}
})