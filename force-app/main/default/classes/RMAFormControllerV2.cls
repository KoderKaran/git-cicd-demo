public without sharing Class RMAFormControllerV2 {
    public Id caseId {get;set{caseId = value;}} /** get set the variable for case Id take value from visual component.**/
    public Case caseData {get;set;}
    public Boolean hasAMP108VerifiedScrap = false;
    public List<string> exceptionProductNamesList = new List<string>();  
    public string exceptionDetails = '';
    public string errorStyle = '0';
    public Integer debugCounter = 0;
    public Organization org = [SELECT Id, IsSandbox  FROM Organization];
    
    public RMAFormControllerV2() {
        if(!Test.isRunningTest()) // Cannot get the caseId from the URL while running the test class.
        {
            caseId = ApexPages.currentPage().getParameters().get('caseId');
            errorStyle = ApexPages.currentPage().getParameters().get('errorStyle');
        }
    }
    
    public List<RMAFormData> GetRMAFormDataList() 
    {
        List<RMAFormData> rmaFormDataList = new List<RMAFormData>();
        
        try
        {            
            caseData = GetCaseData(); // GET CASE DATA       
            
            List<CaseProduct__c> CaseProductList = GetCaseProductData(); // GET CaseProduct__c DATA
            Map<String, List<CaseProduct__c>> caseprodMap = CreateProductList(CaseProductList); // Loop through CaseProduct__c records and separte them into lists for each PDF page
            
            for(string rmaLocation : caseprodMap.keySet()) // Each "rmaLocation" corresponds to a different PDF page
            {
                debugCounter = ++debugCounter;
                RMAFormData fd = new rmaFormData(); // There is a RMAFormData object for every page in the PDF
                
                if (casedata.Alternate_Ship_Address__c) {fd.CustomerAltShippingAddress = casedata.Alternate_Ship_To_Address__c;}
                
                else
                {
                    fd.AccountShippingStreet = casedata.Account.ShippingStreet;
                    fd.AccountShippingCity = casedata.Account.ShippingCity;
                    fd.AccountShippingState = casedata.Account.ShippingState;
                    fd.AccountShippingPostalCode = casedata.Account.ShippingPostalCode;
                }
                   // Get mapping values
                if (exceptionProductNamesList.contains(rmaLocation))
                {
                    PopulateRMAFormDataExceptions(fd, caseprodMap, rmaLocation);
                }
                else if (rmaLocation == 'SCRAP' || rmaLocation == 'REPAIRINFIELD')
                {
                    CustomPopulateRMAFormData('1', fd, caseprodMap, rmaLocation);  // 1 is the code "Form Verbiage (Scrap:RepairInField)" 
                }
                else if (rmaLocation == 'VERIFIEDSCRAP') // this is an edge case only for the AMP108 product
                {
                    CustomPopulateRMAFormData('6', fd, caseprodMap, rmaLocation); // 6 is the code "Form Verbiage (Scrap:VerifiedScrap)" 
                }
                else 
                {
                    PopulateRMAFormData(fd, caseprodMap, rmaLocation);                    
 				}                
                
                if (org.IsSandbox == true)
                {
                    fd.DebuggingMessage = '|||| DEBUGGING INFORMATION ||||' +
                        '<br />Loop Count: ' + debugCounter + 
                        '<br />caseprodMap.keySet(): ' + caseprodMap.keySet() + 
                        '<br />Case.Account.Dealer_Type2__c: ' + caseData.Account.Dealer_Type2__c + 
                        '<br />Case.Account.SAP_Instance__c: ' + caseData.Account.SAP_Instance__c + 
                        '<br />CaseProduct__c.Item__r.RMA_Location__c: ' + exceptionDetails + 
                        '<br />Case.Account.BillingCountry: ' + caseData.Account.BillingCountry;
                }            
                
                rmaFormDataList.Add(fd);
            }
            
            return rmaFormDataList;
        }
        catch (Exception e)
        {
            if (errorStyle == '0') // if errorStyle is 0 don't return an exception. I want to throw an exception if this form is being attached to an email.
            {
                RMAFormData fd = new rmaFormData();
                fd.DebuggingMessage = '<br />RMA_FORM_EXCEPTION' +
                    '<br /><br />' + exceptionDetails +  
                    '<br /><br />Exception Message: ' + e.getMessage() +
                    '<br />Exception Type' + e.getTypeName() +                             
                    '<br />Exception Stack Trace' + e.getStackTraceString() + '<br /><br />';            
                rmaFormDataList.Add(fd);
                return rmaFormDataList;
            }
            
            throw e;        
        }       
    }                
    
    private Map<String, List<CaseProduct__c>> CreateProductList(List<CaseProduct__c> caseProductList)
    {
        Map<String, List<CaseProduct__c>> caseprodMap = new Map<String, List<CaseProduct__c>>(); // temporary map so that we can gather lists of CaseProducts
        ProcessAMP108EdgeCase(caseProductList); // This populates hasAMP108VerifiedScrap variable for an extreme edge case for the AMP108 product only
        PopulateExceptionProductNamesList(); // Populate exceptionProductNamesList with list of ExeptionProducts       
        
        for(CaseProduct__c caseProduct : caseProductList)
        { 
            if(caseProduct.Item__r != null)
            {
                if (exceptionProductNamesList.contains(caseProduct.Item__r.ProductCode)) // Check for product exceptions
                {
                    System.Debug('Exceptions: caseProduct.Item__r.ProductCode: '+ caseProduct.Item__r.ProductCode); 
                    ProcessCaseProductItem(caseProduct.Item__r.ProductCode, caseProduct, caseprodMap);        
                }
                else
                {
                    caseProduct.Item__r.RMA_Location__c = caseProduct.Item__r.RMA_Location__c == null ? 'Default' : caseProduct.Item__r.RMA_Location__c;             
                    
                    // THIS IS WHERE ALL THE HARDCODED BUSINESS LOGIC IS APPLIED. IN THE FUTURE IT MIGHT BE WISE TO PULL SOME OF THIS LOGIC INTO THE TABLES
                    string rmaLocation = ApplyBusinessLogicProcessing(caseProduct, caseprodMap); // caseprodMap is 'Passed by Reference'    
                    
                    switch on rmaLocation {
                        when 'Default' { // WHERE LOGIC WAS DEFAULT	
                            ProcessCaseProductItem(caseProduct.Item__r.RMA_Location__c.toUpperCase(), caseProduct, caseprodMap);
                        }	  
                        when else {	// WHERE LOGIC WAS CUSTOM
                            ProcessCaseProductItem(rmaLocation, caseProduct, caseprodMap);
                        }
                    }  
                }
            }
        }
        
        return caseprodMap;
    }
    
    private string ApplyBusinessLogicProcessing(CaseProduct__c caseProduct, Map<String, List<CaseProduct__c>> caseprodMap)
    {
        // THIS IS WHERE ALL THE BUSINESS LOGIC APPLIED 'SCRAP', 'PDX', 'UKTRIADDISTRIBUTORS', 'REPAIRINFIELD'  
        string rmaLocation = 'Default';
        
        // Triad products in the UK used to be scrapped. This was used in production for a year. It was removed per John Grants request in December 2020.
        //if(caseData.Account.SAP_Instance__c == 'SAP_UK' && !caseData.Account.Account_Group__c.contains('Distributor') &&  caseProduct.Item__r.RMA_Location__c.toUpperCase() == 'PDX' && caseProduct.RMA_Outcome__c.contains('Advance Replacement'))
        //{
        //    system.debug('DebugArea1');
        //    return 'SCRAP';
        //}     
        
        if(caseData.Account.SAP_Instance__c == 'SAP_UK' &&  caseData.Account.Account_Group__c.contains('Distributor') &&  caseProduct.Item__r.RMA_Location__c.toUpperCase() == 'PDX' && (caseProduct.RMA_Outcome__c == 'Repair - In Warranty' || caseProduct.RMA_Outcome__c == 'Repair - Out of Warranty'))return 'REPAIRINFIELD';      
        
        if((caseData.Account.SAP_Instance__c == 'SAP_UK' &&  caseData.Account.Account_Group__c.contains('Distributor') &&  caseProduct.Item__r.RMA_Location__c.toUpperCase() == 'PDX' )) return 'UKTRIADDISTRIBUTORS'; 
                  
        
        if(caseProduct.Scrap__c && caseProduct.RMA__c == 'Yes' && caseProduct.RMA_Type__c != 'Sales' && (caseProduct.Item_Code__c != 'C4-AMP108' && caseProduct.Item_Code__c != 'C4-AMP108-BX' && caseProduct.Item_Code__c != 'B-C4-AMP108'))
        {
            system.debug('DebugArea4');
            return 'SCRAP';
        }         
        
        if(caseProduct.RMA__c == 'Yes' && caseProduct.RMA_Type__c != 'Sales' && !caseProduct.Scrap__c)
        {                         
            if((caseProduct.Item_Code__c == 'C4-AMP108' || caseProduct.Item_Code__c == 'C4-AMP108-BX' || caseProduct.Item_Code__c == 'B-C4-AMP108')&& hasAMP108VerifiedScrap && caseProduct.RMA_Outcome__c != 'Repair - Out of Warranty' && caseProduct.RMA_Outcome__c != 'Repair - Out of Warranty (PO Required)'){return 'VERIFIEDSCRAP';}
        } 
        
        system.debug('ApplyBusinessLogicProcessing: 6!' + rmaLocation);
        
        return rmaLocation;
    }
    
    private void ProcessCaseProductItem(string rmaLocation, CaseProduct__c caseProduct, Map<String, List<CaseProduct__c>> caseprodMap)
    {
        if(caseprodMap.containsKey(rmaLocation)){List<CaseProduct__c> caseProdList = caseprodMap.get(rmaLocation);caseProdList.add(caseProduct);caseprodMap.put(rmaLocation, caseProdList);} 
        else
        {
            caseprodMap.put(rmaLocation, new List<CaseProduct__c>{caseProduct});
        }        
    }   
    
    private void PopulateRMAFormData(RMAFormData fd, Map<String, List<CaseProduct__c>> caseprodMap, string rmaLocation)
    {                 
        fd.shippingName = GetContentRecord(GetShippingRule('Return Name', rmaLocation).RMA_Communication_Content__c);                        
        fd.shippingAddress = GetContentRecord(GetShippingRule('Return Address', rmaLocation).RMA_Communication_Content__c); 
       // fd.formVerbiage =  GetFormVerbiage(GetFormVerbiageRule('Form Verbiage', rmaLocation).RMA_Communication_Content__c);  
        fd.RMALocation = rmaLocation;
        fd.CaseProductList = caseprodMap.get(rmaLocation);   
    }

    private void CustomPopulateRMAFormData(string contentCode, RMAFormData fd, Map<String, List<CaseProduct__c>> caseprodMap, string rmaLocation)
    {                 
        fd.formVerbiage = GetFormVerbiage(GetContentByContentCode(contentCode).Id); fd.RMALocation = rmaLocation;fd.CaseProductList = caseprodMap.get(rmaLocation);   
    }
    
    
    private void PopulateRMAFormDataExceptions(RMAFormData fd, Map<String, List<CaseProduct__c>> caseprodMap, string rmaLocation)
    {
        RMA_Communication_Exception__c exceptionProduct = GetExceptionProduct(rmaLocation);    
        
        string caseProduct = caseprodMap.get(rmaLocation)[0].Item__r.RMA_Location__c.toUpperCase();       
        caseProduct = caseProduct == null ? 'DEFAULT' : caseProduct;
               
        fd.shippingName = GetContentRecord(GetShippingRule('Return Name', caseProduct).RMA_Communication_Content__c);   
        fd.shippingAddress = GetContentRecord(GetShippingRule('Return Address', caseProduct).RMA_Communication_Content__c); 
        fd.formVerbiage = GetFormVerbiage(exceptionProduct.RMA_Communication_Content__c);                   
        fd.RMALocation = rmaLocation;
        fd.CaseProductList = caseprodMap.get(rmaLocation);    
    }
    
   
   private RMA_Communication_Content__c GetFormVerbiage(Id contentId)
    {
        RMA_Communication_Content__c content = GetContentRecord(contentId);
        
        // Apply  			
        if (content.Content__c.Contains('{{{VerifiedScrapEmailAddressBySAPInstance}}}'))
        {
            switch on caseData.Account.SAP_Instance__c
            {
                when 'SAP_US' {
                    system.debug('SAP_US');
                    content.Content__c = content.Content__c.replace('{{{VerifiedScrapEmailAddressBySAPInstance}}}', 'verifiedscrap-us@control4.com');
                }	
                when 'SAP_UK' {
                    system.debug('SAP_UK');
                    content.Content__c = content.Content__c.replace('{{{VerifiedScrapEmailAddressBySAPInstance}}}', 'verifiedscrap-uk@control4.com');
                }
                when 'SAP_NC' {
                    system.debug('SAP_NC');
                    content.Content__c = content.Content__c.replace('{{{VerifiedScrapEmailAddressBySAPInstance}}}', 'verifiedscrap-aus@control4.com');
                }
            }              
        }
        
        return content;           
    }  
    
    private void ProcessAMP108EdgeCase(List<CaseProduct__c> caseProductList)
    {
        Integer intCounter = 0;
        
        for(CaseProduct__c caseProduct : caseProductList){ 
            if ((caseProduct.Item_Code__c == 'C4-AMP108' || caseProduct.Item_Code__c == 'C4-AMP108-BX' || caseProduct.Item_Code__c == 'B-C4-AMP108') && (caseProduct.RMA_Outcome__c != 'Repair - Out of Warranty' && caseProduct.RMA_Outcome__c != 'Repair - Out of Warranty (PO Required)') ){intCounter++; }}
        
        // this is a special use case. They want verifiedscrip if the only have one AMP108 product. If there are 2 or more they want it to act like a regular RMA.  
        if (intCounter == 1){hasAMP108VerifiedScrap = true; }       
    }
    
    
    private RMA_Communication_Exception__c GetExceptionProduct(string rmaLocation)
    {    
        RMA_Communication_Exception__c result;
        
        try
        {       
            result = [Select Id, RMA_Communication_Content__c 
                      from RMA_Communication_Exception__c 
                      where Product__r.ProductCode = :rmaLocation];       
        }
        catch (Exception e)
        {
            exceptionDetails = exceptionDetails + e.getMessage() + e.getStackTraceString() + 'VALUE Product__r.ProductCode:   ' + rmaLocation;
        }
        
        return result;      
    }
    
   
    private  RMA_Communication_Content__c GetContentRecord(Id contentId)
    {
        RMA_Communication_Content__c result;
        
        try
        {       
            result = [SELECT Id, Content__c FROM RMA_Communication_Content__c where Id = :contentId];
            result.Content__c = result.Content__c.replace('<p','<div').replace('</p','</div'); // this is a workaround becaue RichTextFields save line breaks as '<p><br></p>' which result in double spacing
        }
        catch (Exception e)
        {
            exceptionDetails = exceptionDetails + e.getMessage() + e.getStackTraceString();
        }
        
        return result;       
    } 
    
  
    private RMA_Communication_Rules__c GetShippingRule(string contentType, string rmaLocation)
    {   
        RMA_Communication_Rules__c result;
        
        try
        {       
            result = [select Id, RMA_Communication_Content__c 
                      from RMA_Communication_Rules__c 
                      where recordtype.name = :contentType
                      and DealerType__c = :caseData.Account.Dealer_Type2__c 
                      and RMA_Location__c INCLUDES (:rmaLocation)
                      and SAP_Instance__c INCLUDES (:caseData.Account.SAP_Instance__c)
                      and Billing_Country__c INCLUDES (:caseData.Account.BillingCountry)];          
        }
        catch (Exception e)
        {
            exceptionDetails = exceptionDetails + e.getMessage() + e.getStackTraceString() +
                '<br />**VALUES**' +
                '<br />recordtype.name: ' + contentType +
                '<br />RMA_Location__c: ' + rmaLocation +
                '<br />caseData.Account.SAP_Instance__c: ' + caseData.Account.SAP_Instance__c +
                '<br />caseData.Account.BillingCountry: ' + caseData.Account.BillingCountry;
        }
        return result;              
    }
 
    
 
 /* private RMA_Communication_Rules__c GetFormVerbiageRule(string contentType, string rmaLocation)
    {      
        RMA_Communication_Rules__c result;
        
        try
        {       
            result = [select Id, RMA_Communication_Content__c 
                      from RMA_Communication_Rules__c 
                      where recordtype.name = :contentType
                      and DealerType__c = :caseData.Account.Dealer_Type2__c 
                      and RMA_Location__c INCLUDES (:rmaLocation)
                      and SAP_Instance__c INCLUDES (:caseData.Account.SAP_Instance__c)
                      and Billing_Country__c INCLUDES (:caseData.Account.BillingCountry)];        
        }
        catch (Exception e)
        {
            exceptionDetails = exceptionDetails + e.getMessage() + e.getStackTraceString() +
                '<br />**VALUES**' +
                '<br />recordtype.name: ' + contentType +
                '<br />Case.Account.Dealer_Type2__c: ' + caseData.Account.Dealer_Type2__c + 
                '<br />RMA_Location__c: ' + rmaLocation +
                '<br />caseData.Account.SAP_Instance__c: ' + caseData.Account.SAP_Instance__c +
                '<br />caseData.Account.BillingCountry: ' + caseData.Account.BillingCountry;
        }
        return result;        
    }*/
    
    private RMA_Communication_Content__c GetContentByContentCode(string contentCode)
    {      
        RMA_Communication_Content__c result;
        
        try
        {       
            result = [select Id, Content__c 
                      from RMA_Communication_Content__c 
                      where ContentCode__c = :contentCode];        
        }
        catch (Exception e)
        {
            exceptionDetails = exceptionDetails + e.getMessage() + e.getStackTraceString() + 'VALUES ContentCode__c: ' + contentCode;
        }
        return result;        
    }
    
    private void PopulateExceptionProductNamesList()
    {
        List<RMA_Communication_Exception__c> exceptionProductList = [Select Id, Product__r.ProductCode 
                                                                     from RMA_Communication_Exception__c 
                                                                     where IsActive__c = true];   
        
        for(RMA_Communication_Exception__c exceptionProduct : exceptionProductList)
        {
            exceptionProductNamesList.Add(exceptionProduct.Product__r.ProductCode);
        }    
    }
    
    private List<CaseProduct__c> GetCaseProductData()
    {
        return  [SELECT Id
                 , RMA__c
                 , New_Email_RMA_Sent__c
                 , MacID__c
                 , Item__r.ProductCode
                 , Item__r.Name
                 , Item__r.RMA_Location__c
                 , Outbound_product__r.Name
                 , Outbound_product__r.ProductCode
                 , Quantity__c, Symptom__c
                 , Symptom_Type__c
                 , Shipment_Priority__c
                 , RMA_Type__c
                 , RMA_Outcome__c
                 , Scrap__c
                 , RMA_Reason__c
                 , Item_Code__c  
                 FROM CaseProduct__c 
                 WHERE Case__c =:caseId
                 	and RMA__c = 'Yes'];   
    }    
    
    private Case GetCaseData()
    {
        return [Select Id
         		, Account.Name
                , Account.SAP_ACCOUNT_ID__c
                , Account.Dealer_Type2__c
                , Account.SAP_Instance__c
                , Account.BillingCountry
                , Account.Account_Group__c
                , Account.ShippingStreet
                , Account.ShippingCity
				, Account.ShippingState
				, Account.ShippingPostalCode 
                , CaseNumber
                , Subject                               
                , Origin
                , MyControl4_Name__c
                , SuppliedName
                , Contact.Name                               
                , SuppliedEmail
                , Contact.Email
                , SuppliedPhone
                , Contact.Phone
                , Owner.FirstName
                , Owner.LastName
                , Alternate_Ship_Address__c
                , Alternate_Ship_To_Address__c
                , Special_RMA_Instructions__c
                , LastModifiedDate
                , (SELECT Id,RMA__c, New_Email_RMA_Sent__c, MacID__c, Item__r.Name,Item__r.ProductCode,  Item__r.RMA_Location__c, Outbound_product__r.Name,  Outbound_product__r.ProductCode,  Quantity__c, Symptom__c, Symptom_Type__c, Shipment_Priority__c, RMA_Type__c, RMA_Outcome__c, Scrap__c FROM CaseProduct__r WHERE RMA__c = 'Yes')
                From Case 
                where Id =:caseId]; 
    }
    
    public class RMAFormData 
    {        
        public RMA_Communication_Content__c shippingName;  
        public RMA_Communication_Content__c shippingAddress;        
        public RMA_Communication_Content__c formVerbiage;       
        public List<CaseProduct__c> CaseProductList = new  List<CaseProduct__c>();
        public string AccountShippingStreet = '';
        public string AccountShippingCity = '';
        public string AccountShippingState = '';
        public string AccountShippingPostalCode = '';  
        public string CustomerAltShippingAddress = '';
        public string RMALocation = ''; 
        public string DebuggingMessage = '';
        
        // Getters
        public RMA_Communication_Content__c getShippingName(){return shippingName;} 
        public RMA_Communication_Content__c getShippingAddress(){return shippingAddress;}                
        public RMA_Communication_Content__c getFormVerbiage(){return formVerbiage;} 
        public List<CaseProduct__c> getCaseProductList(){return CaseProductList;}        
        public string getAccountShippingStreet() {return AccountShippingStreet;} 
        public string getAccountShippingCity() {return AccountShippingCity;} 
        public string getAccountShippingState() {return AccountShippingState;} 
        public string getAccountShippingPostalCode() {return AccountShippingPostalCode;}    
        public string getCustomerAltShippingAddress(){return CustomerAltShippingAddress;} 
        public string getRMALocation(){return RMALocation;} 
        public string getDebuggingMessage() {return DebuggingMessage;}         
    }
}