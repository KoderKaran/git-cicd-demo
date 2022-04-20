@isTest
private class UtilityDailyDealerSalesLogLastYearTest {

	public static Account testDataAccount() {
		Account objAccount = new Account();
		objAccount.Name = 'Test Name';
		return objAccount;
	}

	public static List<Product2> createProduct() {
		List<Product2> product2List = new List<Product2>();
		Product2 product2Obj = new Product2();
		product2Obj.Name = 'testProduct Controllers';
		product2Obj.Dealer_Sales_Category__c = 'Controllers';
		// product2Obj.Dealer_Sales_Sub_Category__c = 'EA5';
		product2Obj.IsActive = true;

		product2List.add(product2Obj);
		Product2 product2Controller2Obj = new Product2();
		product2Controller2Obj.Name = 'testProduct Controllers2';
		product2Controller2Obj.Dealer_Sales_Category__c = 'Controllers';
		product2Controller2Obj.Dealer_Sales_Sub_Category__c = 'EA5';
		product2Controller2Obj.IsActive = true;
		product2List.add(product2Controller2Obj);
		Product2 product2Controller3Obj = new Product2();
		product2Controller3Obj.Name = 'testProduct Controllers2';
		product2Controller3Obj.Dealer_Sales_Category__c = 'Controllers';
		product2Controller3Obj.Dealer_Sales_Sub_Category__c = 'EA5';
		product2Controller3Obj.IsActive = true;
		product2List.add(product2Controller3Obj);
		Product2 product2AudioObj = new Product2();
		product2AudioObj.Name = 'testProduct Audio';
		product2AudioObj.Dealer_Sales_Category__c = 'Audio';
		// product2AudioObj.Dealer_Sales_Sub_Category__c = 'Audio Matrix';
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
		product2Audio3Obj.Dealer_Sales_Sub_Category__c = 'Audio Matrix';
		product2Audio3Obj.IsActive = true;
		product2List.add(product2Audio3Obj);
		Product2 product2VideoObj = new Product2();
		product2VideoObj.Name = 'testProduct Video';
		product2VideoObj.Dealer_Sales_Category__c = 'Video';
		// product2VideoObj.Dealer_Sales_Sub_Category__c = 'Extenders';
		product2VideoObj.IsActive = true;
		product2List.add(product2VideoObj);
		Product2 product2Video2Obj = new Product2();
		product2Video2Obj.Name = 'testProduct Video2';
		product2Video2Obj.Dealer_Sales_Category__c = 'Video';
		product2Video2Obj.Dealer_Sales_Sub_Category__c = 'Extenders';
		product2Video2Obj.IsActive = true;
		product2List.add(product2Video2Obj);
		Product2 product2Video3Obj = new Product2();
		product2Video3Obj.Name = 'testProduct Video2';
		product2Video3Obj.Dealer_Sales_Category__c = 'Video';
		product2Video3Obj.Dealer_Sales_Sub_Category__c = 'Extenders';
		product2Video3Obj.IsActive = true;
		product2List.add(product2Video3Obj);
		Product2 product2LightingObj = new Product2();
		product2LightingObj.Name = 'testProduct Lighting';
		product2LightingObj.Dealer_Sales_Category__c = 'Lighting';
		// product2LightingObj.Dealer_Sales_Sub_Category__c = 'Face Plates';
		product2LightingObj.IsActive = true;
		product2List.add(product2LightingObj);
		Product2 product2Lighting2Obj = new Product2();
		product2Lighting2Obj.Name = 'testProduct Lighting2';
		product2Lighting2Obj.Dealer_Sales_Category__c = 'Lighting';
		product2Lighting2Obj.Dealer_Sales_Sub_Category__c = 'Face Plates';
		product2Lighting2Obj.IsActive = true;
		product2List.add(product2Lighting2Obj);
		Product2 product2Lighting3Obj = new Product2();
		product2Lighting3Obj.Name = 'testProduct Lighting2';
		product2Lighting3Obj.Dealer_Sales_Category__c = 'Lighting';
		product2Lighting3Obj.Dealer_Sales_Sub_Category__c = 'Face Plates';
		product2Lighting3Obj.IsActive = true;
		product2List.add(product2Lighting3Obj);
		Product2 product2ClimateControlObj = new Product2();
		product2ClimateControlObj.Name = 'testProduct Climate Control';
		product2ClimateControlObj.Dealer_Sales_Category__c = 'Climate';
		// product2ClimateControlObj.Dealer_Sales_Sub_Category__c = 'Thermostat';
		product2ClimateControlObj.IsActive = true;
		product2List.add(product2ClimateControlObj);
		Product2 product2ClimateControl2Obj = new Product2();
		product2ClimateControl2Obj.Name = 'testProduct Climate Control2';
		product2ClimateControl2Obj.Dealer_Sales_Category__c = 'Climate';
		product2ClimateControl2Obj.Dealer_Sales_Sub_Category__c = 'Thermostat';
		product2ClimateControl2Obj.IsActive = true;
		product2List.add(product2ClimateControl2Obj);
		Product2 product2ClimateControl3Obj = new Product2();
		product2ClimateControl3Obj.Name = 'testProduct Climate Control2';
		product2ClimateControl3Obj.Dealer_Sales_Category__c = 'Climate';
		product2ClimateControl3Obj.Dealer_Sales_Sub_Category__c = 'Thermostat';
		product2ClimateControl3Obj.IsActive = true;
		product2List.add(product2ClimateControl3Obj);
		Product2 product2PakedgeObj = new Product2();
		product2PakedgeObj.Name = 'testProduct Pakedge';
		product2PakedgeObj.Dealer_Sales_Category__c = 'Pakedge';
		// product2PakedgeObj.Dealer_Sales_Sub_Category__c = 'WAPs';
		product2PakedgeObj.IsActive = true;
		product2List.add(product2PakedgeObj);
		Product2 product2Pakedge2Obj = new Product2();
		product2Pakedge2Obj.Name = 'testProduct Pakedge2';
		product2Pakedge2Obj.Dealer_Sales_Category__c = 'Pakedge';
		product2Pakedge2Obj.Dealer_Sales_Sub_Category__c = 'WAPs';
		product2Pakedge2Obj.IsActive = true;
		product2List.add(product2Pakedge2Obj);
		Product2 product2Pakedge3Obj = new Product2();
		product2Pakedge3Obj.Name = 'testProduct Pakedge2';
		product2Pakedge3Obj.Dealer_Sales_Category__c = 'Pakedge';
		product2Pakedge3Obj.Dealer_Sales_Sub_Category__c = 'WAPs';
		product2Pakedge3Obj.IsActive = true;
		product2List.add(product2Pakedge3Obj);
		Product2 product2InterfaceAndCommObj = new Product2();
		product2InterfaceAndCommObj.Name = 'testProduct interfaces and Communnication';
		product2InterfaceAndCommObj.Dealer_Sales_Category__c = 'Interface / Communication';
		// product2InterfaceAndCommObj.Dealer_Sales_Sub_Category__c = 'Remotes';
		product2InterfaceAndCommObj.IsActive = true;
		product2List.add(product2InterfaceAndCommObj);
		Product2 product2InterfaceAndComm2Obj = new Product2();
		product2InterfaceAndComm2Obj.Name = 'testProduct interfaces and Communnication2';
		product2InterfaceAndComm2Obj.Dealer_Sales_Category__c = 'Interface / Communication';
		product2InterfaceAndComm2Obj.Dealer_Sales_Sub_Category__c = 'Remotes';
		product2InterfaceAndComm2Obj.IsActive = true;
		product2List.add(product2InterfaceAndComm2Obj);
		Product2 product2InterfaceAndComm3Obj = new Product2();
		product2InterfaceAndComm3Obj.Name = 'testProduct interfaces and Communnication2';
		product2InterfaceAndComm3Obj.Dealer_Sales_Category__c = 'Interface / Communication';
		product2InterfaceAndComm3Obj.Dealer_Sales_Sub_Category__c = 'Remotes';
		product2InterfaceAndComm3Obj.IsActive = true;
		product2List.add(product2InterfaceAndComm3Obj);
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
		Product2 product2NetworkingObj = new Product2();
		product2NetworkingObj.Name = 'testProduct Networking';
		product2NetworkingObj.Dealer_Sales_Category__c = 'Networking';
		product2NetworkingObj.IsActive = true;
		product2List.add(product2NetworkingObj);
		Product2 product2PartnerProductObj = new Product2();
		product2PartnerProductObj.Name = 'testProduct Partner Products';
		product2PartnerProductObj.Dealer_Sales_Category__c = 'Partner Products';
		product2PartnerProductObj.IsActive = true;
		product2List.add(product2PartnerProductObj);
		return product2List;
	}

