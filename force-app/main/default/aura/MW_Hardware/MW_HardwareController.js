({
    doInit : function(component, event, helper) {       
        $A.util.addClass(component.find("MWHardwareNeeo_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareNeeoGuide_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareNeeoQuickTips_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareNeeoQuickTipsRestart_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareNeeoQuickTipsReset_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareNeeoTS_Div"),'toggle');        
        $A.util.addClass(component.find("MWHardwareNeeoTSNE_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareNeeoTSNEStep1_Div"),'toggle');    
        $A.util.addClass(component.find("MWHardwareNeeoTSNEStep2_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareNeeoTSNEStep3_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');       
        $A.util.addClass(component.find("MWHardwareNeeoTSAR_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareNeeoTSOther_Div"),'toggle');   
        $A.util.addClass(component.find("MWAppSuccess_Div"),'toggle');       
        $A.util.addClass(component.find("MWHardwareWatch_Div"),'toggle');       
        $A.util.addClass(component.find("MWHardwareWatchRem_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemReboot_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');        
        $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');       
        $A.util.addClass(component.find("MWHardwareWatchNewDevice_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchQuickStart_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareWatchRemRebootNContactDealer_Div"),'toggle');       
        $A.util.addClass(component.find("MWHardwareListen_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareListenEntGuide_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareListenNoSound_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareListenMusic_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareListenMusicDriver_Div"),'toggle');      
        $A.util.addClass(component.find("MWHardwareLighting_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTS_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTSAPD120_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTSKD120_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTSLDZ101_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTSK6_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTSSuccess_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTSContactDealer_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTSElectrician_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareLightingTSLightSolutions_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfort_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfortC4ThermV2_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfortC4ThermV2Reboot_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfortC4ThermV1_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfortC4ThermV1Reboot_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfortC4ThermSuccess_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfortC4ThermContactDealer_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfortHVAC_Div"),'toggle');
        $A.util.addClass(component.find("MWHardwareComfortQuickStart_Div"),'toggle');
        $A.util.addClass(component.find("OS3IDK_Div"),'toggle');
        
        helper.LogAnalytics('Products', 'Home');    
    },    
    handleBubbling : function(component, event, helper) {        
        
        var analyticsAction = '';
        var analyticsLabel = '';
        var params = event.getParams();
        var navigateAction = params.ComponentAction;      
        
        switch (navigateAction) {        
            case "NeeoClick":
                $A.util.addClass(component.find("MWHardwareBegin_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeo_Div"),'toggle');             
                break;
            case "WatchClick":
                $A.util.addClass(component.find("MWHardwareBegin_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatch_Div"),'toggle'); 
                
                analyticsAction = 'Watch';
                analyticsLabel = 'Watch';                
                break;
            case "ListenClick":
                $A.util.addClass(component.find("MWHardwareBegin_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListen_Div"),'toggle'); 
                
                analyticsAction = 'Listen';
                analyticsLabel = 'Listen'; 
                break;     
            case "LightingClick":
                $A.util.addClass(component.find("MWHardwareBegin_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLighting_Div"),'toggle'); 
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Lighting'; 
                break;     
            case "ComfortClick":              
                $A.util.addClass(component.find("MWHardwareBegin_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareComfort_Div"),'toggle'); 
                
                analyticsAction = 'Comfort';
                analyticsLabel = 'Comfort';                 
                break;               
            case "RemoteTroubleshootingClick":              
                $A.util.addClass(component.find("MWHardwareWatch_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatchRem_Div"),'toggle'); 
                
                analyticsAction = 'Watch';
                analyticsLabel = 'Remote Troubleshoot';
                break;
            case "NewDeviceClick":              
                $A.util.addClass(component.find("MWHardwareWatch_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatchNewDevice_Div"),'toggle'); 
                
                analyticsAction = 'Watch';
                analyticsLabel = 'New Device'; 
                break;
            case "QuickStartClick":              
                $A.util.addClass(component.find("MWHardwareWatch_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareWatchQuickStart_Div"),'toggle');
                
                analyticsAction = 'Watch';
                analyticsLabel = 'Quick Start Guide';
                break;
            case "MWHardwareNeeoGuideClick":                 
                $A.util.addClass(component.find("MWHardwareNeeo_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoGuide_Div"),'toggle'); 
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'User Guide Home';
                break;   
            case "MWHardwareNeeoGuide_Back":                 
                $A.util.addClass(component.find("MWHardwareNeeoGuide_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareNeeo_Div"),'toggle');
                break;               
            case "MWHardwareNeeoLearnMoreClick":
                window.open('https://www.control4.com/o/neeo','_blank');  
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Learn More (Button Click)';
                break;                
            case "MWHardwareNeeoQTClick":
                $A.util.addClass(component.find("MWHardwareNeeo_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareNeeoQuickTips_Div"),'toggle');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Quick Tips Home';
                break;                
            case "MSHardwareNeeoQTFAQ":
                window.open('https://www.control4.com/help/c4/user/userguide/#topics/interfaces/neeo/neeo_faq.htm','_blank');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Neeo FAQ (Button Click)';
                break;        
            case "MSHardwareNeeoQTRestart":
                $A.util.addClass(component.find("MWHardwareNeeoQuickTips_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareNeeoQuickTipsRestart_Div"),'toggle');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Quick Tips - Restart Remote';
                break;                
            case "MSHardwareNeeoQTReset":
                $A.util.addClass(component.find("MWHardwareNeeoQuickTips_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareNeeoQuickTipsReset_Div"),'toggle');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Quick Tips - Remote Restart';
                break;              
            case "MWHardwareNeeo_Back":
                $A.util.addClass(component.find("MWHardwareNeeo_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareBegin_Div"),'toggle');                    
                break;                
            case "MSHardwareNeeoQuickTips_Back":
                $A.util.addClass(component.find("MWHardwareNeeoQuickTips_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeo_Div"),'toggle');                    
                break;                    
            case "MSHardwareNeeoQuickTipsRestart_Back":
                $A.util.addClass(component.find("MWHardwareNeeoQuickTipsRestart_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoQuickTips_Div"),'toggle');                    
                break;         
            case "MSHardwareNeeoQuickTipsReset_Back":
                $A.util.addClass(component.find("MWHardwareNeeoQuickTipsReset_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoQuickTips_Div"),'toggle');                    
                break;
            case "MSHardwareNeeoTS_Back":
                $A.util.addClass(component.find("MWHardwareNeeoTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeo_Div"),'toggle');   
                break;
            case "MSHardwareNeeoTSOther_Back":
                $A.util.addClass(component.find("MWHardwareNeeoTSOther_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTS_Div"),'toggle');   
                break;              
            case "MSHardwareNeeoTSAR_Back":
                $A.util.addClass(component.find("MWHardwareNeeoTSAR_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTS_Div"),'toggle');   
                break;  
            case "MSHardwareNeeoTSNE_Back":
                $A.util.addClass(component.find("MWHardwareNeeoTSNE_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTS_Div"),'toggle');   
                break;               
            case "MWHardwareNeeoTSClick":
                $A.util.addClass(component.find("MWHardwareNeeo_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTS_Div"),'toggle');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Troubleshoot Home';               
                break;                 
            case "NeeoTSNEClick":
                $A.util.addClass(component.find("MWHardwareNeeoTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNE_Div"),'toggle');  
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Network Error Home';     
                break;
            case "NeeoTSARClick":
                $A.util.addClass(component.find("MWHardwareNeeoTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSAR_Div"),'toggle');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Authentication Required';  
                break;
            case "NeeoTSOtherClick":
                $A.util.addClass(component.find("MWHardwareNeeoTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSOther_Div"),'toggle');

                analyticsAction = 'Neeo';
                analyticsLabel = 'Contract Pro (Other)'; 
                break;
            case "MSHardwareNeeoNENext":
                $A.util.addClass(component.find("MWHardwareNeeoTSNE_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep1_Div"),'toggle');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'N.E. 1 - Remote Location';
                break;                
            case "MSHardwareNeeoTSNEStep1_Back":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep1_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNE_Div"),'toggle');   
                break;
            case "MSHardwareNeeoTSNEStep1_Y":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep1_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');               
                component.set("v.PreviousScreen", 'MWHardwareNeeoTSNEStep1_Div');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Neeo Success';
                break;                
            case "MSHardwareNeeoTSNEStep1_N":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep1_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep2_Div"),'toggle');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'N.E. 2 - Restart Remote';
                break;
            case "MSHardwareNeeoTSNEStep2_Back":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep2_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep1_Div"),'toggle');   
                break;
            case "MSHardwareNeeoTSNEStep2_Y":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep2_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');               
                component.set("v.PreviousScreen", 'MWHardwareNeeoTSNEStep2_Div');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Neeo Success';
                break;                
            case "MSHardwareNeeoTSNEStep2_N":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep2_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep3_Div"),'toggle');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'N.E. 3 - Restart Router';
                break;
            case "MSHardwareNeeoTSNEStep3_Back":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep3_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep2_Div"),'toggle');   
                break;
            case "MSHardwareNeeoTSNEStep3_Y":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep3_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');               
                component.set("v.PreviousScreen", 'MWHardwareNeeoTSNEStep3_Div');
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'Neeo Success';
                break;                
            case "MSHardwareNeeoTSNEStep3_N":
                $A.util.addClass(component.find("MWHardwareNeeoTSNEStep3_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');               
                component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div'); 
                
                analyticsAction = 'Neeo';
                analyticsLabel = 'N.E. 4 - Reboot C4';
                break;
            case "MWAppConControllers_Back":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep3_Div"),'toggle');  
                break;               
            case "MWAppSuccess_Back":	                
                $A.util.addClass(component.find("MWAppSuccess_Div"),'toggle');        		
                if (component.get("v.PreviousScreen") == "MWHardwareNeeoTSNEStep1_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep1_Div"),'toggle');  
                }
                if (component.get("v.PreviousScreen") == "MWHardwareNeeoTSNEStep2_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep2_Div"),'toggle');  
                }               
                if (component.get("v.PreviousScreen") == "MWHardwareNeeoTSNEStep3_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep3_Div"),'toggle');  
                } 
                if (component.get("v.PreviousScreen") == "MWHardwareWatchRemRebootNEA5_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');  
                    component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div');
                }
                if (component.get("v.PreviousScreen") == "MWHardwareWatchRemRebootNEA3_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');  
                    component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div');
                }
                if (component.get("v.PreviousScreen") == "MWHardwareWatchRemRebootNEA1_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');  
                    component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div');
                }   
                if (component.get("v.PreviousScreen") == "MWHardwareWatchRemRebootNCA10_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');  
                    component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div');
                }   
                if (component.get("v.PreviousScreen") == "MWHardwareWatchRemRebootNCA1_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');  
                    component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div');
                }
                if (component.get("v.PreviousScreen") == "MWHardwareWatchRemRebootNHC250_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');  
                    component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div');
                } 
                if (component.get("v.PreviousScreen") == "MWHardwareWatchRemRebootNHC800_Div")
                {
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');  
                    component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div');
                } 
                break;              
            case "MWHardwareWatch_Back":              
                $A.util.addClass(component.find("MWHardwareWatch_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareBegin_Div"),'toggle'); 
                break;  
            case "MWHardwareListen_Back":              
                $A.util.addClass(component.find("MWHardwareListen_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareBegin_Div"),'toggle'); 
                break;  
            case "MWHardwareLighting_Back":              
                $A.util.addClass(component.find("MWHardwareLighting_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareBegin_Div"),'toggle'); 
                break; 
            case "MWHardwareLightingTS_Back":              
                $A.util.addClass(component.find("MWHardwareLightingTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLighting_Div"),'toggle'); 
                break;               
            case "MWHardwareWatchRem_Yes":              
                $A.util.addClass(component.find("MWHardwareWatchRem_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatchRemReboot_Div"),'toggle'); 
                component.set("v.RemoteTroubleshootIconAnswer", 'Yes'); // This is because both yes and no go to the same screen. This matters later in the path.
                
                analyticsAction = 'Watch';
                analyticsLabel = 'Restart Remote';
                break;
            case "MWHardwareWatchRem_No":              
                $A.util.addClass(component.find("MWHardwareWatchRem_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatchRemReboot_Div"),'toggle'); 
                component.set("v.RemoteTroubleshootIconAnswer", 'No'); // This is because both yes and no go to the same screen.  This matters later in the path.
                
                analyticsAction = 'Watch';
                analyticsLabel = 'Restart Remote';
                break;
            case "MWHardwareWatchRem_Back":              
                $A.util.addClass(component.find("MWHardwareWatchRem_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatch_Div"),'toggle'); 
                break;
            case "MWHardwareWatchRemReboot_Back":              
                $A.util.addClass(component.find("MWHardwareWatchRemReboot_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatchRem_Div"),'toggle'); 
                break;                
            case "MWHardwareWatchRemReboot_Yes":              
                $A.util.addClass(component.find("MWHardwareWatchRemReboot_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWHardwareWatchRemReboot_Div'); 
                
                analyticsAction = 'Watch';
                analyticsLabel = 'Controller Restart | Success';
                break;     
            case "MWHardwareWatchRemReboot_No":              
                $A.util.addClass(component.find("MWHardwareWatchRemReboot_Div"),'toggle');               
                if (component.get("v.RemoteTroubleshootIconAnswer") == "Yes")
                {
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');                     
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Choose Controller';
                }
                if (component.get("v.RemoteTroubleshootIconAnswer") == "No")
                {
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemReboot_Div');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNContactDealer_Div"),'toggle'); 
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Contact Dealer | Remote';
                }
                break;     
            case "MWHardwareWatchRemRebootY_Back":              
                $A.util.addClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');        		
                $A.util.removeClass(component.find(component.get("v.PreviousScreen")),'toggle');    
                break;
            case "MWHardwareWatchRemRebootN_Back":              
                $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatchRemReboot_Div"),'toggle'); 
                break;
            case "MWHardwareWatchNewDevice_Back":              
                $A.util.addClass(component.find("MWHardwareWatchNewDevice_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatch_Div"),'toggle'); 
                break;
            case "MWHardwareWatchQuickStart_Back":              
                $A.util.addClass(component.find("MWHardwareWatchQuickStart_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareWatch_Div"),'toggle'); 
                break;
            case "EntertainmentGuideClick":              
                $A.util.addClass(component.find("MWHardwareListen_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListenEntGuide_Div"),'toggle'); 
                
                analyticsAction = 'Listen';
                analyticsLabel = 'Entertainment Guide';
                break;  
            case "NoSoundClick":              
                $A.util.addClass(component.find("MWHardwareListen_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListenNoSound_Div"),'toggle'); 
                
                analyticsAction = 'Listen';
                analyticsLabel = 'No Source';
                break;  
            case "MusicServicesClick":              
                $A.util.addClass(component.find("MWHardwareListen_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListenMusic_Div"),'toggle'); 
                
                analyticsAction = 'Listen';
                analyticsLabel = 'Music Services';
                break;                
            case "MusicServicesDriverClick":              
                $A.util.addClass(component.find("MWHardwareListenMusic_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListenMusicDriver_Div"),'toggle'); 
                
                analyticsAction = 'Listen';
                analyticsLabel = 'Control4 Music Driver';
                break;
            case "MWHardwareListenMusicDriver_Back":              
                $A.util.addClass(component.find("MWHardwareListenMusicDriver_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListenMusic_Div"),'toggle'); 
                break;               
            case "MWHardwareListen_Back":              
                $A.util.addClass(component.find("MWHardwareListen_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareBegin_Div"),'toggle'); 
                break;                
            case "MWHardwareListenEntGuide_Back":              
                $A.util.addClass(component.find("MWHardwareListenEntGuide_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListen_Div"),'toggle'); 
                break;  
            case "MWHardwareListenNoSound_Back":              
                $A.util.addClass(component.find("MWHardwareListenNoSound_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListen_Div"),'toggle'); 
                break; 
            case "MWHardwareListenMusic_Back":              
                $A.util.addClass(component.find("MWHardwareListenMusic_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareListen_Div"),'toggle'); 
                break;                 
            case "MWHardwareLightingTSElectrician_Back":              
                $A.util.addClass(component.find("MWHardwareLightingTSElectrician_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLighting_Div"),'toggle'); 
                break; 
            case "MWHardwareLightingTSLightSolutions_Back":              
                $A.util.addClass(component.find("MWHardwareLightingTSLightSolutions_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLighting_Div"),'toggle'); 
                break;               
            case "TroubleShootingClick":              
                $A.util.addClass(component.find("MWHardwareLighting_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTS_Div"),'toggle'); 
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Troubleshooting'; 
                break;  
            case "ElectricianClick":              
                $A.util.addClass(component.find("MWHardwareLighting_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTSElectrician_Div"),'toggle'); 
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Electrician'; 
                break;  
            case "LightingSolutionsClick":              
                $A.util.addClass(component.find("MWHardwareLighting_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTSLightSolutions_Div"),'toggle'); 
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Lightning Guide'; 
                break;  
            case "MWHardwareLightingTSAPD120_Back":              
                $A.util.addClass(component.find("MWHardwareLightingTSAPD120_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTS_Div"),'toggle'); 
                break;  
            case "MWHardwareLightingTSKD120_Back":              
                $A.util.addClass(component.find("MWHardwareLightingTSKD120_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTS_Div"),'toggle'); 
                break;
            case "MWHardwareLightingTSLDZ101_Back":              
                $A.util.addClass(component.find("MWHardwareLightingTSLDZ101_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTS_Div"),'toggle'); 
                break;
            case "MWHardwareLightingTSK6_Back":              
                $A.util.addClass(component.find("MWHardwareLightingTSK6_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTS_Div"),'toggle'); 
                break;
            case "APD120Click":              
                $A.util.addClass(component.find("MWHardwareLightingTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTSAPD120_Div"),'toggle'); 
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Restart Dimmer';
                break;  
            case "KD120Click":              
                $A.util.addClass(component.find("MWHardwareLightingTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTSKD120_Div"),'toggle'); 
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Restart Keypad';
                break;  
            case "LDZ101Click":              
                $A.util.addClass(component.find("MWHardwareLightingTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTSLDZ101_Div"),'toggle'); 
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Restart Dimmer Legacy';
                break;  
            case "K6Click":              
                $A.util.addClass(component.find("MWHardwareLightingTS_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTSK6_Div"),'toggle'); 
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Restart Keypad Legacy';
                break;                
            case "MWHardwareLightingTSAPD120_Success":              
                $A.util.addClass(component.find("MWHardwareLightingTSAPD120_Div"),'toggle');               
                $A.util.removeClass(component.find("MWHardwareLightingTSSuccess_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWHardwareLightingTSAPD120_Div');
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Restart Success';
                break;
            case "MWHardwareLightingTSAPD120_ContactDealer":              
                $A.util.addClass(component.find("MWHardwareLightingTSAPD120_Div"),'toggle');        		
                $A.util.removeClass(component.find("MWHardwareLightingTSContactDealer_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWHardwareLightingTSAPD120_Div');
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Contact Dealer';
                break;                
            case "MWHardwareLightingTSKD120_Success":              
                $A.util.addClass(component.find("MWHardwareLightingTSKD120_Div"),'toggle');               
                $A.util.removeClass(component.find("MWHardwareLightingTSSuccess_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWHardwareLightingTSKD120_Div');
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Restart Success';
                break;
            case "MWHardwareLightingTSKD120_ContactDealer":              
                $A.util.addClass(component.find("MWHardwareLightingTSKD120_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareLightingTSContactDealer_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareLightingTSKD120_Div');
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Contact Dealer';
                break;
            case "MWHardwareLightingTSLDZ101_Success":              
                $A.util.addClass(component.find("MWHardwareLightingTSLDZ101_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareLightingTSSuccess_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareLightingTSLDZ101_Div');
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Restart Success';
                break;
            case "MWHardwareLightingTSLDZ101_ContactDealer":              
                $A.util.addClass(component.find("MWHardwareLightingTSLDZ101_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareLightingTSContactDealer_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareLightingTSLDZ101_Div');
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Contact Dealer';
                break;
            case "MWHardwareLightingTSK6_Success":              
                $A.util.addClass(component.find("MWHardwareLightingTSK6_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareLightingTSSuccess_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareLightingTSK6_Div');
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Restart Success';
                break;
            case "MWHardwareLightingTSK6_ContactDealer":              
                $A.util.addClass(component.find("MWHardwareLightingTSK6_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareLightingTSContactDealer_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareLightingTSK6_Div');
                
                analyticsAction = 'Lighting';
                analyticsLabel = 'Contact Dealer';
                break;
            case "MWHardwareLightingTSSuccess_Back":                
                $A.util.addClass(component.find("MWHardwareLightingTSSuccess_Div"),'toggle');
                $A.util.removeClass(component.find(component.get("v.PreviousScreen")),'toggle');
                break;
            case "MWHardwareLightingTSContactDealer_Back":                
                $A.util.addClass(component.find("MWHardwareLightingTSContactDealer_Div"),'toggle');
                $A.util.removeClass(component.find(component.get("v.PreviousScreen")),'toggle');
                break;
            case "ThermV2Click":                
                $A.util.addClass(component.find("MWHardwareComfort_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermV2_Div"),'toggle');
                break;                        
            case "ThermV1Click":                
                $A.util.addClass(component.find("MWHardwareComfort_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermV1_Div"),'toggle');
                
                analyticsAction = 'Thermostat V1';
                analyticsLabel = 'Thermostat V1'; 
                break;    
            case "HVACClick":                
                $A.util.addClass(component.find("MWHardwareComfort_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortHVAC_Div"),'toggle');
                
                analyticsAction = 'Comfort';
                analyticsLabel = 'HVAC Pros'; 
                break;    
            case "ComfortQuickStartClick":                
                $A.util.addClass(component.find("MWHardwareComfort_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortQuickStart_Div"),'toggle');
                
                analyticsAction = 'Comfort';
                analyticsLabel = 'Comfort Guide'; 
                break;               
            case "MWHardwareComfort_Back":                
                $A.util.addClass(component.find("MWHardwareComfort_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareBegin_Div"),'toggle');
                break;  
            case "MWHardwareComfortHVAC_Back":                
                $A.util.addClass(component.find("MWHardwareComfortHVAC_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfort_Div"),'toggle');
                break;                 
            case "MWHardwareComfortQuickStart_Back":                
                $A.util.addClass(component.find("MWHardwareComfortQuickStart_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfort_Div"),'toggle');
                break;
            case "MWHardwareComfortC4ThermV2Reboot_Click":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV2_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermV2Reboot_Div"),'toggle');
                
                analyticsAction = 'Thermostat V2';
                analyticsLabel = 'Thermostat V2 Restart';
                break;  
            case "MWHardwareComfortC4ThermV2_Back":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV2_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfort_Div"),'toggle');
                break;          
            case "MWHardwareComfortC4ThermV2Reboot_Back":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV2Reboot_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermV2_Div"),'toggle');
                
                analyticsAction = 'Thermostat V2';
                analyticsLabel = 'Thermostat V2'; 
                break;                   
            case "MWHardwareComfortC4ThermV2Reboot_Y":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV2Reboot_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermSuccess_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareComfortC4ThermV2Reboot_Div');
                
                analyticsAction = 'Thermostat';
                analyticsLabel = 'Restart Success'; 
                break;                 
            case "MWHardwareComfortC4ThermV2Reboot_N":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV2Reboot_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermContactDealer_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareComfortC4ThermV2Reboot_Div');
                
                analyticsAction = 'Thermostat';
                analyticsLabel = 'Contact Dealer'; 
                break;               
            case "MWHardwareComfortC4ThermV1Reboot_Click":      
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV1_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermV1Reboot_Div"),'toggle');
                
                analyticsAction = 'Thermostat V1';
                analyticsLabel = 'Thermostat V1 Restart';                 
                break;              
            case "MWHardwareComfortC4ThermV1_Back":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV1_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfort_Div"),'toggle');
                break;
            case "MWHardwareComfortC4ThermV1Reboot_Back":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV1Reboot_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermV1_Div"),'toggle');
                break;                
            case "MWHardwareComfortC4ThermV1Reboot_Y":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV1Reboot_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermSuccess_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareComfortC4ThermV1Reboot_Div');
                
                analyticsAction = 'Thermostat';
                analyticsLabel = 'Restart Success'; 
                break;                 
            case "MWHardwareComfortC4ThermV1Reboot_N":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermV1Reboot_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4ThermContactDealer_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWHardwareComfortC4ThermV1Reboot_Div');
                
                analyticsAction = 'Thermostat';
                analyticsLabel = 'Contact Dealer'; 
                break;               
            case "MWHardwareComfortC4ThermGuide_Back":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermGuide_Div"),'toggle');
                $A.util.removeClass(component.find("MWHardwareComfortC4Therm_Div"),'toggle');
                break;                
            case "MWHardwareComfortC4ThermSuccess_Back":                
                $A.util.addClass(component.find("MWHardwareComfortC4ThermSuccess_Div"),'toggle');
                $A.util.removeClass(component.find(component.get("v.PreviousScreen")),'toggle');
                break;                    
            case "MWHardwareComfortC4ThermContactDealer_Back":              
                $A.util.addClass(component.find("MWHardwareComfortC4ThermContactDealer_Div"),'toggle');
                $A.util.removeClass(component.find(component.get("v.PreviousScreen")),'toggle');
                break;
            case "EA5TroubshootClick":               
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Restart EA-5';                    
                }               
                break;
            case "EA3TroubshootClick":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Restart EA-3';
                }
                break;
            case "EA1TroubshootClick": 
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Restart EA-1';
                }
                break;
            case "CA10TroubshootClick":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Restart CA-10';
                }
                break;
            case "CA1TroubshootClick":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Restart CA-1';
                }
                break;
            case "HC250TroubshootClick":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Restart HC-250';
                }
                break;
            case "HC800TroubshootClick":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Restart HC-800';
                }
                break;
            case "IDKClick":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("OS3IDK_Div"),'toggle');
                }
                else 
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                    $A.util.removeClass(component.find("OS3IDK_Div"),'toggle');
                }
                break;
            case "BackClick":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("OS3IDK_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                }
                else 
                {
                    $A.util.addClass(component.find("OS3IDK_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                }
                break;
            case "ContactDealClick":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("OS3IDK_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNContactDealer_Div"),'toggle');
                    
                    analyticsAction = 'Neeo';
                	analyticsLabel = 'Contact Pro';  
                }
                else 
                {                
                    $A.util.addClass(component.find("OS3IDK_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootNContactDealer_Div"),'toggle');
                    component.set("v.PreviousScreen", 'OS3IDK_Div');
                }
                break;
                
            case "MWHardwareWatchRemRebootNEA5_Back":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                }      
                break;
            case "MWHardwareWatchRemRebootNEA3_Back":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                }
                break;
            case "MWHardwareWatchRemRebootNEA1_Back":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                }
                break;
            case "MWHardwareWatchRemRebootNCA10_Back":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                }
                break;               
            case "MWHardwareWatchRemRebootNCA1_Back":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                }
                break;
            case "MWHardwareWatchRemRebootNHC250_Back":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                }
                break;
            case "MWHardwareWatchRemRebootNHC800_Back":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootN_Div"),'toggle');
                }
                break;
                
            case "MWHardwareWatchRemRebootNEA5_Y": 
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA5_Div');
                    
                    analyticsAction = 'Neeo';
                	analyticsLabel = 'Neeo Success';
                }
                else
                {                
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA5_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Success';
                }
                break;
            case "MWHardwareWatchRemRebootNEA3_Y":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA3_Div');
                    
                    analyticsAction = 'Neeo';
                	analyticsLabel = 'Neeo Success';
                }
                else
                {   
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA3_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Success';
                }
                break;
            case "MWHardwareWatchRemRebootNEA1_Y":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA1_Div');
                    
                    analyticsAction = 'Neeo';
                	analyticsLabel = 'Neeo Success';
                }
                else
                { 
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA1_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Success';
                }
                break;
            case "MWHardwareWatchRemRebootNCA10_Y": 
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNCA10_Div');
                    
                    analyticsAction = 'Neeo';
                	analyticsLabel = 'Neeo Success';
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNCA10_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Success';
                }
                break;
            case "MWHardwareWatchRemRebootNCA1_Y":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNCA1_Div');
                    
                    analyticsAction = 'Neeo';
                	analyticsLabel = 'Neeo Success';
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNCA1_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Success';
                }
                break;
            case "MWHardwareWatchRemRebootNHC250_Y":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNHC250_Div');
                    
                    analyticsAction = 'Neeo';
                	analyticsLabel = 'Neeo Success';
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNHC250_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Success';
                }
                break;
            case "MWHardwareWatchRemRebootNHC800_Y":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');
                    $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNHC800_Div');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchRemRebootY_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNHC800_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Success';
                }
                break;
                
            case "MWHardwareWatchRemRebootNEA5_N":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousRebootControllerScreen", 'MWHardwareWatchRemRebootNEA5_Div');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA5_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA5_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Contact Dealer';
                }
                break;
            case "MWHardwareWatchRemRebootNEA3_N":  
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousRebootControllerScreen", 'MWHardwareWatchRemRebootNEA3_Div');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA3_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA3_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Contact Dealer';
                }
                break;
            case "MWHardwareWatchRemRebootNEA1_N":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousRebootControllerScreen", 'MWHardwareWatchRemRebootNEA1_Div');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNEA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNEA1_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Contact Dealer';
                }
                break;                
            case "MWHardwareWatchRemRebootNCA10_N":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousRebootControllerScreen", 'MWHardwareWatchRemRebootNCA10_Div');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA10_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNCA10_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Contact Dealer';
                }
                break;
            case "MWHardwareWatchRemRebootNCA1_N":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousRebootControllerScreen", 'MWHardwareWatchRemRebootNCA1_Div');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNCA1_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNCA1_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Contact Dealer';
                }
                break;
            case "MWHardwareWatchRemRebootNHC250_N":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousRebootControllerScreen", 'MWHardwareWatchRemRebootNHC250_Div');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC250_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNHC250_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Contact Dealer';
                }
                break;
            case "MWHardwareWatchRemRebootNHC800_N":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousRebootControllerScreen", 'MWHardwareWatchRemRebootNHC800_Div');
                }
                else
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNHC800_Div"),'toggle');
                    $A.util.removeClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWHardwareWatchRemRebootNHC800_Div');
                    
                    analyticsAction = 'Watch';
                    analyticsLabel = 'Controller Restart | Contact Dealer';
                }
                break;
                
            case "MWHardwareWatchContactUs_Back":
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    $A.util.removeClass(component.find(component.get("v.PreviousRebootControllerScreen")),'toggle');
                }
                else 
                {  
                    $A.util.addClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');
                    $A.util.removeClass(component.find(component.get("v.PreviousScreen")),'toggle');
                }
                break;                
            case "MWHardwareWatchRemRebootNContactDealer_Back":   
                if (component.get("v.PreviousScreen") == "MWAppCon500Controllers_Div")
                {
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNContactDealer_Div"),'toggle');
                    $A.util.removeClass(component.find("OS3IDK_Div"),'toggle');                 
                }
                else 
                {    
                    $A.util.addClass(component.find("MWHardwareWatchRemRebootNContactDealer_Div"),'toggle');      		
                    $A.util.removeClass(component.find(component.get("v.PreviousScreen")),'toggle');  
                }
                break;            
            case "NeeoUserGuide":
                analyticsAction = 'Neeo';
                analyticsLabel = 'User Guide (Button Click)';                
                break;
            case "NeeoQuickStartGuide":
                analyticsAction = 'Neeo';
                analyticsLabel = 'Quick Start Guide (Button Click)';                
                break;               
            case "MSHardwareNeeoTSNE_Skip2":
                $A.util.addClass(component.find("MWHardwareNeeoTSNE_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep2_Div"),'toggle');
                break;
            case "MSHardwareNeeoTSNE_Skip3":
                $A.util.addClass(component.find("MWHardwareNeeoTSNE_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWHardwareNeeoTSNEStep3_Div"),'toggle');
                break;
            case "MSHardwareNeeoTSNE_Skip4":
                $A.util.addClass(component.find("MWHardwareNeeoTSNE_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWAppCon500Controllers_Div'); 
                break;
                
            case "Modal_Close":
                component.find("overlayLib2").notifyClose();
                break;               
        }
        
        helper.LogAnalytics(analyticsAction, analyticsLabel); 
    }
})