@isTest
public class DealerVisitTest 
{
    Static testMethod void DealerVisit()
    {
        //Creating the account for testing
		account a1 = new account(name = 'test'); 
		Insert a1;
        //Creating the Contact w/email
		contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        //Creating the account for testing
		account a2 = new account(name = 'tester', Dealer_Visit__c = Date.today().addDays(-2)); 
		Insert a2;
        //Creating the Contact w/email
		contact con1 = new contact(lastname ='tester', firstname = 'testercontact',email='testerit@gmail.com', accountid = a2.Id);
        Insert con1;
        //Creating the account for testing
		account a3 = new account(name = 'testing it', Dealer_Visit__c = Date.today().addDays(-2), Weekly_Dealer_Visits__c = 1); 
		Insert a3;
        //Creating the Contact w/email
		contact con2 = new contact(lastname ='tester', firstname = 'testercontact',email='testerit@gmail.com', accountid = a2.Id);
        Insert con2;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        note nt = new note(ParentId = a1.Id, Title = 'Dealer Visit', Body = 'This is testing number 1' );
        Insert nt;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        note nt1 = new note(ParentId = a1.Id, Title = 'Dealer Visit', Body = 'This is testing number 2' );
        Insert nt1;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        note nt2 = new note(ParentId = a2.Id, Title = 'Dealer Visit', Body = 'This is testing number 3' );
        Insert nt2;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        note nt3 = new note(ParentId = a3.Id, Title = 'Dealer Visit', Body = 'This is testing number 3' );
        Insert nt3;
    }
}