	public static List<Daily_Dealer_Sales_Log__c> createDealer_Sales_Category (Integer totalCost, Integer quantity) {
		Account acc = testDataAccount();
		insert acc;
		List<Product2> productList = createProduct();
		insert productList;
		List<Daily_Dealer_Sales_Log__c> dealer_Sales_CategoryList = new List<Daily_Dealer_Sales_Log__c>();
		for(Product2 productObj : productList) {
			Daily_Dealer_Sales_Log__c dealer_Sales_CategoryObj = new Daily_Dealer_Sales_Log__c();
			if(totalCost != 0) {
				dealer_Sales_CategoryObj.Total_Cost__c = 500;
			}
			if(quantity != 0) {
				dealer_Sales_CategoryObj.Quantity__c = 50;
			}
			dealer_Sales_CategoryObj.Sales_Date__c = System.today().addYears(-1);
			dealer_Sales_CategoryObj.Product__c = productObj.Id;
			dealer_Sales_CategoryObj.Dealer__c = acc.Id;
			dealer_Sales_CategoryList.add(dealer_Sales_CategoryObj);
		}
		return dealer_Sales_CategoryList;
	}


	@isTest static void DailyDealerSalesLogLastYearTest() {
		System.Test.startTest();
		List<Daily_Dealer_Sales_Log__c> dailyDealerSalesLogList = createDealer_Sales_Category(500,50);
		UtilityDailyDealerSalesLogLastYear dailyDealerSalesLog = new UtilityDailyDealerSalesLogLastYear();
		insert dailyDealerSalesLogList;
		Account account = [SELECT Id FROM Account];
		dailyDealerSalesLog.accID = account;
		dailyDealerSalesLog.fetchDailyDealerSalesLog();
		dailyDealerSalesLog.audioStackedData();
		dailyDealerSalesLog.AudioStackedListData();
		dailyDealerSalesLog.controllersStackedData();
		dailyDealerSalesLog.ControllersStackedListData();
		dailyDealerSalesLog.videoStackedData();
		dailyDealerSalesLog.VideoStackedListData();
		dailyDealerSalesLog.lightingStackedData();
		dailyDealerSalesLog.lightingStackedListData();
		dailyDealerSalesLog.climateControlStackedData();
		dailyDealerSalesLog.ClimateControlPieData();
		dailyDealerSalesLog.pakedgeStackedData();
		dailyDealerSalesLog.PakedgeStackedListData();
		dailyDealerSalesLog.DoorLockStackedData();
		dailyDealerSalesLog.DoorLockStackedListData();
		dailyDealerSalesLog.TriadStackedData();
		dailyDealerSalesLog.TriadStackedListData();
		dailyDealerSalesLog.thirdPartyStackedData();
		dailyDealerSalesLog.thirdPartyStackedListData();
		dailyDealerSalesLog.interfaceComStackedData();
		dailyDealerSalesLog.interfaceComStackedListData();
		dailyDealerSalesLog.CardAccessData();
		dailyDealerSalesLog.CardAccessStackedListData();
		dailyDealerSalesLog.NetworkingStackedData();
		dailyDealerSalesLog.NetworkingStackedListData();
		dailyDealerSalesLog.PartnerProductBarDataStackedData();
		dailyDealerSalesLog.PartnerProductBarDataStackedListData();
		System.Test.stopTest();
	}


