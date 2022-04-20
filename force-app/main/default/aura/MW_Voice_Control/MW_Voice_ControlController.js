({
    doInit : function(component, event, helper) {
        
        $A.util.addClass(component.find("MWVoiceControlGetStarted_Div"),'toggle');
        $A.util.addClass(component.find("MWVoiceControlCustScreenNames_Div"),'toggle'); 
        $A.util.addClass(component.find("MWVoiceControlAlexa_Div"),'toggle');
        $A.util.addClass(component.find("MWVoiceControlGoogleAssistant_Div"),'toggle');
        
        helper.LogAnalytics('Voice Control', 'Home'); 
    },	
    
    handleBubbling : function(component, event, helper)  {
        var analyticsAction = '';
        var analyticsLabel = '';       
        var params = event.getParams();
        var navigateAction = params.ComponentAction;
        //var previousScreen = params.PreviousScreen;
        //console.log("navigateAction: " + navigateAction);		
        
        switch (navigateAction) {
            case "GettingStartedClick":                
                $A.util.addClass(component.find("MWVoiceControlAlexa_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWVoiceControlGetStarted_Div"),'toggle'); // Unhide screen
                analyticsAction = 'Getting Started Video';
                analyticsLabel = 'Alexa Getting Started Video';                 
                break;
            case "CustScreenNamesClick":
                $A.util.addClass(component.find("MWVoiceControlAlexa_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWVoiceControlCustScreenNames_Div"),'toggle'); // Unhide screen
                analyticsAction = 'Customizing Screen Names';
                analyticsLabel = 'Alexa Customizing Screen Names';  
                break;
            case "AlexaClick":
                $A.util.addClass(component.find("MWVoiceControlBegin_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWVoiceControlAlexa_Div"),'toggle'); // Unhide screen
                analyticsAction = 'Home';
                analyticsLabel = 'Alexa';                 
                break;
            case "GoogleAssistantClick":
                $A.util.addClass(component.find("MWVoiceControlBegin_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWVoiceControlGoogleAssistant_Div"),'toggle'); // Unhide screen
                analyticsAction = 'Home';
                analyticsLabel = 'Google';
                break;
            case "QuickStartGuideClick":
                //Log analytics before opening new window
                helper.LogAnalytics('Quick Start Guide', 'Alexa Quick Start Guide (Button Click)'); 
                window.open('https://www.control4.com/docs/product/alexa/quick-start-guide/english/latest/alexa-quick-start-guide-rev-b.pdf','_blank');       
                break;
            case "SetupClick":
                helper.LogAnalytics('Google Setup', 'Google Setup (Button Click)'); 
                window.open('http://ctrl4.co/voice-setup','_blank');       
                break;
            case "UsingClick":
                helper.LogAnalytics('Google Using', 'Google Using (Button Click)'); 
                window.open('http://ctrl4.co/voice-ug','_blank');       
                break;
            case "FAQClick":
                helper.LogAnalytics('Google FAQ', 'Google FAQ (Button Click)'); 
                window.open('http://ctrl4.co/voice-faq','_blank');       
                break;
            case "CustomerFAQsClick":
                //Log analytics before opening new window
                helper.LogAnalytics('Customer FAQs', 'Alexa Customer FAQs (Button Click)'); 
                window.open('https://www.control4.com/docs/product/alexa/frequently-asked-questions/english/latest/alexa-frequently-asked-questions-rev-f.pdf','_blank');
                break;
            case "MWVoiceControlGetStarted_Back":
                $A.util.addClass(component.find("MWVoiceControlGetStarted_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWVoiceControlAlexa_Div"),'toggle'); // Unhide screen
                break;
            case "MWVoiceControlCustScreenNames_Back":
                $A.util.addClass(component.find("MWVoiceControlCustScreenNames_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWVoiceControlAlexa_Div"),'toggle'); // Unhide screen
                break;
            case "MWVoiceControlAlexa_Back":
                $A.util.addClass(component.find("MWVoiceControlAlexa_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWVoiceControlBegin_Div"),'toggle'); // Unhide screen
                break;
            case "MWVoiceControlGoogleAssistant_Back":
                $A.util.addClass(component.find("MWVoiceControlGoogleAssistant_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWVoiceControlBegin_Div"),'toggle'); // Unhide screen
                break;
            case "VoiceControl_BacktoMainScreen":
                $A.util.addClass(component.find("MWVoiceControlGetStarted_Div"),'toggle');  // Hide screen
                $A.util.addClass(component.find("MWVoiceControlCustScreenNames_Div"),'toggle');  // Hide screen                
                $A.util.removeClass(component.find("MWVoiceControlBegin_Div"),'toggle'); // Unhide screen
                break;               
                
            case "Modal_Close":
                component.find("overlayLib2").notifyClose();
                break;
        }
        
        helper.LogAnalytics(analyticsAction, analyticsLabel); 
    }
})