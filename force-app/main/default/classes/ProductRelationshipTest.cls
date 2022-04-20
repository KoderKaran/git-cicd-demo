@isTest
public class ProductRelationshipTest {
            
 public static testmethod void testTrigger() {
     
             //Creating the account for testing
             
        List<Account> AccList = new List<Account>();
        account a1 = new account(name = 'test'); 
        a1.SAP_Instance__c = 'SAP_US';
        a1.Account_Group__c = '02 Retail';
        a1.SAP_ACCOUNT_ID__c = '0001';
        AccList.add(a1);
        account a2 = new account(name = 'test1'); 
        a2.SAP_Instance__c = 'SAP_UK';
        a2.Account_Group__c = '03 Retail';
        a2.SAP_ACCOUNT_ID__c = '0002';
        AccList.add(a2);
        account a3 = new account(name = 'test2'); 
        a3.SAP_Instance__c = 'SAP_AU';
        a3.Account_Group__c = '04 Retail';
        a3.SAP_ACCOUNT_ID__c = '0003';
        AccList.add(a3);
        
        insert AccList;
        
        //Creating the Contact w/email
        List<Contact> conList = new List<Contact>();
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        conList.add(con);
        contact con1 = new contact(lastname ='testing1', firstname = 'testcontact1',email='testingit1@gmail.com', accountid = a2.Id);
        conList.add(con1);
        contact con2 = new contact(lastname ='testing2', firstname = 'testcontact2',email='testingit2@gmail.com', accountid = a3.Id);
        conList.add(con2);
        
        insert conList;
        List<Case> caseList = new List<Case>();
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(AccountId = a1.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        caseList.add(cs);
        Case cs1 = new Case(AccountId = a2.Id, ContactId = con1.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                   
        caseList.add(cs1); 
        Case cs2 = new Case(AccountId = a3.Id, ContactId = con2.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        caseList.add(cs2);
        Case cs3 = new Case(AccountId = a1.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                   
        caseList.add(cs3);
        Case cs4 = new Case(AccountId = a1.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        caseList.add(cs4);
        Case cs5 = new Case(AccountId = a1.Id, ContactId = con.Id, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);                   
        caseList.add(cs5);                  
        Insert caseList;
         Id recordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
        
        List<Product2> pdList = new List<Product2>();
        //Creating a product for the RMA
        Product2 pd = New Product2(RecordTypeId = recordTypeId,Name = 'Control4 System Remote Control SR260 and Recharging Station', ProductCode = 'TEST1234', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd);
        //Creating a product for the RMA
        Product2 pd2 = New Product2(RecordTypeId = recordTypeId,Name = 'Assy, System Remote Control W/O Recharge Contacts SR260', ProductCode = 'TEST123', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd2);
        //Creating a product for the RMA
        Product2 pd3 = New Product2(RecordTypeId = recordTypeId,Name = 'DIN-RAIL 8-CHANNEL RELAY V2', ProductCode = 'TEST12', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd3);
        //Creating a product for the RMA
        Product2 pd4 = New Product2(RecordTypeId = recordTypeId,Name = 'Entertainment & Automation Controller, 1-Zone B-STOCK 2-YR WARRANTY', ProductCode = 'TEST1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd4);
        //Creating a product for the RMA
        Product2 pd5 = New Product2(RecordTypeId = recordTypeId,Name = 'Sony RMT-835 Commander Remote Control Batteries', ProductCode = 'TEST12C1', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd5);
        //Creating a product for the RMA
        Product2 pd6 = New Product2(RecordTypeId = recordTypeId,Name = 'Sony RM-717 Commander Remote Control Batteries', ProductCode = 'TEST12C2', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd6);
        Product2 pd7 = New Product2(RecordTypeId = recordTypeId,Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - BlackB', ProductCode = 'TEST1234B', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd7);
        Product2 pd8 = New Product2(RecordTypeId = recordTypeId,Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - BlackBX', ProductCode = 'TEST1234BX', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd8);
        Product2 pd9 = New Product2(RecordTypeId = recordTypeId,Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - BlackC', ProductCode = 'TEST1234CSt', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd9);
        Product2 pd10 = New Product2(RecordTypeId = recordTypeId,Name = 'Sony - 2.1-Channel 320W Soundbar System with Wireless Subwoofer - BlackAlT', ProductCode = 'TEST1234Alt', Description = 'Testing item', IsActive = True, Scrap__c = False, RMA_Location__c = 'Default', HALLAM_Inventory__c =25,DALLAS_Inventory__c =10,CVG_Inventory__c =8,PDX_Inventory__c =6,SLC_Inventory__c =0,SAN_Inventory__c =5,YORK_Inventory__c = 4);
        pdList.add(pd10);
        
        Insert pdList;

        List<Product_Relationships__c> PrdRelList = new List<Product_Relationships__c>();
        Product_Relationships__c pr1 = new Product_Relationships__c(Parent__c = pd.Id , Child__c = pd2.Id);
        PrdRelList.add(pr1);
        Product_Relationships__c pr2 = new Product_Relationships__c(Parent__c =pd5.Id , Child__c = pd2.Id);
        PrdRelList.add(pr2);
        Product_Relationships__c pr6 = new Product_Relationships__c(Parent__c = pd6.Id,B_Stock__c = pd3.Id);
        PrdRelList.add(pr6);
        Product_Relationships__c pr7 = new Product_Relationships__c(Parent__c = pd7.Id ,Bx_Stock__c =pd4.Id);
        PrdRelList.add(pr7);        

        Insert PrdRelList;
     
     List<Product_Relationships__c> PrdRelList1 = new List<Product_Relationships__c>();
        Product_Relationships__c pr8 = new Product_Relationships__c(Parent__c = pd.Id , Child__c = pd2.Id);
        PrdRelList1.add(pr8);
        Product_Relationships__c pr9 = new Product_Relationships__c(Parent__c =pd5.Id , Child__c = pd2.Id);
        PrdRelList1.add(pr9);
        Product_Relationships__c pr10 = new Product_Relationships__c(Parent__c = pd6.Id,B_Stock__c = pd3.Id);
        PrdRelList1.add(pr10);
        Product_Relationships__c pr11 = new Product_Relationships__c(Parent__c = pd7.Id ,Bx_Stock__c =pd4.Id);
        PrdRelList1.add(pr11);
     try{
         Insert PrdRelList1;
     }catch(exception e){
         system.debug('***exception Error Message-->'+e.getMessage());
     }
     
     
       //Product_Relationships__c psrc=new Product_Relationships__c();
       //psrc.Parent__c = 'pdList';
       //insert psrc;    
    }
}