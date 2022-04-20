({
    doInit : function(component, event, helper) {
      	$A.util.addClass(component.find("Vid1_Div"),'toggle');
    },
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "BackToGuidesStartPage_Back" });        
        cmpEvent.fire(); 
	},
    Vid1Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid1_Div"),'toggle');        
    },
    VidBackButton : function(component, event, helper) {        
        $A.util.addClass(component.find("Vid1_Div"),'toggle'); 
      	$A.util.removeClass(component.find("Main_Div"),'toggle');    
        document.getElementById('Vid1').src = "https://fast.wistia.net/embed/iframe/hgo75h4up8?videoFoam=true"; 
    }
})