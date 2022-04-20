public class WP_dRMA_Controller {
    
    private final static Integer MAX_RESULTS = 8;
    
    @AuraEnabled(cacheable=true) 
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
        
        searchTerm += '*'; // Prepare query paramters
        List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING
                                             Product2 (Id, Name, ProductCode 
                                                       WHERE id NOT IN :selectedIds
                                                        AND RecordTypeId = '0121T00000024FHQAY' AND IsActive = TRUE) // 0121T00000024FHQAY is the Support Record Type, Eric Quinney - added is active TRUE
                                             LIMIT :MAX_RESULTS];     
        
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        Product2 [] products = ((List<Product2>) searchResults[0]);
        for (Product2 product : products) {
            results.add(new LookupSearchResult(product.Id, 'Product', 'standard:products', product.Name, product.ProductCode));
        }
        
        return results;       
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<LookupSearchResult> searchIssues(String searchTerm, List<String> selectedIds) {
        
        searchTerm += '*'; // Prepare query paramters
        List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING
                                             Support_Issue_Code__c (Id, Name, Search_Help__c WHERE id NOT IN :selectedIds AND Is_TSS_Reason__c = True)  // Eric Quinney added AND Is_TSS_Reason__c = True
                                             LIMIT :MAX_RESULTS];
        
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        Support_Issue_Code__c [] reasonCodes = ((List<Support_Issue_Code__c>) searchResults[0]);
        for (Support_Issue_Code__c rc : reasonCodes) {
            results.add(new LookupSearchResult(rc.Id, 'Reason', 'standard:product_required',  rc.Name, rc.Search_Help__c));
        }
        
        return results;       
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<LookupSearchResult> searchItems(String searchTerm, List<String> selectedIds) {
        
        searchTerm += '*'; // Prepare query paramters
        List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING
                                             Product2 (Id, Name, ProductCode 
                                                       WHERE id NOT IN :selectedIds
                                                       AND RecordTypeId = '0121T00000024FLQAY') // 0121T00000024FLQAY is the Standard Record Type
                                             LIMIT :MAX_RESULTS];
        
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        Product2 [] products = ((List<Product2>) searchResults[0]);
        for (Product2 product : products) {
            results.add(new LookupSearchResult(product.Id, 'Product', 'standard:products', product.Name, product.ProductCode));
        }
        
        return results;          
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<LookupSearchResult> outboundItems(String searchTerm, List<String> selectedIds) {
        
        searchTerm += '*'; // Prepare query paramters
        List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING
                                             Product2 (Id, Name, ProductCode WHERE id NOT IN :selectedIds 
                                                       AND RecordTypeId = '0121T00000024FLQAY') // 0121T00000024FLQAY is the Standard Record Type
                                             LIMIT :MAX_RESULTS];
        
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        Product2 [] products = ((List<Product2>) searchResults[0]);
        for (Product2 product : products) {
            results.add(new LookupSearchResult(product.Id, 'Product', 'standard:products', product.Name, product.ProductCode));
        }
        
        return results;          
    }
    
    @AuraEnabled
    public static Boolean GetIs3rdPartyProduct (string productSku)
    {
        Boolean x3p = [Select X3P_Product__c from Product2 where recordtypeID = '0121T00000024FLQAY' and productCode = :productSku limit 1].X3P_Product__c;       
        return x3p == true ? true : false; // handles nulls?        
    }
    
    @AuraEnabled  
    public static List<String> GetOutcomeList(Id caseId)
    {          
        List<String> pickListValuesList= new List<String>();        
       	pickListValuesList.add('-- Select One --');
        pickListValuesList.add('None - Out of Warranty'); 
        
        Case c = [select Account.Credit_Only_Account__c from case where id =  :caseID];
        
        if (c.Account.Credit_Only_Account__c)
        {

            pickListValuesList.add('Credit Only');           
        }
        else
        {
            Schema.DescribeFieldResult fieldResult = CaseProduct__c.RMA_Outcome__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
               if(pickListVal.getLabel() != 'None - Out of Warranty' && pickListVal.getLabel() != '-- Select One --'){
                    pickListValuesList.add(pickListVal.getLabel());
                }
            }            
        }
        
        return pickListValuesList;
    }
    
    @AuraEnabled  
    public static List<String> GetShipmentList()
    {       
        List<String> pickListValuesList= new List<String>();        
        Schema.DescribeFieldResult fieldResult = CaseProduct__c.Shipment_Priority__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        
        return pickListValuesList;
    }
    
    @AuraEnabled  
    public static CustValues GetCustomValues(Id caseID)
    {       
        CustValues cv = new CustValues();
        
        Case c = [select Id, Account.Credit_Only_Account__c, Account.BillingCountry,  Account.SAP_Instance__c from case where id =  :caseID];
        cv.CreditOnly = c.Account.Credit_Only_Account__c == true ? true : false;
        
        //cv.Shipping = c.Account.BillingCountry;
        
        switch on c.Account.SAP_Instance__c {
            when 'SAP_US' {		
                cv.Shipping = 'FedEx Ground';
            }	
            when 'SAP_AU' {	
                cv.Shipping = 'Australia - Ground';
            }
            when 'SAP_UK' {	
                cv.Shipping = 'DHL';
            }
            when 'SAP_NC' {	
                cv.Shipping = 'FedEx Ground';
            }
            when else {	
                cv.Shipping = 'FedEx Ground';               
            }
        }
        
        return cv;
    }    
    
    //@AuraEnabled  
    //public static Boolean GetIsSerialized(Id productID)
    //{       
    //    Product2 p = [select Id, Serialized__c from Product2 where id =  :productID];        
    //    return p.Serialized__c;
    //}   
    
    @AuraEnabled  
    public static list<RMAListWrapper> GetRMARecords(Id caseID)
    {
        List<RMAListWrapper> wList = new List<RMAListWrapper>();
        List<CaseProduct__c> cpList = [select id, Name, RMA__c, MacID__c, Supported_Product__r.Name, Item__r.Name from CaseProduct__c where Case__c = :caseID];
        
        for (CaseProduct__c cp : cpList)
        {
            RMAListWrapper w = new RMAListWrapper();
            w.id = cp.Id;
            //w.iconName = 'standard:products';
            w.name = cp.Name;
            w.rma = cp.RMA__c;
            w.macID = cp.MacID__c;            
            w.supProdName = cp.Supported_Product__r.Name;
            w.itemName = cp.Item__r.Name == null ? '' : cp.Item__r.Name;
            wList.Add(w);
        }
        
        return wList;
    }

    @AuraEnabled
    public static String getCaseRecord(String caseId) {

        List<Case> caseList = [
            SELECT RMA_Exceptions__c
              FROM Case
             WHERE Id =: caseId
        ];

        if(!caseList.isEmpty()) {

            if(caseList[0].RMA_Exceptions__c != null || caseList[0].RMA_Exceptions__c != '') {

                return caseList[0].RMA_Exceptions__c;
            }
        }
        return 'None';
    }

    @AuraEnabled
    public static String exceptionMetadata() {

        List<RMA_Exceptions__mdt> rmaExceptionList = RMA_Exceptions__mdt.getAll().values();
        String techSupportException = '', dealerSupportException = '';

        if(rmaExceptionList != null || !rmaExceptionList.isEmpty()) {

            for(RMA_Exceptions__mdt exceptionmdt : rmaExceptionList) {

                if(exceptionmdt.DeveloperName == 'Tech_Support_Exception') {

                    techSupportException = exceptionmdt.RMA_Exception_Name__c;
                }
                if(exceptionmdt.DeveloperName == 'Dealer_Satisfaction_Exception') {

                    dealerSupportException = exceptionmdt.RMA_Exception_Name__c;
                }
            }
        }
        return techSupportException+' '+dealerSupportException;
    }

    @AuraEnabled  
    public static string SaveRMA(string rmaId, string caseId, string notes, string supportProd, string version, string issue, boolean isRMA, 
                                 string macSerServ, string item, string sku, string salesNumber, boolean SalesNumberViaAutomation, string nsoReason, 
                                 string outcome, string outboundItem, string miscPartReason, string shipping, Integer quantity, boolean failUpdate,
                                 boolean damageTransit, boolean failBox, boolean ovrcIssue, boolean noTroubleshoot, boolean inWarranty, string inWarrantyReason,
                                 String inWarrantyException)
    {  
        system.debug('SaveRMA function');     
        system.debug('item Id ' + item);     
        string returnVal = 'ERROR';
        
        try
        {
            CaseProduct__c cp = new CaseProduct__c();
            // Is this a new or existing caseproduct))c?
            if (!String.isBlank(rmaId))
            {
                // this is an existing caseproduct__c
                cp.Id = rmaId;             
            }
            else
            {
                // this is a new caseproduct__c
                cp.Case__c = caseId;
            }           
            
            // only save sales number if it is not 'NOT FOUND'
            if (salesNumber != 'NOT FOUND') {
                cp.Sales_Order_Number__c = salesNumber;    
            }             
                   
            cp.Supported_Product__c = supportProd;
            cp.Firmware_Versions__c = version;
            cp.Support_Issue_Detail__c = issue;
            cp.RMA__c = isRMA == true ? 'Yes' : 'No';
            cp.RMA_Type__c = 'Defective';
            
            if (isRMA)
            {
                cp.MacID__c = macSerServ;
                cp.Item__c = item;
                cp.InWarranty__c = inWarranty;
                cp.InWarranty_Reason__c = inWarrantyReason;
                cp.Sales_Order_Populated_Via_Automation__c = SalesNumberViaAutomation;
                cp.detail__c = notes;
                
                if (String.isBlank(salesNumber) && !String.isBlank(sku))
                {
                    Case c = [SELECT Id, SAP_Account_ID__c FROM Case WHERE Id = :caseId]; 
                    string salesNumberBestQuess = GetWarrantyLatestSObySKU_CallOut(c.SAP_Account_ID__c, sku);
                    
                    if (!String.isBlank(salesNumberBestQuess))
                    {
                        cp.Sales_Order_Number__c = salesNumberBestQuess;
                        cp.Sales_Order_Populated_Via_Automation__c = true;
                        cp.Sales_Order_Not_Available_Reason__c = 'Best Guess Found';
                    }
                    else
                    {
                        cp.Sales_Order_Number__c = 'NOT FOUND';
                        cp.Sales_Order_Populated_Via_Automation__c = true;                       
                    }                   
                }  
                                
                if (nsoReason != '- None -' && cp.Sales_Order_Not_Available_Reason__c != 'Best Guess Found') {
                    cp.Sales_Order_Not_Available_Reason__c = nsoReason;
                }

                if (!String.isBlank(outboundItem)) {                            
                    cp.Outbound_Product__c = outboundItem;
                }
                
                cp.MISC_PART_Description__c = miscPartReason + ' Miscellaneous or Replacement Part';               
                cp.Quantity__c = quantity;
                cp.Failed_On_Update__c = failUpdate;
                cp.Damaged_in_Transit__c = damageTransit;            
                cp.Out_of_Box_failure__c = failBox;
                cp.OvrC_Issue__c = ovrcIssue;
                cp.No_Troubleshooting__c = noTroubleshoot;    
            }
            
            if (outcome != '- None -') {
                cp.RMA_Outcome__c = outcome; 
            }
            
            if (outcome != 'Credit Only' && outcome != 'None - Out of Warranty') {
                cp.Shipment_Priority__c = shipping;
            }
            else
            {
                cp.Shipment_Priority__c = 'No Replacement Needed'; 
            }
            
            upsert cp;
            
            CaseProduct__c cp2 = [SELECT Name from CaseProduct__c WHERE Id = :cp.Id];            
            returnVal = cp2.Name;
            
            if (!String.isBlank(notes))
            {
                FeedItem p = new FeedItem();
                p.ParentId = caseId; //eg. Opportunity id, custom object id..
                p.Body = notes;
                insert p;  
            }

            //Upsert Case to update the RMA_Exceptions__c field
            //Start
            System.debug('caseId -- ' + caseId +'   ||||||  ' + 'inWarrantyException -- ' + inWarrantyException );
            if(!String.isBlank(caseId) && !String.isBlank(inWarrantyException)) {

                if(inWarrantyException != 'None') {

                    Case caseObj = new Case();
                    caseObj.Id = caseId;
                    caseObj.RMA_Exceptions__c = inWarrantyException;
                    System.debug('caseObj -- ' + caseObj);
                    try {

                        //Database.SaveResult[] srList = Database.upsert(caseObj, false);
                        upsert caseObj;
                        //System.debug('Upsert result'+srList);

                        System.debug('after upsert');
                    }catch (Exception e)
                    {   System.debug('e.getMessage(); -- ' + e.getMessage());
                        // SELECT id, Apex_Class__c, Method__c, Message__c, Stack_Trace__c FROM Apex_Debug_Log__c WHERE Apex_Class__c = 'WP_dRMA_Controller' order by createddate desc limit 100
                        new ApexDebugLog().createLog(new ApexDebugLog.Error('WP_dRMA_Controller', 'SaveRMA', rmaId, e));
                        return 'ERROR ' + e.getMessage();
                    }
                }
            }
            //stop
        }
        catch (Exception e)
        {
            // SELECT id, Apex_Class__c, Method__c, Message__c, Stack_Trace__c FROM Apex_Debug_Log__c WHERE Apex_Class__c = 'WP_dRMA_Controller' order by createddate desc limit 100
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WP_dRMA_Controller', 'SaveRMA', rmaId, e));
            return 'ERROR ' + e.getMessage();                
        }
        
        return returnVal;
    }    
    
    public static string GetWarrantyLatestSObySKU_CallOut (string sapAccountId, string sku)
    {  
        try
        {              
            //req.setEndpoint('https://erp.control4.com/C4Test/query/SF_GetSalesOrderBestGuess.aspx?cardcode=RIC906&sku=OVRC-300-PRO'); // for a quick test            
            //string url = 'https://erp.control4.com/C4Test/query/SF_GetSalesOrderBestGuess.aspx?cardcode=' + sapAccountId + '&sku=' + sku;            
            //string url = 'https://erp.control4.com/Default/query/SF_GetSalesOrderBestGuess.aspx?cardcode=' + sapAccountId + '&sku=' + sku;            
            
            Boolean IsSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;        
            string url = 'SF_GetSalesOrderBestGuess.aspx?cardcode=' + sapAccountId + '&sku=' + sku;
            if (IsSandbox)
            {
                url = 'https://erp.control4.com/C4Test/query/' + url;       
            }
            else
            {
                url = 'https://erp.control4.com/Default/query/' + url;
            }           
            
            system.debug('Url ' + url);
            HttpRequest req = new HttpRequest();       
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setHeader('content-type','application/json');  
            req.setHeader('Accept','application/json');
            req.setTimeout(120000);
            req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('steve:steve')));
            
            // Send the request, and return a response		
            Http h = new Http();
            HttpResponse res = h.send(req);           
            
            // Format the JSON to deserialize properly
            string fixJSON1 = res.getBody().replace('@id','rowID').replace('@name','columnName').replace('@alias','columnAlias').replace('@type','columnType').replace('@key','columnKey');       
            string fixJSON2 = fixJSON1.replace('@','');   
            LatestSalesOrderJSONtoApex salesData = LatestSalesOrderJSONtoApex.parse(fixJSON2);       
            string salesOrderNumber = salesData.response.payload.querydata.data.row.Warranty_order_id;
            system.debug('JSON ' + fixJSON2.substring(300, fixJSON2.length())); // substring. debug won't write much to debug log           
            system.debug('Sales Order Number ' + salesOrderNumber);
            
            if (salesOrderNumber != '')
            {
                return salesOrderNumber;
            }
        }
        catch (Exception ex)
        {
            //new ApexDebugLog().createLog(new ApexDebugLog.Error('WarrantyLookupToolController', 'GetWarrantyLatestSObySKU_CallOut', 0, ex));
        }
        
        return '';
    }     
    
    @AuraEnabled  
    public static RMAWrapper GetRMA(Id rmaId)
    {
        CaseProduct__c cp = [select id
                             , Supported_Product__c
                             , Supported_Product__r.ProductCode
                             , Supported_Product__r.Name
                             , Firmware_Versions__c
                             , Support_Issue_Detail__c
                             , Support_Issue_Detail__r.Name
                             , Support_Issue_Detail__r.Search_Help__c
                             , RMA__c
                             , InWarranty__c
                             , InWarranty_Reason__c
                             , MacID__c
                             , Item__c
                             , Item__r.ProductCode
                             , Item__r.Name                             
                             , Sales_Order_Number__c
                             , Sales_Order_Not_Available_Reason__c
                             , RMA_Outcome__c
                             , Outbound_Product__c
                             , Outbound_Product__r.ProductCode
                             , Outbound_Product__r.Name                             
                             , Shipment_Priority__c
                             , Quantity__c
                             , Failed_On_Update__c
                             , Damaged_in_Transit__c
                             , Out_of_Box_failure__c
                             , OvrC_Issue__c
                             , No_Troubleshooting__c 
                             from CaseProduct__c where id = :rmaId];
        
        RMAWrapper w = new RMAWrapper();     
        w.SupportedProduct = cp.Supported_Product__c;
        w.SupportedProductSKU = cp.Supported_Product__r.ProductCode;
        w.SupportedProductName = cp.Supported_Product__r.Name;
        w.Version = cp.Firmware_Versions__c;        
        w.Issue  = cp.Support_Issue_Detail__c;
        w.IssueHelp = cp.Support_Issue_Detail__r.Search_Help__c;
        w.IssueName = cp.Support_Issue_Detail__r.Name;
        w.RMA  = cp.RMA__c == 'Yes' ? true : false;  
        w.InWarranty = cp.InWarranty__c;
        w.InWarrantyReason = cp.InWarranty_Reason__c;
        w.MacSerServ = cp.MacID__c;        
        w.Item  = cp.Item__c;       
        w.ItemSKU = cp.Item__r.ProductCode;
        w.ItemName = cp.Item__r.Name;        
        w.SalesNumber = cp.Sales_Order_Number__c;
        w.NSO = String.isBlank(cp.Sales_Order_Not_Available_Reason__c) ? false : true;
        w.NSOReason = cp.Sales_Order_Not_Available_Reason__c;            
        w.RMAOutcome  = cp.RMA_Outcome__c;
        w.Outbound = String.isBlank(cp.Outbound_Product__c) ? false : true;
        w.OutboundItem = cp.Outbound_Product__c;
        w.OutboundSKU = cp.Outbound_Product__r.ProductCode;
        w.OutboundName = cp.Outbound_Product__r.Name;
        w.Shipping  = cp.Shipment_Priority__c;        
        w.Quantity  = Integer.ValueOf(cp.Quantity__c);        
        w.FailedUpdate  = cp.Failed_On_Update__c;        
        w.DamagedTransit  = cp.Damaged_in_Transit__c;        
        w.OutBoxfailure  = cp.Out_of_Box_failure__c;        
        w.OvrCIssue  = cp.OvrC_Issue__c;        
        w.NoTroubleshooting  = cp.No_Troubleshooting__c; 
        
        return w;        
    }    
    
    
    
    @AuraEnabled  
    public static string DeleteRMA(string rmaId)
    {        
        try
        {
            CaseProduct__c cp = [select id from CaseProduct__c where id = :rmaId];
            delete cp;
        }
        catch (Exception e)
        {
            // SELECT id, Apex_Class__c, Method__c, Message__c, Stack_Trace__c FROM Apex_Debug_Log__c WHERE Apex_Class__c = 'WP_dRMA_Controller' order by createddate desc limit 100
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WP_dRMA_Controller', 'DeleteRMA', rmaId, e));
            return 'ERROR ' + e.getMessage();                
        }
        
        return 'SUCCESS';
    }   
    
    public class CustValues
    {
        @AuraEnabled
        public String Shipping {get; set;}
        
        @AuraEnabled
        public Boolean CreditOnly {get; set;}        
    }
    
    public class RMAListWrapper 
    {
        @AuraEnabled
        public Id id {get; set;}
        
        @AuraEnabled
        public String iconName {get; set;}
        
        @AuraEnabled
        public String name {get; set;}
        
        @AuraEnabled
        public String rma {get; set;}
        
        @AuraEnabled
        public String macID {get; set;}
        
        @AuraEnabled
        public String supProdName {get; set;}
        
        @AuraEnabled
        public String itemName {get; set;}
    }
    
    public class RMAWrapper 
    {      
        @AuraEnabled
        public String SupportedProduct {get; set;}
        
        @AuraEnabled
        public String SupportedProductSKU {get; set;}
        
        @AuraEnabled
        public String SupportedProductName {get; set;}
        
        @AuraEnabled
        public String Version {get; set;}
        
        @AuraEnabled
        public String Issue {get; set;}
        
        @AuraEnabled
        public String IssueHelp {get; set;}
        
        @AuraEnabled
        public String IssueName {get; set;}        
        
        @AuraEnabled
        public Boolean RMA {get; set;}
        
        @AuraEnabled
        public String MacSerServ {get; set;}
        
        @AuraEnabled
        public Boolean InWarranty {get; set;}

        @AuraEnabled
        public String InWarrantyReason {get; set;}
        
        @AuraEnabled
        public String Item {get; set;}
        
        @AuraEnabled
        public String ItemSKU {get; set;}
        
        @AuraEnabled
        public String ItemName {get; set;}
        
        @AuraEnabled
        public String SalesNumber {get; set;}
        
        @AuraEnabled
        public Boolean NSO {get; set;}
        
        @AuraEnabled
        public String NSOReason {get; set;}       
        
        @AuraEnabled
        public String RMAOutcome {get; set;}
        
        @AuraEnabled
        public Boolean Outbound {get; set;}        
        
        @AuraEnabled
        public String OutboundItem {get; set;}
        
        @AuraEnabled
        public String OutboundSKU {get; set;}
        
        @AuraEnabled
        public String OutboundName {get; set;}
        
        @AuraEnabled
        public String Shipping {get; set;}
        
        @AuraEnabled
        public Integer Quantity {get; set;}
        
        @AuraEnabled
        public Boolean FailedUpdate {get; set;}
        
        @AuraEnabled
        public Boolean DamagedTransit {get; set;}
        
        @AuraEnabled
        public Boolean OutBoxfailure {get; set;}
        
        @AuraEnabled
        public Boolean OvrCIssue {get; set;}
        
        @AuraEnabled
        public Boolean NoTroubleshooting {get; set;}        
    }
    
    // Container class to define the structure of the LookupSearchResult object
    private class LookupSearchResult {
        
        private Id id;
        private String sObjectType;
        private String icon;
        private String title;
        private String subtitle;
        
        public LookupSearchResult(Id id, String sObjectType, String icon, String title, String subtitle) {
            this.id = id;
            this.sObjectType = sObjectType;
            this.icon = icon;
            this.title = title;
            this.subtitle = subtitle;
        }
        
        @AuraEnabled
        public Id getId() {
            return id;
        }
        
        @AuraEnabled
        public String getSObjectType() {
            return sObjectType;
        }
        
        @AuraEnabled
        public String getIcon() {
            return icon;
        }
        
        @AuraEnabled
        public String getTitle() {
            return title;
        }
        
        @AuraEnabled
        public String getSubtitle() {
            return subtitle;
        }
    }
}