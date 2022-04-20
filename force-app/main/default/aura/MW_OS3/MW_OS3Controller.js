({
    doInit : function(component, event, helper) {        
        var hideScreen = component.find("OS3Videos_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3Guides_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3App_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3ConnectionIssues_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3Wifi_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiHome_Div");
        $A.util.addClass(hideScreen,'toggle');        
        hideScreen = component.find("OS3WifiAway_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3ChooseController_Div");
        $A.util.addClass(hideScreen,'toggle');        
        hideScreen = component.find("OS3WifiStep1_Div");
        $A.util.addClass(hideScreen,'toggle');        
        hideScreen = component.find("OS3Connected_Div");
        $A.util.addClass(hideScreen,'toggle');     
        hideScreen = component.find("OS3WifiStep2No_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiIOS_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerIOS1_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerIOS2_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerIOS3_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerIOS4_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerIOS5_Div");
        $A.util.addClass(hideScreen,'toggle');         
        hideScreen = component.find("OS3WifiAndroid_Div");
        $A.util.addClass(hideScreen,'toggle');        
        hideScreen = component.find("OS3WifiPowerAndroid1_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerAndroid2_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerAndroid3_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerAndroid4_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3WifiPowerAndroid5_Div");
        $A.util.addClass(hideScreen,'toggle'); 
        hideScreen = component.find("OS3EA5_Div");
        $A.util.addClass(hideScreen,'toggle'); 
        hideScreen = component.find("OS3EA3_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3EA1_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3CA10_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3CA1_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3HC800_Div");
        $A.util.addClass(hideScreen,'toggle');        
        hideScreen = component.find("OS3IDK_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3ContactDealer_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3SystemRestart_Div");
        $A.util.addClass(hideScreen,'toggle');
        hideScreen = component.find("OS3C4SystemRestart_Div");
        $A.util.addClass(hideScreen,'toggle');
        helper.LogAnalytics('OS3', 'Home');
    },	
    
    handleBubbling : function(component, event, helper) {
        var analyticsAction = '';
        var analyticsLabel = '';
        var params = event.getParams();
        var navigateAction = params.ComponentAction;
        var previousScreens = [];
        previousScreens = component.get("v.PreviousScreens");
        
        switch (navigateAction) {
            case "VideosClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen
                $A.util.removeClass(component.find("OS3Videos_Div"),'toggle'); // Unhide screen                
                previousScreens.push("OS3Videos_Div");                
                analyticsAction = 'How To Videos';
                analyticsLabel = 'Home';                
                break;
            case "GuidesClick":                             
                analyticsAction = 'User Guide';
                analyticsLabel = 'User Guide (Button Click)';  
                window.open('http://Ctrl4.co/userguide');                              
                break;
            case "AppClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3App_Div"),'toggle'); // Unhide screen               
                previousScreens.push("OS3App_Div");
                analyticsAction = 'OS 3 App';
                analyticsLabel = 'Download OS 3 App'; 
                break;
            case "ConnectionClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3ConnectionIssues_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3ConnectionIssues_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Connection Issues'; 
                break;
            case "WifiClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3Wifi_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3Wifi_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Home or Away';
                break;
            case "WifiHomeClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiHome_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiHome_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | 3 Steps';
                break;
            case "WifiAwayClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiAway_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiAway_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Get 4Sight';
                break;
            case "WifiStep1Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiStep1_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiStep1_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Step 1 (WiFi)';                
                break;
            case "OS3ConnectedClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3Connected_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3Connected_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App'; 
                break;
            case "WifiStep2NoClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiStep2No_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiStep2No_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Skip to Step 2 (Button Click)';
                break;
            case "WifiIOSClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiIOS_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiIOS_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | iOS Email & Password';
                break;
            case "WifiIOS1Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerIOS1_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerIOS1_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | iOS Step 1';
                break;
            case "WifiIOS2Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerIOS2_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerIOS2_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | iOS Step 2';
                break;
            case "WifiIOS3Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerIOS3_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerIOS3_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | iOS Step 3';
                break;
            case "WifiIOS4Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerIOS4_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerIOS4_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | iOS Step 4';
                break;
            case "WifiIOS5Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerIOS5_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerIOS5_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | iOS Step 5';
                break;
            case "WifiAndroidClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiAndroid_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiAndroid_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Android Email & Password';
                break;
            case "WifiAndroid1Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerAndroid1_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerAndroid1_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Android Step 1';
                break;
            case "WifiAndroid2Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerAndroid2_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerAndroid2_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Android Step 2';
                break;
            case "WifiAndroid3Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerAndroid3_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerAndroid3_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Android Step 3';
                break;
            case "WifiAndroid4Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerAndroid4_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerAndroid4_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Android Step 4';
                break;
            case "WifiAndroid5Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3WifiPowerAndroid5_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3WifiPowerAndroid5_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | Android Step 5';
                break;
            case "ChooseControllerClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3ChooseController_Div"),'toggle'); // Unhide screen
                
                if(previousScreens[previousScreens.length-1] === "OS3C4SystemRestart_Div" || previousScreens[previousScreens.length-1] === "OS3SystemRestart_Div" ){
                    component.set("v.title","Unable to Connect");
                } else {
					component.set("v.title","Unable to Connect - Step 3");                    
                    helper.LogAnalytics('Connection Issues', 'UTC | Skip to Step 3 (Button Click)');                  
                }
                previousScreens.push("OS3ChooseController_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Choose Controller';
                break;
            case "EA5Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3EA5_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3EA5_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Restart EA-5';
                break;         
            case "EA3Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3EA3_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3EA3_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Restart EA-3';
                break;       
            case "EA1Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3EA1_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3EA1_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Restart EA-1';
                break;  
            case "CA10Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3CA10_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3CA10_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Restart CA-10';
                break;  
            case "CA1Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3CA1_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3CA1_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Restart CA-1';
                break;     
            case "HC800Click":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3HC800_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3HC800_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Restart HC-800';
                break;      
            case "IDKClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3IDK_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3IDK_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'IDK';                
                break;            
            case "Controller_YesClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3Connected_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3Connected_Div");
                break;            
            case "Controller_NoClick":
                if(previousScreens.indexOf("OS3Wifi_Div") > -1){
                    window.open('https://www.control4.com/company/contact-us/support');                    
                }else{
                    $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                    $A.util.removeClass(component.find("OS3ContactDealer_Div"),'toggle'); // Unhide screen
                    previousScreens.push("OS3ContactDealer_Div");
                    break;                     
                }
                break;            
            case "ContactDealClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3ContactDealer_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3ContactDealer_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Contact Dealer | App';                
                break;
            case "SystemClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3SystemRestart_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3SystemRestart_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | 500';
                break;
            case "C4SystemClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3C4SystemRestart_Div"),'toggle'); // Unhide screen
                previousScreens.push("OS3C4SystemRestart_Div");
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'UTC | 403';
                break;
                
                
            case "BackClick":
                $A.util.addClass(component.find(previousScreens[previousScreens.length-1]),'toggle');  // Hide screen
                
                previousScreens.pop();
                
                $A.util.removeClass(component.find(previousScreens[previousScreens.length-1]),'toggle'); // Unhide screen
                break;
                
            case "Modal_Close":
                component.find("overlayLib2").notifyClose();
                break;
                
        }
        
        helper.LogAnalytics(analyticsAction, analyticsLabel); 
    }
})