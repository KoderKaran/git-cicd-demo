@isTest
public class LiveChatTest 
{
    Static testMethod void LiveChatTranscript()
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
        CaseProduct__c cp = new CaseProduct__c(Case__c = cs.Id, Detail__c = 'testing', Type__c = 'Hardware', Product_Type__c = 'HVAS', Product__c = 'Thermostat', Issue__c = 'No Power',
                                               Version__c = '2.6.1', RMA__c = 'Yes', Symptom__c = 'Cracked LCD', RMA_Type__c = 'Defective', RMA_Outcome__c = 'Repair - In Warranty',
                                               Troubleshooting__c = 'Yes', Restock_Fee__c = 'No', MacID__c = '10283', New_Email_RMA_Sent__c = False, Item__c = pd.Id, Time_Delayed_Task__c = True);
        Insert cp;
        //Creating a ChatTranscript from LiveChat for testing the live chat functionality
        LiveChat_transcript__c lc = new LiveChat_transcript__c(LiveChat_Chat_Id__c = 'NUWHJ5R0W5',Case__c = cs.Id, Account__c = a1.Id,Start_Time__c = system.now(), End_Time__c = system.now(),
                                                               Contact__c = con.Id);
        Insert lc;
        if(lc.Transcript__c == Null)
        {
            lc.Transcript__c = 'this is for testing purposes';
            update lc;
        }
    }
}