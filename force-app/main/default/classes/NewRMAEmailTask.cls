@isTest
Public class NewRMAEmailTask {
    static testMethod void NewRMAEmailTask()
    {
        //Creating the account for testing
		account a1 = new account(name = 'test'); 
		Insert a1;
        //Creating the Contact w/email
		contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
		Insert cs;
        //Creating a product for the RMA
        Product2 pd = New Product2(Name = '00040 Testing Item', ProductCode = 'CM FG', Description = 'Testing item', IsActive = True);
        
        Insert pd;
        //Creating a RMA for the case - so that the Trigger can pdate the fields in the RMA
        CaseProduct__c cp = new CaseProduct__c(Case__c = cs.Id, Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        Insert cp;
        if(cp.Time_Delayed_Task__c == True)
        {cp.Time_Delayed_Task__c = False;
        }
        Update cp;
        	 }
}