({
    doInit : function(component, event, helper) {
        //console.log('Init is being ran');
        
        var hideScreen = component.find("AccountEmailValidation_Div");
        $A.util.addClass(hideScreen,'toggle');	
        hideScreen = component.find("AccountForgotPassword_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("AccountDealerOfRecord_Div");
        $A.util.addClass(hideScreen,'toggle');               
        hideScreen = component.find("Account4Sight_Div");
        $A.util.addClass(hideScreen,'toggle'); 
        hideScreen = component.find("Account4SightGetNow_Div");
        $A.util.addClass(hideScreen,'toggle');       
        hideScreen = component.find("Account4SightTaxError_Div");
        $A.util.addClass(hideScreen,'toggle');   
        hideScreen = component.find("Account4SightCancel_Div");
        $A.util.addClass(hideScreen,'toggle');   
        hideScreen = component.find("Account4SightCreditCard_Div");
        $A.util.addClass(hideScreen,'toggle'); 
        
        helper.LogAnalytics('Account', 'Home');       
    },
    
    handleBubbling : function(component, event, helper) {
        
        var analyticsAction = '';
        var analyticsLabel = '';
        var params = event.getParams();
        var navigateAction = params.ComponentAction;
        var previousScreen = params.PreviousScreen;
        //console.log("navigateAction: " + navigateAction);     
      
        switch (navigateAction) {
            case "ForgotPasswordClick":
                $A.util.addClass(component.find("AccountBegin_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("AccountForgotPassword_Div"),'toggle'); // Unhide screen

                analyticsAction = 'Forgot Password';
                analyticsLabel = 'Request Password Reset';                
                break;
            case "ResetPasswordButtonClick":
                analyticsAction = '4Sight';
                analyticsLabel = 'Request Password Reset(Button Click)';              
              break;                   
            case "DealerOfRecordClick":
                $A.util.addClass(component.find("AccountBegin_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("AccountDealerOfRecord_Div"),'toggle'); // Unhide screen
                
                analyticsAction = 'Change Smart Home Pro';
                analyticsLabel = 'Change Pro';     
                break;
            case "Sight4Click":
                $A.util.addClass(component.find("AccountBegin_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4Sight_Div"),'toggle'); // Unhide screen
                
                analyticsAction = '4Sight';
                analyticsLabel = '4Sight';                     
                break; 
            case "Get4SightNow":
                $A.util.addClass(component.find("Account4Sight_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4SightGetNow_Div"),'toggle'); // Unhide screen
                
                analyticsAction = '4Sight';
                analyticsLabel = 'Get 4Sight Now';                   
                break;
            case "Account4SightTaxError":
                $A.util.addClass(component.find("Account4Sight_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4SightTaxError_Div"),'toggle'); // Unhide screen   

                analyticsAction = '4Sight';
                analyticsLabel = 'Tax Error';                   
                break;
            case "Account4SightCancel":
                $A.util.addClass(component.find("Account4Sight_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4SightCancel_Div"),'toggle'); // Unhide screen
                
                analyticsAction = '4Sight';
                analyticsLabel = 'Cancel 4Sight';                     
                break;                  
                case "Account4SightCreditCard":
                $A.util.addClass(component.find("Account4Sight_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4SightCreditCard_Div"),'toggle'); // Unhide screen

                analyticsAction = '4Sight';
                analyticsLabel = 'Update Credit Card';                   
                break;             
            case "AccountForgotPassword_Back":
                $A.util.addClass(component.find("AccountForgotPassword_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("AccountBegin_Div"),'toggle'); // Unhide screen        		
                break;    
            case "AccountDealerOfRecord_Back":
                $A.util.addClass(component.find("AccountDealerOfRecord_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("AccountBegin_Div"),'toggle'); // Unhide screen        		
                break;  
            case "Account4Sight_Back":
                $A.util.addClass(component.find("Account4Sight_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("AccountBegin_Div"),'toggle'); // Unhide screen        		
                break;              
            case "Account4SightGetNow_Back":
                $A.util.addClass(component.find("Account4SightGetNow_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4Sight_Div"),'toggle'); // Unhide screen        		
                break;  
            case "Account4SightTaxError_Back":
                $A.util.addClass(component.find("Account4SightTaxError_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4Sight_Div"),'toggle'); // Unhide screen        		
                break;        
            case "Account4SightCancel_Back":
                $A.util.addClass(component.find("Account4SightCancel_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4Sight_Div"),'toggle'); // Unhide screen        		
                break;
            case "Account4SightCreditCard_Back":
                $A.util.addClass(component.find("Account4SightCreditCard_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("Account4Sight_Div"),'toggle'); // Unhide screen
                break;              
                
                case "Modal_Close":
                component.find("overlayLib2").notifyClose();
                break; 
        }        
        
        helper.LogAnalytics(analyticsAction, analyticsLabel); 
    }
})