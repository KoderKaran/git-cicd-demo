({
	BackButtonClick : function(component, event, helper) {    
        document.getElementById('custScreenVid').src = "https://fast.wistia.net/embed/iframe/1dhfe187ny?videoFoam=true"; // This stops the video from playing       
        var cmpEvent = component.getEvent("bubblingEvent");        
        cmpEvent.setParams({"ComponentAction" : "MWVoiceControlCustScreenNames_Back" });        
        cmpEvent.fire(); 
	}   
})