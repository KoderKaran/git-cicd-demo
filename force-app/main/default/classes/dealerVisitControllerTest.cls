/**
* ====================================================================================================
*     Version     Date            Comment
* ====================================================================================================
*     1.0         27-Mar-2017     -Test class for dealerVisitController.
*     1.1         16-Nov-2017     -Updated test class to execute for dealerVisitController2 class and dealerVisitClone Page
*      
**/
@isTest
private class dealerVisitControllerTest {
    
    public static Account testDataAccount() {
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.Premier_Status_Breakpoint_1__c = 75000;
        objAccount.Premier_Status_Breakpoint_2__c = 150000;
        objAccount.Premier_Status_Breakpoint_3__c = 250000;
        return objAccount;
    }
    
    
    public static Product2 createProductForAllSubCategories(String category, String subCategory) {
        Product2 product2Obj = new Product2();
        product2Obj.Name = 'testProduct '+category;
        product2Obj.Dealer_Sales_Category__c = category;
        product2Obj.Dealer_Sales_Sub_Category__c = subCategory;
        product2Obj.IsActive = true;
        insert product2Obj;
        return product2Obj;
    }
    
    public static List<Product2> createProduct() {
        List<Product2> product2List = new List<Product2>();
        Product2 product2Obj = new Product2();
        product2Obj.Name = 'testProduct Controllers';
        product2Obj.Dealer_Sales_Category__c = 'Controllers';
        product2Obj.Dealer_Sales_Sub_Category__c = 'EA5';
        product2Obj.IsActive = true;
        product2List.add(product2Obj);
        Product2 product2Controller2Obj = new Product2();
        product2Controller2Obj.Name = 'testProduct Controllers2';
        product2Controller2Obj.Dealer_Sales_Category__c = 'Controllers';
        product2Controller2Obj.Dealer_Sales_Sub_Category__c = 'EA1';
        product2Controller2Obj.IsActive = true;
        Product2 product2Controller3Obj = new Product2();
        product2Controller3Obj.Name = 'testProduct Controllers2';
        product2Controller3Obj.Dealer_Sales_Category__c = 'Controllers';
        product2Controller3Obj.Dealer_Sales_Sub_Category__c = '';
        product2Controller3Obj.IsActive = true;
        product2List.add(product2Controller3Obj);
        Product2 product2AudioObj = new Product2();
        product2AudioObj.Name = 'testProduct Audio';
        product2AudioObj.Dealer_Sales_Category__c = 'Audio';
        product2AudioObj.Dealer_Sales_Sub_Category__c = 'Audio Matrix';
        product2AudioObj.IsActive = true;
        product2List.add(product2AudioObj);
        Product2 product2Audio2Obj = new Product2();
        product2Audio2Obj.Name = 'testProduct Audio2';
        product2Audio2Obj.Dealer_Sales_Category__c = 'Audio';
        product2Audio2Obj.Dealer_Sales_Sub_Category__c = 'Audio Matrix';
        product2Audio2Obj.IsActive = true;
        product2List.add(product2Audio2Obj);
        Product2 product2Audio3Obj = new Product2();
        product2Audio3Obj.Name = 'testProduct Audio2';
        product2Audio3Obj.Dealer_Sales_Category__c = 'Audio';
        product2Audio3Obj.Dealer_Sales_Sub_Category__c = '';
        product2Audio3Obj.IsActive = true;
        product2List.add(product2Audio3Obj);
        Product2 product2VideoObj = new Product2();
        product2VideoObj.Name = 'testProduct Video';
        product2VideoObj.Dealer_Sales_Category__c = 'Video';
        product2VideoObj.Dealer_Sales_Sub_Category__c = 'Extenders';
        product2VideoObj.IsActive = true;
        product2List.add(product2VideoObj);
        Product2 product2Video2Obj = new Product2();
        product2Video2Obj.Name = 'testProduct Video2';
        product2Video2Obj.Dealer_Sales_Category__c = 'Video';
        product2Video2Obj.Dealer_Sales_Sub_Category__c = 'Extenders';
        product2Video2Obj.IsActive = true;
        product2List.add(product2Video2Obj);
        Product2 product2LightingObj = new Product2();
        product2LightingObj.Name = 'testProduct Lighting';
        product2LightingObj.Dealer_Sales_Category__c = 'Lighting';
        product2LightingObj.Dealer_Sales_Sub_Category__c = 'Face Plates';
        product2LightingObj.IsActive = true;
        product2List.add(product2LightingObj);
        Product2 product2Lighting2Obj = new Product2();
        product2Lighting2Obj.Name = 'testProduct Lighting2';
        product2Lighting2Obj.Dealer_Sales_Category__c = 'Lighting';
        product2Lighting2Obj.Dealer_Sales_Sub_Category__c = 'Face Plates';
        product2Lighting2Obj.IsActive = true;
        product2List.add(product2Lighting2Obj);
        Product2 product2ClimateControlObj = new Product2();
        product2ClimateControlObj.Name = 'testProduct Climate Control';
        product2ClimateControlObj.Dealer_Sales_Category__c = 'Climate';
        product2ClimateControlObj.Dealer_Sales_Sub_Category__c = 'Thermostat';
        product2ClimateControlObj.IsActive = true;
        product2List.add(product2ClimateControlObj);
        Product2 product2ClimateControl2Obj = new Product2();
        product2ClimateControl2Obj.Name = 'testProduct Climate Control2';
        product2ClimateControl2Obj.Dealer_Sales_Category__c = 'Climate';
        product2ClimateControl2Obj.Dealer_Sales_Sub_Category__c = 'Thermostat';
        product2ClimateControl2Obj.IsActive = true;
        product2List.add(product2ClimateControl2Obj);
        Product2 product2PakedgeObj = new Product2();
        product2PakedgeObj.Name = 'testProduct Pakedge';
        product2PakedgeObj.Dealer_Sales_Category__c = 'Pakedge';
        product2PakedgeObj.Dealer_Sales_Sub_Category__c = 'WAPs';
        product2PakedgeObj.IsActive = true;
        product2List.add(product2PakedgeObj);
        Product2 product2Pakedge2Obj = new Product2();
        product2Pakedge2Obj.Name = 'testProduct Pakedge2';
        product2Pakedge2Obj.Dealer_Sales_Category__c = 'Pakedge';
        product2Pakedge2Obj.Dealer_Sales_Sub_Category__c = 'WAPs';
        product2Pakedge2Obj.IsActive = true;
        product2List.add(product2Pakedge2Obj);
        Product2 product2InterfaceAndCommObj = new Product2();
        product2InterfaceAndCommObj.Name = 'testProduct interfaces and Communnication';
        product2InterfaceAndCommObj.Dealer_Sales_Category__c = 'Interface / Communication';
        product2InterfaceAndCommObj.Dealer_Sales_Sub_Category__c = 'Remotes';
        product2InterfaceAndCommObj.IsActive = true;
        product2List.add(product2InterfaceAndCommObj);
        Product2 product2InterfaceAndComm2Obj = new Product2();
        product2InterfaceAndComm2Obj.Name = 'testProduct interfaces and Communnication2';
        product2InterfaceAndComm2Obj.Dealer_Sales_Category__c = 'Interface / Communication';
        product2InterfaceAndComm2Obj.Dealer_Sales_Sub_Category__c = 'Remotes';
        product2InterfaceAndComm2Obj.IsActive = true;
        product2List.add(product2InterfaceAndComm2Obj);
        Product2 product2triadObj = new Product2();
        product2triadObj.Name = 'testProduct Triad';
        product2triadObj.Dealer_Sales_Category__c = 'Triad';
        product2triadObj.IsActive = true;
        product2List.add(product2triadObj);
        Product2 product2LocksObj = new Product2();
        product2LocksObj.Name = 'testProduct Locks';
        product2LocksObj.Dealer_Sales_Category__c = 'Door Locks';
        product2LocksObj.IsActive = true;
        product2List.add(product2LocksObj);
        Product2 product2ThirdPartyObj = new Product2();
        product2ThirdPartyObj.Name = 'testProduct Third Party';
        product2ThirdPartyObj.Dealer_Sales_Category__c = '3rd Party';
        product2ThirdPartyObj.IsActive = true;
        product2List.add(product2ThirdPartyObj);
        Product2 product2CardAccessObj = new Product2();
        product2CardAccessObj.Name = 'testProduct Card Access';
        product2CardAccessObj.Dealer_Sales_Category__c = 'Card Access';
        product2CardAccessObj.IsActive = true;
        product2List.add(product2CardAccessObj);
        return product2List;
    }
    
