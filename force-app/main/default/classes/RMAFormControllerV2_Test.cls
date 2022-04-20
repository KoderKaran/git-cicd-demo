@isTest(SeeAllData=true)
Public class RMAFormControllerV2_Test {
     
    static testMethod void GetRMAFormDataList_DefaultTest()
    {
        
        //Creating the account for testing
        account acc = new account(name = 'test', SAP_Instance__c = 'SAP_US', Account_Group__c = '02 Retail', SAP_ACCOUNT_ID__c = '0001', BillingCountry = 'US'); 
        Insert acc;

        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = acc.Id);
        Insert con;

        Case cs = new Case(AccountId = acc.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        Insert cs;

        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'CM FG1', Description = 'Testing item', IsActive = True, Scrap__c = true, RMA_Location__c = 'Default');
        Insert pd;        

        CaseProduct__c cp = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        Insert cp;
        
                
        RMA_Communication_Content__c rcc = new  RMA_Communication_Content__c (Name ='Test');
        insert rcc;
            
        RMA_Communication_Exception__c rce = new RMA_Communication_Exception__c(Name = 'Test',RMA_Communication_Content__c = rcc.id,Product__c=pd.id,IsActive__c = true );
        insert rce;
        
       
        
        RMAFormControllerV2 ctrl = new RMAFormControllerV2();
        ctrl.caseId = cs.Id;
        ctrl.errorStyle = '0';  
        ctrl.exceptionDetails ='none';
        
  
        List<RMAFormControllerV2.RMAFormData> rmaList = ctrl.GetRMAFormDataList();
        
        // Cover all of the getters
        RMAFormControllerV2.RMAFormData rmaFormData = rmaList[0];
        string rmaLocation = rmaFormData.getRMALocation();
        RMA_Communication_Content__c shippingName = rmaFormData.getShippingName();
        RMA_Communication_Content__c shippingAddress = rmaFormData.getShippingAddress();                
        RMA_Communication_Content__c formVerbiage = rmaFormData.getFormVerbiage();
 		List<CaseProduct__c> caseProductList = rmaFormData.getCaseProductList();
        
        Map<String, List<CaseProduct__c>> caseprodMap = new Map<String, List<CaseProduct__c>>();
        caseprodMap.put(rmaLocation,caseProductList);
        string debuggingMessage = rmaFormData.getDebuggingMessage();  
        string shippingStreet = rmaFormData.getAccountShippingStreet();
        string shippingCity = rmaFormData.getAccountShippingCity();
        string shippingState = rmaFormData.getAccountShippingState();
        string shippingPostalCode = rmaFormData.getAccountShippingPostalCode();
        string shippingAltAddress = rmaFormData.getCustomerAltShippingAddress();
        
        
        
        
        
        
       // RMA_Communication_Exception__c rmaList2 = ctrl.GetExceptionProduct(rmaLocation);
       // RMA_Communication_Content__c rmaList3 = ctrl.GetContentRecord('00N38000003v1LM');
        //RMA_Communication_Rules__c rmaList4 = ctrl.GetFormVerbiageRule(rmaLocation,rmaLocation); 
        //ctrl.PopulateRMAFormDataExceptions(rmaFormData,caseprodMap,rmaLocation);
    }
    
    static testMethod void GetRMAFormDataList_ExceptionTest()
    {
        //Creating the account for testing
        account acc = new account(name = 'GetRMAFormDataList_ExceptionTest', SAP_Instance__c = 'SAP_UK', Account_Group__c = '02 Retail', SAP_ACCOUNT_ID__c = '0001', BillingCountry = 'US'); 
        Insert acc;
        
        Organization org = [SELECT Id, IsSandbox  FROM Organization];

        //Account acc = [Select Id from account where Id = '0015000000JN3NH']; // this don't work. Use an actual account. caseData.Account.SAP_Instance__c  + caseData.Account.BillingCountry
        
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = acc.Id);
        Insert con;

        Case cs = new Case(AccountId = acc.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for GetRMAFormDataList_ExceptionTest', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        Insert cs;

        Product2 pd = New Product2(Name = 'Control4 System Remote Control SR260', ProductCode = 'C4-SR260', Description = 'Control4 System Remote Control SR260', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default');
        insert pd;
        //Product2 pd = [Select Id from Product2 where productCode = 'C4-SR260' and recordtypeid = '']; // Hopefully in the future the master record type won't be blank     
        CaseProduct__c cp = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        Insert cp;
        
        RMAFormControllerV2 ctrl = new RMAFormControllerV2();
        ctrl.caseId = cs.Id;        
        ctrl.errorStyle = '0';
        ctrl.org = org;
        List<RMAFormControllerV2.RMAFormData> rmaList = ctrl.GetRMAFormDataList();  
    }   
  
    static testMethod void GetRMAFormDataList_ScrapTest()
    {
        //Creating the account for testing
        account acc = new account(name = 'test', SAP_Instance__c = 'SAP_US', Account_Group__c = '02 Retail', SAP_ACCOUNT_ID__c = '0001', BillingCountry = 'US'); 
        Insert acc;

        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = acc.Id);
        Insert con;

        Case cs = new Case(AccountId = acc.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        Insert cs;

        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'CM FG1', Description = 'Testing item', IsActive = True, Scrap__c = true, RMA_Location__c = 'PDX');
        Insert pd;      

        CaseProduct__c cp = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        Insert cp;
        
        RMAFormControllerV2 ctrl = new RMAFormControllerV2();
        ctrl.caseId = cs.Id;        
        ctrl.errorStyle = '0';
        List<RMAFormControllerV2.RMAFormData> rmaList = ctrl.GetRMAFormDataList();   
    }
    
   

}