@isTest
public class UpdateCaseEmail 
{
    Static testMethod void UpdateCaseEmail()
    {
        //Creating the account for testing
		account a1 = new account(name = 'test'); 
		Insert a1;
        //Creating the Contact w/email
		contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        case cs = new Case(Account = a1, Contact = con, Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
		Insert cs;
        //Sending an email to meet Trigger rule (ie must be assigned to case)
        EmailMessage emess = New EmailMessage(FromAddress ='dsacks@control4.com.dev', ToAddress= 'testingit@gmail.com', Subject = 'Testing Apex trigger',
                                              TextBody = 'this his the message of the email', ParentId = cs.Id);
        Insert emess;
        
    }
    

}