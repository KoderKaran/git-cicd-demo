@isTest
Public class EmailTemplateControllerTest {

     
    static testMethod void EmailTemplate_methodOne ()
    {
        //Creating the account for testing
        account a1 = new account(name = 'test'); 
        a1.SAP_Instance__c = 'US';
        a1.Account_Group__c = '02 Retail';
        a1.SAP_ACCOUNT_ID__c = '0001';
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        List<Case> caseList = new List<Case>();
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        caseList.add(cs);
        Case cs1 = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                   
        caseList.add(cs1);                   
        Insert caseList;
        
        List<Product2> pdList = new List<Product2>();
        //Creating a product for the RMA
        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'CM FG1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default');
        pdList.add(pd);
        //Creating a product for the RMA
        Product2 pd2 = New Product2(Name = '00041 Testing Item', ProductCode = 'CM FG2', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default');
        pdList.add(pd2);
        
        Insert pdList;
        
        List<CaseProduct__c> cpList = new List<CaseProduct__c>();
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp1 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        cpList.add(cp1);
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp2 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd2.Id, Time_Delayed_Task__c = True);
        cpList.add(cp2);
        
        Insert cpList;
        
        EmailTemplateController ctrl = new EmailTemplateController();
        ctrl.caseId = cs.Id;
        ctrl.getCaseProducts();
        
    }
    
    static testMethod void EmailTemplate_methodTwo ()
    {
        //Creating the account for testing
        account a1 = new account(name = 'test'); 
        a1.SAP_Instance__c = 'US';
        a1.Account_Group__c = '02 Retail';
        a1.SAP_ACCOUNT_ID__c = '0001';
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        List<Case> caseList = new List<Case>();
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        caseList.add(cs);
        Case cs1 = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                   
        caseList.add(cs1);                   
        Insert caseList;
        
        List<Product2> pdList = new List<Product2>();
        //Creating a product for the RMA
        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'CM FG1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'PDX');
        pdList.add(pd);
        //Creating a product for the RMA
        Product2 pd2 = New Product2(Name = '00041 Testing Item', ProductCode = 'CM FG2', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'PDX');
        pdList.add(pd2);
        
        Insert pdList;
        
        List<CaseProduct__c> cpList = new List<CaseProduct__c>();
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp1 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        cpList.add(cp1);
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp2 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd2.Id, Time_Delayed_Task__c = True);
        cpList.add(cp2);
        
        Insert cpList;
        
        EmailTemplateController ctrl = new EmailTemplateController();
        ctrl.caseId = cs.Id;
        ctrl.getCaseProducts();
        
        
    }
    
    static testMethod void EmailTemplate_methodThree ()
    {
        //Creating the account for testing
        account a1 = new account(name = 'test'); 
        a1.SAP_Instance__c = 'US';
        a1.Account_Group__c = '02 Retail';
        a1.SAP_ACCOUNT_ID__c = '0001';
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        List<Case> caseList = new List<Case>();
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        caseList.add(cs);
        Case cs1 = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                   
        caseList.add(cs1);                   
        Insert caseList;
        
        List<Product2> pdList = new List<Product2>();
        //Creating a product for the RMA
        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'CM FG1', Description = 'Testing item', IsActive = True, Scrap__c = True, RMA_Location__c = 'Default');
        pdList.add(pd);
        //Creating a product for the RMA
        Product2 pd2 = New Product2(Name = '00041 Testing Item', ProductCode = 'CM FG2', Description = 'Testing item', IsActive = True, Scrap__c = True, RMA_Location__c = 'Default');
        pdList.add(pd2);
        
        Insert pdList;
        
        List<CaseProduct__c> cpList = new List<CaseProduct__c>();
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp1 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        cpList.add(cp1);
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp2 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd2.Id, Time_Delayed_Task__c = True);
        cpList.add(cp2);
        
        Insert cpList;
        
        EmailTemplateController ctrl = new EmailTemplateController();
        ctrl.caseId = cs.Id;
        ctrl.getCaseProducts();
        
        
    }
    
    static testMethod void EmailTemplate_methodFour ()
    {
        //Creating the account for testing
        account a1 = new account(name = 'test'); 
        a1.SAP_Instance__c = 'US';
        a1.Account_Group__c = '02 Retail';
        a1.SAP_ACCOUNT_ID__c = '0001';
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        List<Case> caseList = new List<Case>();
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        caseList.add(cs);
        Case cs1 = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                   
        caseList.add(cs1);                   
        Insert caseList;
        
        List<Product2> pdList = new List<Product2>();
        //Creating a product for the RMA
        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'TESTFG1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'York');
        pdList.add(pd);
        //Creating a product for the RMA
        Product2 pd2 = New Product2(Name = '00041 Testing Item', ProductCode = 'TESTFG2', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'SLC');
        pdList.add(pd2);
        
        Insert pdList;
        
        List<CaseProduct__c> cpList = new List<CaseProduct__c>();
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp1 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        cpList.add(cp1);
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp2 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd2.Id, Time_Delayed_Task__c = True);
        cpList.add(cp2);
        
        Insert cpList;
        
        EmailTemplateController ctrl = new EmailTemplateController();
        ctrl.caseId = cs.Id;
        ctrl.getCaseProducts();
        
        
    }
      
    
    static testMethod void EmailTemplate_UKDistributors ()
    {
        //Creating the account for testing
        account AcctUK = new account(name = 'testUKDistributors');  
        AcctUK.SAP_Instance__c = 'UK';       
        AcctUK.Account_Group__c = 'Distributor';
        AcctUK.SAP_ACCOUNT_ID__c = '0001';
        Insert AcctUK;
        
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = AcctUK.Id);
        Insert con;

        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(AccountId = AcctUK.Id, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                 
        Insert cs;

        //Creating a product for the RMA
        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'TESTFG1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'PDX');
        
        Insert pd;
        
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power', 
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        
        Insert cp;    
        
        EmailTemplateController ctrl = new EmailTemplateController();
        ctrl.caseId = cs.Id;
        //ctrl.getCaseProducts();       
    }
    
    static testMethod void EmailTemplate_UKNonDistributorsAdvanceReplacement ()
    {
        //Creating the account for testing
        account AcctUK = new account(name = 'testUKnonDistributors');  
        AcctUK.SAP_Instance__c = 'UK';       
        AcctUK.Account_Group__c = 'Dealer';
        AcctUK.SAP_ACCOUNT_ID__c = '0001';
        Insert AcctUK;
        
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = AcctUK.Id);
        Insert con;

        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(AccountId = AcctUK.Id, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                 
        Insert cs;
        
        //Creating a product for the RMA
        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'TESTFG1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'PDX');
        
        Insert pd;
        
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power', 
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Advance Replacement',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        
        Insert cp;
 
        
        EmailTemplateController ctrl = new EmailTemplateController();
        ctrl.caseId = cs.Id;
        //ctrl.getCaseProducts();       
    }   

    static testMethod void EmailTemplate_UKDistributorsNotRepairWarranty ()
    {
        //Creating the account for testing
        account AcctUK = new account(name = 'testUKnonDistributors');  
        AcctUK.SAP_Instance__c = 'UK';       
        AcctUK.Account_Group__c = 'Distributor';
        AcctUK.SAP_ACCOUNT_ID__c = '0001';
        Insert AcctUK;
        
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = AcctUK.Id);
        Insert con;

        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(AccountId = AcctUK.Id, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                 
        Insert cs;
        
        //Creating a product for the RMA
        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'TESTFG1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'PDX');
        
        Insert pd;
        
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power', 
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Advance Replacement',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        
        Insert cp;
 
        
        EmailTemplateController ctrl = new EmailTemplateController();
        ctrl.caseId = cs.Id;
        //ctrl.getCaseProducts();       
    }   
}