	@isTest static void DailyDealerSalesLogLastYearTestWithCost() {
		System.Test.startTest();
		List<Daily_Dealer_Sales_Log__c> dailyDealerSalesLogList = createDealer_Sales_Category(500,0);
		UtilityDailyDealerSalesLogLastYear dailyDealerSalesLog = new UtilityDailyDealerSalesLogLastYear();
		insert dailyDealerSalesLogList;
		Account account = [SELECT Id FROM Account];
		dailyDealerSalesLog.accID = account;
		dailyDealerSalesLog.fetchDailyDealerSalesLog();
		dailyDealerSalesLog.audioStackedData();
		dailyDealerSalesLog.AudioStackedListData();
		dailyDealerSalesLog.controllersStackedData();
		dailyDealerSalesLog.ControllersStackedListData();
		dailyDealerSalesLog.videoStackedData();
		dailyDealerSalesLog.VideoStackedListData();
		dailyDealerSalesLog.lightingStackedData();
		dailyDealerSalesLog.lightingStackedListData();
		dailyDealerSalesLog.climateControlStackedData();
		dailyDealerSalesLog.ClimateControlPieData();
		dailyDealerSalesLog.pakedgeStackedData();
		dailyDealerSalesLog.PakedgeStackedListData();
		dailyDealerSalesLog.DoorLockStackedData();
		dailyDealerSalesLog.DoorLockStackedListData();
		dailyDealerSalesLog.TriadStackedData();
		dailyDealerSalesLog.TriadStackedListData();
		dailyDealerSalesLog.thirdPartyStackedData();
		dailyDealerSalesLog.thirdPartyStackedListData();
		dailyDealerSalesLog.interfaceComStackedData();
		dailyDealerSalesLog.interfaceComStackedListData();
		dailyDealerSalesLog.CardAccessData();
		dailyDealerSalesLog.CardAccessStackedListData();
		dailyDealerSalesLog.NetworkingStackedData();
		dailyDealerSalesLog.NetworkingStackedListData();
		dailyDealerSalesLog.PartnerProductBarDataStackedData();
		dailyDealerSalesLog.PartnerProductBarDataStackedListData();
		System.Test.stopTest();
	}

