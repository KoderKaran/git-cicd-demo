({
    doInit : function(component, event, helper) {
        //console.log('Init is being ran');        
        
        $A.util.addClass(component.find("MWAppCon_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Rem_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321LocDNAPath_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc1_Div"),'toggle');
        $A.util.addClass(component.find("MWAppSuccess_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc1N_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS1_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS2_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS3_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS4_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS5_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS6_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS7_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid1_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid2_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid3_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid4_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid5_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid6_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid7_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid8_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');        
        $A.util.addClass(component.find("MWAppCon500_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
        $A.util.addClass(component.find("500_Title_Div"),'toggle');
        $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');       
        $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');        
        $A.util.addClass(component.find("MWAppCon500_EA5_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon500_EA3_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon500_EA1_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon500_CA10_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon500_CA1_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon500_HC250_Div"),'toggle');
        $A.util.addClass(component.find("MWAppCon500_HC800_Div"),'toggle');        
        $A.util.addClass(component.find("MWHardwareWatchContactUs_Div"),'toggle');  
        $A.util.addClass(component.find("MWAppContactDealer_Div"),'toggle');      
        $A.util.addClass(component.find("MWAppConDNA_Div"),'toggle');
        $A.util.addClass(component.find("MWAppConDNA_N_Div"),'toggle');        
        $A.util.addClass(component.find("MWAppNewDevice_Div"),'toggle');       
        $A.util.addClass(component.find("MWAppMusicServices_Div"),'toggle');   
        $A.util.addClass(component.find("MWHardwareListenMusicDriver_Div"),'toggle');       
        $A.util.addClass(component.find("MWAppIntAnywhere_Div"),'toggle');      
        $A.util.addClass(component.find("MWAppPCMac_Div"),'toggle');       
        $A.util.addClass(component.find("MWAppPCMacInstall_Div"),'toggle');       
        $A.util.addClass(component.find("MWAppPCMacTroubleshoot_Div"),'toggle');       
        $A.util.addClass(component.find("MWAppIntAnywhereGet_Div"),'toggle');       
        $A.util.addClass(component.find("MWAppIntAnywhereDoc_Div"),'toggle');     
        $A.util.addClass(component.find("OS3IDK_Div"),'toggle');  
        helper.LogAnalytics('App', 'Home');  
    },	
    
    handleBubbling : function(component, event, helper)  {        
        var analyticsAction = '';
        var analyticsLabel = '';
        var params = event.getParams();
        var navigateAction = params.ComponentAction;
        //var previousScreen = params.PreviousScreen;
        //console.log("App navigateAction: " + navigateAction);		
        
        switch (navigateAction) {
            case "ConnectionIssuesClick":
                $A.util.addClass(component.find("MWAppBegin_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon_Div"),'toggle');                
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Connection Issues';                   
                break; 
            case "NewDeviceClick":
                $A.util.addClass(component.find("MWAppBegin_Div"),'toggle');  
                $A.util.removeClass(component.find("MWAppNewDevice_Div"),'toggle'); 
                analyticsAction = 'New Device';
                analyticsLabel = 'Download OS 2 App';                 
                break; 
            case "MusicServicesClick":
                $A.util.addClass(component.find("MWAppBegin_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppMusicServices_Div"),'toggle'); 
                break;     
            case "IntercomAnywhereClick":
                $A.util.addClass(component.find("MWAppBegin_Div"),'toggle');     
                $A.util.removeClass(component.find("MWAppIntAnywhere_Div"),'toggle');                 
                analyticsAction = 'Intercom Anywhere';
                analyticsLabel = 'Intercom Anywhere';  
                break;
         /*   case "PCMacClick":
                $A.util.addClass(component.find("MWAppBegin_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppPCMac_Div"),'toggle'); 
                analyticsAction = 'Control4 App for PC/Mac';
                analyticsLabel = 'Control4 App for PC/Mac';                  
                break; */
            case "HowDoIGetButtonClick":
                $A.util.addClass(component.find("MWAppIntAnywhere_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppIntAnywhereGet_Div"),'toggle'); 
                analyticsAction = 'Intercom Anywhere';
                analyticsLabel = 'How Do I Get It?';
                break;
            case "ShowDocsButtonClick":
                $A.util.addClass(component.find("MWAppIntAnywhere_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppIntAnywhereDoc_Div"),'toggle');
                analyticsAction = 'Intercom Anywhere';
                analyticsLabel = 'Show Documents'; 
                break;  
            case "AppCon_Back":
                $A.util.addClass(component.find("MWAppCon_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppBegin_Div"),'toggle'); 
                break;               
            case "Con40321Click":         
                $A.util.addClass(component.find("MWAppCon_Div"),'toggle');
                $A.util.addClass(component.find("MWAppConDNA_N_Div"),'toggle');              
                $A.util.removeClass(component.find("MWAppCon40321_Div"),'toggle');
                component.set("v.Trail", '40321');
                
                var DNAPath = component.get("v.DNAPath");
                if (DNAPath != 'DNACompleted')
                {
                    component.set("v.DNAPath", ''); 
                }
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Home or Away';  
                break; 
            case "Con500Click":
                $A.util.addClass(component.find("MWAppCon_Div"),'toggle');
                $A.util.addClass(component.find("MWAppConDNA_N_Div"),'toggle');
                $A.util.removeClass(component.find("MWAppCon500_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '500'; 
                
                component.set("v.Trail", '500');
                
                var DNAPath = component.get("v.DNAPath");
                if (DNAPath != 'DNACompleted')
                {
                    component.set("v.DNAPath", ''); 
                }               
                break;  
            case "DNAClick":                
                $A.util.addClass(component.find("MWAppCon_Div"),'toggle');
                $A.util.removeClass(component.find("MWAppConDNA_Div"),'toggle');
                
                var DNAPath = component.get("v.DNAPath");
                if (DNAPath != 'DNACompleted')
                {
                    component.set("v.DNAPath", 'DNABegin'); 
                }
                
                component.set("v.NewDeviceBackBackButton", ''); // this is just to make the back button work
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'D.N.A';
                break;
            case "DNAClickFromNewDevices":                
                $A.util.addClass(component.find("MWAppCon_Div"),'toggle');
                $A.util.addClass(component.find("MWAppNewDevice_Div"),'toggle'); // This is also triggered from the New Device Screen 
                $A.util.removeClass(component.find("MWAppConDNA_Div"),'toggle');
                
                analyticsAction = 'New Device';
                analyticsLabel = 'New Device | Yes (Button Click)';
                
                var DNAPath = component.get("v.DNAPath");
                if (DNAPath != 'DNACompleted')
                {
                    component.set("v.DNAPath", 'DNABegin'); 
                }      
                
                component.set("v.NewDeviceBackBackButton", 'NewDeviceBackBackButton'); // this is just to make the back button work           
                break;              
            case "MWAppConDNA_iOS":                
                $A.util.addClass(component.find("MWAppConDNA_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS_Div"),'toggle');
                component.set("v.DeviceType", 'MWAppConDNA_Div');
                component.set("v.DeviceType_ForDNAPath", 'iOS');
                component.set("v.ScreenTitle", 'Device Not Authenticated - iOS');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS Email & Password';
                break;
            case "MWAppConDNA_Android":                
                $A.util.addClass(component.find("MWAppConDNA_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid_Div"),'toggle');
                component.set("v.DeviceType", 'MWAppConDNA_Div');
                component.set("v.DeviceType_ForDNAPath", 'Android');
                component.set("v.ScreenTitle", 'Device Not Authenticated - Android'); 
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android Email & Password';
                break;
            case "MWAppConDNA_Back":                
                $A.util.addClass(component.find("MWAppConDNA_Div"),'toggle');          		
                
                
                var NewDeviceBackBackButton = component.get("v.NewDeviceBackBackButton");
                if (NewDeviceBackBackButton != 'NewDeviceBackBackButton')
                {
                    $A.util.removeClass(component.find("MWAppCon_Div"),'toggle');
                }
                else
                {
                    $A.util.removeClass(component.find("MWAppNewDevice_Div"),'toggle');  
                }
                break;               
            case "AppNewDevice_Back":
                $A.util.addClass(component.find("MWAppNewDevice_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppBegin_Div"),'toggle'); 
                break; 
            case "MWHardwareListenMusic_Back":
                $A.util.addClass(component.find("MWAppMusicServices_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppBegin_Div"),'toggle');                 
                break;
            case "MusicServicesDriverClick":
                $A.util.addClass(component.find("MWAppMusicServices_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWHardwareListenMusicDriver_Div"),'toggle');                 
                break;  
            case "MWHardwareListenMusicDriver_Back":
                $A.util.addClass(component.find("MWHardwareListenMusicDriver_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppMusicServices_Div"),'toggle');                 
                break;               
            case "AppIntAnywhere_Back":
                $A.util.addClass(component.find("MWAppIntAnywhere_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppBegin_Div"),'toggle'); 
                break;  
            case "MWAppPCMac_Back":
                $A.util.addClass(component.find("MWAppPCMac_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppBegin_Div"),'toggle'); 
                break;
            case "MWAppPCMacInstall_Back":
                $A.util.addClass(component.find("MWAppPCMacInstall_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppPCMac_Div"),'toggle'); 
                break;    
            case "InstallButtonClick":
                $A.util.addClass(component.find("MWAppPCMac_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppPCMacInstall_Div"),'toggle');                 
                analyticsAction = 'Control4 App for PC/Mac';
                analyticsLabel = 'Install';
                break;    
            case "TroubleshootButtonClick":
                $A.util.addClass(component.find("MWAppPCMac_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppPCMacTroubleshoot_Div"),'toggle'); 
                analyticsAction = 'Control4 App for PC/Mac';
                analyticsLabel = 'Troubleshoot';                
                break;                    
            case "MWAppPCMactroubleshoot_Back":
                $A.util.addClass(component.find("MWAppPCMacTroubleshoot_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppPCMac_Div"),'toggle'); 
                break;                
            case "MWAppIntAnywhereGet_Back":
                $A.util.addClass(component.find("MWAppIntAnywhereGet_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppIntAnywhere_Div"),'toggle'); 
                break;    
            case "MWAppIntAnywhereDoc_Back":
                $A.util.addClass(component.find("MWAppIntAnywhereDoc_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppIntAnywhere_Div"),'toggle'); 
                break;
            case "MWAppCon40321_Back":
                $A.util.addClass(component.find("MWAppCon40321_Div"),'toggle'); 
                
                var DNAPath = component.get("v.DNAPath");               
                if (DNAPath == 'DNACompleted')
                {
                    $A.util.removeClass(component.find("MWAppConDNA_N_Div"),'toggle');                    
                }
                else
                {
                    $A.util.removeClass(component.find("MWAppCon_Div"),'toggle');   
                }
                break;
            case "MWAppCon40321_Remote":
                $A.util.addClass(component.find("MWAppCon40321_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Rem_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Get 4Sight';
                break;
            case "MWAppCon40321_Local":
                $A.util.addClass(component.find("MWAppCon40321_Div"),'toggle');          		
                
                var DNAPath = component.get("v.DNAPath");               
                if (DNAPath == 'DNACompleted')
                {
                    $A.util.removeClass(component.find("MWAppCon40321LocDNAPath_Div"),'toggle');
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'D.N.A. | 403.21 | 2 Steps';
                }
                else
                {
                    $A.util.removeClass(component.find("MWAppCon40321Loc_Div"),'toggle'); 
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = '403.21 | 3 Steps'; 
                }               
                break;
            case "MWAppCon40321LocDNAPath_Back":
                $A.util.addClass(component.find("MWAppCon40321LocDNAPath_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321_Div"),'toggle');                
                break; 
            case "MWAppCon40321LocDNAPath_Next":
                $A.util.addClass(component.find("MWAppCon40321LocDNAPath_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc1_Div"),'toggle'); 
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Step 1 (WiFi)';
                break;               
            case "MWAppCon40321Rem_Back":
                $A.util.addClass(component.find("MWAppCon40321Rem_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321_Div"),'toggle'); 
                break;
            case "MWAppCon40321Loc_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321_Div"),'toggle'); 
                break;
            case "MWAppCon40321Loc1_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc1_Div"),'toggle');   		 
                
                var DNAPath = component.get("v.DNAPath");               
                if (DNAPath == 'DNACompleted')
                {
                    $A.util.removeClass(component.find("MWAppCon40321LocDNAPath_Div"),'toggle');                 
                }
                else
                {
                    $A.util.removeClass(component.find("MWAppCon40321Loc_Div"),'toggle');    
                }               
                break;
            case "MWAppCon40321Loc1_Yes":
                $A.util.addClass(component.find("MWAppCon40321Loc1_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWAppCon40321Loc1_Div');  
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';
                break;
            case "MWAppCon40321Loc1_No":
                $A.util.addClass(component.find("MWAppCon40321Loc1_Div"),'toggle');      		
                var DNAPath = component.get("v.DNAPath");               
                if (DNAPath == 'DNACompleted')
                {
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("403Step2_Title_Div"),'toggle');
                    component.set("v.Trail", 'MWAppCon40321Loc1_Div'); 
                    component.set("v.PreviousScreen", 'MWAppCon40321Loc1_Div');
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = '500 | Chose Controller';
                }
                else
                {
                    $A.util.removeClass(component.find("MWAppCon40321Loc1N_Div"),'toggle');
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = '403.21 | Step 2 (Mobile OS)';
                }               
                break;                
            case "MWAppCon40321Loc_Local1":
                $A.util.addClass(component.find("MWAppCon40321Loc_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc1_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Step 1 (WiFi)';
                break;
            case "MWAppCon40321Loc_Skip2":
                $A.util.addClass(component.find("MWAppCon40321Loc_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc1N_Div"),'toggle');
                component.set("v.SkipTracker", 'Step2Skip');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Skip to Step 2 (Button Click)';
                break;                
            case "MWAppCon40321Loc_Skip3":
                $A.util.addClass(component.find("MWAppCon40321Loc_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');
                component.set("v.SkipTracker", 'Step3Skip'); 
                component.set("v.Trail", 'MWAppCon40321Loc_Div');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Skip to Step 3 (Button Click)';
                break;                
            case "MWAppCon40321Loc1N_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc1N_Div"),'toggle');                
                var SkipTracker = component.get("v.SkipTracker");
                
                if (SkipTracker == 'Step2Skip')
                {  
                    $A.util.removeClass(component.find("MWAppCon40321Loc_Div"),'toggle');
                    component.set("v.SkipTracker", ''); 
                }
                else
                {
                    $A.util.removeClass(component.find("MWAppCon40321Loc1_Div"),'toggle');   
                }               
                break;
            case "MWAppCon40321Loc2DroidN_Back"://??? not sure if this is used
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc1N_Div"),'toggle'); 
                break;                              
            case "MWAppCon40321Loc2DroidN_Yes"://??? not sure if this is used
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid1_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWAppCon40321Loc2DroidN');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 1';
                break;             
            case "MWAppCon40321Loc2iOSN_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOSN_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc1N_Div"),'toggle'); 
                break;
            case "MW_App_Con_403_21_Loc_2_iOS":
                component.set("v.ScreenTitle", '403.21 - iOS');
                $A.util.addClass(component.find("MWAppCon40321Loc1N_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS_Div"),'toggle');
                component.set("v.DeviceType", 'MWAppCon40321Loc1N_Div'); 
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS Email & Password';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_1":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS1_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS | Step 1';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_2":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS1_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS2_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS | Step 2';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_3":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS2_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS3_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS | Step 3';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_4":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS3_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS4_Div"),'toggle');                  
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS | Step 4';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_5":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS4_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS5_Div"),'toggle');                
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS | Step 5';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_6":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS5_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS6_Div"),'toggle');                 
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS | Step 6';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_7":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS6_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS7_Div"),'toggle');                  
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS | Step 7';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_8":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS7_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle');                
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | iOS | Step 8';
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_8Y":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWAppCon40321Loc2iOS8_Div'); 
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';                
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_8N":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle');               
                
                var DeviceType_ForDNAPath = component.get("v.DeviceType_ForDNAPath");
                
                if (DeviceType_ForDNAPath == 'iOS') // this means Device Not Authenticated is the path the user in on
                {
                    $A.util.removeClass(component.find("MWAppConDNA_N_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon40321Loc2iOS8_Div');
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'D.N.A.';
                }                
                else
                {
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');              
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');              
                    component.set("v.Trail", 'MWAppCon40321Loc2iOS8_Div');
                    component.set("v.PreviousScreen", 'MWAppCon40321Loc2iOS8_Div'); 
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = '403.21 | Chose Controller';
                }
                
                var DNAPath = component.get("v.DNAPath");
                if (DNAPath == 'DNABegin')
                {
                    component.set("v.DNAPath", 'DNACompleted'); 
                }                
                break;                 
                
            case "MW_App_Con_403_21_Loc_2_Droid":
                $A.util.addClass(component.find("MWAppCon40321Loc1N_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid_Div"),'toggle');
                component.set("v.DeviceType", 'MWAppCon40321Loc1N_Div');
                component.set("v.ScreenTitle", '403.21 - Android');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android Email & Password';
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_1":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid1_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 1';
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_2":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid1_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid2_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 2';
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_3":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid2_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid3_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 3';
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_4":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid3_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid4_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 4';
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_5":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid4_Div"),'toggle');		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid5_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 5';
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_6":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid5_Div"),'toggle');     		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid6_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 6';                
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_7":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid6_Div"),'toggle');       		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid7_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 7';
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_8":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid7_Div"),'toggle');       		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid8_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 8';                
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_9":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid8_Div"),'toggle');     		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '403.21 | Android | Step 9'; 
                break;          
            case "MW_App_Con_403_21_Loc_2_Droid_9Y":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWAppCon40321Loc2Droid9_Div');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';                
                break;                
            case "MW_App_Con_403_21_Loc_2_Droid_9N":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');  
                
                var DeviceType_ForDNAPath = component.get("v.DeviceType_ForDNAPath");
                
                if (DeviceType_ForDNAPath == 'Android') // this means Device Not Authenticated is the path the user in on
                {
                    $A.util.removeClass(component.find("MWAppConDNA_N_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon40321Loc2Droid9_Div'); 
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'D.N.A.';
                }                
                else
                {
                    $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');
                    component.set("v.Trail", 'MWAppCon40321Loc2Droid9_Div');
                    component.set("v.PreviousScreen", 'MWAppCon40321Loc2Droid9_Div'); 
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = '403.21 | Chose Controller';                    
                }
                
                var DNAPath = component.get("v.DNAPath");
                if (DNAPath == 'DNABegin')
                {
                    component.set("v.DNAPath", 'DNACompleted'); 
                }               
                break;                
                
            case "MW_App_Con_403_21_Loc_2_iOS_1_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS1_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_2_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS2_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS1_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_3_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS3_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS2_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_4_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS4_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS3_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_5_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS5_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS4_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_6_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS6_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS5_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_7_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS7_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS6_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_8_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2iOS7_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_1_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid1_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_2_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid2_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid1_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_3_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid3_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid2_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_4_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid4_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid3_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_5_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid5_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid4_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_6_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid6_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid5_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_7_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid7_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid6_Div"),'toggle');                    
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_8_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid8_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid7_Div"),'toggle');                    
                break;               
            case "MW_App_Con_403_21_Loc_2_Droid_9_Back":
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');          		
                $A.util.removeClass(component.find("MWAppCon40321Loc2Droid8_Div"),'toggle');                    
                break; 
                
                // 500 flow    
            case "MWAppCon500_Back":
                $A.util.addClass(component.find("MWAppCon500_Div"),'toggle'); 
                
                var DNAPath = component.get("v.DNAPath");               
                if (DNAPath == 'DNACompleted')
                {
                    $A.util.removeClass(component.find("MWAppConDNA_N_Div"),'toggle');                    
                }
                else
                {
                    $A.util.removeClass(component.find("MWAppCon_Div"),'toggle');   
                }
                break;
            case "MWAppCon500_Next":
                $A.util.addClass(component.find("MWAppCon500_Div"),'toggle');          		
                $A.util.removeClass(component.find("500_Title_Div"),'toggle');  
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                component.set("v.Trail", 'MWAppCon500_Div');
                component.set("v.PreviousScreen", 'MWAppCon500_Div');
                
                analyticsAction = 'Connection Issues';
                analyticsLabel = '500 | Chose Controller';
                break;
            case "EA5TroubshootClick":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                $A.util.addClass(component.find("403Step3_Title_Div"),'toggle'); 
                $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');
                $A.util.addClass(component.find("500_Title_Div"),'toggle');                                
                $A.util.removeClass(component.find("MWAppCon500_EA5_Div"),'toggle');                 
                break;
            case "EA3TroubshootClick":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle'); 
                $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');
                $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');
                $A.util.addClass(component.find("500_Title_Div"),'toggle'); 
                $A.util.removeClass(component.find("MWAppCon500_EA3_Div"),'toggle');  
                break;
            case "EA1TroubshootClick":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');
                $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');
                $A.util.addClass(component.find("500_Title_Div"),'toggle');           		
                $A.util.removeClass(component.find("MWAppCon500_EA1_Div"),'toggle');  
                break;
            case "CA10TroubshootClick":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');
                $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');
                $A.util.addClass(component.find("500_Title_Div"),'toggle');           		
                $A.util.removeClass(component.find("MWAppCon500_CA10_Div"),'toggle');  
                break;
            case "CA1TroubshootClick":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');
                $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');
                $A.util.addClass(component.find("500_Title_Div"),'toggle');           		
                $A.util.removeClass(component.find("MWAppCon500_CA1_Div"),'toggle');  
                break;
            case "HC250TroubshootClick":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                $A.util.addClass(component.find("403Step3_Title_Div"),'toggle'); 
                $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');
                $A.util.addClass(component.find("500_Title_Div"),'toggle');                 
                $A.util.removeClass(component.find("MWAppCon500_HC250_Div"),'toggle');  
                break;
            case "HC800TroubshootClick":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');
                $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');
                $A.util.addClass(component.find("500_Title_Div"),'toggle');                 
                $A.util.removeClass(component.find("MWAppCon500_HC800_Div"),'toggle');  
                break;
            case "MW_App_Con_403_21_Loc_2_iOS_Back":
                var DeviceType = component.get("v.DeviceType");
                $A.util.addClass(component.find("MWAppCon40321Loc2iOS_Div"),'toggle');  
                
                if (DeviceType == 'MWAppConDNA_Div')
                {       		
                    $A.util.removeClass(component.find("MWAppConDNA_Div"),'toggle');                     
                }
                if (DeviceType == 'MWAppCon40321Loc1N_Div')
                {       		
                    $A.util.removeClass(component.find("MWAppCon40321Loc1N_Div"),'toggle');                 
                }
                
                break;
            case "MW_App_Con_403_21_Loc_2_Droid_Back":
                var DeviceType = component.get("v.DeviceType");
                $A.util.addClass(component.find("MWAppCon40321Loc2Droid_Div"),'toggle');  
                
                if (DeviceType == 'MWAppConDNA_Div')
                {       		
                    $A.util.removeClass(component.find("MWAppConDNA_Div"),'toggle');                     
                }
                if (DeviceType == 'MWAppCon40321Loc1N_Div')
                {       		
                    $A.util.removeClass(component.find("MWAppCon40321Loc1N_Div"),'toggle');                    
                }                                   
                break;   
            case "MW_App_DNA_N_Back":
                var DeviceType_ForDNAPath = component.get("v.DeviceType_ForDNAPath"); //////////////////////////////////////////////////////////////////////////////
                $A.util.addClass(component.find("MWAppConDNA_N_Div"),'toggle');  
                
                if (DeviceType_ForDNAPath == 'iOS')
                {       		
                    $A.util.removeClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle');                     
                }
                if (DeviceType_ForDNAPath == 'Android')
                {       		
                    $A.util.removeClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');                    
                }
                break;  
                //This reused from the Hardware wizard
            case "MWHardwareWatchRemRebootNEA5_Back":
                var trail = component.get("v.Trail");
                
                console.log(trail);
                
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == 'MWAppCon40321Loc_Div') 
                {
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon500_Div')
                {
                    $A.util.removeClass(component.find("500_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon40321Loc1_Div') 
                {
                    $A.util.removeClass(component.find("403Step2_Title_Div"),'toggle');  
                }
                
                $A.util.addClass(component.find("MWAppCon500_EA5_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');         
                break;
            case "MWHardwareWatchRemRebootNEA3_Back":
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div'  || trail == 'MWAppCon40321Loc_Div')
                {
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon500_Div')
                {
                    $A.util.removeClass(component.find("500_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon40321Loc1_Div') 
                {
                    $A.util.removeClass(component.find("403Step2_Title_Div"),'toggle');  
                }
                
                $A.util.addClass(component.find("MWAppCon500_EA3_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');         
                break;
            case "MWHardwareWatchRemRebootNEA1_Back":
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div'  || trail == 'MWAppCon40321Loc_Div')
                {
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon500_Div')
                {
                    $A.util.removeClass(component.find("500_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon40321Loc1_Div') 
                {
                    $A.util.removeClass(component.find("403Step2_Title_Div"),'toggle');  
                }
                
                $A.util.addClass(component.find("MWAppCon500_EA1_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');         
                break;
            case "MWHardwareWatchRemRebootNCA10_Back":
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == 'MWAppCon40321Loc_Div')
                {
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon500_Div')
                {
                    $A.util.removeClass(component.find("500_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon40321Loc1_Div') 
                {
                    $A.util.removeClass(component.find("403Step2_Title_Div"),'toggle');  
                }
                
                $A.util.addClass(component.find("MWAppCon500_CA10_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');         
                break;
            case "MWHardwareWatchRemRebootNCA1_Back":
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == 'MWAppCon40321Loc_Div')
                {
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon500_Div')
                {
                    $A.util.removeClass(component.find("500_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon40321Loc1_Div') 
                {
                    $A.util.removeClass(component.find("403Step2_Title_Div"),'toggle');  
                }
                
                $A.util.addClass(component.find("MWAppCon500_CA1_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');         
                break;
            case "MWHardwareWatchRemRebootNHC250_Back":
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == 'MWAppCon40321Loc_Div')
                {
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon500_Div')
                {
                    $A.util.removeClass(component.find("500_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon40321Loc1_Div') 
                {
                    $A.util.removeClass(component.find("403Step2_Title_Div"),'toggle');  
                }
                
                $A.util.addClass(component.find("MWAppCon500_HC250_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');         
                break;
            case "MWHardwareWatchRemRebootNHC800_Back":
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == 'MWAppCon40321Loc_Div')
                {
                    $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon500_Div')
                {
                    $A.util.removeClass(component.find("500_Title_Div"),'toggle');  
                }
                if (trail == 'MWAppCon40321Loc1_Div') 
                {
                    $A.util.removeClass(component.find("403Step2_Title_Div"),'toggle');  
                }
                
                $A.util.addClass(component.find("MWAppCon500_HC800_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle');         
                break;       
                
            case "MWHardwareWatchRemRebootNEA5_Y":        
                $A.util.addClass(component.find("MWAppCon500_EA5_Div"),'toggle');              
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');
                component.set("v.PreviousScreen", 'MWAppCon500_EA5_Div'); 
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';
                break;
            case "MWHardwareWatchRemRebootNEA3_Y":              
                $A.util.addClass(component.find("MWAppCon500_EA3_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWAppCon500_EA3_Div');
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';
                break;
            case "MWHardwareWatchRemRebootNEA1_Y":              
                $A.util.addClass(component.find("MWAppCon500_EA1_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWAppCon500_EA1_Div');
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';
                break;
            case "MWHardwareWatchRemRebootNCA10_Y":              
                $A.util.addClass(component.find("MWAppCon500_CA10_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWAppCon500_CA10_Div');
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';
                break;
            case "MWHardwareWatchRemRebootNCA1_Y":              
                $A.util.addClass(component.find("MWAppCon500_CA1_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWAppCon500_CA1_Div');
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';
                break;
            case "MWHardwareWatchRemRebootNHC250_Y":              
                $A.util.addClass(component.find("MWAppCon500_HC250_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle');  
                component.set("v.PreviousScreen", 'MWAppCon500_HC250_Div');
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';
                break;
            case "MWHardwareWatchRemRebootNHC800_Y":              
                $A.util.addClass(component.find("MWAppCon500_HC800_Div"),'toggle');         		
                $A.util.removeClass(component.find("MWAppSuccess_Div"),'toggle'); 
                component.set("v.PreviousScreen", 'MWAppCon500_HC800_Div');
                analyticsAction = 'Connection Issues';
                analyticsLabel = 'Success App';
                break;
                
            //case "MWHardwareWatchRemRebootNContactDealer_Back":              
            case "MWAppContactDealer_Back":               
                var previousScreen = component.get("v.PreviousScreen");
                $A.util.addClass(component.find("MWAppContactDealer_Div"),'toggle'); 
                
                if (previousScreen == 'MWAppCon40321Loc2iOS8_Div')
                {       		
                    $A.util.removeClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle');                     
                }
                else if (previousScreen == 'MWAppCon40321Loc2Droid9_Div')
                {       		
                    $A.util.removeClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');                    
                }
                    else if (previousScreen == 'MWAppCon40321Loc1_Div')
                    {          		
                        $A.util.removeClass(component.find("MWAppCon40321Loc1_Div"),'toggle');                    
                    }
                        else if (previousScreen == 'MWAppCon500_EA5_Div')
                        {        		
                            $A.util.removeClass(component.find("MWAppCon500_EA5_Div"),'toggle');
                            component.set("v.PreviousScreen", component.get("v.Trail"));                    
                        }
                            else if (previousScreen == 'MWAppCon500_EA3_Div')
                            {         		
                                $A.util.removeClass(component.find("MWAppCon500_EA3_Div"),'toggle');
                                component.set("v.PreviousScreen", component.get("v.Trail"));                    
                            }
                                else if (previousScreen == 'MWAppCon500_EA1_Div')
                                {         		
                                    $A.util.removeClass(component.find("MWAppCon500_EA1_Div"),'toggle');
                                    component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                }
                                    else if (previousScreen == 'MWAppCon500_CA10_Div')
                                    {         		
                                        $A.util.removeClass(component.find("MWAppCon500_CA10_Div"),'toggle');
                                        component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                    }
                                        else if (previousScreen == 'MWAppCon500_CA1_Div')
                                        {         		
                                            $A.util.removeClass(component.find("MWAppCon500_CA1_Div"),'toggle');
                                            component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                        }
                                            else if (previousScreen == 'MWAppCon500_HC250_Div')
                                            {        		
                                                $A.util.removeClass(component.find("MWAppCon500_HC250_Div"),'toggle');
                                                component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                            }
                                                else if (previousScreen == 'MWAppCon500_HC800_Div')
                                                {          		
                                                    $A.util.removeClass(component.find("MWAppCon500_HC800_Div"),'toggle');
                                                    component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                                }    
                                                    else if(previousScreen == 'OS3IDK_Div'){
                                                        $A.util.removeClass(component.find("OS3IDK_Div"),'toggle');                                                    
                                                    }
                break;                
                
                
            case "MWHardwareWatchRemRebootNEA5_N":
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == '40321' || trail == 'MWAppCon40321Loc_Div')
                {
                    window.open('https://www.control4.com/company/contact-us/support','_blank');
                    component.find("overlayLib2").notifyClose();
                }
                else
                {
                    $A.util.addClass(component.find("MWAppCon500_EA5_Div"),'toggle');         		
                    $A.util.removeClass(component.find("MWAppContactDealer_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon500_EA5_Div'); 
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'Contact Dealer | App';
                }
                break;
            case "MWHardwareWatchRemRebootNEA3_N":              
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == '40321' || trail == 'MWAppCon40321Loc_Div')
                {
                    window.open('https://www.control4.com/company/contact-us/support','_blank');
                    component.find("overlayLib2").notifyClose();
                }
                else
                {
                    $A.util.addClass(component.find("MWAppCon500_EA3_Div"),'toggle');         		
                    $A.util.removeClass(component.find("MWAppContactDealer_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon500_EA3_Div'); 
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'Contact Dealer | App';
                }
                break;
            case "MWHardwareWatchRemRebootNEA1_N":              
                var trail = component.get("v.Trail");
                
                console.log(trail);
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == '40321' || trail == 'MWAppCon40321Loc_Div')
                {
                    window.open('https://www.control4.com/company/contact-us/support','_blank');
                    component.find("overlayLib2").notifyClose();
                }
                else
                {
                    $A.util.addClass(component.find("MWAppCon500_EA1_Div"),'toggle');         		
                    $A.util.removeClass(component.find("MWAppContactDealer_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon500_EA1_Div'); 
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'Contact Dealer | App';
                }
                break;                
            case "MWHardwareWatchRemRebootNCA10_N":              
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == '40321' || trail == 'MWAppCon40321Loc_Div')
                {
                    window.open('https://www.control4.com/company/contact-us/support','_blank');
                    component.find("overlayLib2").notifyClose();
                }
                else
                {
                    $A.util.addClass(component.find("MWAppCon500_CA10_Div"),'toggle');         		
                    $A.util.removeClass(component.find("MWAppContactDealer_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon500_CA10_Div');
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'Contact Dealer | App';
                } 
                break;
            case "MWHardwareWatchRemRebootNCA1_N":              
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == '40321' || trail == 'MWAppCon40321Loc_Div')
                {
                    window.open('https://www.control4.com/company/contact-us/support','_blank');
                    component.find("overlayLib2").notifyClose();
                }
                else
                {
                    $A.util.addClass(component.find("MWAppCon500_CA1_Div"),'toggle');         		
                    $A.util.removeClass(component.find("MWAppContactDealer_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon500_CA1_Div');
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'Contact Dealer | App';
                } 
                break;
            case "MWHardwareWatchRemRebootNHC250_N":              
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == '40321' || trail == 'MWAppCon40321Loc_Div')
                {
                    window.open('https://www.control4.com/company/contact-us/support','_blank');
                    component.find("overlayLib2").notifyClose();
                }
                else
                {
                    $A.util.addClass(component.find("MWAppCon500_HC250_Div"),'toggle');         		
                    $A.util.removeClass(component.find("MWAppContactDealer_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon500_HC250_Div'); 
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'Contact Dealer | App';
                }
                break;
            case "MWHardwareWatchRemRebootNHC800_N":              
                var trail = component.get("v.Trail");
                if (trail == 'MWAppCon40321Loc2iOS8_Div' || trail == 'MWAppCon40321Loc2Droid9_Div' || trail == '40321' || trail == 'MWAppCon40321Loc_Div')
                {
                    window.open('https://www.control4.com/company/contact-us/support','_blank');
                    component.find("overlayLib2").notifyClose();
                }
                else
                {
                    $A.util.addClass(component.find("MWAppCon500_HC800_Div"),'toggle');         		
                    $A.util.removeClass(component.find("MWAppContactDealer_Div"),'toggle');
                    component.set("v.PreviousScreen", 'MWAppCon500_HC800_Div'); 
                    
                    analyticsAction = 'Connection Issues';
                    analyticsLabel = 'Contact Dealer | App';
                }
                break;
                
                
            case "MWAppSuccess_Back":
                var previousScreen = component.get("v.PreviousScreen");
                $A.util.addClass(component.find("MWAppSuccess_Div"),'toggle'); 
                
                if (previousScreen == 'MWAppCon40321Loc2iOS8_Div')
                {       		
                    $A.util.removeClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle');                     
                }
                else if (previousScreen == 'MWAppCon40321Loc2Droid9_Div')
                {       		
                    $A.util.removeClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');                    
                }
                    else if (previousScreen == 'MWAppCon40321Loc1_Div')
                    {          		
                        $A.util.removeClass(component.find("MWAppCon40321Loc1_Div"),'toggle');                    
                    }
                        else if (previousScreen == 'MWAppCon500_EA5_Div')
                        {        		
                            $A.util.removeClass(component.find("MWAppCon500_EA5_Div"),'toggle');
                            component.set("v.PreviousScreen", component.get("v.Trail"));                    
                        }
                            else if (previousScreen == 'MWAppCon500_EA3_Div')
                            {         		
                                $A.util.removeClass(component.find("MWAppCon500_EA3_Div"),'toggle');
                                component.set("v.PreviousScreen", component.get("v.Trail"));                    
                            }
                                else if (previousScreen == 'MWAppCon500_EA1_Div')
                                {         		
                                    $A.util.removeClass(component.find("MWAppCon500_EA1_Div"),'toggle');
                                    component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                }
                                    else if (previousScreen == 'MWAppCon500_CA10_Div')
                                    {         		
                                        $A.util.removeClass(component.find("MWAppCon500_CA10_Div"),'toggle');
                                        component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                    }
                                        else if (previousScreen == 'MWAppCon500_CA1_Div')
                                        {         		
                                            $A.util.removeClass(component.find("MWAppCon500_CA1_Div"),'toggle');
                                            component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                        }
                                            else if (previousScreen == 'MWAppCon500_HC250_Div')
                                            {        		
                                                $A.util.removeClass(component.find("MWAppCon500_HC250_Div"),'toggle');
                                                component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                            }
                                                else if (previousScreen == 'MWAppCon500_HC800_Div')
                                                {          		
                                                    $A.util.removeClass(component.find("MWAppCon500_HC800_Div"),'toggle');
                                                    component.set("v.PreviousScreen", component.get("v.Trail"));                    
                                                }                
                
                break;   
                
            case "MWAppConControllers_Back":
                var previousScreen = component.get("v.PreviousScreen");
                var DNAPath = component.get("v.DNAPath");
                var SkipTracker = component.get("v.SkipTracker");
                
                console.log("previousScreen: " + previousScreen);
                console.log("DNAPath: " + DNAPath);
                console.log("SkipTracker: " + SkipTracker);
                
                if (SkipTracker == 'Step3Skip')
                {           
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');          		
                    $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');  
                    $A.util.removeClass(component.find("MWAppCon40321Loc_Div"),'toggle');
                    component.set("v.SkipTracker", '');  
                }
                else if (previousScreen == 'MWAppCon40321Loc2iOS8_Div')
                {
                    $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');          		
                    $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');  
                    $A.util.removeClass(component.find("MWAppCon40321Loc2iOS8_Div"),'toggle'); 
                }
                    else if (previousScreen == 'MWAppCon40321Loc2Droid9_Div')
                    {
                        $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');          		
                        $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');  
                        $A.util.removeClass(component.find("MWAppCon40321Loc2Droid9_Div"),'toggle');                    
                    }
                        else if (previousScreen == 'MWAppCon500_Div')
                        {
                            $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                            $A.util.addClass(component.find("500_Title_Div"),'toggle');  
                            $A.util.removeClass(component.find("MWAppCon500_Div"),'toggle');                    
                        }
                            else if (previousScreen == 'MWAppCon40321Loc1_Div')
                            {
                                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');
                                $A.util.addClass(component.find("403Step2_Title_Div"),'toggle');  
                                $A.util.removeClass(component.find("MWAppCon40321Loc1_Div"),'toggle');                    
                            }
                break;               
                
            case "IDKClick":
                $A.util.addClass(component.find("MWAppCon500Controllers_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("OS3IDK_Div"),'toggle'); // Unhide screen
                $A.util.addClass(component.find("403Step3_Title_Div"),'toggle'); 
                
                console.log("PreviousScreen " + component.get("v.PreviousScreen"));
                console.log("Trail " + component.get("v.Trail"));

                break;
            case "BackClick":
                $A.util.addClass(component.find("OS3IDK_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWAppCon500Controllers_Div"),'toggle'); // Unhide screen
                
                if (component.get("v.Trail") == 'MWAppCon500_Div')
                {
                  $A.util.addClass(component.find("403Step3_Title_Div"),'toggle');
                  $A.util.removeClass(component.find("500_Title_Div"),'toggle');                    
                }
                else
                {
                  $A.util.removeClass(component.find("403Step3_Title_Div"),'toggle');
                  $A.util.addClass(component.find("500_Title_Div"),'toggle');  
                }                            
                
                component.set("v.PreviousScreen", component.get("v.Trail"));                
                break;
            case "ContactDealClick":
                $A.util.addClass(component.find("OS3IDK_Div"),'toggle');  // Hide screen        		
                $A.util.removeClass(component.find("MWAppContactDealer_Div"),'toggle'); // Unhide screen 
                component.set("v.PreviousScreen", 'OS3IDK_Div');
                break;  
            case "Modal_Close":
                component.find("overlayLib2").notifyClose();
                break;               
        }
        
        helper.LogAnalytics(analyticsAction, analyticsLabel); 
    }
})