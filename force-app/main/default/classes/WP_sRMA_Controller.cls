public class WP_sRMA_Controller {
    
    @AuraEnabled  
    public static List<String> GetReasonCodes()
    {       
        List<String> pickListValuesList= new List<String>();
        
        Schema.DescribeFieldResult fieldResult = CaseProduct__c.RMA_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        
        return pickListValuesList;
    }
    
    // Check to see if the product exists in Salesforce
    @AuraEnabled
    public static string ValidateProductSKU(string productCode)
    {
        try
        {
            Product2 p = [SELECT Id, ProductCode 
                          FROM Product2 
                          WHERE (RecordTypeId = '0121T00000024FLQAY' OR RecordTypeId = '') 
                          AND ProductCode = :productCode
                          LIMIT 1]; 
            
            return 'Success';
        }
        catch (Exception e)
        {
            return 'Error';
        }      
    }
    
    @AuraEnabled  
    public static String CreateCaseProduct (string itemsJSON, string caseId, boolean sendViaTrigger, boolean noCreditMemo, boolean optOutOfEmail, string notes)
    {      
        try 
        {   
            system.debug(itemsJSON);            
            List<NewCaseProduct> newCPList = (List<NewCaseProduct>) System.JSON.deserialize(itemsJSON.Replace('__c',''), List<NewCaseProduct>.class);
            
            // Get list of SKU's
            List<String> skusList = new List<String>();
            for(NewCaseProduct ncp: newCPList){
                skusList.add(ncp.SKU);
            }

            // GET Product2 ID's
            List<Product2> pList = [SELECT Id, ProductCode  
                                    FROM Product2 
                                    WHERE (RecordTypeId = '0121T00000024FLQAY' OR RecordTypeId = '')
                                    AND ProductCode in :skusList]; 

            // build product maps
            Map<String, Id> productMap = new Map<String, Id>();
            for (Product2 p : pList){
                productMap.put(p.ProductCode, p.Id);
            }            
            
            List<CaseProduct__c> insertList = new List<CaseProduct__c>();
            
            for (NewCaseProduct ncp: newCPList)
            {               
                CaseProduct__c cp = new CaseProduct__c();
                cp.Case__c = caseId;
                cp.RecordTypeId = '0121T00000024FGQAY';
                cp.Original_Sale_Price__c = ncp.UnitPrice;
                cp.Quantity__c = decimal.valueOf(ncp.Quantity);
                cp.Sales_Order_Number__c = ncp.SalesNumber;
                cp.Sales_Order_Date__c = date.parse(ncp.SalesDate);
                cp.No_Credit_Memo_Needed__c = noCreditMemo;
                cp.Shipment_Priority__c = 'No Replacement Needed'; 
                if (!String.isblank(ncp.WarehouseError) && (ncp.Reason == 'Warehouse Error')){
                    cp.Warehouse_Error__c = ncp.WarehouseError;    
                }                
                cp.RMA_Outcome__c = 'Credit Only';
                cp.RMA__c = 'Yes';    
                cp.RMA_Type__c = 'Sales';
                cp.RMA_Reason__c = ncp.Reason;
                cp.Item__c = productMap.get(ncp.SKU);
                insertList.add(cp);			            
            }
            
            insert insertList;
            
            // update the case
            Case c = [SELECT Id, RMA_SendviaTrigger__c 
                      FROM Case 
                      WHERE id = :caseId];            
            c.RMA_SendviaTrigger__c = optOutOfEmail == true ? false : sendViaTrigger;       
            c.OptOutofEmail__c = optOutOfEmail;
            c.Description = notes;
            update c;

            system.debug('optOutOfEmail: ' +  optOutOfEmail);
            
            if (optOutOfEmail)
            {
                FeedItem post = new FeedItem();
                post.ParentId = caseId; //eg. Opportunity id, custom object id..
                post.Body = 'Sales RMA Created. Email Notification Opted Out';
                insert post;  
            }            
        } 
        catch(DmlException e) {
            System.debug('ERROR: ' + e.getTypeName() + ' ' + e.getMessage() + ' ' + e.getStackTraceString());
            //return 'ERROR: ' + e.getTypeName() + ' ' + e.getMessage() + ' ' + e.getStackTraceString() + ' ' + 'Paramaters: caseID: ' + caseId;
            return 'ERROR ' + e.getMessage();   
        }        
        
        return 'Success';
    }    
    
    @AuraEnabled
    public static Boolean GetIs3rdPartyProduct (string productSku)
    {
        Boolean x3p = [Select X3P_Product__c from Product2 where recordtypeID = '0121T00000024FLQAY' and productCode = :productSku limit 1].X3P_Product__c;       
        return x3p == true ? true : false; // handles nulls?        
    }
    
    @AuraEnabled  
    public static String GetSalesOrderInformation (string caseID, string salesNumber, string beginDate, string endDate)
    {       
        system.debug('GetSalesOrderInformation ' + caseID + ' ' + salesNumber + ' ' + beginDate + ' ' + endDate);
        
        Case currentCase = [SELECT SAP_ACCOUNT_ID__c FROM Case where Id = :caseID]; // Get the CardCode        
        
        salesNumber = salesNumber == null ? '' : salesNumber; // 0 if not a valid number
		//https://wsqa.snapav.com/test.aspx  // This is how to see the B1WebApi User Interface        
        //string url = 'https://wsqa.snapav.com/Default/query/Salesforce_GetRMAinfo.aspx?CardCode=' + currentCase.SAP_ACCOUNT_ID__c + '&salesNumber=' + salesNumber + '&beginDate=' + beginDate + '&endDate=' + endDate; 
        //string url = 'https://zed.snapav.com:443/Default/query/Salesforce_GetRMAinfo.aspx?CardCode=' + currentCase.SAP_ACCOUNT_ID__c + '&salesNumber=' + salesNumber + '&beginDate=' + beginDate + '&endDate=' + endDate; 
        
        Boolean IsSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;        
        string url = '/Default/query/Salesforce_GetRMAinfo.aspx?CardCode=' + currentCase.SAP_ACCOUNT_ID__c + '&salesNumber=' + salesNumber + '&beginDate=' + beginDate + '&endDate=' + endDate;
        if (IsSandbox)
        {
        	url = 'https://wsqa.snapav.com' + url;       
        }
        else
        {
            url = 'https://zed.snapav.com:443' + url;
        }
            
        system.debug(url);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('content-type','application/json');  
        req.setHeader('Accept','application/json');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('b1webapi:snap4v')));
        
        // Send the request, and return a response		
        Http h = new Http();
        HttpResponse res = h.send(req);        
        
        system.debug('fixJSON0 ' + res.getBody());    
        
        // Format the JSON to deserialize properly
        string fixJSON1 = res.getBody().replace('@id','rowID').replace('@name','columnName').replace('@alias','columnAlias').replace('@type','columnType').replace('@key','columnKey').replace('@objType','columnObjType');       
        string fixJSON2 = fixJSON1.replace('@','');
        
        WP_sRMA_JSONtoApex salesData = NULL;
        boolean isSingleRow = false;
        
        if (fixJSON2.contains('"row":[{"rowID"')) // [ means its a list
        {
           system.debug('JSON is a list'); 
           system.debug(fixJSON2); 
           salesData = WP_sRMA_JSONtoApex.parse(fixJSON2);  
        }
        else // not a list
        {
            system.debug('JSON is single');
            isSingleRow = true;
            string fixJSON3 = fixJSON2.replace('"row":[{"rowID"','"row":{"rowID"').replace('}]}}}','}}}}').replace('"data":{"row":','"data":{"singleRow":');  
            system.debug(fixJSON3);  
            salesData = WP_sRMA_JSONtoApex.parse(fixJSON3);  
        }        
        
        List<DeliveriesWrapper> dwList = new List<DeliveriesWrapper>();
        string previousDelivery = '';        
        
        if (isSingleRow)
        {
           	WP_sRMA_JSONtoApex.Row r = salesData.response.payload.querydata.data.singleRow;
			previousDelivery = r.ODLN_DocNum;
            DeliveriesWrapper wrapper = new DeliveriesWrapper();
            wrapper.KeyField = r.KeyField + 'root';
            wrapper.deliverNumber = r.ODLN_DocNum;
            wrapper.SalesNumber = r.ORDR_DocNum;
            wrapper.SalesDate = r.ORDR_DocDate;
            List<Items> items = new List<Items>();
            Items item = new Items();
            item.KeyField = r.KeyField;
            item.deliverNumber = r.ODLN_DocNum;
            item.DLN1_ItemCode = r.DLN1_ItemCode;
            item.DLN1_Dscription = r.DLN1_Dscription;
            item.RDR1_Quantity = r.RDR1_Quantity;
            item.DLN1_Quantity = r.DLN1_Quantity;
            item.DLN1_Price = r.DLN1_Price;
            item.DLN1_LineTotal = r.DLN1_LineTotal;
            items.add(item);            
            wrapper.items = items;
            dwList.add(wrapper);  
        }
        else
        {
            for (WP_sRMA_JSONtoApex.Row r : salesData.response.payload.querydata.data.row)
            {
                if (r.ODLN_DocNum != previousDelivery)
                {
                    previousDelivery = r.ODLN_DocNum;
                    DeliveriesWrapper wrapper = new DeliveriesWrapper();
                    wrapper.KeyField = r.KeyField + 'root';
                    wrapper.deliverNumber = r.ODLN_DocNum;
                    wrapper.SalesNumber = r.ORDR_DocNum;
                    wrapper.SalesDate = r.ORDR_DocDate;
                    List<Items> items = new List<Items>();
                    for(WP_sRMA_JSONtoApex.Row r2 : salesData.response.payload.querydata.data.row)
                    {
                        if (r2.ODLN_DocNum == r.ODLN_DocNum)
                        {
                            Items item = new Items();
                            item.KeyField = r2.KeyField;
                            item.deliverNumber = r2.ODLN_DocNum;
                            item.DLN1_ItemCode = r2.DLN1_ItemCode;
                            item.DLN1_Dscription = r2.DLN1_Dscription;
                            item.RDR1_Quantity = r2.RDR1_Quantity;
                            item.DLN1_Quantity = r2.DLN1_Quantity;
                            item.DLN1_Price = r2.DLN1_Price;
                            item.DLN1_LineTotal = r2.DLN1_LineTotal;
                            items.add(item);
                        }
                    }
                    
                    wrapper.items = items;
                    dwList.add(wrapper);
                }   
            }
        }
        
        return JSON.serializePretty(dwList);   
    }
    
    public Class DeliveriesWrapper{
        @AuraEnabled
        public String KeyField {get;set;}
        @AuraEnabled
        public String deliverNumber {get;set;}
        @AuraEnabled
        public String SalesNumber {get;set;}
        @AuraEnabled
        public String SalesDate {get;set;}
        @AuraEnabled
        public String ODLN_DocDate {get;set;}
        @AuraEnabled
        public List<Items> items {get;set;}
    }
    
    public Class Items{
        @AuraEnabled
        public String KeyField {get;set;}
        @AuraEnabled
        public String deliverNumber {get;set;}
        @AuraEnabled
        public String SalesNumber {get;set;}        
        @AuraEnabled
        public String ODLN_DocNum {get;set;}
        @AuraEnabled
        public String ORDR_DocNum {get;set;}
        @AuraEnabled
        public String DLN1_ItemCode {get;set;}
        @AuraEnabled
        public String DLN1_Dscription {get;set;}
        @AuraEnabled
        public String RDR1_Quantity {get;set;}
        @AuraEnabled
        public String DLN1_Quantity {get;set;}
        @AuraEnabled
        public String DLN1_Price {get;set;}
        @AuraEnabled
        public String DLN1_LineTotal {get;set;}
    }
    
    public class NewCaseProduct {
        public String sobjectType;
        public String SKU;
        public String Quantity;
        public String SalesNumber;
        public String SalesDate;
        public decimal UnitPrice;
        public String Reason;
        public String WarehouseError;     
        public String Original_Sale_Price;
    }    
}