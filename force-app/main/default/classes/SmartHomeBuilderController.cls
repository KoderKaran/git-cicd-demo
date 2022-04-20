global class SmartHomeBuilderController {

    public SmartHomeBuilderController(ApexPages.StandardController stdController) {
        Lead currentLead = (Lead)stdController.getRecord();
    }

    @AuraEnabled
    public static Lead getLeadInfo(String leadId) {
        List<Lead> leadInfo = [
            SELECT Id, Name, Street, City, State, Country, PostalCode
            FROM Lead
            WHERE Id =:leadId
            LIMIT 1 
        ];
        if (!leadInfo.isEmpty()) {
            return leadInfo.get(0);
        }
        return null;
    }

    @AuraEnabled
	public static void saveSmartRecords (String leadId, HomeBuilder__c smrt,  List<String> listClimate, List<String> listTv, List<String> listSmart, List<String> listMusic, List<String> listSecurity, List<String> listOtherHome) {
        
        List<Lead> leadInfo = [
            SELECT Id, Name, Street, City, State, Country, PostalCode, Lead_Message__c
            FROM Lead
            WHERE Id =:leadId
            LIMIT 1
        ];

        String leadName = leadInfo.get(0).Name;
        String nameForComponent = ' Home Builder Component';

        smrt.Name = leadName + ' Home Builder';
        insert smrt;

        if (leadInfo != null) {
            if ((smrt.Lead_Message__c != null) && (smrt.Lead_Message__c != '')) {
                leadInfo.get(0).Lead_Message__c = smrt.Lead_Message__c;
            }
        }

        update leadInfo.get(0);     

        String homeBuilderId = smrt.Id;
        String componentTv = 'Television';
        String componentSmart = 'Smart Lighting';
        String componentMusic = 'Music';
        String componentSecurity = 'Security';
        String componentClimate = 'Climate';
        String componentOtherHome = 'Other';
        String componentAdditional = 'Controller';  
        Integer totalPotentialValue = Integer.valueOf(smrt.Potential_value__c);      

        List<Home_Builder_Component__c> lstCompData = new List<Home_Builder_Component__c>();

        if (!listTv.isEmpty()) {
            System.debug(' listTv +++++ ' + listTv);
            Integer listSize = listTv.size();
            Integer noOfTv = listSize > 0 && String.isNotBlank(listTv.get(0)) ? Integer.valueOf(listTv.get(0)) : null;
            String roomA = listSize > 1 ? listTv.get(1) : null;
            Integer noOfRooms = listSize > 2 && String.isNotBlank(listTv.get(2)) ? Integer.valueOf(listTv.get(2)) : null;
            String roomB = listSize > 4 ? listTv.get(4) : null;
            String roomC = listSize > 5 ? listTv.get(5) : null;            
            
            if (noOfTv != null) {
                lstCompData.add(new Home_Builder_Component__c(
                    Name = componentTv + ' ' + leadName + nameForComponent, 
                    Home_builder__c = homeBuilderId,
                    Component_Type__c = componentTv,
                    NonC4_Potential_Value__c = noOfTv * 1000,
                    Number__c = noOfTv)
                );
            }
            if (roomA != null && noOfRooms != null) {
                lstCompData.add(new Home_Builder_Component__c(
                    Name = componentTv + ' ' + leadName + nameForComponent, 
                    Home_builder__c = homeBuilderId,
                    Component_Type__c = componentTv,
                    Number__c = noOfRooms,
                    C4_Potential_Value__c = noOfRooms * 200,
                    Room_Component__c = roomA)
                );
            }
            if (roomB != null) {
                lstCompData.add(new Home_Builder_Component__c(
                    Name = componentTv + ' ' + leadName + nameForComponent, 
                    Home_builder__c = homeBuilderId,
                    Component_Type__c = componentSmart,
                    Number__c = 1,
                    Room_Component__c = roomB)
                );
            }
            if (roomC != null) {
                lstCompData.add(new Home_Builder_Component__c(
                    Name = componentTv + ' ' + leadName + nameForComponent, 
                    Home_builder__c = homeBuilderId,
                    Component_Type__c = componentSmart,
                    Number__c = 1,
                    Room_Component__c = roomC)
                );
            }
       } 

        if (!listSmart.isEmpty()) {
        Integer noOfSm = listSmart.size() > 5 && String.isNotBlank(listSmart.get(5)) ? Integer.valueOf(listSmart.get(5)) : null;
        String roomA = listSmart.size() > 0 ? listSmart.get(0) : null;
        String roomB = listSmart.size() > 1 ? listSmart.get(1) : null;
        String roomC = listSmart.size() > 2 ? listSmart.get(2) : null;
        String roomD = listSmart.size() > 3 ? listSmart.get(3) : null;
        String roomE = listSmart.size() > 4 ? listSmart.get(4) : null;

            if (noOfSm != null && roomA != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentSmart + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentSmart,
                        Room_Component__c = roomA,
                        Number__c = noOfSm,
                        C4_Potential_Value__c = noOfSm * 250)
                );
            }
            if (roomB != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentSmart + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentSmart,
                        Number__c = 6,
                        Room_Component__c = roomB,
                        C4_Potential_Value__c = 250 * 6)
                );
            }
            if (roomC != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentSmart + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentSmart,
                        Number__c = 1,
                        Room_Component__c = roomC,
                        C4_Potential_Value__c = 250)
                );
            }
            if (roomD != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentSmart + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentSmart,
                        Number__c = 2,
                        Room_Component__c = roomD,
                        C4_Potential_Value__c = 500)
                );
            }
            if (roomE != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentSmart + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentSmart,
                        Room_Component__c = roomE,
                        Number__c = noOfSm,
                        C4_Potential_Value__c = noOfSm * 250) 
                );
            }
        }

        if (!listMusic.isEmpty()) {
        Integer noOfSm = listMusic.size() > 5 && String.isNotBlank(listMusic.get(5)) ? Integer.valueOf(listMusic.get(5)) : null;
        String roomA = listMusic.size() > 0 ? listMusic.get(0) : null;
        String roomB = listMusic.size() > 1 ? listMusic.get(1) : null;
        String roomC = listMusic.size() > 2 ? listMusic.get(2) : null;
        String roomD = listMusic.size() > 3 ? listMusic.get(3) : null;
        String roomE = listMusic.size() > 4 ? listMusic.get(4) : null;

            if (noOfSm != null && roomA != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentMusic + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentMusic,
                        Room_Component__c = roomA,
                        Number__c = noOfSm,
                        C4_Potential_Value__c = noOfSm * 750)
                );
            }
            if (roomB != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentMusic + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentMusic,
                        Number__c = 2,
                        Room_Component__c = roomB,
                        C4_Potential_Value__c = 2 * 750)
                );
            }
            if (roomC != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentMusic + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentMusic,
                        Number__c = 1,
                        Room_Component__c = roomC,
                         C4_Potential_Value__c = 750)
                );
            }
            if (roomD != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentMusic + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentMusic,
                        Number__c = 2,
                        Room_Component__c = roomD,
                        C4_Potential_Value__c = 1500)
                );
            }
            if (roomE != null ) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentMusic + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentMusic,
                        Room_Component__c = roomE,
                        Number__c = noOfSm,
                        C4_Potential_Value__c = noOfSm * 750) 
                );
            }

            Decimal noOfRoomsNonC4;
            Integer roundRooms;
            Decimal decimalRooms;
            String noOfRoomsNonC4istring = listMusic.size() > 6 ? listMusic.get(6) : null;
            if (noOfRoomsNonC4istring != null) {
                noOfRoomsNonC4 = Decimal.valueOf(noOfRoomsNonC4istring);
                decimalRooms = noOfRoomsNonC4/8;
                roundRooms = (integer)decimalRooms.round(system.RoundingMode.UP);
                System.debug('roundRooms + ' + roundRooms + '  ' + decimalRooms + ' ' + noOfRoomsNonC4);
            }

            if (noOfRoomsNonC4 != null) {
                        lstCompData.add(new Home_Builder_Component__c(
                        Name = componentMusic + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentMusic,
                        Room_Component__c = 'Amp',
                        Number__c = roundRooms
                        ) 
                    );
                        lstCompData.add(new Home_Builder_Component__c(
                        Name = componentMusic + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentMusic,
                        Room_Component__c = 'AV Switch',
                        Number__c = roundRooms,
                        NonC4_Potential_Value__c = roundRooms*200
                        ) 
                    );
            }
        }    

        if (!listSecurity.isEmpty()) {
        String roomA = listSecurity.size() > 0 ? listSecurity.get(0) : null;
        String roomB = listSecurity.size() > 2 ? listSecurity.get(2) : null;
        String roomC = listSecurity.size() > 4 ? listSecurity.get(4) : null;
        //String roomD = listSecurity.size() > 3 ? listSecurity.get(3) : null;
      
            if (roomA != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentSecurity + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentSecurity,
                        Number__c = 3,
                        C4_Potential_Value__c = 900,
                        Room_Component__c = roomA)
                );
            }
            if (roomB != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentSecurity + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentSecurity,
                        Number__c = 5,
                        C4_Potential_Value__c = 2000,
                        Room_Component__c = roomB)
                );
            }
            if (roomC != null) {
                lstCompData.add(new Home_Builder_Component__c(
                        Name = componentSecurity + ' ' + leadName + nameForComponent, 
                        Home_builder__c = homeBuilderId,
                        Component_Type__c = componentSecurity,
                        Number__c = 1,
                        C4_Potential_Value__c = 1800,
                        Room_Component__c = roomC)
                );
            }
        }

        if (!listClimate.isEmpty()) {
        Integer noOfCli = listClimate.size() > 0 && String.isNotBlank(listClimate.get(0)) ? Integer.valueOf(listClimate.get(0)) : null;
            if (noOfCli != null) {
                Home_Builder_Component__c homeBuildComp = new Home_Builder_Component__c(
                    Name = componentClimate + ' ' + leadName + nameForComponent, 
                    Home_builder__c = smrt.Id,
                    Component_Type__c = componentClimate,
                    Number__c = noOfCli,
                    C4_Potential_Value__c = noOfCli * 350,
                    Room_Component__c = 'Thermostats'
                );
            lstCompData.add(homeBuildComp);
            }
        } 

        if (!listOtherHome.isEmpty()) {
        //System.debug('listOtherHome +++ ' + listOtherHome);
        String other_description = listOtherHome.size() > 0 ? listOtherHome.get(0) : null;
            if (other_description != null) {
                Home_Builder_Component__c homeBuildComp = new Home_Builder_Component__c(
                    Name = componentOtherHome + ' ' + leadName + nameForComponent, 
                    Home_builder__c = smrt.Id,
                    Component_Type__c = componentOtherHome,
                    Other_Description__c = other_description
                );
            lstCompData.add(homeBuildComp);
            }
        }    

        if (totalPotentialValue != null) {
            Integer starterController = 10000;
            Integer premiumController = 25000;
            String valueForRoomField = 'Whole Home';

            if (totalPotentialValue<=starterController) {
                Home_Builder_Component__c homeBuildComp = new Home_Builder_Component__c(
                    Name = componentAdditional + ' EA1 ' + leadName + nameForComponent, 
                    Home_builder__c = smrt.Id,
                    Component_Type__c = 'Controller EA1',
                    Number__c = 1,
                    Room_Component__c = valueForRoomField,
                    C4_Potential_Value__c = 500
                );
                lstCompData.add(homeBuildComp);
            }
            if ((totalPotentialValue>starterController) && (totalPotentialValue<=premiumController)) {
                Home_Builder_Component__c homeBuildComp = new Home_Builder_Component__c(
                    Name = componentAdditional + ' EA3 ' + leadName + nameForComponent, 
                    Home_builder__c = smrt.Id,
                    Component_Type__c = 'Controller EA3',
                    Number__c = 1,
                    Room_Component__c = valueForRoomField,
                    C4_Potential_Value__c = 1000
                );
            lstCompData.add(homeBuildComp);

            }
            if (totalPotentialValue>premiumController) {
                Home_Builder_Component__c homeBuildComp = new Home_Builder_Component__c(
                    Name = componentAdditional + ' EA5 ' + leadName + nameForComponent, 
                    Home_builder__c = smrt.Id,
                    Component_Type__c = 'Controller EA5',
                    Number__c = 1,
                    Room_Component__c = valueForRoomField,
                    C4_Potential_Value__c = 2000
                );
            lstCompData.add(homeBuildComp);
                
            }
        }        

        if (lstCompData.isEmpty()) {
            return;
        }
        insert lstCompData;
    }
}