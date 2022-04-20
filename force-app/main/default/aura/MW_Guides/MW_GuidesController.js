({
	doInit : function(component, event, helper) {        
        $A.util.addClass(component.find("MWGuidesSolution_Div"),'toggle');
        $A.util.addClass(component.find("MWGuidesIntercomAnywhere_Div"),'toggle');
        $A.util.addClass(component.find("MWGuidesProgram_Div"),'toggle');
        $A.util.addClass(component.find("MWVoiceControl_Div"),'toggle');
        $A.util.addClass(component.find("MWGuidesElectHVAC_Div"),'toggle');
        $A.util.addClass(component.find("MWGuidesElect_Div"),'toggle'); 
        $A.util.addClass(component.find("MWGuidesHVAC_Div"),'toggle');
        
        helper.LogAnalytics('Guides', 'Home');  
	},	
    
	handleBubbling : function(component, event, helper) {
        
        var analyticsAction = '';
        var analyticsLabel = '';
        var params = event.getParams();
        var navigateAction = params.ComponentAction;
        //var previousScreen = params.PreviousScreen;
        //console.log("navigateAction: " + navigateAction);		
        
        switch (navigateAction) {
            case "SolutionGuidesClick":                
        		$A.util.addClass(component.find("MWGuidesBegin_Div"),'toggle');  // Hide screen        		
        		$A.util.removeClass(component.find("MWGuidesSolution_Div"),'toggle'); // Unhide screen
                
                analyticsAction = 'Solution Guides';
                analyticsLabel = 'Solution Guides';  
                break;
            case "IntercomAnywhereClick":
        		$A.util.addClass(component.find("MWGuidesBegin_Div"),'toggle');  // Hide screen        		
        		$A.util.removeClass(component.find("MWGuidesIntercomAnywhere_Div"),'toggle'); // Unhide screen
                
                analyticsAction = 'Intercom Anywhere';
                analyticsLabel = 'Intercom Anywhere';                 
                break;
            case "EndUserClick":
        		$A.util.addClass(component.find("MWGuidesBegin_Div"),'toggle');  // Hide screen        		
        		$A.util.removeClass(component.find("MWGuidesProgram_Div"),'toggle'); // Unhide screen
                
                analyticsAction = 'Homeowner Automations';
                analyticsLabel = 'Homeowner Automations';                 
                break;
            case "VoiceControlClick":
        		$A.util.addClass(component.find("MWGuidesBegin_Div"),'toggle');  // Hide screen        		
        		$A.util.removeClass(component.find("MWVoiceControl_Div"),'toggle'); // Unhide screen
                break;
            case "ElectricianHVACClick":
        		$A.util.addClass(component.find("MWGuidesBegin_Div"),'toggle');  // Hide screen       
        		$A.util.removeClass(component.find("MWGuidesElectHVAC_Div"),'toggle'); // Unhide screen
                
                analyticsAction = 'Electrician & HVAC Pros';
                analyticsLabel = 'Electrician & HVAC Pros'; 
                break;                         
            case "BackToGuidesStartPage_Back":
        		$A.util.addClass(component.find("MWGuidesSolution_Div"),'toggle');  // Hide screen
                $A.util.addClass(component.find("MWGuidesIntercomAnywhere_Div"),'toggle');  // Hide screen
                $A.util.addClass(component.find("MWGuidesProgram_Div"),'toggle');  // Hide screen
                $A.util.addClass(component.find("MWVoiceControl_Div"),'toggle');  // Hide screen
                $A.util.addClass(component.find("MWGuidesElectHVAC_Div"),'toggle');  // Hide screen
                
        		$A.util.removeClass(component.find("MWGuidesBegin_Div"),'toggle'); // Unhide screen
                break;                  
            case "ElectricianClick":
        		$A.util.addClass(component.find("MWGuidesElectHVAC_Div"),'toggle');  // Hide screen       
        		$A.util.removeClass(component.find("MWGuidesElect_Div"),'toggle'); // Unhide screen
                break;   

                analyticsAction = 'Electrician & HVAC Pros';
                analyticsLabel = 'Electrician';    
            case "HVACClick":
        		$A.util.addClass(component.find("MWGuidesElectHVAC_Div"),'toggle');  // Hide screen       
        		$A.util.removeClass(component.find("MWGuidesHVAC_Div"),'toggle'); // Unhide screen
                
                analyticsAction = 'Electrician & HVAC Pros';
                analyticsLabel = 'HVAC Pros'; 
                break;                   
            case "MWGuidesElec_Back":
        		$A.util.addClass(component.find("MWGuidesElect_Div"),'toggle');  // Hide screen       
        		$A.util.removeClass(component.find("MWGuidesElectHVAC_Div"),'toggle'); // Unhide screen
                break; 
            case "MWGuidesHVAC_Back":
        		$A.util.addClass(component.find("MWGuidesHVAC_Div"),'toggle');  // Hide screen       
        		$A.util.removeClass(component.find("MWGuidesElectHVAC_Div"),'toggle'); // Unhide screen
                break;                
                
            case "Modal_Close":
				component.find("overlayLib2").notifyClose();
             break;
        }
        
        helper.LogAnalytics(analyticsAction, analyticsLabel); 
    }
})