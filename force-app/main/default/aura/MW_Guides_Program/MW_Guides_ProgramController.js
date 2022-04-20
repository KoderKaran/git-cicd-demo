({
    doInit : function(component, event, helper) {
     	$A.util.addClass(component.find("Vid1_Div"),'toggle');
        $A.util.addClass(component.find("Vid2_Div"),'toggle');
        $A.util.addClass(component.find("Vid3_Div"),'toggle');
        $A.util.addClass(component.find("Vid4_Div"),'toggle');
        $A.util.addClass(component.find("Vid5_Div"),'toggle');
        $A.util.addClass(component.find("Vid6_Div"),'toggle');
        $A.util.addClass(component.find("Vid7_Div"),'toggle');
        $A.util.addClass(component.find("Vid8_Div"),'toggle');
        $A.util.addClass(component.find("Vid9_Div"),'toggle');
        $A.util.addClass(component.find("Vid10_Div"),'toggle');
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
    Vid2Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid2_Div"),'toggle');        
    },
    Vid3Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid3_Div"),'toggle');        
    },
    Vid4Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid4_Div"),'toggle');        
    },
    Vid5Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid5_Div"),'toggle');        
    },
    Vid6Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid6_Div"),'toggle');        
    },
    Vid7Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid7_Div"),'toggle');        
    },
    Vid8Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid8_Div"),'toggle');        
    },
    Vid9Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid9_Div"),'toggle');        
    },
    Vid10Click : function(component, event, helper) {        
        $A.util.addClass(component.find("Main_Div"),'toggle');        
       	$A.util.removeClass(component.find("Vid10_Div"),'toggle');        
    },
    VidBackButton : function(component, event, helper) {        
        $A.util.addClass(component.find("Vid1_Div"),'toggle');        
        $A.util.addClass(component.find("Vid2_Div"),'toggle'); 
        $A.util.addClass(component.find("Vid3_Div"),'toggle');      
        $A.util.addClass(component.find("Vid4_Div"),'toggle'); 
        $A.util.addClass(component.find("Vid5_Div"),'toggle'); 
        $A.util.addClass(component.find("Vid6_Div"),'toggle'); 
        $A.util.addClass(component.find("Vid7_Div"),'toggle'); 
        $A.util.addClass(component.find("Vid8_Div"),'toggle'); 
        $A.util.addClass(component.find("Vid9_Div"),'toggle'); 
        $A.util.addClass(component.find("Vid10_Div"),'toggle'); 
        $A.util.removeClass(component.find("Main_Div"),'toggle');
        document.getElementById('firstVid').src = "https://fast.wistia.net/embed/iframe/rzypjckys4?videoFoam=true"; 
        document.getElementById('Vid2').src = "https://fast.wistia.net/embed/iframe/spdxj1wesh?videoFoam=true"; 
        document.getElementById('Vid3').src = "https://fast.wistia.net/embed/iframe/isr73vxphi?videoFoam=true"; 
        document.getElementById('Vid4').src = "https://fast.wistia.net/embed/iframe/1dsc5vyp7p?videoFoam=true"; 
        document.getElementById('Vid5').src = "https://fast.wistia.net/embed/iframe/5i84kpi7dj?videoFoam=true"; 
        document.getElementById('Vid6').src = "https://fast.wistia.net/embed/iframe/n8gukk9juy?videoFoam=true"; 
        document.getElementById('Vid7').src = "https://fast.wistia.net/embed/iframe/v0og9q39sw?videoFoam=true"; 
        document.getElementById('Vid8').src = "https://fast.wistia.net/embed/iframe/mvs1oegx0t?videoFoam=true"; 
        document.getElementById('Vid9').src = "https://fast.wistia.net/embed/iframe/ux0n589btt?videoFoam=true"; 
        document.getElementById('Vid10').src = "https://fast.wistia.net/embed/iframe/n8gukk9juy?videoFoam=true";
    }
})