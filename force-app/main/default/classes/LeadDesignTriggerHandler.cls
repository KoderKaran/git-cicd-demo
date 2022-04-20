public class LeadDesignTriggerHandler {
    public static Id leadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();         
    public static Map<String,Schema.RecordTypeInfo> designservicesRTList = Schema.SObjectType.Design_Services__c.getRecordTypeInfosByName();
    public static void CheckLeadFields(List<Lead> leadList){
        for(Lead newLead:leadList){
            if(!(newLead.Theater_Type__c == null) || !(newLead.Theater_Dimensions__c== null) || !(newLead.Theater_Display__c==null) || !(newLead.Theater_Ceiling_Depth__c==null) || !(newLead.Theater_Wall_Depth__c==null) || !(newLead.Theater_Speaker_Placement__c==null) || !(newLead.Theater_Speaker_Line__c==null) || !(newLead.Theater_Max_Volume__c==null) || !(newLead.Theater_Customer_Budget__c==null) || !(newLead.Theater_Floorplan__c==null)|| !(newLead.Theater_Display__c==null)|| !(newLead.Theater_Display_Type__c==null) || !(newLead.Theater_Electronics__c==null)|| !(newLead.Theater_Seating__c ==null)|| !(newLead.Theater_Speaker_Layout__c==null)|| !(newLead.Theater_Challenges__c==null)){
                   newLead.Is_Theater_Filled__c = true;
               }
            if(!(newLead.Audio_Zones_Qty__c  == null) || !(newLead.Audio_Customer_Budget__c == null) || !(newLead.Audio_Room_Detail__c==null) || !(newLead.Audio_Wall_Depth__c ==null) || !(newLead.Audio_Ceiling_Depth__c ==null) || !(newLead.Audio_Speaker_Pair_Qty__c ==null) || !(newLead.Audio_Speaker_Layout__c ==null) || !(newLead.Audio_Speaker_Placement__c ==null) || !(newLead.Audio_Speaker_Line__c ==null) || !(newLead.Audio_Max_Volume__c ==null)|| !(newLead.Audio_With_Tv__c ==null)|| !(newLead.Audio_Onscreen_Navigator__c ==null) || !(newLead.Audio_Tv_Input__c ==null)|| !(newLead.Audio_Surround_Sound__c  ==null)|| !(newLead.Audio_Stereo_Sound__c ==null)|| !(newLead.Audio_Outdoor__c ==null) || !(newLead.Audio_Ten_Inch_Portable__c==null)|| !(newLead.Audio_Seven_Inch_Portable__c==null) ||!(newLead.Audio_Seven_Inch_InWall__c==null)|| !(newLead.Audio_Ten_Inch_InWall__c==null) ||!(newLead.Audio_Configurable_Keypad__c==null)|| !(newLead.Audio_Door_Stations__c==null) ||!(newLead.Audio_Touchscreen_Color__c==null)|| !(newLead.Audio_Door_Station_Style__c==null) ||!(newLead.Audio_Thermostats__c==null)|| !(newLead.Audio_Cameras__c==null) ||!(newLead.Audio_Electronics__c==null)|| !(newLead.Audio_Floor_Plan__c==null) ||!(newLead.Audio_Challenges__c==null)|| !(newLead.Audio_Floor_Plan__c==null) || (newLead.Audio_Has_Surround_Sound__c) || (newLead.Audio_Home_Theater__c) || (newLead.Audio_Has_Outdoor__c) || (newLead.Audio_Floor_Plan_Available__c)){
                   newLead.Is_Audio_Filled__c = true;
               }
            if(!(newLead.Lighting_Design_Type__c == null) || !(newLead.Lighting_Project_Size__c== null) || !(newLead.Lighting_Design_Overview__c==null) || !(newLead.Dimming_Type__c==null) || !(newLead.Total_Lighting_Zones__c==null) || !(newLead.Total_Lighting_Loads__c==null) || !(newLead.Total_3_Way_Light_Loads__c==null) || !(newLead.Total_Dimmable__c==null) || !(newLead.Lighting_Floor_Plan__c==null) || !(newLead.Lighting_Challenges__c==null)|| !(newLead.Central_Design_Special_Request__c==null)|| !(newLead.Central_Design_Type__c==null) || (newLead.Lighting_Floor_Plan_Available__c)){
                   newLead.Is_Lightning_Filled__c = true;
               }
            if(!(newLead.Wireless_High_Throughput_Devices__c == null) || !(newLead.Wireless_Low_Throughput_Devices__c== null) || !(newLead.Wired_High_Throughput_Devices__c==null) || !(newLead.Wired_Low_Throughput_Devices__c==null) || !(newLead.Network_POE__c==null) || !(newLead.Network_PoEPlus__c==null) || !(newLead.Secondary_Switch_Qty__c==null) || !(newLead.Estimated_PoE_Wattage__c==null) || !(newLead.Network_Aesthetic__c==null) || !(newLead.Home_Size__c==null)|| !(newLead.Home_Size_Unit__c==null)|| !(newLead.Interior_Wall_Material__c==null) || !(newLead.Ceiling_Material__c==null)|| !(newLead.Environment__c==null) || !(newLead.Floors__c==null)|| !(newLead.Network_Challenges__c==null) || !(newLead.Network_Speed__c==null)|| !(newLead.Network_Speed_Unit__c==null) || !(newLead.Network_Peak_Usage__c==null)|| !(newLead.Network_Floorplan__c == null) ||(newLead.Advanced_Management__c) || (newLead.Secondary_Switch__c) || (newLead.Secondary_Managed_Switch__c) || (newLead.Secondary_Switch_PoE__c) ||(newLead.Outdoor__c) || (newLead.Network_Floorplan_Available__c)){
                   newLead.Is_Network_Filled__c = true;
               }
        }
    }
    public static void LeadDesign(List<Lead> leadList){
        List<Design_Services__c> newDesignList = new List<Design_Services__c>();	        
       
        for(Lead newLead:leadList){
            if(newLead.RecordTypeId == leadRT ){                
                if(newLead.Is_Theater_Filled__c == true){    
                    newDesignList.add(createRecord(newLead, designservicesRTList.get('Theater Design').getRecordTypeId(), 'Theater Design'));   
                }
                if(newLead.Is_Audio_Filled__c == true){                  
                    newDesignList.add(createRecord(newLead, designservicesRTList.get('Audio Design').getRecordTypeId(), 'Audio Design'));
                }
                if(newLead.Is_Lightning_Filled__c == true){
                    newDesignList.add(createRecord(newLead, designservicesRTList.get('Lighting Design').getRecordTypeId(), 'Lighting Design'));
                } 
                if(newLead.Is_Network_Filled__c == true){
                    newDesignList.add(createRecord(newLead, designservicesRTList.get('Network Design').getRecordTypeId(), 'Network Design'));                   
                }                                                      
            }
        }
        if(!newDesignList.isEmpty()){
            insert newDesignList;
        }
        
    }
    public static Design_Services__c createRecord(Lead leadRec, Id leadRT, String recTypeName ){
         
        Design_Services__c newDesignRecord = new Design_Services__c();         
        if(recTypeName=='Theater Design') {
            newDesignRecord.RecordTypeId = leadRT;
            newDesignRecord.Theater_Type__c = leadRec.Theater_Type__c;
            newDesignRecord.Theater_Floorplan__c = leadRec.Theater_Floorplan__c;
            newDesignRecord.Theater_Floor_Plan_Available__c = leadRec.Theater_Floor_Plan_Available__c;
            newDesignRecord.Theater_Dimensions__c = leadRec.Theater_Dimensions__c;
            newDesignRecord.Theater_Display__c = leadRec.Theater_Display__c;
            newDesignRecord.Theater_Display_Type__c = leadRec.Theater_Display_Type__c;
            newDesignRecord.Theater_Electronics__c = leadRec.Theater_Electronics__c;
            newDesignRecord.Theater_Ceiling_Depth__c = leadRec.Theater_Ceiling_Depth__c;
            newDesignRecord.Theater_Wall_Depth__c = leadRec.Theater_Wall_Depth__c;
            newDesignRecord.Theater_Seating__c = leadRec.Theater_Seating__c;
            newDesignRecord.Theater_Speaker_Placement__c = leadRec.Theater_Speaker_Placement__c;
            newDesignRecord.Theater_Speaker_Layout__c = leadRec.Theater_Speaker_Layout__c;
            newDesignRecord.Theater_Speaker_Line__c = leadRec.Theater_Speaker_Line__c;
            newDesignRecord.Theater_Max_Volume__c = leadRec.Theater_Max_Volume__c;
            newDesignRecord.Theater_Customer_Budget__c = leadRec.Theater_Customer_Budget__c;
            newDesignRecord.Theater_Challenges__c = leadRec.Theater_Challenges__c;
        }   
        if(recTypeName=='Audio Design') {
            newDesignRecord.RecordTypeId = leadRT;
            newDesignRecord.Audio_Zones_Qty__c = leadRec.Audio_Zones_Qty__c;
            newDesignRecord.Audio_Customer_Budget__c = leadRec.Audio_Customer_Budget__c;
            newDesignRecord.Audio_Room_Detail__c = leadRec.Audio_Room_Detail__c;
            newDesignRecord.Audio_Wall_Depth__c = leadRec.Audio_Wall_Depth__c;
            newDesignRecord.Audio_Ceiling_Depth__c = leadRec.Audio_Ceiling_Depth__c;
            newDesignRecord.Audio_Speaker_Pair_Qty__c = leadRec.Audio_Speaker_Pair_Qty__c;
            newDesignRecord.Audio_Speaker_Layout__c = leadRec.Audio_Speaker_Layout__c;
            newDesignRecord.Audio_Speaker_Placement__c = leadRec.Audio_Speaker_Placement__c;
            newDesignRecord.Audio_Speaker_Line__c = leadRec.Audio_Speaker_Line__c;
            newDesignRecord.Audio_Max_Volume__c = leadRec.Audio_Max_Volume__c;
            newDesignRecord.Audio_With_Tv__c = leadRec.Audio_With_Tv__c;
            newDesignRecord.Audio_Onscreen_Navigator__c = leadRec.Audio_Onscreen_Navigator__c;
            newDesignRecord.Audio_Tv_Input__c = leadRec.Audio_Tv_Input__c;
            newDesignRecord.Audio_Surround_Sound__c = leadRec.Audio_Surround_Sound__c;
            newDesignRecord.Audio_Stereo_Sound__c = leadRec.Audio_Stereo_Sound__c;
            newDesignRecord.Audio_Outdoor__c = leadRec.Audio_Outdoor__c;
            newDesignRecord.Audio_Ten_Inch_Portable__c = leadRec.Audio_Ten_Inch_Portable__c;
            newDesignRecord.Audio_Seven_Inch_Portable__c = leadRec.Audio_Seven_Inch_Portable__c;
            newDesignRecord.Audio_Seven_Inch_InWall__c = leadRec.Audio_Seven_Inch_InWall__c;
            newDesignRecord.Audio_Ten_Inch_InWall__c = leadRec.Audio_Ten_Inch_InWall__c;
            newDesignRecord.Audio_Configurable_Keypad__c = leadRec.Audio_Configurable_Keypad__c;
            newDesignRecord.Audio_Door_Stations__c = leadRec.Audio_Door_Stations__c;
            newDesignRecord.Audio_Touchscreen_Color__c = leadRec.Audio_Touchscreen_Color__c;
            newDesignRecord.Audio_Door_Station_Style__c = leadRec.Audio_Door_Station_Style__c;
            newDesignRecord.Audio_Thermostats__c = leadRec.Audio_Thermostats__c;
            newDesignRecord.Audio_Cameras__c = leadRec.Audio_Cameras__c;
            newDesignRecord.Audio_Electronics__c = leadRec.Audio_Electronics__c;
            newDesignRecord.Audio_Has_Surround_Sound__c = leadRec.Audio_Has_Surround_Sound__c;
            newDesignRecord.Audio_Home_Theater__c = leadRec.Audio_Home_Theater__c;
            newDesignRecord.Audio_Outdoor__c = leadRec.Audio_Outdoor__c;
            newDesignRecord.Audio_Floor_Plan_Available__c = leadRec.Audio_Floor_Plan_Available__c;
            newDesignRecord.Audio_Floor_Plan__c = leadRec.Audio_Floor_Plan__c;
            newDesignRecord.Audio_Challenges__c = leadRec.Audio_Challenges__c;     
        }
        if(recTypeName=='Lighting Design') {
            newDesignRecord.RecordTypeId = leadRT;
            newDesignRecord.Lighting_Design_Type__c = leadRec.Lighting_Design_Type__c;
            newDesignRecord.Lighting_Project_Size__c = leadRec.Lighting_Project_Size__c;     
			newDesignRecord.Lighting_Design_Overview__c = leadRec.Lighting_Design_Overview__c;     
            newDesignRecord.Dimming_Type__c = leadRec.Dimming_Type__c;     
            newDesignRecord.Total_Lighting_Zones__c = leadRec.Total_Lighting_Zones__c;     
            newDesignRecord.Total_Light_Loads__c = leadRec.Total_Lighting_Loads__c;     
            newDesignRecord.Total_Dimmable__c = leadRec.Total_Dimmable__c;     
            newDesignRecord.Lighting_Floor_Plan_Available__c = leadRec.Lighting_Floor_Plan_Available__c;     
            newDesignRecord.Lighting_Floor_Plan__c = leadRec.Lighting_Floor_Plan__c;     
            newDesignRecord.Lighting_Challenges__c = leadRec.Lighting_Challenges__c;     
            newDesignRecord.Central_Design_Special_Request__c = leadRec.Central_Design_Special_Request__c;     
            newDesignRecord.Central_Design_Type__c = leadRec.Central_Design_Type__c;     
        }
        if(recTypeName=='Network Design') {
            newDesignRecord.RecordTypeId = leadRT;
            newDesignRecord.Wireless_High_Throughput_Devices__c = leadRec.Wireless_High_Throughput_Devices__c;     
            newDesignRecord.Wireless_Low_Throughput_Devices__c = leadRec.Wireless_Low_Throughput_Devices__c;     
            newDesignRecord.Wired_High_Throughput_Devices__c = leadRec.Wired_High_Throughput_Devices__c;     
            newDesignRecord.Wired_Low_Throughput_Devices__c = leadRec.Wired_Low_Throughput_Devices__c;     
            newDesignRecord.Network_PoE__c = leadRec.Network_PoE__c;     
            newDesignRecord.Network_PoEPlus__c = leadRec.Network_PoEPlus__c;     
            newDesignRecord.Advanced_Management__c = leadRec.Advanced_Management__c;     
            newDesignRecord.Secondary_Switch__c = leadRec.Secondary_Switch__c;     
            newDesignRecord.Secondary_Managed_Switch__c = leadRec.Secondary_Managed_Switch__c;     
            newDesignRecord.Secondary_Switch_PoE__c = leadRec.Secondary_Switch_PoE__c;     
            newDesignRecord.Secondary_Switch_Qty__c = leadRec.Secondary_Switch_Qty__c;     
            newDesignRecord.Estimated_PoE_Wattage__c = leadRec.Estimated_PoE_Wattage__c;     
            newDesignRecord.Network_Aesthetic__c = leadRec.Network_Aesthetic__c;     
            newDesignRecord.Home_Size_Unit__c = leadRec.Home_Size_Unit__c;     
            newDesignRecord.Interior_Wall_Material__c = leadRec.Interior_Wall_Material__c;     
            newDesignRecord.Home_Size__c = leadRec.Home_Size__c;     
            newDesignRecord.Ceiling_Material__c = leadRec.Ceiling_Material__c;     
            newDesignRecord.Environment__c = leadRec.Environment__c;     
            newDesignRecord.Floors__c = leadRec.Floors__c;     
            newDesignRecord.Outdoor__c = leadRec.Outdoor__c;     
            newDesignRecord.Network_Challenges__c = leadRec.Network_Challenges__c;     
            newDesignRecord.Network_Speed__c = leadRec.Network_Speed__c;     
            newDesignRecord.Network_Speed_Unit__c = leadRec.Network_Speed_Unit__c;     
            newDesignRecord.Network_Peak_Usage__c = leadRec.Network_Peak_Usage__c;     
            newDesignRecord.Network_Floorplan_Available__c = leadRec.Network_Floorplan_Available__c;     
            newDesignRecord.Network_Floorplan__c = leadRec.Network_Floorplan__c;         
        }
        newDesignRecord.Lead__c = leadRec.Id;
		return newDesignRecord;    
    }
    public static void ConvertedUpdField(List<Lead> leadList){
        Map<Id, Lead> leadIds = new Map<Id,Lead>();
        List<Design_Services__c> leadDesingList = new List<Design_Services__c>();
        for(Lead newLead:leadList){
            if(newLead.ConvertedOpportunityId != null){
                leadIds.put(newLead.Id, newLead);
            }
        }
        for(Design_Services__c desRec : [SELECT Opportunity__c, Lead__c 
                                         FROM Design_Services__c 
                                         WHERE Lead__c IN: leadIds.keySet()]){            
			leadDesingList.add(new Design_Services__c(Id = desRec.Id,
                                                      Opportunity__c = leadIds.get(desRec.Lead__c).ConvertedOpportunityId));                                    
        }
        if(!leadDesingList.isEmpty()){
            update leadDesingList;
        }
    }
} 
//check record type
//check fields
//create record - Design Services Object
//plug in values from new lead
//new method dynamic param:list of leads,id from map
//method returns design services