    public static void createSalesLogForAudio1 (Id accId){
        Product2 product = createProductForAllSubCategories('Audio','70 Volt Amplifiers');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForAudio2 (Id accId){
        Product2 product = createProductForAllSubCategories('Audio','70 Volt Amplifiers');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Audio','Audio Accessories');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
    }
    
    public static void createSalesLogForAudio (Id accId){
        Product2 product = createProductForAllSubCategories('Audio','70 Volt Amplifiers');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Audio','Audio Accessories');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Audio','Audio Switches');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
    }
    public static void createSalesLogForAudio4 (Id accId){
        Product2 product = createProductForAllSubCategories('Audio','70 Volt Amplifiers');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Audio','Audio Accessories');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Audio','Audio Switches');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Audio','Power Amplifiers');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
    }
    
    public static void createSalesLogForAudio5 (Id accId){
        Product2 product = createProductForAllSubCategories('Audio','70 Volt Amplifiers');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Audio','Audio Accessories');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Audio','Audio Switches');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Audio','Power Amplifiers');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
        Product2 product5 = createProductForAllSubCategories('Audio','Matrix Amplifiers');
        createDailyDealer(product5,accId);
        createDailyDealerForLastYear(product5,accId);
    }
    
    public static void createSalesLogForVideo1 (Id accId){
        Product2 product = createProductForAllSubCategories('Video','Extenders');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForVideo2 (Id accId){
        Product2 product = createProductForAllSubCategories('Video','Extenders');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Video','HDMI');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
    }
    public static void createSalesLogForVideo3 (Id accId){
        Product2 product = createProductForAllSubCategories('Video','Extenders');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Video','HDMI');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Video','Video Accessories');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
    }
    
    
    
    public static void createSalesLogForClimate1 (Id accId){
        Product2 product = createProductForAllSubCategories('Climate','Climate Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForClimate2 (Id accId){
        Product2 product = createProductForAllSubCategories('Climate','Climate Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Climate','Thermostat');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
    }
    
    public static void createSalesLogForController1 (Id accId){
        Product2 product = createProductForAllSubCategories('Controllers','Controller Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForController2 (Id accId){
        Product2 product = createProductForAllSubCategories('Controllers','Controller Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Controllers','EA1');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
    }
    
    public static void createSalesLogForController (Id accId){
        Product2 product = createProductForAllSubCategories('Controllers','Controller Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Controllers','EA1');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Controllers','EA2');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
    }
    public static void createSalesLogForController4 (Id accId){
        Product2 product = createProductForAllSubCategories('Controllers','Controller Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Controllers','EA1');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Controllers','EA3');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Controllers','EA5');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
    }
    
    public static void createSalesLogForController5 (Id accId){
        Product2 product = createProductForAllSubCategories('Controllers','Controller Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Controllers','EA1');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Controllers','EA3');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Controllers','EA5');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
        Product2 product5 = createProductForAllSubCategories('Controllers','IO Extenders');
        createDailyDealer(product5,accId);
        createDailyDealerForLastYear(product5,accId);
    }
    
    
    public static void createSalesLogForInterfaceComm1 (Id accId){
        Product2 product = createProductForAllSubCategories('Interface / Communication','Door Station');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForInterfaceComm2 (Id accId){
        Product2 product = createProductForAllSubCategories('Interface / Communication','Door Station');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Interface / Communication','Interface Accessories');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
    }
    
    public static void createSalesLogForInterfaceComm3 (Id accId){
        Product2 product = createProductForAllSubCategories('Interface / Communication','Door Station');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Interface / Communication','Interface Accessories');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Interface / Communication','MDU Servers');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
    }
    public static void createSalesLogForInterfaceComm4 (Id accId){
        Product2 product = createProductForAllSubCategories('Interface / Communication','Door Station');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Interface / Communication','Interface Accessories');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Interface / Communication','MDU Servers');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Interface / Communication','Remotes');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
    }
    
    public static void createSalesLogForInterfaceComm5 (Id accId){
        Product2 product = createProductForAllSubCategories('Interface / Communication','Door Station');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Interface / Communication','Interface Accessories');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Interface / Communication','MDU Servers');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Interface / Communication','Remotes');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
        Product2 product5 = createProductForAllSubCategories('Interface / Communication','Touch Screens');
        createDailyDealer(product5,accId);
        createDailyDealerForLastYear(product5,accId);
    }
    
    
    
    public static void createSalesLogForLighting1 (Id accId){
        Product2 product = createProductForAllSubCategories('Lighting','Centralized Lighting');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForLighting2 (Id accId){
        Product2 product = createProductForAllSubCategories('Lighting','Centralized Lighting');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Lighting','Engraving');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
    }
    
    public static void createSalesLogForLighting3 (Id accId){
        Product2 product = createProductForAllSubCategories('Lighting','Centralized Lighting');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Lighting','Engraving');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Lighting','Faceplates');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
    }
    public static void createSalesLogForLighting4 (Id accId){
        Product2 product = createProductForAllSubCategories('Lighting','Centralized Lighting');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Lighting','Engraving');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Lighting','Faceplates');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Lighting','Lighting Accessories');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
    }
    
    public static void createSalesLogForLighting5 (Id accId){
        Product2 product = createProductForAllSubCategories('Lighting','Centralized Lighting');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Lighting','Engraving');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Lighting','Faceplates');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Lighting','Lighting Accessories');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
        Product2 product5 = createProductForAllSubCategories('Lighting','Wireless Gen3');
        createDailyDealer(product5,accId);
        createDailyDealerForLastYear(product5,accId);
    }
    
    
    
    public static void createSalesLogForPakedge1 (Id accId){
        Product2 product = createProductForAllSubCategories('Pakedge','Pakedge Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForPakedge2 (Id accId){
        Product2 product = createProductForAllSubCategories('Pakedge','Pakedge Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Pakedge','PDUs');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
    }
    
    public static void createSalesLogForPakedge3 (Id accId){
        Product2 product = createProductForAllSubCategories('Pakedge','Pakedge Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Pakedge','PDUs');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Pakedge','Routers');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
    }
    public static void createSalesLogForPakedge4 (Id accId){
        Product2 product = createProductForAllSubCategories('Pakedge','Pakedge Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Pakedge','PDUs');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Pakedge','Routers');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Pakedge','Switches');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
    }
    
    public static void createSalesLogForPakedge5 (Id accId){
        Product2 product = createProductForAllSubCategories('Pakedge','Pakedge Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Pakedge','PDUs');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Pakedge','Routers');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Pakedge','Switches');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
        Product2 product5 = createProductForAllSubCategories('Pakedge','WAPs');
        createDailyDealer(product5,accId);
        createDailyDealerForLastYear(product5,accId);
    }
    
    public static void createSalesLogForPakedge6 (Id accId){
        Product2 product = createProductForAllSubCategories('Pakedge','Pakedge Accessories');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
        Product2 product2 = createProductForAllSubCategories('Pakedge','PDUs');
        createDailyDealer(product2,accId);
        createDailyDealerForLastYear(product2,accId);
        Product2 product3 = createProductForAllSubCategories('Pakedge','Routers');
        createDailyDealer(product3,accId);
        createDailyDealerForLastYear(product3,accId);
        Product2 product4 = createProductForAllSubCategories('Pakedge','Switches');
        createDailyDealer(product4,accId);
        createDailyDealerForLastYear(product4,accId);
        Product2 product5 = createProductForAllSubCategories('Pakedge','WAPs');
        createDailyDealer(product5,accId);
        createDailyDealerForLastYear(product5,accId);
        Product2 product6 = createProductForAllSubCategories('Pakedge','Wireless Controllers');
        createDailyDealer(product6,accId);
        createDailyDealerForLastYear(product6,accId);
    }
    
    public static void createSalesLogFor3rdParty (Id accId){
        Product2 product = createProductForAllSubCategories('3rd Party','');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForCardAccess (Id accId){
        Product2 product = createProductForAllSubCategories('Card Access','');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForDoorLock (Id accId){
        Product2 product = createProductForAllSubCategories('Door Locks','');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForNetworking (Id accId){
        Product2 product = createProductForAllSubCategories('Networking','');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForPartnerProducts (Id accId){
        Product2 product = createProductForAllSubCategories('Partner Products','');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    public static void createSalesLogForTriad (Id accId){
        Product2 product = createProductForAllSubCategories('Triad','');
        createDailyDealer(product,accId);
        createDailyDealerForLastYear(product,accId);
    }
    
    
    
    
    public static Daily_Dealer_Sales_Log__c createDailyDealer (Product2 product,Id accId) {
        Daily_Dealer_Sales_Log__c dealer_Sales_CategoryObj = new Daily_Dealer_Sales_Log__c();
        dealer_Sales_CategoryObj.Total_Cost__c = 500;
        dealer_Sales_CategoryObj.Quantity__c = 50;
        dealer_Sales_CategoryObj.Product__c = product.Id;
        dealer_Sales_CategoryObj.Dealer__c = accId;
        dealer_Sales_CategoryObj.Sales_Date__c = System.today();
        insert dealer_Sales_CategoryObj;
        return dealer_Sales_CategoryObj;
    }
    public static Daily_Dealer_Sales_Log__c createDailyDealerForLastYear (Product2 product,Id accId) {
        Daily_Dealer_Sales_Log__c dealer_Sales_CategoryObj = new Daily_Dealer_Sales_Log__c();
        dealer_Sales_CategoryObj.Total_Cost__c = 500;
        dealer_Sales_CategoryObj.Quantity__c = 50;
        dealer_Sales_CategoryObj.Product__c = product.Id;
        dealer_Sales_CategoryObj.Dealer__c = accId;
        dealer_Sales_CategoryObj.Sales_Date__c = System.today().addYears(-1);
        insert dealer_Sales_CategoryObj;
        return dealer_Sales_CategoryObj;
    }
    
    public static void createDealer_Sales_Category (Id accId, List<Product2> productList) {
        List<Daily_Dealer_Sales_Log__c> dealer_Sales_CategoryList = new List<Daily_Dealer_Sales_Log__c>();
        for(Product2 productObj : productList) {
            Daily_Dealer_Sales_Log__c dealer_Sales_CategoryObj = new Daily_Dealer_Sales_Log__c();
            dealer_Sales_CategoryObj.Total_Cost__c = 500;
            dealer_Sales_CategoryObj.Quantity__c = 50;
            dealer_Sales_CategoryObj.Product__c = productObj.Id;
            dealer_Sales_CategoryObj.Dealer__c = accId;
            dealer_Sales_CategoryObj.Sales_Date__c = System.today();
            dealer_Sales_CategoryList.add(dealer_Sales_CategoryObj);
        }
        
        for(Product2 productObj : productList) {
            Daily_Dealer_Sales_Log__c dealer_Sales_CategoryObj = new Daily_Dealer_Sales_Log__c();
            dealer_Sales_CategoryObj.Total_Cost__c = 500;
            dealer_Sales_CategoryObj.Quantity__c = 50;
            dealer_Sales_CategoryObj.Product__c = productObj.Id;
            dealer_Sales_CategoryObj.Dealer__c = accId;
            dealer_Sales_CategoryObj.Sales_Date__c = System.today().addYears(-1);
            dealer_Sales_CategoryList.add(dealer_Sales_CategoryObj);
        }
        insert dealer_Sales_CategoryList;
    }
    
    public static list<Contact> testDataContact(Id accountId) {
        List<Contact> lstContact = new List<Contact>();
        
        for(integer i=0;i<4;i++) {
            Contact objContact = new Contact();
            objContact.LastName = 'Test Contact' + i;
            objContact.AccountId = accountId;
            lstContact.add(objContact);
        }
        return lstContact;
    }
    
    public static Task testDataTask(Id accountId) {
        Task objTask = new Task();
        objTask.Subject = 'Other';
        objTask.Priority = 'Normal';
        objTask.Status = 'In Progress';
        objTask.WhatId = accountId;
        objTask.OwnerId = UserInfo.getUserId();
        return objTask;
    }
    
    // Method tests Creation of Tasks, Sales Notes, Discussion Items when we select Contact and populate Dealer Engagement fields
    @isTest static void testCheckSelectedContacts() {
        
        // Create Account
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 2000;
        objAcc.YTD_Revenue__c = 2500;
        insert objAcc;
        
        // Create Products
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [SELECT Id FROM Product2 LIMIT 10];
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio(objAcc.Id);
        createSalesLogForController(objAcc.Id);
        createSalesLogForClimate1(objAcc.Id);
        createSalesLogForInterfaceComm1(objAcc.Id);
        createSalesLogForLighting1(objAcc.Id);
        createSalesLogForPakedge1(objAcc.Id);
        createSalesLogForVideo1(objAcc.Id);
        createSalesLogForTriad(objAcc.Id);
        createSalesLogForPartnerProducts(objAcc.Id);
        createSalesLogForNetworking(objAcc.Id);
        createSalesLogForDoorLock(objAcc.Id);
        createSalesLogForCardAccess(objAcc.Id);
        createSalesLogFor3rdParty(objAcc.Id);
        
        // Create Contacts
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        // Create Task
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        // Create VIR Data
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 1;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        
        // Set Page to be tested
        Test.setCurrentPage(Page.dealerVisitClone);
        
        // Create Instance of standard controller for Account
        ApexPages.StandardController objStandController = new ApexPages.StandardController(objAcc);
        
        // Set standard controller instance to extension that need to be tested
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(objStandController);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        contacts[0].primaryContact = True;
        contacts[0].selected = True;
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        
        /* Start select contact */
        dealerVisitContInst.idSelected = lstContact[0].Id;
        dealerVisitContInst.disableCheckbox();
        dealerVisitContInst.showPopup();
        dealerVisitContInst.getselectedList();
        dealerVisitContInst.contactList[0].selected = true;
        dealerVisitContInst.selectedContactList();
        dealerVisitContInst.closePopup();
        /* End select contact */
        
        // Set 'Sales Note Type :'
        dealerVisitContInst.selectedValue1 = String.valueOf(dealerVisitContInst.type1[0].getValue());         
        
        // Set 'Dealer Engagement Type:'
        dealerVisitContInst.selectedValue = 'Office';
        
        List<SelectOption> selOpts = dealerVisitContInst.type;
        
        dealerVisitContInst.setDealerType();
        
        /* Start to set values for first Dealer Engagement to create Open Activities */
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';        
        /* End to set values for first Dealer Engagement to create Open Activities */ 
        
        dealerVisitContInst.getselectedFamilies();       
        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
        
        // Get Sales Note for Account
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Type__c, 
            Account__c,
            Category__c,
            Sub_Category__c,
            Contact_Date__c,
            Engagement_Type__c
            FROM 
            Sales_Notes__c 
            WHERE 
            Account__c =: objAcc.Id
        ];
        
        List<Discussion_Item__c> lstDiscussItem;
        
        // Check asserts when one Sales Note record is created
        if(lstSalesNotes != null && lstSalesNotes.size() == 1){            
            
            System.assertEquals(dealerVisitContInst.selectedValue1 +' '+ dealerVisitContInst.dueDate.format(), lstSalesNotes[0].Name);
            System.assertEquals(dealerVisitContInst.selectedValue1, lstSalesNotes[0].Type__c);
            System.assertEquals(dealerVisitContInst.dueDate ,lstSalesNotes[0].Contact_Date__c);
            System.assertEquals(dealerVisitContInst.selectedValue ,lstSalesNotes[0].Engagement_Type__c);
            
            // Get Discussion Items for Sales Items being created
            lstDiscussItem = [
                SELECT 
                Id, 
                Name, 
                Sales_Notes__c, 
                Notes__c,
                Type__c,
                P4_Type__c,
                Subject__c
                FROM 
                Discussion_Item__c 
                WHERE 
                Sales_Notes__c =: lstSalesNotes[0].Id
            ];            
           
            // Check if Discussion Iems are created
            System.assert(lstDiscussItem != null && lstDiscussItem.size() > 0);           
        }
    }
    
    /* Method tests Creation of Tasks, Sales Notes, Discussion Items when we select Contact and populate Dealer Engagement fields 
     * such that flags are set for 'Flag for P4' field 
     */
    @isTest static void testDealerEngageFlags() {
        
        // Create Account
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 2000;
        objAcc.YTD_Revenue__c = 2500;
        insert objAcc;
        
        // Create Products
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [SELECT Id FROM Product2 LIMIT 10];
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio(objAcc.Id);
        createSalesLogForController(objAcc.Id);
        createSalesLogForClimate1(objAcc.Id);
        createSalesLogForInterfaceComm1(objAcc.Id);
        createSalesLogForLighting1(objAcc.Id);
        createSalesLogForPakedge1(objAcc.Id);
        createSalesLogForVideo1(objAcc.Id);
        createSalesLogForTriad(objAcc.Id);
        createSalesLogForPartnerProducts(objAcc.Id);
        createSalesLogForNetworking(objAcc.Id);
        createSalesLogForDoorLock(objAcc.Id);
        createSalesLogForCardAccess(objAcc.Id);
        createSalesLogFor3rdParty(objAcc.Id);
        
        // Create Contacts
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        // Create Task
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        // Create VIR Data
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 1;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        
        // Set Page to be tested
        Test.setCurrentPage(Page.dealerVisitClone);
        
        // Create Instance of standard controller for Account
        ApexPages.StandardController objStandController = new ApexPages.StandardController(objAcc);
        
        // Set standard controller instance to extension that need to be tested
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(objStandController);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        contacts[0].primaryContact = True;
        contacts[0].selected = True;
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        
        /* Start select contact */
        dealerVisitContInst.idSelected = lstContact[0].Id;
        dealerVisitContInst.disableCheckbox();
        dealerVisitContInst.showPopup();
        dealerVisitContInst.getselectedList();
        dealerVisitContInst.contactList[0].selected = true;
        dealerVisitContInst.selectedContactList();
        dealerVisitContInst.closePopup();
        /* End select contact */
        
        // Set 'Sales Note Type :'
        dealerVisitContInst.selectedValue1 = String.valueOf(dealerVisitContInst.type1[0].getValue());         
        
        // Set 'Dealer Engagement Type:'
        dealerVisitContInst.selectedValue = 'Office';
        
        List<SelectOption> selOpts = dealerVisitContInst.type;
        
        dealerVisitContInst.setDealerType();
        
        /* Start to set values for first Dealer Engagement to create Open Activities */
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.selectedFlag  = dealerVisitContInst.getFlagForPFournotes()[0].getvalue();
        dealerVisitContInst.selectedFlag2 = dealerVisitContInst.getFlagForPFournotes()[0].getvalue();
        dealerVisitContInst.selectedFlag3 = dealerVisitContInst.getFlagForPFournotes()[0].getvalue();
        dealerVisitContInst.selectedFlag4 = dealerVisitContInst.getFlagForPFournotes()[0].getvalue();
        /* End to set values for first Dealer Engagement to create Open Activities */ 
        
        dealerVisitContInst.getselectedFamilies();       
        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
        
        // Get Sales Note for Account
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Type__c, 
            Account__c,
            Category__c,
            Sub_Category__c,
            Contact_Date__c,
            Engagement_Type__c
            FROM 
            Sales_Notes__c 
            WHERE 
            Account__c =: objAcc.Id
        ];
        
        List<Discussion_Item__c> lstDiscussItem;
        
        // Check asserts when one Sales Note record is created
        if(lstSalesNotes != null && lstSalesNotes.size() == 1){            
            
            System.assertEquals(dealerVisitContInst.selectedValue1 +' '+ dealerVisitContInst.dueDate.format(), lstSalesNotes[0].Name);
            System.assertEquals(dealerVisitContInst.selectedValue1, lstSalesNotes[0].Type__c);
            System.assertEquals(dealerVisitContInst.dueDate ,lstSalesNotes[0].Contact_Date__c);
            System.assertEquals(dealerVisitContInst.selectedValue ,lstSalesNotes[0].Engagement_Type__c);
            
            // Get Discussion Items for Sales Items being created
            lstDiscussItem = [
                SELECT 
                Id, 
                Name, 
                Sales_Notes__c, 
                Notes__c,
                Type__c,
                P4_Type__c,
                Subject__c
                FROM 
                Discussion_Item__c 
                WHERE 
                Sales_Notes__c =: lstSalesNotes[0].Id
            ];            
           
            // Check if Discussion Iems are created
            System.assert(lstDiscussItem != null && lstDiscussItem.size() > 0);           
        }
    }
    
    // Method tests Creation of Sales Notes, Discussion Items when we select Contact and populate Product Discussion fields
    @isTest static void testCheckOpportunities() {
        
        // Create Account
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 200;
        objAcc.YTD_Revenue__c = 250;
        insert objAcc;
        
        // Create Products
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [
            SELECT 
            Id 
            FROM 
            Product2 
            LIMIT 10];
        
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio(objAcc.Id);
        createSalesLogForController(objAcc.Id);
        createSalesLogForClimate1(objAcc.Id);
        createSalesLogForInterfaceComm1(objAcc.Id);
        createSalesLogForLighting1(objAcc.Id);
        createSalesLogForPakedge1(objAcc.Id);
        createSalesLogForVideo1(objAcc.Id);
        createSalesLogForTriad(objAcc.Id);
        createSalesLogForPartnerProducts(objAcc.Id);
        createSalesLogForNetworking(objAcc.Id);
        createSalesLogForDoorLock(objAcc.Id);
        createSalesLogForCardAccess(objAcc.Id);
        createSalesLogFor3rdParty(objAcc.Id);
        
        // Create Contacts
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        // Create Task
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        // Create VIR Data
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 1;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        
        // Set Page to be tested
        Test.setCurrentPage(Page.dealerVisitClone);
        
        // Create Instance of standard controller for Account
        ApexPages.StandardController objStandController = new ApexPages.StandardController(objAcc);
        
        // Set standard controller instance to extension that need to be tested
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(objStandController);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        contacts[0].primaryContact = True;
        contacts[0].selected = True;
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        
        /* Start select contact */
        dealerVisitContInst.idSelected = lstContact[0].Id;
        dealerVisitContInst.disableCheckbox();
        dealerVisitContInst.showPopup();
        dealerVisitContInst.getselectedList();
        dealerVisitContInst.contactList[0].selected = true;
        dealerVisitContInst.selectedContactList();
        dealerVisitContInst.closePopup();
        /* End select contact */
        
        // Set 'Sales Note Type :'
        dealerVisitContInst.selectedValue1 = String.valueOf(dealerVisitContInst.type1[0].getValue());         
        
        // Set 'Dealer Engagement Type:'
        dealerVisitContInst.selectedValue = 'Office';
        
        List<SelectOption> selOpts = dealerVisitContInst.type;
        
        dealerVisitContInst.setDealerType(); 
        
        /* Start to set data for Opportunities */
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Test Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[0].productSubProductsWrapperList[0].subProductString = 'EA5';
        dealerVisitContInst.discussionItemWrapperList[0].productSubProductsWrapperList[0].selectedSubProduct = true;
        dealerVisitContInst.discussionItemWrapperList[0].productCompetitorWrapperList[0].competitorString = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[0].productCompetitorWrapperList[0].selectedCompetitor = true;
        dealerVisitContInst.category = 'Controllers';
        dealerVisitContInst.subCategory = 'EA5';
        dealerVisitContInst.selectedFamilies = 'Controllers';
        /* End to set data for Opportunities */
        
        dealerVisitContInst.getselectedFamilies();
        
        dealerVisitContInst.opportunities = 'Controllers';        
        
        /* Start set data to create Opportunities */
        List<dealerVisitController2.OpportunityData> listOppData = new List<dealerVisitController2.OpportunityData>();
        
        dealerVisitController2.OpportunityData objOppData = new dealerVisitController2.OpportunityData();
        
        objOppData.closedDate = String.valueOf(Date.today());
        objOppData.doubAmount = 100;
        objOppData.strDescription = 'Test description';
        objOppData.strName = dealerVisitContInst.discussionItemWrapperList[0].product;
        objOppData.strNextStep = 'Test next step';
        objOppData.strStage = 'Closed Won';
        
        listOppData.add(objOppData);
        /* End set data to create Opportunities */
        
        // Set the list generated to page parameter
        ApexPages.currentPage().getParameters().put('strOpportunities',JSON.serialize(listOppData));
        
        dealerVisitContInst.Proceed();
        
        dealerVisitContInst.assignOpportunities();
        
        dealerVisitContInst.redirectToAccount();
        
        System.Test.stopTest();
        
        // Get Sales Note for Account
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Type__c, 
            Account__c,
            Category__c,
            Sub_Category__c,
            Contact_Date__c,
            Engagement_Type__c
            FROM 
            Sales_Notes__c 
            WHERE 
            Account__c =: objAcc.Id
        ];
        
        List<Discussion_Item__c> lstDiscussItem;
        
        // Check asserts when one Sales Note record is created
        if(lstSalesNotes != null && lstSalesNotes.size() == 1){            
            
            System.assertEquals(dealerVisitContInst.selectedValue1 +' '+ dealerVisitContInst.dueDate.format(), lstSalesNotes[0].Name);
            System.assertEquals(dealerVisitContInst.selectedValue1, lstSalesNotes[0].Type__c);
            System.assertEquals(dealerVisitContInst.dueDate ,lstSalesNotes[0].Contact_Date__c);
            System.assertEquals(dealerVisitContInst.selectedValue ,lstSalesNotes[0].Engagement_Type__c);
            
            // Get Discussion Items for Sales Items being created
            lstDiscussItem = [
                SELECT 
                Id, 
                Name, 
                Sales_Notes__c, 
                Notes__c,
                Type__c,
                P4_Type__c,
                Subject__c
                FROM 
                Discussion_Item__c 
                WHERE 
                Sales_Notes__c =: lstSalesNotes[0].Id
            ];            
           
            // Check if Discussion Iems are created
            System.assert(lstDiscussItem != null && lstDiscussItem.size() > 0);           
        }
        
        // Get new Opportunity created for 'Controller'
        List<Opportunity> listOpp = [
            Select 
            Id, 
            Name 
            From 
            Opportunity 
            Where 
            AccountId =: objAcc.Id 
        ];
        
        // Check if it's the same Opportunity that we created
        if(listOpp != null && listOpp.size() == 1){
             System.assertEquals(objOppData.strName, listOpp[0].Name);
        }
    }
    
    // Method tests Creation of Sales Notes, Discussion Items when we select Contact and populate Product Discussion fields such that Opportunity creation fails
    @isTest static void testCheckOpportunitiesCreationFailure() {
        
        // Create Account
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 200;
        objAcc.YTD_Revenue__c = 250;
        insert objAcc;
        
        // Create Products
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [
            SELECT 
            Id 
            FROM 
            Product2 
            LIMIT 10
        ];
        
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio(objAcc.Id);
        createSalesLogForController(objAcc.Id);
        createSalesLogForClimate1(objAcc.Id);
        createSalesLogForInterfaceComm1(objAcc.Id);
        createSalesLogForLighting1(objAcc.Id);
        createSalesLogForPakedge1(objAcc.Id);
        createSalesLogForVideo1(objAcc.Id);
        createSalesLogForTriad(objAcc.Id);
        createSalesLogForPartnerProducts(objAcc.Id);
        createSalesLogForNetworking(objAcc.Id);
        createSalesLogForDoorLock(objAcc.Id);
        createSalesLogForCardAccess(objAcc.Id);
        createSalesLogFor3rdParty(objAcc.Id);
        
        // Create Contacts
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        // Create Task
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        // Create VIR Data
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 1;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        
        // Set Page to be tested
        Test.setCurrentPage(Page.dealerVisitClone);
        
        // Create Instance of standard controller for Account
        ApexPages.StandardController objStandController = new ApexPages.StandardController(objAcc);
        
        // Set standard controller instance to extension that need to be tested
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(objStandController);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        contacts[0].primaryContact = True;
        contacts[0].selected = True;
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        
        /* Start select contact */
        dealerVisitContInst.idSelected = lstContact[0].Id;
        dealerVisitContInst.disableCheckbox();
        dealerVisitContInst.showPopup();
        dealerVisitContInst.getselectedList();
        dealerVisitContInst.contactList[0].selected = true;
        dealerVisitContInst.selectedContactList();
        dealerVisitContInst.closePopup();
        /* End select contact */
        
        // Set 'Sales Note Type :'
        dealerVisitContInst.selectedValue1 = String.valueOf(dealerVisitContInst.type1[0].getValue());         
        
        // Set 'Dealer Engagement Type:'
        dealerVisitContInst.selectedValue = 'Office';
        
        List<SelectOption> selOpts = dealerVisitContInst.type;
        
        dealerVisitContInst.setDealerType(); 
        
        /* Start to set data for Opportunities */
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Test Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[0].productSubProductsWrapperList[0].subProductString = 'EA5';
        dealerVisitContInst.discussionItemWrapperList[0].productSubProductsWrapperList[0].selectedSubProduct = true;
        dealerVisitContInst.discussionItemWrapperList[0].productCompetitorWrapperList[0].competitorString = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[0].productCompetitorWrapperList[0].selectedCompetitor = true;
        dealerVisitContInst.category = 'Controllers';
        dealerVisitContInst.subCategory = 'EA5';
        dealerVisitContInst.selectedFamilies = 'Controllers';
        /* End to set data for Opportunities */
        
        dealerVisitContInst.getselectedFamilies();
        
        dealerVisitContInst.opportunities = 'Controllers';        
        
        /* Start set data to create Opportunities */
        List<dealerVisitController2.OpportunityData> listOppData = new List<dealerVisitController2.OpportunityData>();
        
        dealerVisitController2.OpportunityData objOppData = new dealerVisitController2.OpportunityData();
        
        // Do not set strName so that the catch block is tested
        objOppData.closedDate = String.valueOf(Date.today());
        objOppData.doubAmount = 100;
        objOppData.strDescription = 'Test description';        
        objOppData.strNextStep = 'Test next step';
        objOppData.strStage = 'Closed Won';
        
        listOppData.add(objOppData);
        /* End set data to create Opportunities */
        
        // Set the list generated to page parameter
        ApexPages.currentPage().getParameters().put('strOpportunities',JSON.serialize(listOppData));
        
        dealerVisitContInst.Proceed();
        
        dealerVisitContInst.assignOpportunities();
        
        dealerVisitContInst.redirectToAccount();
        
        System.Test.stopTest();
        
        // Get new Opportunity created for 'Controller'
        List<Opportunity> listOpp = [
            Select 
            Id, 
            Name 
            From 
            Opportunity 
            Where 
            AccountId =: objAcc.Id 
        ];
        
        // Check if Opportunity is created
        System.assertEquals(0, listOpp.size());          
    }
    
    // Method tests Creation of Tasks, Sales Notes, Discussion Items when we select Contact and populate Dealer Engagement fields where 'Flag for P4' is 'None'
    @isTest static void testFlagP4IsNoneDealerEngage() {
        
        // Create Account
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 2000;
        objAcc.YTD_Revenue__c = 2500;
        insert objAcc;
        
        // Create Products
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [SELECT Id FROM Product2 LIMIT 10];
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio(objAcc.Id);
        createSalesLogForController(objAcc.Id);
        createSalesLogForClimate1(objAcc.Id);
        createSalesLogForInterfaceComm1(objAcc.Id);
        createSalesLogForLighting1(objAcc.Id);
        createSalesLogForPakedge1(objAcc.Id);
        createSalesLogForVideo1(objAcc.Id);
        createSalesLogForTriad(objAcc.Id);
        createSalesLogForPartnerProducts(objAcc.Id);
        createSalesLogForNetworking(objAcc.Id);
        createSalesLogForDoorLock(objAcc.Id);
        createSalesLogForCardAccess(objAcc.Id);
        createSalesLogFor3rdParty(objAcc.Id);
        
        // Create Contacts
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        // Create Task
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        // Create VIR Data
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 1;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        
        // Set Page to be tested
        Test.setCurrentPage(Page.dealerVisitClone);
        
        // Create Instance of standard controller for Account
        ApexPages.StandardController objStandController = new ApexPages.StandardController(objAcc);
        
        // Set standard controller instance to extension that need to be tested
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(objStandController);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        contacts[0].primaryContact = True;
        contacts[0].selected = True;
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        
        /* Start select contact */
        dealerVisitContInst.idSelected = lstContact[0].Id;
        dealerVisitContInst.disableCheckbox();
        dealerVisitContInst.showPopup();
        dealerVisitContInst.getselectedList();
        dealerVisitContInst.contactList[0].selected = true;
        dealerVisitContInst.selectedContactList();
        dealerVisitContInst.closePopup();
        /* End select contact */
        
        // Set 'Sales Note Type :'
        dealerVisitContInst.selectedValue1 = String.valueOf(dealerVisitContInst.type1[0].getValue());         
        
        // Set 'Dealer Engagement Type:'
        dealerVisitContInst.selectedValue = 'Office';
        
        List<SelectOption> selOpts = dealerVisitContInst.type;
        
        dealerVisitContInst.setDealerType();
        
        /* Start to set values for first Dealer Engagement to create Open Activities */
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.selectedFlag  = '--None--';
        dealerVisitContInst.selectedFlag2 = '--None--';
        dealerVisitContInst.selectedFlag3 = '--None--';
        dealerVisitContInst.selectedFlag4 = '--None--';
        /* End to set values for first Dealer Engagement to create Open Activities */ 
        
        dealerVisitContInst.getselectedFamilies();       
        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
        
        // Get Sales Note for Account
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Type__c, 
            Account__c,
            Category__c,
            Sub_Category__c,
            Contact_Date__c,
            Engagement_Type__c
            FROM 
            Sales_Notes__c 
            WHERE 
            Account__c =: objAcc.Id
        ];
        
        List<Discussion_Item__c> lstDiscussItem;
        
        // Check asserts when one Sales Note record is created
        if(lstSalesNotes != null && lstSalesNotes.size() == 1){            
            
            System.assertEquals(dealerVisitContInst.selectedValue1 +' '+ dealerVisitContInst.dueDate.format(), lstSalesNotes[0].Name);
            System.assertEquals(dealerVisitContInst.selectedValue1, lstSalesNotes[0].Type__c);
            System.assertEquals(dealerVisitContInst.dueDate ,lstSalesNotes[0].Contact_Date__c);
            System.assertEquals(dealerVisitContInst.selectedValue ,lstSalesNotes[0].Engagement_Type__c);
            
            // Get Discussion Items for Sales Items being created
            lstDiscussItem = [
                SELECT 
                Id, 
                Name, 
                Sales_Notes__c, 
                Notes__c,
                Type__c,
                P4_Type__c,
                Subject__c
                FROM 
                Discussion_Item__c 
                WHERE 
                Sales_Notes__c =: lstSalesNotes[0].Id
            ];            
           
            // Check if Discussion Iems are created
            System.assert(lstDiscussItem != null && lstDiscussItem.size() > 0);           
        }
    }
    
    
    @isTest static void testCheckNoSelectedContacts() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 4000;
        objAcc.YTD_Revenue__c = 4500;
        
        insert objAcc;
        
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [SELECT Id FROM Product2 OFFSET 10];
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio1(objAcc.Id);
        createSalesLogForController1(objAcc.Id);
        createSalesLogForClimate2(objAcc.Id);
        createSalesLogForInterfaceComm2(objAcc.Id);
        createSalesLogForLighting2(objAcc.Id);
        createSalesLogForPakedge2(objAcc.Id);
        createSalesLogForVideo2(objAcc.Id);
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 2;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        
        // Set the page and controller to be tested
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController objStdController = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(objStdController);
        
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        dealerVisitContInst.currentRatingStage = '';
        dealerVisitContInst.get25Val = 0;
        dealerVisitContInst.final25Val = 0;
        dealerVisitContInst.get50Val = 0;
        dealerVisitContInst.final50Val = 0;
        dealerVisitContInst.get75VAl = 0;
        dealerVisitContInst.final75Val = 0;
        dealerVisitContInst.get100Val = 0;
        dealerVisitContInst.final100Val = 0;
        dealerVisitContInst.get25Val2 = 0;
        dealerVisitContInst.final25Val2 = 0;
        dealerVisitContInst.get50Val2 = 0;
        dealerVisitContInst.final50Val2 = 0;
        dealerVisitContInst.get75VAl2 = 0;
        dealerVisitContInst.final75Val2 = 0;
        dealerVisitContInst.get100Val2 = 0;
        dealerVisitContInst.final100Val2 = 0;
        
        dealerVisitContInst.getAudioBarDataThisYear();
        dealerVisitContInst.getControllerBarDataThisYear();
        dealerVisitContInst.getVideoBarDataThisYear();
        dealerVisitContInst.getLightingBarDataThisYear();
        dealerVisitContInst.getClimateBarDataThisYear();
        dealerVisitContInst.getpakedgeBarDataThisYear();
        dealerVisitContInst.getThridPartyBarDataThisYear();
        dealerVisitContInst.getInterfaceBarDataThisYear();
        dealerVisitContInst.getCardAccessBarDataThisYear();
        dealerVisitContInst.getDoorLockBarDataThisYear();
        dealerVisitContInst.getNetworkingBarDataThisYear();
        dealerVisitContInst.getPartnerProductBarDataThisYear();
        dealerVisitContInst.getTriadBarDataThisYear();
        
        dealerVisitContInst.getAudioBarDataLastYear();
        dealerVisitContInst.getControllerBarDataLastYear();
        dealerVisitContInst.getVideoBarDataLastYear();
        dealerVisitContInst.getLightingBarDataLastYear();
        dealerVisitContInst.getClimateBarDataLastYear();
        dealerVisitContInst.getpakedgeBarDataLastYear();
        dealerVisitContInst.getThridPartyBarDataLastYear();
        dealerVisitContInst.getInterfaceBarDataLastYear();
        dealerVisitContInst.getCardAccessBarDataLastYear();
        dealerVisitContInst.getDoorLockBarDataLastYear();
        dealerVisitContInst.getNetworkingBarDataLastYear();
        dealerVisitContInst.getPartnerProductBarDataLastYear();
        dealerVisitContInst.getTriadBarDataLastYear();
        
        dealerVisitContInst.selectedValue = 'Office';
        
        dealerVisitContInst.setDealerType();
        
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        dealerVisitContInst.getselectedFamilies();
        
        dealerVisitContInst.opportunities = 'Controllers';         
        dealerVisitContInst.completedActivity = objTask.Id;
        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
        
                
        List<Task> lstTask = [
            SELECT 
            Id, 
            Status, 
            AccountId,
            ActivityDate 
            FROM 
            Task 
            WHERE 
            AccountId =: objAcc.Id AND Status = 'Completed'
        ];
        System.assertEquals(System.today(), lstTask[0].ActivityDate);
    }
    
    @isTest static void testWhenRatingGold() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 1000;
        objAcc.YTD_Revenue__c = 1500;
        insert objAcc;
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 3;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;        
        
        System.Test.startTest();
        
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        dealerVisitContInst.selectedValue = 'Office';
        dealerVisitContInst.setDealerType();
        
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        
        dealerVisitContInst.getselectedFamilies();
        
        dealerVisitContInst.opportunities = 'Controllers';
        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
        
        List<Sales_Notes__c> lstSalesNotes = [SELECT Id, Name, Contact__c, Account__c,Category__c,Sub_Category__c FROM Sales_Notes__c WHERE Account__c =: objAcc.Id];
        System.assert(lstSalesNotes != null);
    }    
    
    @isTest static void testWhenRatingStandard() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 1000;
        objAcc.YTD_Revenue__c = 500;
        insert objAcc;
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 4;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;        
        
        System.Test.startTest();
        
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        dealerVisitContInst.selectedValue = 'Office';
        dealerVisitContInst.setDealerType();
        
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        
        dealerVisitContInst.getselectedFamilies();
        
        dealerVisitContInst.opportunities = 'Controllers';
        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
        
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Contact__c, 
            Account__c,
            Category__c,
            Sub_Category__c 
            FROM 
            Sales_Notes__c 
            WHERE 
            Account__c =: objAcc.Id
        ];
        
        System.assert(lstSalesNotes != null);
    }
    
    @isTest static void testWhenNoRating() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 1000;
        objAcc.YTD_Revenue__c = 0;
        insert objAcc;
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 3;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 2;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 4;
        insert virObj;
        
        System.Test.startTest();
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        dealerVisitContInst.selectedValue = 'Office';
        dealerVisitContInst.setDealerType();
        
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        dealerVisitContInst.getselectedFamilies();
        dealerVisitContInst.opportunities = 'Controllers';
        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
        
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Contact__c, 
            Account__c,
            Category__c,
            Sub_Category__c 
            FROM 
            Sales_Notes__c 
            WHERE 
            Account__c =: objAcc.Id
        ];
        
        System.assert(lstSalesNotes != null);
    }
    
    
    @isTest static void testWhenRatingMax() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 1000;
        objAcc.YTD_Revenue__c = 7000;
        insert objAcc;
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 5;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 2;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 4;
        insert virObj;
        
        System.Test.startTest();
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        dealerVisitContInst.selectedValue = 'Office';
        
        dealerVisitContInst.setDealerType();
        
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps','Audio Switches'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        dealerVisitContInst.getselectedFamilies();
        
        dealerVisitContInst.opportunities = 'Controllers';
        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
        
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Contact__c, 
            Account__c,
            Category__c,
            Sub_Category__c 
            FROM 
            Sales_Notes__c 
            WHERE 
            Account__c =: objAcc.Id];
        
        System.assert(lstSalesNotes != null);
    }    
    
    @isTest static void testCheckAudio2SubCategories() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 4000;
        objAcc.YTD_Revenue__c = 4500;
        
        insert objAcc;
        
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [SELECT Id FROM Product2 OFFSET 10];
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio2(objAcc.Id);
        createSalesLogForController2(objAcc.Id);
        createSalesLogForInterfaceComm3(objAcc.Id);
        createSalesLogForLighting3(objAcc.Id);
        createSalesLogForPakedge3(objAcc.Id);
        createSalesLogForVideo3(objAcc.Id);
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 2;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        dealerVisitContInst.currentRatingStage = '';
        dealerVisitContInst.get25Val = 0;
        dealerVisitContInst.final25Val = 0;
        dealerVisitContInst.get50Val = 0;
        dealerVisitContInst.final50Val = 0;
        dealerVisitContInst.get75VAl = 0;
        dealerVisitContInst.final75Val = 0;
        dealerVisitContInst.get100Val = 0;
        dealerVisitContInst.final100Val = 0;
        dealerVisitContInst.get25Val2 = 0;
        dealerVisitContInst.final25Val2 = 0;
        dealerVisitContInst.get50Val2 = 0;
        dealerVisitContInst.final50Val2 = 0;
        dealerVisitContInst.get75VAl2 = 0;
        dealerVisitContInst.final75Val2 = 0;
        dealerVisitContInst.get100Val2 = 0;
        dealerVisitContInst.final100Val2 = 0;
        
        dealerVisitContInst.getAudioBarDataThisYear();
        dealerVisitContInst.getControllerBarDataThisYear();
        dealerVisitContInst.getVideoBarDataThisYear();
        dealerVisitContInst.getLightingBarDataThisYear();
        dealerVisitContInst.getClimateBarDataThisYear();
        dealerVisitContInst.getpakedgeBarDataThisYear();
        dealerVisitContInst.getThridPartyBarDataThisYear();
        dealerVisitContInst.getInterfaceBarDataThisYear();
        dealerVisitContInst.getCardAccessBarDataThisYear();
        dealerVisitContInst.getDoorLockBarDataThisYear();
        dealerVisitContInst.getNetworkingBarDataThisYear();
        dealerVisitContInst.getPartnerProductBarDataThisYear();
        dealerVisitContInst.getTriadBarDataThisYear();
        
        dealerVisitContInst.getAudioBarDataLastYear();
        dealerVisitContInst.getControllerBarDataLastYear();
        dealerVisitContInst.getVideoBarDataLastYear();
        dealerVisitContInst.getLightingBarDataLastYear();
        dealerVisitContInst.getClimateBarDataLastYear();
        dealerVisitContInst.getpakedgeBarDataLastYear();
        dealerVisitContInst.getThridPartyBarDataLastYear();
        dealerVisitContInst.getInterfaceBarDataLastYear();
        dealerVisitContInst.getCardAccessBarDataLastYear();
        dealerVisitContInst.getDoorLockBarDataLastYear();
        dealerVisitContInst.getNetworkingBarDataLastYear();
        dealerVisitContInst.getPartnerProductBarDataLastYear();
        dealerVisitContInst.getTriadBarDataLastYear();
        
        dealerVisitContInst.selectedValue = 'Office';
        dealerVisitContInst.setDealerType();
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        dealerVisitContInst.getselectedFamilies();
        dealerVisitContInst.opportunities = 'Controllers';
        
        dealerVisitContInst.completedActivity = objTask.Id;        
        dealerVisitContInst.Proceed();
        
        System.Test.stopTest();
       
        List<Task> lstTask = [
            SELECT 
            Id, 
            Status, 
            AccountId,
            ActivityDate 
            FROM 
            Task 
            WHERE 
            AccountId =: objAcc.Id AND Status = 'Completed'
        ];
        
        System.assert(lstTask != null);
        System.assertEquals(System.today(), lstTask[0].ActivityDate);
        
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Contact__c, 
            Account__c,
            Category__c,
            Sub_Category__c 
            FROM 
            Sales_Notes__c 
            WHERE Account__c =: objAcc.Id
        ];
        
        System.assert(lstSalesNotes != null);
        
        List<Discussion_Item__c> lstDiscussionItem = [
            SELECT 
            Id, 
            Name 
            FROM 
            Discussion_Item__c
        ];
        
        System.assert(lstDiscussionItem != null);
    }
    
    @isTest static void testCheckAudio4SubCategories() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 4000;
        objAcc.YTD_Revenue__c = 150000;
        
        insert objAcc;
        
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [SELECT Id FROM Product2 OFFSET 10];
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio4(objAcc.Id);
        createSalesLogForController4(objAcc.Id);
        createSalesLogForInterfaceComm4(objAcc.Id);
        createSalesLogForLighting4(objAcc.Id);
        createSalesLogForPakedge4(objAcc.Id);
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 2;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        dealerVisitContInst.currentRatingStage = '';
        dealerVisitContInst.get25Val = 0;
        dealerVisitContInst.final25Val = 0;
        dealerVisitContInst.get50Val = 0;
        dealerVisitContInst.final50Val = 0;
        dealerVisitContInst.get75VAl = 0;
        dealerVisitContInst.final75Val = 0;
        dealerVisitContInst.get100Val = 0;
        dealerVisitContInst.final100Val = 0;
        dealerVisitContInst.get25Val2 = 0;
        dealerVisitContInst.final25Val2 = 0;
        dealerVisitContInst.get50Val2 = 0;
        dealerVisitContInst.final50Val2 = 0;
        dealerVisitContInst.get75VAl2 = 0;
        dealerVisitContInst.final75Val2 = 0;
        dealerVisitContInst.get100Val2 = 0;
        dealerVisitContInst.final100Val2 = 0;
        
        dealerVisitContInst.getAudioBarDataThisYear();
        dealerVisitContInst.getControllerBarDataThisYear();
        dealerVisitContInst.getVideoBarDataThisYear();
        dealerVisitContInst.getLightingBarDataThisYear();
        dealerVisitContInst.getClimateBarDataThisYear();
        dealerVisitContInst.getpakedgeBarDataThisYear();
        dealerVisitContInst.getThridPartyBarDataThisYear();
        dealerVisitContInst.getInterfaceBarDataThisYear();
        dealerVisitContInst.getCardAccessBarDataThisYear();
        dealerVisitContInst.getDoorLockBarDataThisYear();
        dealerVisitContInst.getNetworkingBarDataThisYear();
        dealerVisitContInst.getPartnerProductBarDataThisYear();
        dealerVisitContInst.getTriadBarDataThisYear();
        
        dealerVisitContInst.getAudioBarDataLastYear();
        dealerVisitContInst.getControllerBarDataLastYear();
        dealerVisitContInst.getVideoBarDataLastYear();
        dealerVisitContInst.getLightingBarDataLastYear();
        dealerVisitContInst.getClimateBarDataLastYear();
        dealerVisitContInst.getpakedgeBarDataLastYear();
        dealerVisitContInst.getThridPartyBarDataLastYear();
        dealerVisitContInst.getInterfaceBarDataLastYear();
        dealerVisitContInst.getCardAccessBarDataLastYear();
        dealerVisitContInst.getDoorLockBarDataLastYear();
        dealerVisitContInst.getNetworkingBarDataLastYear();
        dealerVisitContInst.getPartnerProductBarDataLastYear();
        dealerVisitContInst.getTriadBarDataLastYear();
        
        dealerVisitContInst.selectedValue = 'Office';
        dealerVisitContInst.setDealerType();
        
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        dealerVisitContInst.getselectedFamilies();
        dealerVisitContInst.opportunities = 'Controllers';
        
        dealerVisitContInst.completedActivity = objTask.Id;
        
        dealerVisitContInst.Proceed();
       
        System.Test.stopTest();
       
        List<Task> lstTask = [
            SELECT 
            Id, 
            Status, 
            AccountId,
            ActivityDate 
            FROM 
            Task 
            WHERE 
            AccountId =: objAcc.Id AND Status = 'Completed'
        ];
        
        System.assert(lstTask != null);        
        System.assertEquals(System.today(), lstTask[0].ActivityDate);
        
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Contact__c, 
            Account__c,
            Category__c,
            Sub_Category__c 
            FROM 
            Sales_Notes__c 
            WHERE Account__c =: objAcc.Id
        ];
        
        System.assert(lstSalesNotes != null);
        
        List<Discussion_Item__c> lstDiscussionItem = [
            SELECT 
            Id, 
            Name 
            FROM 
            Discussion_Item__c
        ];
        
        System.assert(lstDiscussionItem != null);
    }
    
    @isTest static void testCheckAudio5SubCategories() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 4000;
        objAcc.YTD_Revenue__c = 250000;
        
        insert objAcc;
        
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [
            SELECT 
            Id 
            FROM 
            Product2 
            OFFSET 10
        ];
        
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio5(objAcc.Id);
        createSalesLogForController5(objAcc.Id);
        createSalesLogForInterfaceComm5(objAcc.Id);
        createSalesLogForLighting5(objAcc.Id);
        createSalesLogForPakedge5(objAcc.Id);
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c =30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 2;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        dealerVisitContInst.currentRatingStage = '';
        dealerVisitContInst.get25Val = 0;
        dealerVisitContInst.final25Val = 0;
        dealerVisitContInst.get50Val = 0;
        dealerVisitContInst.final50Val = 0;
        dealerVisitContInst.get75VAl = 0;
        dealerVisitContInst.final75Val = 0;
        dealerVisitContInst.get100Val = 0;
        dealerVisitContInst.final100Val = 0;
        dealerVisitContInst.get25Val2 = 0;
        dealerVisitContInst.final25Val2 = 0;
        dealerVisitContInst.get50Val2 = 0;
        dealerVisitContInst.final50Val2 = 0;
        dealerVisitContInst.get75VAl2 = 0;
        dealerVisitContInst.final75Val2 = 0;
        dealerVisitContInst.get100Val2 = 0;
        dealerVisitContInst.final100Val2 = 0;
        
        dealerVisitContInst.getAudioBarDataThisYear();
        dealerVisitContInst.getControllerBarDataThisYear();
        dealerVisitContInst.getVideoBarDataThisYear();
        dealerVisitContInst.getLightingBarDataThisYear();
        dealerVisitContInst.getClimateBarDataThisYear();
        dealerVisitContInst.getpakedgeBarDataThisYear();
        dealerVisitContInst.getThridPartyBarDataThisYear();
        dealerVisitContInst.getInterfaceBarDataThisYear();
        dealerVisitContInst.getCardAccessBarDataThisYear();
        dealerVisitContInst.getDoorLockBarDataThisYear();
        dealerVisitContInst.getNetworkingBarDataThisYear();
        dealerVisitContInst.getPartnerProductBarDataThisYear();
        dealerVisitContInst.getTriadBarDataThisYear();
        
        dealerVisitContInst.getAudioBarDataLastYear();
        dealerVisitContInst.getControllerBarDataLastYear();
        dealerVisitContInst.getVideoBarDataLastYear();
        dealerVisitContInst.getLightingBarDataLastYear();
        dealerVisitContInst.getClimateBarDataLastYear();
        dealerVisitContInst.getpakedgeBarDataLastYear();
        dealerVisitContInst.getThridPartyBarDataLastYear();
        dealerVisitContInst.getInterfaceBarDataLastYear();
        dealerVisitContInst.getCardAccessBarDataLastYear();
        dealerVisitContInst.getDoorLockBarDataLastYear();
        dealerVisitContInst.getNetworkingBarDataLastYear();
        dealerVisitContInst.getPartnerProductBarDataLastYear();
        dealerVisitContInst.getTriadBarDataLastYear();
        
        dealerVisitContInst.selectedValue = 'Office';
        dealerVisitContInst.setDealerType();
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        
        dealerVisitContInst.getselectedFamilies();
        
        dealerVisitContInst.opportunities = 'Controllers';
        
        /* Start set data to create Opportunities */
        List<dealerVisitController2.OpportunityData> listOppData = new List<dealerVisitController2.OpportunityData>();
        
        dealerVisitController2.OpportunityData objOppData = new dealerVisitController2.OpportunityData();
        
        // Do not set strName so that the catch block is tested
        objOppData.closedDate = String.valueOf(Date.today());
        objOppData.doubAmount = 100;
        objOppData.strDescription = 'Test description';        
        objOppData.strNextStep = 'Test next step';
        objOppData.strName = dealerVisitContInst.discussionItemWrapperList[0].product;
        objOppData.strStage = 'Closed Won';
        
        listOppData.add(objOppData);
        /* End set data to create Opportunities */
        
        // Set the list generated to page parameter
        ApexPages.currentPage().getParameters().put('strOpportunities',JSON.serialize(listOppData));
        
         dealerVisitContInst.Proceed();
        
        dealerVisitContInst.assignOpportunities();
        
        dealerVisitContInst.redirectToAccount();
       
        System.Test.stopTest();
        
        Opportunity oppRecord = [
            SELECT 
            Id, 
            Name, 
            AccountId 
            FROM 
            Opportunity 
            WHERE 
            AccountId =: objAcc.Id 
        ];
        
        System.assert(oppRecord != null);
        System.assertEquals('Controllers', oppRecord.Name);
       
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Contact__c, 
            Account__c,
            Category__c,
            Sub_Category__c 
            FROM 
            Sales_Notes__c 
            WHERE 
            Account__c =: objAcc.Id
        ];
        
        System.assert(lstSalesNotes != null);
        
        List<Discussion_Item__c> lstDiscussionItem = [
            SELECT 
            Id, 
            Name 
            FROM 
            Discussion_Item__c
        ];
        
        System.assert(lstDiscussionItem != null);
    }
    
    @isTest static void testCheckPakedge6SubCategories() {
        
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 4000;
        objAcc.YTD_Revenue__c = 150000;
        
        insert objAcc;
        
        List<Product2> productList = createProduct();
        insert productList;
        
        List<Product2> productsCreated = [SELECT Id FROM Product2 OFFSET 10];
        createDealer_Sales_Category(objAcc.Id,productsCreated);
        createSalesLogForAudio5(objAcc.Id);
        createSalesLogForController5(objAcc.Id);
        createSalesLogForInterfaceComm5(objAcc.Id);
        createSalesLogForLighting5(objAcc.Id);
        createSalesLogForPakedge6(objAcc.Id);
        
        List<Contact> lstContact = testDataContact(objAcc.Id);
        insert lstContact;
        
        Task objTask = testDataTask(objAcc.Id);
        insert objTask;
        
        VIR_Data__c virObj = new VIR_Data__c();
        virObj.Current_Status__c = 'Diamond';
        virObj.Dealer__c = objAcc.Id;
        virObj.NextTierRemainingRevenueRequiredAmt__c = 30000;
        virObj.Next_Premier_Status_Name__c = 'Diamond';
        virObj.CurrentVIRTier__c = 4;
        virObj.QTDRevenueTotalAmt__c = 2;
        virObj.SecondVIRTier__c = 2;
        virObj.ThirdVIRTier__c = 3;
        virObj.First_VIR_Tier__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_3__c = 4;
        virObj.VIR_Rev_Breakpoint_for_Tier_2__c = 3;
        virObj.VIR_Rev_Breakpoint_for_Tier_1__c = 2;
        insert virObj;
        
        System.Test.startTest();
        
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        
        dealerVisitContInst.taskObj = new Task();
        dealerVisitContInst.taskObj.ActivityDate = System.today();
        dealerVisitContInst.dueDate = System.today();
        List<dealerVisitController2.cContact> contacts = dealerVisitContInst.getContacts();
        
        dealerVisitContInst.selectedList = 'Test Contact1,Test Contact2';
        dealerVisitContInst.currentRatingStage = '';
        dealerVisitContInst.get25Val = 0;
        dealerVisitContInst.final25Val = 0;
        dealerVisitContInst.get50Val = 0;
        dealerVisitContInst.final50Val = 0;
        dealerVisitContInst.get75VAl = 0;
        dealerVisitContInst.final75Val = 0;
        dealerVisitContInst.get100Val = 0;
        dealerVisitContInst.final100Val = 0;
        dealerVisitContInst.get25Val2 = 0;
        dealerVisitContInst.final25Val2 = 0;
        dealerVisitContInst.get50Val2 = 0;
        dealerVisitContInst.final50Val2 = 0;
        dealerVisitContInst.get75VAl2 = 0;
        dealerVisitContInst.final75Val2 = 0;
        dealerVisitContInst.get100Val2 = 0;
        dealerVisitContInst.final100Val2 = 0;
        
        dealerVisitContInst.getAudioBarDataThisYear();
        dealerVisitContInst.getControllerBarDataThisYear();
        dealerVisitContInst.getVideoBarDataThisYear();
        dealerVisitContInst.getLightingBarDataThisYear();
        dealerVisitContInst.getClimateBarDataThisYear();
        dealerVisitContInst.getpakedgeBarDataThisYear();
        dealerVisitContInst.getThridPartyBarDataThisYear();
        dealerVisitContInst.getInterfaceBarDataThisYear();
        dealerVisitContInst.getCardAccessBarDataThisYear();
        dealerVisitContInst.getDoorLockBarDataThisYear();
        dealerVisitContInst.getNetworkingBarDataThisYear();
        dealerVisitContInst.getPartnerProductBarDataThisYear();
        dealerVisitContInst.getTriadBarDataThisYear();
        
        dealerVisitContInst.getAudioBarDataLastYear();
        dealerVisitContInst.getControllerBarDataLastYear();
        dealerVisitContInst.getVideoBarDataLastYear();
        dealerVisitContInst.getLightingBarDataLastYear();
        dealerVisitContInst.getClimateBarDataLastYear();
        dealerVisitContInst.getpakedgeBarDataLastYear();
        dealerVisitContInst.getThridPartyBarDataLastYear();
        dealerVisitContInst.getInterfaceBarDataLastYear();
        dealerVisitContInst.getCardAccessBarDataLastYear();
        dealerVisitContInst.getDoorLockBarDataLastYear();
        dealerVisitContInst.getNetworkingBarDataLastYear();
        dealerVisitContInst.getPartnerProductBarDataLastYear();
        dealerVisitContInst.getTriadBarDataLastYear();
        
        dealerVisitContInst.selectedValue = 'Office';
        dealerVisitContInst.setDealerType();
        dealerVisitContInst.flag1 = false;
        dealerVisitContInst.flag2 = true;
        dealerVisitContInst.flag3 = false;
        dealerVisitContInst.flag4 = true;
        dealerVisitContInst.followUp1 = true;
        dealerVisitContInst.followUp2 = true;
        dealerVisitContInst.followUp3 = true;
        dealerVisitContInst.followUp4 = true;
        
        dealerVisitContInst.planValue = 'Test Plan value';
        dealerVisitContInst.problem = 'Test Problem value';
        dealerVisitContInst.progress = 'Test Progress value';
        dealerVisitContInst.proposal = 'Test Proposal value';
        
        dealerVisitContInst.subjectTask1 = 'Test Sub1';
        dealerVisitContInst.subjectTask2 = 'Test Sub2';
        dealerVisitContInst.subjectTask3 = 'Test Sub3';
        dealerVisitContInst.subjectTask4 = 'Test Sub4';
        
        dealerVisitContInst.descriptionTask1 = 'Test desc1';
        dealerVisitContInst.descriptionTask2 = 'Test desc2';
        dealerVisitContInst.descriptionTask3 = 'Test desc3';
        dealerVisitContInst.descriptionTask4 = 'Test desc4';
        
        dealerVisitContInst.discussionItemWrapperList[0].product = 'Controllers';
        dealerVisitContInst.discussionItemWrapperList[0].notes = 'Controllers Note';
        dealerVisitContInst.discussionItemWrapperList[0].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[0].subProducts = new Set<String>{'EA5','EA3'};
        dealerVisitContInst.discussionItemWrapperList[1].product = 'Audio';
        dealerVisitContInst.discussionItemWrapperList[1].notes = 'Audio Note';
        dealerVisitContInst.discussionItemWrapperList[1].flagForP4 = 'Problem';
        dealerVisitContInst.discussionItemWrapperList[1].subProducts = new Set<String>{'Matrix Amps','Power Amps'};
        dealerVisitContInst.discussionItemWrapperList[0].competitor = 'Elan';
        dealerVisitContInst.discussionItemWrapperList[1].competitor = 'Sonos';
        dealerVisitContInst.selectedFamilies = 'Controllers,Audio';
        
        dealerVisitContInst.getselectedFamilies();
        dealerVisitContInst.opportunities = 'Controllers';
        dealerVisitContInst.completedActivity = objTask.Id;
        
        /* Start set data to create Opportunities */
        List<dealerVisitController2.OpportunityData> listOppData = new List<dealerVisitController2.OpportunityData>();
        
        dealerVisitController2.OpportunityData objOppData = new dealerVisitController2.OpportunityData();
        
        // Do not set strName so that the catch block is tested
        objOppData.closedDate = String.valueOf(Date.today());
        objOppData.doubAmount = 100;
        objOppData.strDescription = 'Test description';        
        objOppData.strNextStep = 'Test next step';
        objOppData.strName = dealerVisitContInst.discussionItemWrapperList[0].product;
        objOppData.strStage = 'Closed Won';
        
        listOppData.add(objOppData);
        /* End set data to create Opportunities */
        
        // Set the list generated to page parameter
        ApexPages.currentPage().getParameters().put('strOpportunities',JSON.serialize(listOppData));
        
         dealerVisitContInst.Proceed();
        
        dealerVisitContInst.assignOpportunities();
        
        dealerVisitContInst.redirectToAccount();
        
        System.Test.stopTest();
        
        Opportunity oppRecord = [
            SELECT 
            Id, 
            Name, 
            AccountId 
            FROM 
            Opportunity 
            WHERE 
            AccountId =: objAcc.Id 
        ];
        
        System.assert(oppRecord != null);
        System.assertEquals('Controllers', oppRecord.Name);
        
        List<Task> lstTask = [
            SELECT 
            Id, 
            Status, 
            AccountId,
            ActivityDate 
            FROM 
            Task 
            WHERE 
            AccountId =: objAcc.Id AND Status = 'Completed'
        ];
        
        System.assert(lstTask != null);
        System.assertEquals(System.today(), lstTask[0].ActivityDate);
        
        List<Sales_Notes__c> lstSalesNotes = [
            SELECT 
            Id, 
            Name, 
            Contact__c, 
            Account__c,
            Category__c,
            Sub_Category__c 
            FROM 
            Sales_Notes__c 
            WHERE Account__c =: objAcc.Id
        ];
        
        System.assert(lstSalesNotes != null);
        
        List<Discussion_Item__c> lstDiscussionItem = [SELECT Id, Name FROM Discussion_Item__c];
        
        System.assert(lstDiscussionItem != null);
    }
    
    @isTest static void testForSelectedFlag() {
        Account objAcc = testDataAccount();
        objAcc.Current_VIR_Earned__c = 4000;
        objAcc.YTD_Revenue__c = 150000;
        insert objAcc;
        
        System.Test.startTest();
        
        Test.setCurrentPage(Page.dealerVisitClone);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        dealerVisitController2 dealerVisitContInst = new dealerVisitController2(sc);
        
        dealerVisitContInst.selectedFlag3 = '--None--';
        dealerVisitContInst.selectedFlag4 = '--None--';
        
        String flag3 = dealerVisitContInst.getselectedFlag3();
        String flag4 = dealerVisitContInst.getselectedFlag4();
        
        System.assertEquals('--None--', flag3);
        System.assertEquals('--None--', flag4);
        
        System.Test.stopTest();  
    }
}