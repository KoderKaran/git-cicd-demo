/**
*   This visual page Controller is used to create Sales_Notes records along with Discussion_Item , Task and Opportunity records
*  
* ====================================================================================================
*     Version     Date            Comment
* ====================================================================================================
*     1.0         15-Mar-2017     -
*      
**/
public with sharing class dealerVisitController2 {
    
    public String accId{get;set;}
    public String selectedList{get;set;}
    public Boolean displayPopup {get;set;}
    public List<cContact> contactList {get; set;}
    public VIR_Data__c virDataObj{get;set;}
    public Date dueDate {get;set;}
    transient public List<Contact> contactsRelatedToAccountList {get;set;} //change by rcsanchez - added transient
    transient public List<Daily_Dealer_Sales_Log__c> dailyDealerSalesLogList {get;set;} //change by rcsanchez - added transient
    transient public List<Task> openActivities {get;set;} //change by rcsanchez - added transient
    public List<Opportunity> relatedOpportunityList {get;set;}
    public List<Opportunity> relatedThisYearOpportunityList {get;set;}
    public List<Opportunity> relatedLastYearOpportunityList {get;set;}
    public Static Map<String,List<String>> mapProductsToSubProducts {get;set;}
    public Static Map<String,List<String>> mapProductsToCompetitor {get;set;}
    
    public String currentRatingStage {get;set;}
    public String nextYearProjectedStage {get;set;}
    public Decimal nextLevelValue {get;set;}
    
    public Boolean followUp1 {get;set;}
    public Boolean followUp2 {get;set;}
    public Boolean followUp3 {get;set;}
    public Boolean followUp4 {get;set;}
    
    public Boolean flag1 {get;set;}
    public Boolean flag2 {get;set;}
    public Boolean flag3 {get;set;}
    public Boolean flag4 {get;set;}
    
    public String planValue{get;set;}
    public String problem {get;set;}
    public String progress {get;set;}
    public String proposal {get;set;}
    public String flagP4 {get;set;}
    
    public String note1Subject {get; set;}
    public String note2Subject {get; set;}
    public String note3Subject {get; set;}
    public String note4Subject {get; set;}
    
    public String selectedCompetitors {get;set;}
    public String selectedFamilies {get;set;}
    public String stage {get;set;}
    public String opportunities {get;set;}
    public String completedActivity {get;set;}
    public Account accountRecord {get;set;}
    public Task taskObj {get;set;}
    public Account accRecord {get;set;}
    public Decimal ratingForGold {get;set;}
    public Decimal ratingForPlatinum {get;set;}
    public Decimal ratingForDiamond {get;set;}
    public Decimal ratingForVIR {get;set;}
    public Decimal ratingForStandardVIR {get;set;}
    public Decimal ratingForFirstVIR {get;set;}
    public Decimal ratingForSecondVIR {get;set;}
    public Decimal ratingForThirdVIR {get;set;}
    
    public Integer get25Val{get;set;}
    public Integer final25Val {get;set;}
    public Integer get50Val{get;set;}
    public Integer final50Val {get;set;}
    public Integer get75VAl{get;set;}
    public Integer final75Val {get;set;}
    public Integer get100Val{get;set;}
    public Integer final100Val {get;set;}
    public Integer get25Val2{get;set;}
    public Integer final25Val2 {get;set;}
    public Integer get50Val2{get;set;}
    public Integer final50Val2 {get;set;}
    public Integer get75VAl2{get;set;}
    public Integer final75Val2 {get;set;}
    public Integer get100Val2{get;set;}
    public Integer final100Val2 {get;set;}
    public List<Decimal> getHighestProudctTotalCost;
    public List<Decimal> getHighestProudctTotalCost2;
    
    public Boolean audioDisplay {get;set;}
    public Boolean controllersDisplay {get;set;}
    public Boolean videoDisplay {get;set;}
    public Boolean lightingDisplay {get;set;}
    public Boolean thirdPartyDisplay {get;set;}
    public Boolean locksDisplay {get;set;}
    public Boolean triadDisplay {get;set;}
    public Boolean cardAccessDisplay {get;set;}
    public Boolean interfacesDisplay {get;set;}
    public Boolean pakedgeDisplay {get;set;}
    public Boolean climateControlDisplay {get;set;}
    transient public UtilityDailyDealerSalesLogThisYear utilityObj; //change by rcsanchez - added transient
    transient public UtilityDailyDealerSalesLogLastYear utilityLastYearObj; //change by rcsanchez - added transient
    
    public static String discussionItemObject = 'Discussion_Item__c';
    public static String controllingProductString = 'Product__c';
    public static String dependentSubProductString = 'Sub_Products__c';
    public static String dependentCompetitorString = 'CompetitorMS__c';
    Map<String,Decimal> mapCategToCountAudio ;
    
    public Set<String> productList {get;set;}
    public Set<String> opportunitySet {get;set;}
    public List<Opportunity> opportunityList {get;set;}
    public List<task> taskFromFollowUpList {get;set;}
    public Boolean recordsSaved {get;set;}
    public String subProducts = '';
    public String salesNoteIdCreted;
    public boolean salesNoteCreated ;
    public Task taskRecord;
    public List<SelectOption> selectP4Type { get;set; }
    public String selectedValue{get;set;}
    public String selectedValue1{get;set;}
    public String salesNoteId;
    public List<Discussion_Item__c> discussionItemList;
    public List<Discussion_Item__c> discussionItemFromP4List;
    public String category;
    public String subCategory;
    public List<Contact> selectedContacts;
    public Set<Id> contactIdSet = new Set<Id>();
    
    public Map<String,Decimal> test = new Map<String,Decimal>();
    
    //Added by Paolo - dependent picklist via js
    public List<Dealer_Visit__c> resultsMapDependent{get;set;}      
    public List<Call_Type__c> resultsMapDependentCall{get;set;}         
    public String JsonMapDependent{get;set;}        
    public String JsonMapDependentCall{get;set;}
    
    // Added by Sudeep
    // Variable to set data on Page access it in controller    
    public String strMessage{get; set{ strMessage = value;}}
    
    //Added for Create follow up task
    public String subjectTask1 {get;set;}
    public date dueDateTask1 {get;set;}
    public String descriptionTask1 {get;set;}
    public Task contactTask1 {get;set;}    
    
    public String subjectTask2 {get;set;}
    public date dueDateTask2 {get;set;}
    public String descriptionTask2 {get;set;}
    public Task contactTask2 {get;set;}    
    
    public String subjectTask3 {get;set;}
    public date dueDateTask3 {get;set;}
    public String descriptionTask3 {get;set;}
    public Task contactTask3 {get;set;}    
    
    public String subjectTask4 {get;set;}
    public date dueDateTask4 {get;set;}
    public String descriptionTask4 {get;set;}
    public Task contactTask4 {get;set;}  
    
    public dealerVisitController2(ApexPages.StandardController stdController) {
        accId = stdController.getRecord().Id;
        utilityObj = new UtilityDailyDealerSalesLogThisYear();
        utilityObj.accID = (Account)stdController.getRecord();
        utilityObj.fetchDailyDealerSalesLog();
        
        utilityLastYearObj = new UtilityDailyDealerSalesLogLastYear();
        utilityLastYearObj.accID = (Account)stdController.getRecord();
        utilityLastYearObj.fetchDailyDealerSalesLog();
        getHighestProudctTotalCost = new List<Decimal>();
        getHighestProudctTotalCost2 = new List<Decimal>();
        
        accountRecord = [select Id, Dealer_Ranking_within_Region_YTD__c, Current_VIR_Earned__c, YTD_Revenue__c, Previous_YOY_Difference__c,
                         Dealer_Ranking_within_Region_Last_Year__c, QTD_Comparison__c, YTD_Comparison__c, YOY_Growth_Prev__c,
                         Open_Orders_Dollars__c, QTD_Revenue_Comparison__c, QTD_Revenue__c, YOY_Growth__c, QTD_YOY_Growth__c,
                         Premier_Status_Breakpoint_1__c, Premier_Status_Breakpoint_2__c, Premier_Status_Breakpoint_3__c,Dealer_Visit__c
                         from Account
                         where Id =: accId
                        ];
        
        taskObj = new Task();
        System.debug('-------------taskObj.ActivityDate'+taskObj.ActivityDate);
        list<VIR_Data__c> virDataList = [select Id,IsProSourceBuyingGroup_0_or_1__c,Current_Status__c,CurrentVIRTier__c,Dealer__c,Dealer_ID__c,
                                         Growth_Breakpoint_1__c,Growth_Breakpoint_2__c,Growth_Breakpoint_3__c,Next_Premier_Status_Name__c,
                                         Next_Status_Remaining_Revenue_Required__c,NextTierRemainingRevenueRequiredAmt__c,NextVIRTier__c,
                                         Premier_Status_Breakpoint_1__c,Premier_Status_Breakpoint_2__c,Premier_Status_Breakpoint_3__c,
                                         Projected_Status__c,QTDRevenueC4Amt__c,QTDRevenueTotalAmt__c,QTDTotalRebateEarnedAmt__c,
                                         SecondVIRTier__c,ThirdVIRTier__c,VIR_Date__c,YoYQtrRevenueGrowthPct__c,CreatedDate,
                                         First_VIR_Tier__c,VIR_Rev_Breakpoint_for_Tier_1__c,VIR_Rev_Breakpoint_for_Tier_2__c,
                                         VIR_Rev_Breakpoint_for_Tier_3__c
                                         from VIR_Data__c
                                         where Dealer__c =:accId
                                         order by CreatedDate DESC
                                         limit 1
                                        ];
        
        if(virDataList != null && virDataList.size() > 0){
            virDataObj = virDataList[0];
            virProgressBarCalculation(virDataObj);
        }
        
        // VIR_Tier_Rating__c vIR_Tier_RatingObj = [select gold__c, platinum__c, diamond__c from VIR_Tier_Rating__c];
        Decimal minGold = accountRecord.Premier_Status_Breakpoint_1__c;
        Decimal minPlatinum = accountRecord.Premier_Status_Breakpoint_2__c;
        Decimal minDiamond = accountRecord.Premier_Status_Breakpoint_3__c;
        // Decimal maxDiamond = vIR_Tier_RatingObj.diamond__c + vIR_Tier_RatingObj.diamond__c;
        mapCategToCountAudio = new Map<String, Decimal>();
        
        if(accountRecord.YTD_Revenue__c != null && accountRecord.Premier_Status_Breakpoint_1__c > 0 && accountRecord.Premier_Status_Breakpoint_2__c > 0 && accountRecord.Premier_Status_Breakpoint_3__c > 0) {
            if(accountRecord.YTD_Revenue__c == 0) {
                ratingForGold = 0;
                ratingForPlatinum = 0;
                ratingForDiamond = 0;
            }
            else if(accountRecord.YTD_Revenue__c <= minGold) {
                currentRatingStage = 'Gold';
                nextYearProjectedStage = 'Platinum';
                nextLevelValue = minGold - accountRecord.YTD_Revenue__c;
                ratingForGold = (accountRecord.YTD_Revenue__c) / (minGold) * 100;
                ratingForPlatinum = 0;
                ratingForDiamond = 0;
            }
            else if(accountRecord.YTD_Revenue__c <= minPlatinum) {
                currentRatingStage = 'Platinum';
                nextYearProjectedStage = 'Diamond';
                nextLevelValue = minPlatinum - accountRecord.YTD_Revenue__c;
                ratingForGold = 100;
                ratingForPlatinum = (accountRecord.YTD_Revenue__c - minGold) / (minPlatinum - minGold) * 100;
                ratingForDiamond = 0;
            }
            else if(accountRecord.YTD_Revenue__c <= minDiamond) {
                nextLevelValue = null;
                currentRatingStage = 'Diamond';
                ratingForGold = 100;
                ratingForPlatinum = 100;
                ratingForDiamond = (accountRecord.YTD_Revenue__c - minPlatinum)/(minDiamond - minPlatinum)*100;
            }
            else {
                nextLevelValue = null;
                currentRatingStage = 'Diamond';
                ratingForGold = 100;
                ratingForPlatinum =100;
                // ratingForDiamond = (accountRecord.YTD_Revenue__c - minDiamond)/(maxDiamond - minDiamond)*100;
                ratingForDiamond = 100;
            }
        }
        
        //Added by Paolo: Pass custom setting values to js
        resultsMapDependent = new List<Dealer_Visit__c>([SELECT Name FROM Dealer_Visit__c ORDER BY Order__c ASC]);        
        resultsMapDependentCall = new List<Call_Type__c>([SELECT Name FROM Call_Type__c ORDER BY Order__c ASC]);      
        JsonMapDependent =JSON.serialize(resultsMapDependent);      
        JsonMapDependentCall =JSON.serialize(resultsMapDependentCall); 
        
        contactTask1 = new Task();
        contactTask2 = new Task();
        contactTask3 = new Task();
        contactTask4 = new Task();
       
        contactTask1.Ownerid = UserInfo.getUserId();
        contactTask2.Ownerid = UserInfo.getUserId();
        contactTask3.Ownerid = UserInfo.getUserId();
        contactTask4.Ownerid = UserInfo.getUserId();
        
        
        salesNoteCreated = false;
        flag1 = false;
        flag2 = false;
        flag3 = false;
        flag4 = false;
        followUp1 = false;
        followUp2 = false;
        followUp3 = false;
        followUp4 = false;
        flagP4 = '';
        dueDate = Date.Today();
        
        selectedCompetitors = '';
        completedActivity = '';
        stage = '';
        opportunities = '';
        salesNoteIdCreted = '';
        
        audioDisplay = false;
        controllersDisplay = false;
        videoDisplay = false;
        lightingDisplay = false;
        thirdPartyDisplay = false;
        locksDisplay = false;
        triadDisplay = false;
        cardAccessDisplay = false;
        interfacesDisplay = false;
        pakedgeDisplay = false;
        climateControlDisplay = false;
        getAudioBarDataThisYear();
        getControllerBarDataThisYear();
        getVideoBarDataThisYear();
        getLightingBarDataThisYear();
        getClimateBarDataThisYear();
        getInterfaceBarDataThisYear();
        getPakedgeBarDataThisYear();
        getTriadBarDataThisYear();
        getThridPartyBarDataThisYear();
        getCardAccessBarDataThisYear();
        getDoorLockBarDataThisYear();
        getNetworkingBarDataThisYear();
        getPartnerProductBarDataThisYear();
        getAudioBarDataLastYear();
        getControllerBarDataLastYear();
        getVideoBarDataLastYear();
        getLightingBarDataLastYear();
        getClimateBarDataLastYear();
        getInterfaceBarDataLastYear();
        getPakedgeBarDataLastYear();
        getTriadBarDataLastYear();
        getThridPartyBarDataLastYear();
        getCardAccessBarDataLastYear();
        getDoorLockBarDataLastYear();
        getNetworkingBarDataLastYear();
        getPartnerProductBarDataLastYear();
        
        // fetching all open activities of account
        selectOpenActivities();
        // fetching all active contacts related to account
        contactsRelatedToAccountList = FetchContacts();
        // fetching most recent 10 Daily_Dealer_Sales_Log
        dailyDealerSalesLogList = FetchdailyDealerSalesLog();
        // fetching all related Opportunities which have record type : 'Dealer Adoption' or 'Design Reviews'
        relatedOpportunityList = fetchOpportunities();
        // fetching all related Opportunities which have record type : 'Dealer Adoption' or 'Design Reviews' and Created This Year
        relatedThisYearOpportunityList = fetchThisYearOpportunities();
        // fetching all related Opportunities which have record type : 'Dealer Adoption' or 'Design Reviews'  and Created Last Year
        relatedLastYearOpportunityList = fetchLastYearOpportunities();
        // fetching values of Controlling and Dependent Picklist (Product & SubProducts)
        getControllingAndDependentValues();
        
    }
    
    
    // Method to fetch all related Opportunities whose record type is : 'Dealer Adoption' or 'Design Reviews' and created This Year
    public List<Opportunity> fetchThisYearOpportunities() {
        Integer thisYear = Date.today().year();
        List<Opportunity> relatedThisYearOpportunityList = [select Name, RecordType.Name, StageName, Product_Segment__c, CloseDate, NextStep, Amount
                                                            from Opportunity
                                                            where (RecordTypeId IN (select Id from RecordType
                                                                                    where sobjecttype = 'Opportunity'
                                                                                    AND Name IN ('Dealer Adoption', 'Design Services'))
                                                                   AND AccountId =: accId AND stageName NOT IN ('Closed Won','Closed Lost')
                                                                   AND CALENDAR_YEAR(CreatedDate) =: thisYear)
                                                            order by CreatedDate DESC                                                          
                                                           ];
        return relatedThisYearOpportunityList;
    }
    
    // Method to fetch all related Opportunities whose record type is : 'Dealer Adoption' or 'Design Reviews' and created Last Year
    public List<Opportunity> fetchLastYearOpportunities() {
        Integer lastYear = Date.today().year()-1;
        List<Opportunity> relatedLastYearOpportunityList = [select Name, RecordType.Name, StageName, Product_Segment__c, CloseDate, NextStep, Amount
                                                            from Opportunity
                                                            where (RecordTypeId IN (select Id from RecordType
                                                                                    where sobjecttype = 'Opportunity'
                                                                                    AND Name IN ('Dealer Adoption', 'Design Services'))
                                                                   AND AccountId =: accId AND stageName NOT IN ('Closed Won','Closed Lost')
                                                                   AND CALENDAR_YEAR(CreatedDate) =: lastYear)
                                                            order by CreatedDate DESC
                                                            LIMIT 10
                                                           ];
        return relatedLastYearOpportunityList;
    }
    
    public void virProgressBarCalculation(VIR_Data__c virDataObj){
        Decimal minFirstVIR = 0.0;
        Decimal minSecondVIR = 0.0;
        Decimal minThirdVIR = 0.0;
        Decimal maxThirdVIR = 0.0;
        if(virDataObj.VIR_Rev_Breakpoint_for_Tier_1__c != Null){
            minFirstVIR = virDataObj.VIR_Rev_Breakpoint_for_Tier_1__c;
        }
        if(virDataObj.VIR_Rev_Breakpoint_for_Tier_2__c != Null){
            minSecondVIR = virDataObj.VIR_Rev_Breakpoint_for_Tier_2__c;
        }
        if(virDataObj.VIR_Rev_Breakpoint_for_Tier_3__c != Null){
            maxThirdVIR = virDataObj.QTDRevenueC4Amt__c;
            minThirdVIR = virDataObj.VIR_Rev_Breakpoint_for_Tier_3__c;
        }
        
        if(virDataObj.QTDRevenueTotalAmt__c != null && minFirstVIR > 0 && minSecondVIR > 0 && minThirdVIR > 0 && maxThirdVIR > 0) {
            if(virDataObj.QTDRevenueTotalAmt__c == 0) {
                ratingForStandardVIR = 0;
                ratingForFirstVIR = 0;
                ratingForSecondVIR = 0;
                ratingForThirdVIR = 0;
            }
            else if(virDataObj.QTDRevenueTotalAmt__c <= minFirstVIR) {
                ratingForStandardVIR = 100;
                ratingForFirstVIR = virDataObj.QTDRevenueTotalAmt__c / minFirstVIR * 100;
                ratingForSecondVIR = 0;
                ratingForThirdVIR = 0;
            }
            else if(virDataObj.QTDRevenueTotalAmt__c <= minSecondVIR) {
                ratingForStandardVIR = 100;
                ratingForFirstVIR = 100;
                ratingForSecondVIR = virDataObj.QTDRevenueTotalAmt__c / minSecondVIR  * 100;
                ratingForThirdVIR = 0;
            }
            else if(virDataObj.QTDRevenueTotalAmt__c <= minThirdVIR) {
                ratingForStandardVIR = 100;
                ratingForFirstVIR = 100;
                ratingForSecondVIR = 100;
                ratingForThirdVIR = virDataObj.QTDRevenueTotalAmt__c / minThirdVIR *100;
            }
            else if(virDataObj.QTDRevenueTotalAmt__c > 0) {
                ratingForStandardVIR = 100;
                ratingForFirstVIR = 100;
                ratingForSecondVIR = 100;
                ratingForThirdVIR = (virDataObj.QTDRevenueTotalAmt__c - minThirdVIR)/(maxThirdVIR - minThirdVIR)*100;
            }
        }
    }
    
    // Method to fetch Open Activities of Account
    public void selectOpenActivities() {
        openActivities = [select Id, Status, ActivityDate, Subject, Description ,OwnerId
                          from Task
                          where (Status != 'Completed' AND WhatId =: accId AND OwnerId =: UserInfo.getUserId())
                          order by Subject];
    }
    
    // Method to fetch all Active Contacts related to Account
    public List<Contact> FetchContacts(){
        List<Contact> contactsRelatedToAccountList = [select Id, Name, Title, Email,Associate_Installer__c, Associate_Installer_Certs_Passed__c,
                                                      Tech_II_Certified__c, Centralized_Lighting_Certified__c, Cert_Count__c
                                                      from Contact
                                                      where AccountId =: accId AND Inactive__c = False
                                                      ORDER BY Name
                                                     ];
        return contactsRelatedToAccountList;
    }
    
    // Method to fetch most recent 10 Daily_Dealer_Sales_Log
    public List<Daily_Dealer_Sales_Log__c> FetchdailyDealerSalesLog() {
    Integer thisYear = Date.today().year();
    Integer lastYear = Date.today().year()-1;
        List<Daily_Dealer_Sales_Log__c> dailyDealerSalesLogList = [select Sales_Date__c, Dealer_Sales_Category__c, Dealer_Sales_Sub_Category__c,
                                                                      Quantity__c, Total_Cost__c
                                                               from Daily_Dealer_Sales_Log__c
                                                               where Dealer__c =: accId AND Sales_Date__c != Null
                                                               ORDER BY Sales_Date__c LIMIT 10 //RC change added LIMIT 10
    ];
        return dailyDealerSalesLogList;
    }
    
    // Method to fetch all related Opportunities whose record type is : 'Dealer Adoption' or 'Design Reviews'
    public List<Opportunity> fetchOpportunities() {
        List<Opportunity> relatedOpportunityList = [select Name, RecordType.Name, StageName, Product_Segment__c, CloseDate, NextStep, Amount
                                                    from Opportunity
                                                    where (RecordTypeId IN (select Id from RecordType WHERE sobjecttype = 'Opportunity'
                                                                            AND Name IN ('Dealer Adoption', 'Design Services', 'BOM'))
                                                           AND AccountId =: accId
                                                           AND stageName NOT IN ('Closed Won','Closed Lost'))
                                                   ];
        return relatedOpportunityList;
    }
    
    // Method to get the Controlling and Dependent picklist values in wrapper
    public void getControllingAndDependentValues() {
        getProductToSubProductMap();
        getProductToCompetitorMap();
        productSubFamily = new List<String>();
        mapProductSubProduct = new Map<String,List<String>>();
        Schema.DescribeFieldResult productResult = Discussion_Item__c.Product__c.getDescribe();
        List<Schema.PicklistEntry> productFamilyValues = productResult.getPicklistValues();
        Schema.DescribeFieldResult subProductResult = Discussion_Item__c.Sub_Products__c.getDescribe();
        List<Schema.PicklistEntry> productSubFamilyValues = subProductResult.getPicklistValues();
        List<String> subProductList;
        discussionItemWrapperList = new List<discussionItemWrapper>();
        
        for(String productValue : mapProductsToSubProducts.keySet()) {
            discussionItemWrapper discussionItemWrapperObj = new discussionItemWrapper();
            if(productValue != null) {
                discussionItemWrapperObj.product = productValue;
                discussionItemWrapperObj.uniqueProduct = productValue.replaceAll('\\s+', '_');
                discussionItemWrapperObj.subProducts = new Set<String>{};
                    List<ProductCompetitorWrapper> comList = new List<ProductCompetitorWrapper>();
                discussionItemWrapperObj.subProducts.addAll(mapProductsToSubProducts.get(productValue));
                
                discussionItemWrapperObj.competitorOptions = new List<SelectOption>();
                for(String competitorValues : mapProductsToCompetitor.get(productValue)) {
                    ProductCompetitorWrapper productCompetitorWrapperObj = new ProductCompetitorWrapper();
                    productCompetitorWrapperObj.competitorString = competitorValues;
                    productCompetitorWrapperObj.selectedCompetitor = false;
                    comList.add(productCompetitorWrapperObj);
                }
                
                List<ProductSubProductsWrapper> proSubProWrapperList = new List<ProductSubProductsWrapper>();
                for(String subProductsValues : mapProductsToSubProducts.get(productValue)) {
                    ProductSubProductsWrapper productSubProductWrapperObj = new ProductSubProductsWrapper();
                    productSubProductWrapperObj.subProductString = subProductsValues;
                    productSubProductWrapperObj.selectedSubProduct = false;
                    proSubProWrapperList.add(productSubProductWrapperObj);
                }
                
                discussionItemWrapperObj.productSubProductsWrapperList = proSubProWrapperList;
                discussionItemWrapperObj.productCompetitorWrapperList = comList;
            }
            discussionItemWrapperList.add(discussionItemWrapperObj);
        }
        setP4TypeValues();
    }
    
    // Method to set the values for P4Type Picklist in Discussion_Item
    public void setP4TypeValues() {
        Schema.DescribeFieldResult statusFieldDescription = Discussion_Item__c.P4_Type__c.getDescribe();
        selectP4Type = new list<SelectOption>();
        selectP4Type.add(new SelectOption('--None--','--None--'));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()) {
            selectP4Type.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
    }
    
    // Method to fetch the controlling and dependent values and map them
    public static Map<String,List<String>> getProductToCompetitorMap(){
        mapProductsToCompetitor = new Map<String,List<String>>();
        Schema.SObjectType pType = Schema.getGlobalDescribe().get(discussionItemObject);
        if ( pType == null )
            return mapProductsToCompetitor;
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //verify field names
        if (!objFieldMap.containsKey(controllingProductString) || !objFieldMap.containsKey(dependentCompetitorString))
            return mapProductsToCompetitor;
        //get the control & dependent values
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(controllingProductString).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(dependentCompetitorString).getDescribe().getPicklistValues();
        //clear heap
        objFieldMap = null;
        //initialize results mapping
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){
            mapProductsToCompetitor.put( ctrl_ple[pControllingIndex].getLabel(), new List<String>());
        }
        //serialize dep entries
        List<dealerVisitController2.TPicklistEntry> objDS_Entries = new List<dealerVisitController2.TPicklistEntry>();
        objDS_Entries = (List<dealerVisitController2.TPicklistEntry>)JSON.deserialize(JSON.serialize(dep_ple), List<dealerVisitController2.TPicklistEntry>.class);
        List<Integer> validIndexes;
        for (dealerVisitController2.TPicklistEntry objDepPLE : objDS_Entries){
            validIndexes = DependentPicklistsData.cnvBits(objDepPLE.validFor);
            for (Integer validIndex : validIndexes){
                mapProductsToCompetitor.get( ctrl_ple[validIndex-1].getLabel() ).add( objDepPLE.label );
            }
        }
        //clear heap
        objDS_Entries = null;
        return mapProductsToCompetitor;
    }
    
    
    // Method to fetch the controlling and dependent values and map them
    public static Map<String,List<String>> getProductToSubProductMap(){
        mapProductsToSubProducts = new Map<String,List<String>>();
        Schema.SObjectType pType = Schema.getGlobalDescribe().get(discussionItemObject);
        if ( pType == null )
            return mapProductsToSubProducts;
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //verify field names
        if (!objFieldMap.containsKey(controllingProductString) || !objFieldMap.containsKey(dependentSubProductString))
            return mapProductsToSubProducts;
        //get the control & dependent values
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(controllingProductString).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(dependentSubProductString).getDescribe().getPicklistValues();
        //clear heap
        objFieldMap = null;
        //initialize results mapping
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){
            mapProductsToSubProducts.put( ctrl_ple[pControllingIndex].getLabel(), new List<String>());
        }
        //serialize dep entries
        List<dealerVisitController2.TPicklistEntry> objDS_Entries = new List<dealerVisitController2.TPicklistEntry>();
        objDS_Entries = (List<dealerVisitController2.TPicklistEntry>)JSON.deserialize(JSON.serialize(dep_ple), List<dealerVisitController2.TPicklistEntry>.class);
        List<Integer> validIndexes;
        for (dealerVisitController2.TPicklistEntry objDepPLE : objDS_Entries){
            validIndexes = DependentPicklistsData.cnvBits(objDepPLE.validFor);
            for (Integer validIndex : validIndexes){
                mapProductsToSubProducts.get( ctrl_ple[validIndex-1].getLabel() ).add( objDepPLE.label );
            }
        }
        //clear heap
        objDS_Entries = null;
        return mapProductsToSubProducts;
    }
    
    /*
* @Summary: Entity to represent a json version of a picklist entry
* so that the validFor property becomes exposed
*/
    public class TPicklistEntry{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public TPicklistEntry(){
        }
    }
    
    // Method to Save SalesNotes record and assign values to another object reords being created
    public PageReference Proceed() {
        
        dueDate = taskObj.ActivityDate;
        
        if (dueDate != null){
            
            opportunityList = new List<Opportunity>();
            
            salesNoteId = createSalesNote();
            
            //createTask(salesNoteId);
            createTaskFollowUp(salesNoteId);
            createDiscussionItem(salesNoteId);
            recordsSaved = true;
            
            // Call saveAll method to save the records
            PageReference objPageRef =  saveAll();
            
            return objPageRef;
            
        }
        
        return null;
    }
    
    /* Start added by Sudeep */
    /* Method creates Opportunities */
    public void createOpportunities(){
        
        if(opportunityList == null || opportunityList.isEmpty()){
            return;
        }
        
        try{
            insert opportunityList;
            strMessage = 'Success!!!';
        }catch(Exception objExc){
            
            // Set error message into a string used on page to display error messages            
            strMessage = objExc.getMessage();
        }
    } 
    
    // Method redirects to Accounts Standard detail page
    public PageReference redirectToAccount(){
        
        PageReference objPageRef = new PageReference('/' + accId);
        
        return objPageRef;
    }
    
    // Method gets string which has JSON for array of Opportunities from page and parses it to be saved
    public void assignOpportunities(){   
        
        String strOppListFromPage = System.CurrentPageReference().getParameters().get('strOpportunities');        
        
        // Change added from Chirag
        
        List<OpportunityData> lstOpportunityData = new List<OpportunityData>();
        
        if (dueDate != null){
            
            if(strOppListFromPage != null || String.isNotEmpty(strOppListFromPage)){
                lstOpportunityData =
                    (List<OpportunityData>) JSON.deserialize(strOppListFromPage,List<OpportunityData>.class);
            }        
            
            List<Opportunity> listOpportunity = new List<Opportunity>();
            
            // Check if list is instantiated and not empty before we clear it
            if(opportunityList != null && !opportunityList.isEmpty()){
                opportunityList.clear();
            }
            
            for (OpportunityData oppData: lstOpportunityData) {
                
                // Set values from list of inner class to Opportunity to be created
                Opportunity opp = new Opportunity(
                    Name = oppData.strName, 
                    CloseDate = Date.valueOf(oppData.closedDate),
                    Description = oppData.strDescription, 
                    StageName = oppData.strStage,
                    Amount = oppData.doubAmount, 
                    NextStep = oppData.strNextStep, 
                    AccountId = accId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
                    .get('Dealer Adoption').getRecordTypeId(),
                    Product_Segment__c = oppData.strName  // Set Product Segment with Opportunities Name added by Sudeep for changes suggest on 27 Nov 2017
                );
                
                opportunityList.add(opp);
            }
            
            // Call method to create Opportunities
            createOpportunities();
            // Change end from Chirag  
        }
    }
    /* End added by Sudeep */
    
    public void createTaskFollowUp(String salesNoteId){        
        
        taskRecord = new Task();
        taskRecord.Subject = 'Dealer '+selectedValue+' Visit';
        taskRecord.OwnerId = UserInfo.getUserId();
        taskRecord.Priority = 'Normal';
        taskRecord.Sales_Notes__c = salesNoteId;
        taskRecord.ActivityDate = dueDate;
        taskRecord.whatId = accId;            // Added for bug fix by Sudeep
        
        taskRecord.type__c = selectedValue;
        taskRecord.Status = 'Complete';
        
        if(idSelected != null) {
            taskRecord.whoId = idSelected;
        }
        taskFromFollowUpList = new List<Task>();
        
        if(followup1){
            contactTask1.Subject = subjectTask1;
            contactTask1.Description = descriptionTask1;
            contactTask1.whatId = accId;
            contactTask1.ActivityDate = dueDateTask1;
            contactTask1.Sales_Notes__c = salesNoteId; // Added for bug fix by Sudeep
            taskFromFollowUpList.add(contactTask1); 
        }  
        if(followup2){
            contactTask2.Subject = subjectTask2;
            contactTask2.Description = descriptionTask2;
            contactTask2.whatId = accId;
            contactTask2.ActivityDate = dueDateTask2;
            contactTask2.Sales_Notes__c = salesNoteId; // Added for bug fix by Sudeep
            taskFromFollowUpList.add(contactTask2); 
        }  
        if(followup3){
            contactTask3.Subject = subjectTask3;
            contactTask3.Description = descriptionTask3;
            contactTask3.whatId = accId;
            contactTask3.ActivityDate = dueDateTask3;
            contactTask3.Sales_Notes__c = salesNoteId; // Added for bug fix by Sudeep
            taskFromFollowUpList.add(contactTask3); 
        }  
        if(followup4){
            contactTask4.Subject = subjectTask4;
            contactTask4.Description = descriptionTask4 ;
            contactTask4.whatId = accId;
            contactTask4.ActivityDate = dueDateTask4;
            contactTask4.Sales_Notes__c = salesNoteId; // Added for bug fix by Sudeep
            taskFromFollowUpList.add(contactTask4); 
        }  
        /* Commented by Sudeep to avoid error 
         *  INVALID_FIELD_FOR_INSERT_UPDATE, cannot specify Id in an insert call: [Id]
        if(taskFromFollowUpList != null) {
            insert taskFromFollowUpList;
        }
        */
    }    
    
    
    // **************************** Create Sales Note Record
    public String createSalesNote() {
        Sales_Notes__c salesNoteRecord = new Sales_Notes__c();
        if(idSelected != null) {
            salesNoteRecord.Contact__c = idSelected;
        }
        
        salesNoteRecord.Account__c = accId;
        salesNoteRecord.Name = selectedValue1 +' '+ dueDate.format();
        salesNoteRecord.Contact_Date__c = dueDate;
        salesNoteRecord.Type__c = selectedValue1;
        salesNoteRecord.Engagement_Type__c = selectedValue;
        if(salesNoteIdCreted == '') {
            // Start Bug Fix by Chirag        
            try {
                insert salesNoteRecord;
                salesNoteCreated = true;
                salesNoteIdCreted = salesNoteRecord.Id;                
            } catch(Exception e) {
                strMessage = e.getMessage();
            }
            // End Bug Fix by Chirag
            return salesNoteRecord.Id;
        }
        else {
            return salesNoteIdCreted;            
        }
    }
    
    // **************************** Create Task Record
    /*public void createTask(String salesNoteId) {
        taskRecord = new Task();
        taskRecord.Subject = 'Dealer '+selectedValue+' Visit';
        taskRecord.OwnerId = UserInfo.getUserId();
        taskRecord.Priority = 'Normal';
        taskRecord.Sales_Notes__c = salesNoteId;
        taskRecord.ActivityDate = dueDate;
        
        taskRecord.type__c = selectedValue;
        taskRecord.Status = 'Completed';
        taskRecord.whatId = accId;
        if(idSelected != null) {
            taskRecord.whoId = idSelected;
        }
        
        // task creation for plans
        taskFromFollowUpList = new List<Task>();
        if(followUp1) {
            Task taskRecordForPlans = new Task();
            System.debug('---------task 2--------'+dueDate);
            System.debug('---------dueDate.format()-------'+dueDate.format());
            taskRecordForPlans.Subject = note1Subject;
            taskRecordForPlans.OwnerId = UserInfo.getUserId();
            taskRecordForPlans.Sales_Notes__c = salesNoteId;
            taskRecordForPlans.Description = planValue;
            taskRecordForPlans.whatId = accId;
            taskFromFollowUpList.add(taskRecordForPlans);
        }
        
        // task creation for Problem
        if(followUp2) {
            Task taskRecordForDiscussion = new Task();
            taskRecordForDiscussion.Subject = note2Subject;
            taskRecordForDiscussion.OwnerId = UserInfo.getUserId();
            taskRecordForDiscussion.Sales_Notes__c = salesNoteId;
            taskRecordForDiscussion.Description = problem;
            taskRecordForDiscussion.whatId = accId;
            taskFromFollowUpList.add(taskRecordForDiscussion);
        }
        
        // task creation for Proposal
        if(followUp3) {
            Task taskRecordForProposal = new Task();
            taskRecordForProposal.Subject = note3Subject;
            taskRecordForProposal.OwnerId = UserInfo.getUserId();
            taskRecordForProposal.Sales_Notes__c = salesNoteId;
            taskRecordForProposal.Description = proposal;
            taskRecordForProposal.whatId = accId;
            taskFromFollowUpList.add(taskRecordForProposal);
        }
        
        // task creation for Progress
        if(followUp4) {
            Task taskRecordForProgress = new Task();
            taskRecordForProgress.Subject = note4Subject;
            taskRecordForProgress.OwnerId = UserInfo.getUserId();
            taskRecordForProgress.Sales_Notes__c = salesNoteId;
            taskRecordForProgress.Description = progress;
            taskRecordForProgress.whatId = accId;
            taskFromFollowUpList.add(taskRecordForProgress);
        }
    }*/
    
        //Flag for P4 for NOTES
    public string selectedFlag {get; set;}
    public string selectedFlag2 {get; set;}
    public string selectedFlag3 {get; set;}
    public string selectedFlag4 {get; set;}
    
    public String getselectedFlag() {
        return selectedFlag;
    }
    public String getselectedFlag2() {
        return selectedFlag2;
    }
    public String getselectedFlag3() {
        return selectedFlag3;
    }
    public String getselectedFlag4() {
        return selectedFlag4;
    }
 
    
    public List<SelectOption> getFlagForPFournotes()
    
        {
          List<SelectOption> options = new List<SelectOption>();  
          options.add(new SelectOption('--None--','--None--')); 
          Schema.DescribeFieldResult fieldResult = Discussion_Item__c.P4_Type__c.getDescribe();
          List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
          for( Schema.PicklistEntry f : ple)
          {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
          }       
          return options;
        }
    
    // **************************** Create Discussion Item Record
    public void createDiscussionItem(String salesNoteId) {
        category = '';
        subCategory = '';
        productList = new Set<String>();
        discussionItemList = new List<Discussion_Item__c>();
        
        String competitorForProduct = '';
        for(discussionItemWrapper discussionItemObj : discussionItemWrapperList) {
            
            Discussion_Item__c discussionItemRecord = new Discussion_Item__c();
            for(ProductCompetitorWrapper competitorWrapperObj : discussionItemObj.productCompetitorWrapperList) {
                if(competitorWrapperObj.selectedCompetitor) {
                    competitorForProduct += competitorWrapperObj.competitorString + ';';
                }
            }
            
            String subProductsForProduct = '';
            for(ProductSubProductsWrapper productSubProductWrapperObj : discussionItemObj.productSubProductsWrapperList) {
                if(productSubProductWrapperObj.selectedSubProduct) {
                    subProductsForProduct += productSubProductWrapperObj.subProductString + ';';
                }
            }
            
            discussionItemRecord.Name =  'Discussion Item for '+discussionItemObj.product;
            discussionItemRecord.Product__c =  discussionItemObj.product;
            discussionItemRecord.Notes__c =  discussionItemObj.notes;
            discussionItemRecord.Sales_Notes__c = salesNoteId;
            
            // Added by Sudeep for updates suggested on 27 Nov 2017
            discussionItemRecord.Competitor__c = competitorForProduct 
                + (discussionItemObj.competitor == null || String.isBlank(discussionItemObj.competitor) ? '' : discussionItemObj.competitor);
            
            if(discussionItemObj.flagForP4 != '--None--') {
                discussionItemRecord.P4_Type__c = discussionItemObj.flagForP4;
            }
            
            discussionItemRecord.Type__c = 'Product';
            if(subProductsForProduct != '' || competitorForProduct != '' || discussionItemObj.flagForP4 != '--None--' || discussionItemObj.notes != '' || discussionItemObj.competitor != '') {
                category += discussionItemRecord.Product__c+ ';';
                subCategory += subProductsForProduct;
                discussionItemRecord.CompetitorMS__c = competitorForProduct;
                discussionItemRecord.Sub_Products__c = subProductsForProduct;
                discussionItemList.add(discussionItemRecord);
                subProductsForProduct = '';
                competitorForProduct = '';
            }
        }
        discussionItemFromP4List = new List<Discussion_Item__c>();
        //if(followup1){ Commented for bug fix by Sudeep
            if(selectedFlag != '--None--') {
                Discussion_Item__c discussionItemFromP4 = new Discussion_Item__c();
                //discussionItemFromP4.Name = 'Discussion Item for Note 1';   // Removed for bug fix by Sudeep
                discussionItemFromP4.Name = note1Subject;   // Added for bug fix by Sudeep
                discussionItemFromP4.Sales_Notes__c = salesNoteId;
                discussionItemFromP4.Notes__c = planValue;
                discussionItemFromP4.Type__c = 'Note 1';
                discussionItemFromP4.P4_Type__c = selectedFlag;
                discussionItemFromP4.Subject__c = note1Subject;
                discussionItemFromP4List.add(discussionItemFromP4);
            }
            else  if(planValue!= '' || note1Subject!='') {
                Discussion_Item__c discussionItemFromP4 = new Discussion_Item__c();
                //discussionItemFromP4.Name = 'Discussion Item for Note 1';   // Removed for bug fix by Sudeep
                discussionItemFromP4.Name = note1Subject;   // Added for bug fix by Sudeep
                discussionItemFromP4.Sales_Notes__c = salesNoteId;
                discussionItemFromP4.Notes__c = planValue;
                discussionItemFromP4.Type__c = 'Note 1';
                discussionItemFromP4.Subject__c = note1Subject;
                discussionItemFromP4List.add(discussionItemFromP4);
            }
       /* } Commented for bug fix by Sudeep
        if(followup2){*/
            if(selectedFlag2 != '--None--') {
                Discussion_Item__c discussionItemFromP4 = new Discussion_Item__c();
                //discussionItemFromP4.Name = 'Discussion Item for Note 2';   // Removed for bug fix by Sudeep
                discussionItemFromP4.Name = note2Subject;   // Added for bug fix by Sudeep
                discussionItemFromP4.Sales_Notes__c = salesNoteId;
                discussionItemFromP4.Notes__c = problem;
                discussionItemFromP4.Type__c = 'Note 2';
                discussionItemFromP4.P4_Type__c = selectedFlag2;
                discussionItemFromP4.Subject__c = note2Subject;
                discussionItemFromP4List.add(discussionItemFromP4);
            }
            else if(problem != '' || note2Subject!='') {
                Discussion_Item__c discussionItemFromP4 = new Discussion_Item__c();
                //discussionItemFromP4.Name = 'Discussion Item for Note 2';   // Removed for bug fix by Sudeep
                discussionItemFromP4.Name = note2Subject;   // Added for bug fix by Sudeep
                discussionItemFromP4.Sales_Notes__c = salesNoteId;
                discussionItemFromP4.Notes__c = problem;
                discussionItemFromP4.Type__c = 'Note 2';
                discussionItemFromP4.Subject__c = note2Subject;
                discussionItemFromP4List.add(discussionItemFromP4);
            }
       /* } Commented for bug fix by Sudeep
        if(followup3){*/
            if(selectedFlag3 != '--None--') {
                Discussion_Item__c discussionItemFromP4 = new Discussion_Item__c();
                //discussionItemFromP4.Name = 'Discussion Item for Note 3';   // Removed for bug fix by Sudeep
                discussionItemFromP4.Name = note3Subject;   // Added for bug fix by Sudeep
                discussionItemFromP4.Sales_Notes__c = salesNoteId;
                discussionItemFromP4.Notes__c = proposal;
                discussionItemFromP4.Type__c = 'Note 3';
                discussionItemFromP4.P4_Type__c = selectedFlag3;
                discussionItemFromP4.Subject__c = note3Subject;
                discussionItemFromP4List.add(discussionItemFromP4);
            }
            else if(proposal != '' || note3Subject!='') {
                Discussion_Item__c discussionItemFromP4 = new Discussion_Item__c();
                //discussionItemFromP4.Name = 'Discussion Item for Note 3';   // Removed for bug fix by Sudeep
                discussionItemFromP4.Name = note3Subject;   // Added for bug fix by Sudeep
                discussionItemFromP4.Sales_Notes__c = salesNoteId;
                discussionItemFromP4.Notes__c = proposal;
                discussionItemFromP4.Type__c = 'Note 3';
                discussionItemFromP4.Subject__c = note3Subject;
                discussionItemFromP4List.add(discussionItemFromP4);
            }
       /* } Commented for bug fix by Sudeep
        if(followup4){*/
            if(selectedFlag4 != '--None--') {
                Discussion_Item__c discussionItemFromP4 = new Discussion_Item__c();
                //discussionItemFromP4.Name = 'Discussion Item for Note 4';   // Removed for bug fix by Sudeep
                discussionItemFromP4.Name = note4Subject;   // Added for bug fix by Sudeep
                discussionItemFromP4.Sales_Notes__c = salesNoteId;
                discussionItemFromP4.Notes__c = progress;
                discussionItemFromP4.Type__c = 'Note 4';
                discussionItemFromP4.P4_Type__c = selectedFlag4;
                discussionItemFromP4.Subject__c = note4Subject;
                discussionItemFromP4List.add(discussionItemFromP4);
            }
            else if(progress != '' || note4Subject!='') {
                Discussion_Item__c discussionItemFromP4 = new Discussion_Item__c();
                //discussionItemFromP4.Name = 'Discussion Item for Note 4';   // Removed for bug fix by Sudeep
                discussionItemFromP4.Name = note4Subject;   // Added for bug fix by Sudeep
                discussionItemFromP4.Sales_Notes__c = salesNoteId;
                discussionItemFromP4.Notes__c = progress;
                discussionItemFromP4.Type__c = 'Note 4';
                discussionItemFromP4.Subject__c = note4Subject;
                discussionItemFromP4List.add(discussionItemFromP4);
            }
        //} Commented for bug fix by Sudeep
    }
    
    public PageReference saveAll() {
        if(taskRecord != null) {
            // Start Bug Fix by Chirag
            try {
                insert taskRecord;
            } catch(Exception e) {
                strMessage = e.getMessage();
            }
            // End Bug Fix by Chirag
        }
        
        List<TaskRelation> taskRelationList = new List<TaskRelation>();
        for(Id contactId : contactIdSet) {
            TaskRelation taskRelationObj = new TaskRelation();
            taskRelationObj.TaskId = taskRecord.Id;
            taskRelationObj.RelationId = contactId;
            taskRelationObj.IsWhat = false;
            taskRelationList.add(taskRelationObj);
        }
        
        if(taskRelationList != null){
            // Start Bug Fix by Chirag
            try {
                insert taskRelationList ;
            } catch(Exception e) {
                strMessage = e.getMessage();
            }
            // End Bug Fix by Chirag
        }
        if(salesNoteIdCreted != '') {
            Sales_Notes__c updateSalesNote = [select Id ,Category__c ,Sub_Category__c from Sales_Notes__c WHERE Id =: salesNoteIdCreted];
            updateSalesNote.Category__c = category;
            updateSalesNote.Sub_Category__c = subCategory;            
        }
        
        
        if(discussionItemList != null) {
            // Start Bug Fix by Chirag
            try {
                insert discussionItemList;
            } catch(Exception e) {
                strMessage = e.getMessage();
            }
            // End Bug Fix by Chirag
        }
        
        
        if(discussionItemFromP4List != null) {
            // Start Bug Fix by Chirag
            try {
                insert discussionItemFromP4List;
            } catch(Exception e) {
                strMessage = e.getMessage();
            }
            // End Bug Fix by Chirag
        }        
        
        if(taskFromFollowUpList != null) {
            // Start Bug Fix by Chirag
            try {
                insert taskFromFollowUpList;
            } catch(Exception e) {
                strMessage = e.getMessage();
            }
            // End Bug Fix by Chirag
            
        }        
        
        List<Id> activityId = new List<Id>();
        Set<Id> activityIdSet = new Set<Id>();
        if(!String.isBlank(completedActivity)) {
            activityId = completedActivity.split(',');
            activityIdSet.addAll(activityId);
            List<Task> activitiesToComplete = [SELECT Id, ActivityDate FROM Task WHERE Id IN :activityIdSet];
            if(!activitiesToComplete.isEmpty() || activitiesToComplete != null) {
                for(Task taskToUpdate : activitiesToComplete) {
                    taskToUpdate.ActivityDate = System.Today();
                    taskToUpdate.Status = 'Completed';
                }
                // Start Bug Fix by Chirag
                try {
                    update activitiesToComplete;
                } catch(Exception e) {
                    strMessage = e.getMessage();
                }
                // End Bug Fix by Chirag
            }
        }
        if(relatedOpportunityList != null) {
            // Start Bug Fix by Chirag
            try {            
                update relatedOpportunityList;
            } catch(Exception e) {
                strMessage = e.getMessage();
            }
            // End Bug Fix by Chirag 
        }
        
        return null;
    }
    
    public String getSelectedCompetitors () {
        return selectedCompetitors;
    }
    
    public String getselectedFamilies() {
        return selectedFamilies;
    }
    
    // *********************** Dealer Engagement Type
    public void setDealerType() {
    }
    
    public List<SelectOption> type {
        get {
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Task.Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            return options;
        }
    }
    
    // *********************** Sales Note Type
    public void setNoteType() {
    }
    
    public List<SelectOption> type1 {
        get {
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Sales_Notes__c.Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            return options;
        }
    }
    
    // *********************** Contact multiselect lookup
    public List<cContact> getContacts() {
        List<Contact> conList = [select Id, Name from Contact where AccountId =: accId AND Inactive__c = False order by Name];
        if(conList != null) {
            if(contactList == null) {
                contactList = new List<cContact>();
                for(Contact contact : conList) {
                    contactList.add(new cContact(contact));
                }
            }
        }
        if(contactList !=null){
            return contactList;
        }
        else
            return null;
    }
    
    // *********************** to display multiselect lookup popup
    public void showPopup() {
        displayPopup = true;
    }
    
    // *********************** to close multiselect lookup popup
    public PageReference closePopup() {
        displayPopup = false;
        return null;
    }
    
    // *********************** Selected contact list
    public String getselectedList () {
        return selectedList;
    }
    
    // *********************** create list of selected contacts
    public PageReference selectedContactList() {
        selectedContacts = new List<Contact>();
        displayPopup = false;
        selectedList = '';
        Integer counter = 1;
        for(cContact cCon: getContacts()) {
            if(cCon.selected == true) {
                selectedContacts.add(cCon.con);
            }
        }
        
        for(Contact conObj : selectedContacts){
            if(counter < selectedContacts.size()) {
                selectedList +=conObj.Name + ',' +'\n';
                counter ++;
            }
            else {
                selectedList +=conObj.Name;
            }
            contactIdSet.add(conObj.Id);
        }
        contactIdSet.remove(idSelected);
        return null;
    }
    
    // *********************** wrapper for selected contact in multiselect lookup
    public class cContact {
        public Contact con {get; set;}
        public Boolean selected {get; set;}
        public Boolean primaryContact {get;set;}
        
        public cContact(Contact c) {
            con = c;
            selected = false;
            primaryContact = false;
        }
    }
    public Id  idSelected {get; set;}
    public void disableCheckbox() {
        for(CContact obj: getContacts()) {
            if(obj.con.Id == idSelected && obj.primaryContact){
            }
            else {
                obj.primaryContact = false;
            }
        }
    }
    
    public class discussionItemWrapper {
        public String product {get;set;}
        public String notes {get;set;}
        public String flagForP4 {get;set;}
        public String competitor {get;set;}
        public String uniqueProduct {get;set;}
        public Set<String> subProducts {get;set;}
        public List<SelectOption> competitorOptions {get;set;}
        public List<productCompetitorWrapper> productCompetitorWrapperList {get;set;}
        public List<productSubProductsWrapper> productSubProductsWrapperList {get;set;}
        
        
    }
    public class productCompetitorWrapper {
        public String competitorString {get;set;}
        public Boolean selectedCompetitor {get;set;}
    }
    
    public class productSubProductsWrapper {
        public String subProductString {get;set;}
        public Boolean selectedSubProduct {get;set;}
    }
    
    // *********************** Multiselect picklist values (Product)
    public List<String> productSubFamily {get;set;}
    public Map<String,List<String>> mapProductSubProduct {get;set;}
    public List<discussionItemWrapper> discussionItemWrapperList {get;set;}
    public Decimal highestval=0.0;
   
    /* Commented out as not used on page or in extension
    public void calculateHighestProductTotalCost(){
        if(!getHighestProudctTotalCost.isEmpty()){
            Integer maxvalue = getHighestProudctTotalCost[0].intValue();
            For (integer i =0;i<getHighestProudctTotalCost.size();i++) {
                if( getHighestProudctTotalCost[i].intValue() > maxvalue)
                    maxvalue = getHighestProudctTotalCost[i].intValue();
            }
            Integer finalmaxValue = maxvalue + (maxvalue/10);
            get25Val = (finalmaxValue * 25)/100;
            final25Val = roundupCurrency(get25Val);
            get50Val = (finalmaxValue * 50)/100;
            final50Val = roundupCurrency(get50Val);
            get75VAl = (finalmaxValue * 75)/100;
            final75Val = roundupCurrency(get75VAl);
            final100Val = roundupCurrency(finalmaxValue);
            
        }
    }
    */
    /* Commented out as not used on page or in extension
* Methods for Bar Graphs
*/
    /*public void calculateHighestProductTotalCost2(){
        if(!getHighestProudctTotalCost2.isEmpty()){
            Integer maxvalue = getHighestProudctTotalCost2[0].intValue();
            For (integer i =0;i<getHighestProudctTotalCost2.size();i++)
            {
                if( getHighestProudctTotalCost2[i].intValue() > maxvalue)
                    maxvalue = getHighestProudctTotalCost2[i].intValue();
            }
            Integer finalmaxValue = maxvalue + (maxvalue/10);
            get25Val2 = (finalmaxValue * 25)/100;
            final25Val2 = roundupCurrency(get25Val);
            get50Val2 = (finalmaxValue * 50)/100;
            final50Val2 = roundupCurrency(get50Val2);
            get75VAl2 = (finalmaxValue * 75)/100;
            final75Val2 = roundupCurrency(get75Val2);
            final100Val2 = roundupCurrency(finalmaxValue);
        }
    }
    // Commented out as not used on page or in extension
    public Integer roundupCurrency(Integer currencyVal){
        Integer num = 1175;
        Integer zeros = 0;
        Integer rounding = 0;
        while(currencyVal>100){
            zeros = zeros +1;
            rounding=Math.mod(currencyVal,10);
            currencyVal/=10;
            if(rounding >5){
                currencyVal=currencyVal+1;
            }
        }
        currencyVal= currencyVal*(Integer)math.pow(10,zeros);
        return currencyVal;
    }
    */
    
    
    public List<Decimal> audioBarDataThisYearList {get;set;}
    public Decimal audioThisYear {get; set;}
    //Method to show Audio Stacked Bar
    public void getAudioBarDataThisYear() {
       audioBarDataThisYearList = new List<Decimal>{0,0,0,0,0,0,0};
            utilityObj.audioStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData> audioDataList = utilityObj.AudioStackedListData();
        List<Decimal> audioList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData audioDataObj : audioDataList) {
            if(audioDataObj.name == '70 Volt Amplifiers')
                audioBarDataThisYearList[0]=audioDataObj.data;
            if(audioDataObj.name == 'Audio Accessories')
                audioBarDataThisYearList[1]=audioDataObj.data;
            if(audioDataObj.name == 'Audio Switches')
                audioBarDataThisYearList[2]=audioDataObj.data;
            if(audioDataObj.name == 'Matrix Amplifiers')
                audioBarDataThisYearList[3]=audioDataObj.data;
            if(audioDataObj.name == 'Power Amplifiers')
                audioBarDataThisYearList[4]=audioDataObj.data;

         audioThisYear = audioBarDataThisYearList[0] + audioBarDataThisYearList[1] + audioBarDataThisYearList[2] + audioBarDataThisYearList[3] + audioBarDataThisYearList[4];
        }
    }
    
    
    public List<Decimal> audioBarDataLastYearList {get;set;}
    public Decimal audioLastYear {get; set;}
    //Method to show Audio Stacked Bar
    public void getAudioBarDataLastYear() {
       audioBarDataLastYearList = new List<Decimal>{0,0,0,0,0,0,0};
            utilityLastYearObj.audioStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData> audioDataList = utilityLastYearObj.AudioStackedListData();
        List<Decimal> audioList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData audioDataObj : audioDataList) {
            
            if(audioDataObj.name == '70 Volt Amplifiers')
                audioBarDataLastYearList[0]=audioDataObj.data;
            if(audioDataObj.name == 'Audio Accessories')
                audioBarDataLastYearList[1]=audioDataObj.data;
            if(audioDataObj.name == 'Audio Switches')
                audioBarDataLastYearList[2]=audioDataObj.data;
            if(audioDataObj.name == 'Matrix Amplifiers')
                audioBarDataLastYearList[3]=audioDataObj.data;
            if(audioDataObj.name == 'Power Amplifiers')
                audioBarDataLastYearList[4]=audioDataObj.data;
                
                
          audioLastYear = (audioBarDataLastYearList[0]+audioBarDataLastYearList[1]+audioBarDataLastYearList[2]+audioBarDataLastYearList[3]+audioBarDataLastYearList[4]);
        }
    }
    
   
    
    public List<Decimal> controllersBarDataList {get;set;}
    public Decimal controlThisYear {get; set;}
    // Method to fill wrapper with values of 'Audio' and its SubProducts from map
    public void getControllerBarDataThisYear() {
        controllersBarDataList = new List<Decimal>{0,0,0,0,0,0,0};
            utilityObj.controllersStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData> controllerDataList = utilityObj.ControllersStackedListData();
        List<Decimal> controllerList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData controllerDataObj : controllerDataList) {
            
            if(controllerDataObj.name == 'Controller Accessories')
                controllersBarDataList[0]=controllerDataObj.data;
            if(controllerDataObj.name == 'EA1')
                controllersBarDataList[1]=controllerDataObj.data;
            if(controllerDataObj.name == 'EA3')
                controllersBarDataList[2]=controllerDataObj.data;
            if(controllerDataObj.name == 'EA5')
                controllersBarDataList[3]=controllerDataObj.data;
            if(controllerDataObj.name == 'IO Extenders')
                controllersBarDataList[4]=controllerDataObj.data;
            if(controllerDataObj.name == 'HC Controllers')
                controllersBarDataList[5]=controllerDataObj.data;
            if(controllerDataObj.name == 'Controllers')
                controllersBarDataList[6]=controllerDataObj.data;
                
           controlThisYear = controllersBarDataList[0]+controllersBarDataList[1]+controllersBarDataList[2]+controllersBarDataList[3]+controllersBarDataList[4]+controllersBarDataList[5]+controllersBarDataList[6];
        }  
    }
    
    public List<Decimal> controllersBarLastYearDataList {get;set;}
    public Decimal controlLastYear {get; set;}
    // Method to fill wrapper with values of 'Audio' and its SubProducts from map
    public void getControllerBarDataLastYear() {
        controllersBarLastYearDataList = new List<Decimal>{0,0,0,0,0,0,0};
            utilityLastYearObj.controllersStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData> controllerDataList = utilityLastYearObj.ControllersStackedListData();
        List<Decimal> controllerList = new List<Decimal>();
        String toolTipData ='';
        for(UtilityDailyDealerSalesLogLastYear.StackedListData controllerDataObj : controllerDataList) {
     
            if(controllerDataObj.name == 'Controller Accessories')
                controllersBarLastYearDataList[0]=controllerDataObj.data;
            if(controllerDataObj.name == 'EA1')
                controllersBarLastYearDataList[1]=controllerDataObj.data;
            if(controllerDataObj.name == 'EA3')
                controllersBarLastYearDataList[2]=controllerDataObj.data;
            if(controllerDataObj.name == 'EA5')
                controllersBarLastYearDataList[3]=controllerDataObj.data;
            if(controllerDataObj.name == 'IO Extenders')
                controllersBarLastYearDataList[4]=controllerDataObj.data;
            if(controllerDataObj.name == 'HC Controllers')
                controllersBarLastYearDataList[5]=controllerDataObj.data;
            if(controllerDataObj.name == 'Controllers')
                controllersBarLastYearDataList[6]=controllerDataObj.data;    
                
          controlLastYear = controllersBarLastYearDataList[0]+controllersBarLastYearDataList[1]+controllersBarLastYearDataList[2]+controllersBarLastYearDataList[3]+controllersBarLastYearDataList[4]+controllersBarLastYearDataList[5]+controllersBarLastYearDataList[6] ;   
        }
    }
    
    public Decimal videoThisYear {get; set;}
    public List<Decimal> videoBarDataList {get;set;}
    public void getVideoBarDataThisYear() {
        videoBarDataList = new List<Decimal>{0,0,0,0};
            utilityObj.videoStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData> videoDataList = utilityObj.VideoStackedListData();
        List<Decimal> videoList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData videoDataObj : videoDataList) {
            
            if(videoDataObj.name == 'HDMI')
                videoBarDataList[0]=videoDataObj.data;
            if(videoDataObj.name == 'HDMI Accessories')
                videoBarDataList[1]=videoDataObj.data;
            if(videoDataObj.name == 'HDMI Extenders')
                videoBarDataList[2]=videoDataObj.data;              
            videoThisYear = videoBarDataList[0]+videoBarDataList[1]+videoBarDataList[2];
        }
    }
    public Decimal videoLastYear {get; set;}
    public List<Decimal> videoBarLastYearDataList {get;set;}
    public void getVideoBarDataLastYear() {
        videoBarLastYearDataList = new List<Decimal>{0,0,0,0};
            utilityLastYearObj.videoStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData> videoDataList = utilityLastYearObj.VideoStackedListData();
        List<Decimal> videoList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData videoDataObj : videoDataList) {
               
            if(videoDataObj.name == 'HDMI')
                videoBarLastYearDataList[0]=videoDataObj.data;
            if(videoDataObj.name == 'HDMI Accessories')
                videoBarLastYearDataList[1]=videoDataObj.data;
            if(videoDataObj.name == 'HDMI Extenders')
                videoBarLastYearDataList[2]=videoDataObj.data;              
            videoLastYear = videoBarLastYearDataList[0]+videoBarLastYearDataList[1]+videoBarLastYearDataList[2];
        }
    }
    
    public Decimal LightingThisYear {get; set;}
    public List<Decimal> lightingBarDataList {get;set;}
    public void getLightingBarDataThisYear() {
        lightingBarDataList = new List<Decimal>{0,0,0,0,0,0};
            utilityObj.lightingStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData> lightingDataList = utilityObj.lightingStackedListData();
        List<Decimal> lightingList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData lightingDataObj : lightingDataList) {
            if(lightingDataObj.name == 'Centralized Lighting')
                lightingBarDataList[0]=lightingDataObj.data;
            if(lightingDataObj.name == 'Engraving')
                lightingBarDataList[1]=lightingDataObj.data;
            if(lightingDataObj.name == 'Faceplates')
                lightingBarDataList[2]=lightingDataObj.data;
            if(lightingDataObj.name == 'Lighting Accessories')
                lightingBarDataList[3]=lightingDataObj.data;
            if(lightingDataObj.name == 'Wireless Gen3')
                lightingBarDataList[4]=lightingDataObj.data;
            if(lightingDataObj.name == 'Lighting')
                lightingBarDataList[5]=lightingDataObj.data;
                LightingThisYear = lightingBarDataList[0]+lightingBarDataList[1] +lightingBarDataList[2] +lightingBarDataList[3] +lightingBarDataList[4] +lightingBarDataList[5];
      }  
    }
    
    public Decimal LightingLastYear {get; set;}
    public List<Decimal> lightingBarLastYearDataList {get;set;}
    public void getLightingBarDataLastYear() {
        lightingBarLastYearDataList = new List<Decimal>{0,0,0,0,0,0};
            utilityLastYearObj.lightingStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData> lightingDataList = utilityLastYearObj.lightingStackedListData();
        List<Decimal> lightingList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData lightingDataObj : lightingDataList) {
            if(lightingDataObj.name == 'Centralized Lighting')
                lightingBarLastYearDataList[0]=lightingDataObj.data;
            if(lightingDataObj.name == 'Engraving')
                lightingBarLastYearDataList[1]=lightingDataObj.data;
            if(lightingDataObj.name == 'Faceplates')
                lightingBarLastYearDataList[2]=lightingDataObj.data;
            if(lightingDataObj.name == 'Lighting Accessories')
                lightingBarLastYearDataList[3]=lightingDataObj.data;
            if(lightingDataObj.name == 'Wireless Gen3')
                lightingBarLastYearDataList[4]=lightingDataObj.data;
            if(lightingDataObj.name == 'Lighting')
                lightingBarLastYearDataList[5]=lightingDataObj.data;
                LightingLastYear = lightingBarLastYearDataList[1] +lightingBarLastYearDataList[2] +lightingBarLastYearDataList[3] +lightingBarLastYearDataList[4] +lightingBarLastYearDataList[5];
        }
    }
    
    public List<Decimal> climateBarDataList {get;set;}
    public Decimal climateThisYear {get; set;}
    public void getClimateBarDataThisYear() {
        climateBarDataList = new List<Decimal>{0,0,0};
            utilityObj.climateControlStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > climateDataList = utilityObj.ClimateControlPieData();
        List<Decimal> climateList = new List<Decimal>();
        String toolTipData ='';
        for(UtilityDailyDealerSalesLogThisYear.StackedListData climateDataObj : climateDataList) {
            if(climateDataObj.name == 'Climate Accessories')
                climateBarDataList[0]=climateDataObj.data;
            if(climateDataObj.name == 'Thermostat')
                climateBarDataList[1]=climateDataObj.data;
            if(climateDataObj.name == 'Climate Control')
                climateBarDataList[2]=climateDataObj.data;
          climateThisYear = climateBarDataList[0]+climateBarDataList[1]+climateBarDataList[2]; 
        }
    }
    
    public Decimal climateLastYear {get; set;}
    public List<Decimal> climateBarLastYearDataList {get;set;}
    public void getClimateBarDataLastYear() {
        climateBarLastYearDataList = new List<Decimal>{0,0,0};
            utilityLastYearObj.climateControlStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > climateDataList = utilityLastYearObj.ClimateControlPieData();
        List<Decimal> climateList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData climateDataObj : climateDataList) {
            if(climateDataObj.name == 'Climate Accessories')
                climateBarLastYearDataList[0]=climateDataObj.data;
            if(climateDataObj.name == 'Thermostat')
                climateBarLastYearDataList[1]=climateDataObj.data;
            if(climateDataObj.name == 'Climate Control')
                climateBarLastYearDataList[2]=climateDataObj.data;
                climateLastYear = climateBarDataList[0]+climateBarDataList[1]+climateBarDataList[2];
        }
    }
    
    public Decimal pakedgeThisYear {get; set;}
    public List<Decimal> pakedgeBarDataList{get;set;}
    public void getPakedgeBarDataThisYear() {
        pakedgeBarDataList = new List<Decimal>{0,0,0,0,0,0,0};
            utilityObj.pakedgeStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > pakedgeDataList = utilityObj.PakedgeStackedListData ();
        List<Decimal> pakedgeList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData pakedgeDataObj : pakedgeDataList) {
            if(pakedgeDataObj.name == 'Pakedge Accessories')
                pakedgeBarDataList[0]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'PDUs')
                pakedgeBarDataList[1]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'Routers')
                pakedgeBarDataList[2]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'Switches')
                pakedgeBarDataList[3]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'WAPs')
                pakedgeBarDataList[4]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'Wireless Controllers')
                pakedgeBarDataList[5]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'Pakedge')
                pakedgeBarDataList[6]=pakedgeDataObj.data;
                pakedgeThisYear = pakedgeBarDataList[0]+ pakedgeBarDataList[1]+ pakedgeBarDataList[2]+ pakedgeBarDataList[3]+ pakedgeBarDataList[4]+ pakedgeBarDataList[5]+ pakedgeBarDataList[6];
        }
    }
    
    public Decimal pakedgeLastYear {get; set;}
    public List<Decimal> pakedgeBarLastYearDataList{get;set;}
    public void getPakedgeBarDataLastYear() {
        pakedgeBarLastYearDataList = new List<Decimal>{0,0,0,0,0,0,0};
            utilityLastYearObj.pakedgeStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > pakedgeDataList = utilityLastYearObj.PakedgeStackedListData ();
        List<Decimal> pakedgeList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData pakedgeDataObj : pakedgeDataList) {
            if(pakedgeDataObj.name == 'Pakedge Accessories')
                pakedgeBarLastYearDataList[0]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'PDUs')
                pakedgeBarLastYearDataList[1]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'Routers')
                pakedgeBarLastYearDataList[2]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'Switches')
                pakedgeBarLastYearDataList[3]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'WAPs')
                pakedgeBarLastYearDataList[4]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'Wireless Controllers')
                pakedgeBarLastYearDataList[5]=pakedgeDataObj.data;
            if(pakedgeDataObj.name == 'Pakedge')
                pakedgeBarLastYearDataList[6]=pakedgeDataObj.data;
                pakedgeLastYear = pakedgeBarLastYearDataList[0] + pakedgeBarLastYearDataList[1] + pakedgeBarLastYearDataList[2] + pakedgeBarLastYearDataList[3] + pakedgeBarLastYearDataList[4] + pakedgeBarLastYearDataList[5] + pakedgeBarLastYearDataList[6]; 
        }
    }
    
    public List<Decimal> thirdPartyBarDataList {get;set;}
    public void getThridPartyBarDataThisYear() {
        thirdPartyBarDataList = new List<Decimal>{0};
            utilityObj.thirdPartyStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > thirdPartyDataList = utilityObj.thirdPartyStackedListData();
        List<Decimal> thirdPartyList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData thirdPartyDataObj : thirdPartyDataList) {
            thirdPartyBarDataList[0]=thirdPartyDataObj.data;
        }
    }
    
    public List<Decimal> thirdPartyBarLastYearDataList {get;set;}
    public void getThridPartyBarDataLastYear() {
        thirdPartyBarLastYearDataList = new List<Decimal>{0};
            utilityLastYearObj.thirdPartyStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > thirdPartyDataList = utilityLastYearObj.thirdPartyStackedListData();
        List<Decimal> thirdPartyList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData thirdPartyDataObj : thirdPartyDataList) {
            thirdPartyBarLastYearDataList[0]=thirdPartyDataObj.data;
        }
    }
    
    public Decimal interfaceThisYear {get; set;}
    public List<Decimal> InterfacesBarDataList {get;set;}
    public void getInterfaceBarDataThisYear() {
        InterfacesBarDataList = new List<Decimal>{0,0,0,0,0,0};
            utilityObj.interfaceComStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > interfaceDataList = utilityObj.interfaceComStackedListData();
        List<Decimal> interfaceList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData interfaceDataObj : interfaceDataList) {
            if(interfaceDataObj.name == 'Door Station')
                InterfacesBarDataList[0]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'Interface Accessories')
                InterfacesBarDataList[1]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'MDU Servers')
                InterfacesBarDataList[2]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'Remotes')
                InterfacesBarDataList[3]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'Touch Screens')
                InterfacesBarDataList[4]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'Interfaces')
                InterfacesBarDataList[5]=interfaceDataObj.data;
                interfaceThisYear = InterfacesBarDataList[0] + InterfacesBarDataList[1] +InterfacesBarDataList[2] +InterfacesBarDataList[3] +InterfacesBarDataList[4] +InterfacesBarDataList[5];
        }
    }
    
    public Decimal interfaceLastYear {get; set;}
    public List<Decimal> InterfacesBarLastYearDataList {get;set;}
    public void getInterfaceBarDataLastYear() {
        InterfacesBarLastYearDataList = new List<Decimal>{0,0,0,0,0,0};
            utilityLastYearObj.interfaceComStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > interfaceDataList = utilityLastYearObj.interfaceComStackedListData();
        List<Decimal> interfaceList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData interfaceDataObj : interfaceDataList) {
            if(interfaceDataObj.name == 'Door Station')
                InterfacesBarLastYearDataList[0]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'Interface Accessories')
                InterfacesBarLastYearDataList[1]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'MDU Servers')
                InterfacesBarLastYearDataList[2]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'Remotes')
                InterfacesBarLastYearDataList[3]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'Touch Screens')
                InterfacesBarLastYearDataList[4]=interfaceDataObj.data;
            if(interfaceDataObj.name == 'Interfaces')
                InterfacesBarLastYearDataList[5]=interfaceDataObj.data;
                interfaceLastYear = InterfacesBarLastYearDataList[0] + InterfacesBarLastYearDataList[1] + InterfacesBarLastYearDataList[2] + InterfacesBarLastYearDataList[3] + InterfacesBarLastYearDataList[4] + InterfacesBarLastYearDataList[5]; 
        }
    }
    
    public Decimal cardaccessThisYear {get; set;}
    public List<Decimal> cardAccessBarDataList {get;set;}
    public void getCardAccessBarDataThisYear() {
        cardAccessBarDataList = new List<Decimal>{0};
            utilityObj.CardAccessData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > cardAccessDataList = utilityObj.CardAccessStackedListData();
        List<Decimal> cardAccessList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData cardAccessDataObj : cardAccessDataList) {
            if(cardAccessDataObj.name == 'Card Access')
                cardAccessBarDataList[0]=cardAccessDataObj.data;
                cardaccessThisYear = cardAccessBarDataList[0];
        }
    }
    public Decimal cardaccessLastYear {get; set;}
    public List<Decimal> cardAccessBarLastYearDataList {get;set;}
    public void getCardAccessBarDataLastYear() {
        cardAccessBarLastYearDataList = new List<Decimal>{0};
            utilityLastYearObj.CardAccessData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > cardAccessDataList = utilityLastYearObj.CardAccessStackedListData();
        List<Decimal> cardAccessList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData cardAccessDataObj : cardAccessDataList) {
            if(cardAccessDataObj.name == 'Card Access')
                cardAccessBarLastYearDataList[0]=cardAccessDataObj.data;
                cardaccessLastYear = cardAccessBarLastYearDataList[0];
        }
    }
    public Decimal doorlocksThisYear {get; set;}
    public List<Decimal> doorLocksBarDataList {get;set;}
    public void getDoorLockBarDataThisYear() {
        doorLocksBarDataList = new List<Decimal>{0,0,0};
            utilityObj.DoorLockStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > doorLockDataList = utilityObj.DoorLockStackedListData();
        List<Decimal> doorLockList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData doorLockDataObj : doorLockDataList) {
                if(doorLockDataObj.name == 'Baldwin')
                doorLocksBarDataList[0]=doorLockDataObj.data;
                if(doorLockDataObj.name == 'Kwikset')
                doorLocksBarDataList[1]=doorLockDataObj.data;
                if(doorLockDataObj.name == 'Yale')
                doorLocksBarDataList[2]=doorLockDataObj.data;
                doorlocksThisYear = doorLocksBarDataList[0] + doorLocksBarDataList[1] + doorLocksBarDataList[2];
        }
    }
    public Decimal doorlocksLastYear {get; set;}
    public List<Decimal> doorLocksBarLastYearDataList {get;set;}
    public void getDoorLockBarDataLastYear() {
        doorLocksBarLastYearDataList = new List<Decimal>{0,0,0};
            utilityLastYearObj.DoorLockStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > doorLockDataList = utilityLastYearObj.DoorLockStackedListData();
        List<Decimal> doorLockList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData doorLockDataObj : doorLockDataList) {
                if(doorLockDataObj.name == 'Baldwin')
                doorLocksBarLastYearDataList[0]=doorLockDataObj.data;
                if(doorLockDataObj.name == 'Kwikset')
                doorLocksBarLastYearDataList[1]=doorLockDataObj.data;
                if(doorLockDataObj.name == 'Yale')
                doorLocksBarLastYearDataList[2]=doorLockDataObj.data;
                doorlocksLastYear = doorLocksBarLastYearDataList[0] + doorLocksBarLastYearDataList[1] + doorLocksBarLastYearDataList[2];
        }
    }
    public Decimal networkingThisYear {get; set;}
    public List<Decimal> networkingBarDataList {get;set;}
    public void getNetworkingBarDataThisYear() {
        networkingBarDataList = new List<Decimal>{0,0,0,0,0,0,0};
            utilityObj.NetworkingStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > networkingDataList = utilityObj.NetworkingStackedListData();
        List<Decimal> networkingList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData networkingDataObj : networkingDataList) {
                if(networkingDataObj.name == 'Networking Accessories')
                networkingBarDataList[0]=networkingDataObj.data;
                if(networkingDataObj.name == 'Network Switches')
                networkingBarDataList[1]=networkingDataObj.data;
                if(networkingDataObj.name == 'PDUs')
                networkingBarDataList[2]=networkingDataObj.data;
                if(networkingDataObj.name == 'Routers')
                networkingBarDataList[3]=networkingDataObj.data;
                if(networkingDataObj.name == 'Wireless Access Points')
                networkingBarDataList[4]=networkingDataObj.data;
                if(networkingDataObj.name == 'Wireless Controllers')
                networkingBarDataList[5]=networkingDataObj.data;
                networkingThisYear = networkingBarDataList[0] + networkingBarDataList[1]  + networkingBarDataList[2]+ networkingBarDataList[3]+ networkingBarDataList[4]+ networkingBarDataList[5];
        }
    }
    public Decimal networkingLastYear {get; set;}
    public List<Decimal> networkingBarLastYearDataList {get;set;}
    public void getNetworkingBarDataLastYear() {
        networkingBarLastYearDataList = new List<Decimal>{0,0,0,0,0,0,0};
            utilityLastYearObj.NetworkingStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > networkingDataList = utilityLastYearObj.NetworkingStackedListData();
        List<Decimal> networkingList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData networkingDataObj : networkingDataList) {              
                if(networkingDataObj.name == 'Networking Accessories')
                networkingBarLastYearDataList[0]=networkingDataObj.data;
                if(networkingDataObj.name == 'Network Switches')
                networkingBarLastYearDataList[1]=networkingDataObj.data;
                if(networkingDataObj.name == 'PDUs')
                networkingBarLastYearDataList[2]=networkingDataObj.data;
                if(networkingDataObj.name == 'Routers')
                networkingBarLastYearDataList[3]=networkingDataObj.data;
                if(networkingDataObj.name == 'Wireless Access Points')
                networkingBarLastYearDataList[4]=networkingDataObj.data;
                if(networkingDataObj.name == 'Wireless Controllers')
                networkingBarLastYearDataList[5]=networkingDataObj.data;
                networkingLastYear = networkingBarLastYearDataList[0] + networkingBarLastYearDataList[1]  + networkingBarLastYearDataList[2]+ networkingBarLastYearDataList[3]+ networkingBarLastYearDataList[4]+ networkingBarLastYearDataList[5];
        }
    }
    
    public Decimal partnerThisYear {get; set;}
    public List<Decimal> partnerProductBarDataList {get;set;}
    public void getPartnerProductBarDataThisYear() {
        partnerProductBarDataList = new List<Decimal>{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
            utilityObj.PartnerProductBarDataStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > partnerProductDataList = utilityObj.PartnerProductBarDataStackedListData();
        List<Decimal>  partnerProductList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData  partnerProductDataObj : partnerProductDataList) {
                if(partnerProductDataObj.name == 'Partner Products')
                partnerProductBarDataList[0]=partnerProductDataObj.data;
                
                partnerThisYear = partnerProductBarDataList[0];

        }
    }
    
    public Decimal partnerLastYear {get; set;}
    public List<Decimal> partnerProductBarLastYearDataList {get;set;}
    public void getPartnerProductBarDataLastYear() {
        partnerProductBarLastYearDataList = new List<Decimal>{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
            utilityLastYearObj.PartnerProductBarDataStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > partnerProductDataList = utilityLastYearObj.PartnerProductBarDataStackedListData();
        List<Decimal>  partnerProductList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData  partnerProductDataObj : partnerProductDataList) {
                
                if(partnerProductDataObj.name == 'Partner Products')
                partnerProductBarLastYearDataList[0]=partnerProductDataObj.data;
                partnerLastYear = partnerProductBarDataList[0];
             }
    }
    
    public Decimal TriadThisYear {get; set;}
    public List<Decimal> triadBarDataList {get;set;}
    public void getTriadBarDataThisYear() {
        triadBarDataList = new List<Decimal>{0,0,0};
            utilityObj.TriadStackedData();
        List<UtilityDailyDealerSalesLogThisYear.StackedListData > triadDataList = utilityObj.TriadStackedListData();
        List<Decimal> triadList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogThisYear.StackedListData triadDataObj : triadDataList) {
                if(triadDataObj.name == 'Accessories')
                triadBarDataList[0] = triadDataObj.data;
                if(triadDataObj.name == 'InCeiling')
                triadBarDataList[1] = triadDataObj.data;
                if(triadDataObj.name == 'Outdoor')
                triadBarDataList[2] = triadDataObj.data;
        
            TriadThisYear = triadBarDataList[0] + triadBarDataList[1] + triadBarDataList[2];
            system.debug(TriadThisYear+'test');
        }
    }
    public Decimal TriadLastYear {get; set;}
    public List<Decimal> triadBarLastYearDataList {get;set;}
    public void getTriadBarDataLastYear() {
        triadBarLastYearDataList = new List<Decimal>{0,0,0};
            utilityLastYearObj.TriadStackedData();
        List<UtilityDailyDealerSalesLogLastYear.StackedListData > triadDataList = utilityLastYearObj.TriadStackedListData();
        List<Decimal> triadList = new List<Decimal>();
        for(UtilityDailyDealerSalesLogLastYear.StackedListData triadDataObj : triadDataList) {
            
                if(triadDataObj.name == 'Accessories')
                triadBarLastYearDataList[0] = triadDataObj.data;
                if(triadDataObj.name == 'InCeiling')
                triadBarLastYearDataList[1] = triadDataObj.data;
                if(triadDataObj.name == 'Outdoor')
                triadBarLastYearDataList[2] = triadDataObj.data;
                
            TriadLastYear = triadBarLastYearDataList[0]+triadBarLastYearDataList[1]+triadBarLastYearDataList[2];
            
        }
    }
      /* Start Added by Sudeep */
    
    // Inner class to get values for new Opportunity from Page
    public class OpportunityData {
        public String strName;
        public String strStage;
        public String closedDate;
        public Double doubAmount;
        public String strDescription;
        public String strNextStep;
        
        public OpportunityData() {
            this.strName = '';
            this.strStage = '';
            this.strDescription = '';
            this.strNextStep = '';
        }        
    }
    
    /* End added by Sudeep */
}