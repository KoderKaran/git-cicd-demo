@isTest
public class RMA_Type_Test {
    
    public static testMethod void RMATypeMethod() {
        
        //Creating the account for testing
        List<Account> AccList = new List<Account>();
        account a1 = new account(name = 'testProd'); 
        a1.SAP_Instance__c = 'SAP_US';
        a1.Account_Group__c = '02 Retail';
        a1.SAP_ACCOUNT_ID__c = '0001';
        a1.ShippingCountry = 'US';
        AccList.add(a1);
        account a2 = new account(name = 'test1Prod'); 
        a2.SAP_Instance__c = 'SAP_UK';
        a2.Account_Group__c = '03 Retail';
        a2.SAP_ACCOUNT_ID__c = '0002';
        a2.ShippingCountry = 'AU';
        AccList.add(a2);
      
        insert AccList;
        
        //Creating the Contact w/email
        List<Contact> conList = new List<Contact>();
        contact con = new contact(lastname ='testingProd', firstname = 'testcontactProd',email='testingitProd@gmail.com', accountid = a1.Id);
        conList.add(con);
        contact con1 = new contact(lastname ='testing1Prod', firstname = 'testcontact1Prod',email='testingit1Prod@gmail.com', accountid = a2.Id);
        conList.add(con1);
               
        insert conList;
        List<Case> caseList = new List<Case>();
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(AccountId = a1.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False, SRMA_Layout__c =True);
        caseList.add(cs);
        Case cs1 = new Case(AccountId = a2.Id, ContactId = con1.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False, SRMA_Layout__c =False);                   
        caseList.add(cs1); 
        Case cs4 = new Case(AccountId = a1.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False, SRMA_Layout__c =True);
        caseList.add(cs4);
        Case cs5 = new Case(AccountId = a1.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False, SRMA_Layout__c =False);                   
        caseList.add(cs5);                  
        Insert caseList;
        Id recordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Support_Product').getRecordTypeId();

        List<Product2> pdList = new List<Product2>();
        //Creating a product for the RMA
        Product2 pd = New Product2(RecordTypeId = recordTypeId, Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - Black', ProductCode = 'TEST1234', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4,Is_Support_Product__c= True );
        pdList.add(pd);
        //Creating a product for the RMA
        Product2 pd2 = New Product2(Name = 'Remote Control', ProductCode = 'TEST123', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd2);
        //Creating a product for the RMA
        Product2 pd3 = New Product2(Name = 'Batteries for remote commander', ProductCode = 'TEST12', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd3);
        //Creating a product for the RMA
        Product2 pd4 = New Product2(Name = 'Optical Cable', ProductCode = 'TEST1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd4);
        //Creating a product for the RMA
        Product2 pd5 = New Product2(Name = 'Sony RMT-835 Commander Remote Control Batteries', ProductCode = 'TEST12C1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd5);
        //Creating a product for the RMA
        Product2 pd6 = New Product2(Name = 'Sony RM-717 Commander Remote Control Batteries', ProductCode = 'TEST12C2', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd6);
        Product2 pd7 = New Product2(Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - BlackB', ProductCode = 'TEST1234B', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd7);
        Product2 pd8 = New Product2(Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - BlackBX', ProductCode = 'TEST1234BX', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd8);
        Product2 pd9 = New Product2(Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - BlackC', ProductCode = 'TEST1234CSt', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd9);
        Product2 pd10 = New Product2(Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - BlackAlT', ProductCode = 'TEST1234Alt', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd10);
        
        
        
        Insert pdList;
        
        List<Product2> prodList = [Select Id, RecordTypeId from Product2 where Id =: pdList[0].id];
        system.debug('***Prod RecordType-->'+prodList[0].RecordTypeId);
        
        List<Support_Issue_Code__c> SuppIssueList = new List<Support_Issue_Code__c>();
        
         Support_Issue_Code__c SICL = New Support_Issue_Code__c(Name ='Product Credit',Search_Help__c ='Sales');
        SuppIssueList.add(SICL);
        
        Support_Issue_Code__c SICL1 = New Support_Issue_Code__c(Name ='Check Credit',Search_Help__c ='Sales');
        SuppIssueList.add(SICL1);
        
        Insert SuppIssueList;
        
         List<CaseProduct__c> cpList = new List<CaseProduct__c>();
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp1 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283',Product_Condition__c='Damaged Product/New Packaging',Serial_Number__c='34567', New_Email_RMA_Sent__c = False, Item__c = pd2.Id, Time_Delayed_Task__c = True);
        cpList.add(cp1);
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp2 = new CaseProduct__c(Case__c = cs1.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Sales', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283',Product_Condition__c='Damaged Product/New Packaging',Serial_Number__c='34567' ,New_Email_RMA_Sent__c = False, Item__c = pd3.Id, Time_Delayed_Task__c = True);
        cpList.add(cp2);
        
        Insert cpList;
        
        //System.assertEquals(objectName,'Case');
        
        String rmaTyp;
        rmaTyp = RMA_Type.GetRMA_Type(cs.Id);
        system.assert(rmaTyp=='Defective RMA');
        rmaTyp = RMA_Type.GetRMA_Type(cs1.Id);
        system.assert(rmaTyp=='Sales RMA');
        rmaTyp = RMA_Type.GetRMA_Type(cpList[0].Id);
        system.assert(rmaTyp=='Defective RMA');
        rmaTyp = RMA_Type.GetRMA_Type(cpList[1].Id);
        system.assert(rmaTyp=='Sales RMA');
        
}
}