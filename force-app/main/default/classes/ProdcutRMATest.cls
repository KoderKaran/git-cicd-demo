@isTest
public class ProdcutRMATest {
    @isTest
    public static void prodRMATestMethod() {
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
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283',Product_Condition__c='Damaged Product/New Packaging',Serial_Number__c='34567', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        cpList.add(cp1);
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp2 = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283',Product_Condition__c='Damaged Product/New Packaging',Serial_Number__c='34567' ,New_Email_RMA_Sent__c = False, Item__c = pd2.Id, Time_Delayed_Task__c = True);
        cpList.add(cp2);
        
        Insert cpList;
        //ProductRMA prms = new ProductRMA();
        CaseProduct__c prms = ProductRMA.getCaseProduct(cpList[0].Id,2);
        List<CaseProduct__c> cloneCaseProd = ProductRMA.cloneCaseProduct(cpList[0],3);
        List<CaseProduct__c> prmsList = ProductRMA.getProduct(cpList[0].Id);
        Map<String, String> condMap = ProductRMA.getCond();
        List<CaseProduct__c> checksingle = new List<CaseProduct__c>();
        ProductRMA.saveproducts(cloneCaseProd,'Control Issues','Software','Set Aside for Test','CLT',prms);
        ProductRMA.saveSingleProduct(cpList[0].Id,'Control Issues','Software','Set Aside for Test','CLT','Damaged Product/New Packaging','34567','10283');
    }
    
}