	@isTest static void DailyDealerSalesLogLastYearTestWithQuantity() {
		System.Test.startTest();
		List<Daily_Dealer_Sales_Log__c> dailyDealerSalesLogList = createDealer_Sales_Category(0,50);
		UtilityDailyDealerSalesLogLastYear dailyDealerSalesLog = new UtilityDailyDealerSalesLogLastYear();
		insert dailyDealerSalesLogList;
		Account account = [SELECT Id FROM Account];
		dailyDealerSalesLog.accID = account;
		dailyDealerSalesLog.fetchDailyDealerSalesLog();
		dailyDealerSalesLog.audioStackedData();
		dailyDealerSalesLog.AudioStackedListData();
		dailyDealerSalesLog.controllersStackedData();
		dailyDealerSalesLog.ControllersStackedListData();
		dailyDealerSalesLog.videoStackedData();
		dailyDealerSalesLog.VideoStackedListData();
		dailyDealerSalesLog.lightingStackedData();
		dailyDealerSalesLog.lightingStackedListData();
		dailyDealerSalesLog.climateControlStackedData();
		dailyDealerSalesLog.ClimateControlPieData();
		dailyDealerSalesLog.pakedgeStackedData();
		dailyDealerSalesLog.PakedgeStackedListData();
		dailyDealerSalesLog.DoorLockStackedData();
		dailyDealerSalesLog.DoorLockStackedListData();
		dailyDealerSalesLog.TriadStackedData();
		dailyDealerSalesLog.TriadStackedListData();
		dailyDealerSalesLog.thirdPartyStackedData();
		dailyDealerSalesLog.thirdPartyStackedListData();
		dailyDealerSalesLog.interfaceComStackedData();
		dailyDealerSalesLog.interfaceComStackedListData();
		dailyDealerSalesLog.CardAccessData();
		dailyDealerSalesLog.CardAccessStackedListData();
		dailyDealerSalesLog.NetworkingStackedData();
		dailyDealerSalesLog.NetworkingStackedListData();
		dailyDealerSalesLog.PartnerProductBarDataStackedData();
		dailyDealerSalesLog.PartnerProductBarDataStackedListData();
		System.Test.stopTest();
	}


}