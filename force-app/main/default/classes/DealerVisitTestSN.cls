@isTest
public class DealerVisitTestSN 
{
    Static testMethod void DealerVisitSN()
    {
        //Creating the account for testing
        account a1 = new account(name = 'test'); 
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        //Creating the account for testing
        account a2 = new account(name = 'tester', Dealer_Visit__c = Date.today().addDays(-2), Current_Quarter_Commitment__c = 2500); 
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
        Sales_Notes__c dv = new Sales_Notes__c(Account__c = a1.Id, Name = 'Dealer Visit', Description__c = 'This is testing number 1' );
        Insert dv;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Sales_Notes__c dv1 = new Sales_Notes__c(Account__c = a1.Id, Name = 'Dealer Visit', Description__c = 'This is testing number 2' );
        Insert dv1;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Sales_Notes__c dv2 = new Sales_Notes__c(Account__c = a2.Id, Name = 'Dealer Visit', Description__c = 'This is testing number 3', Change_Quarter_Commitment__c = 5500, Changed_Quarter__c = '4th' );
        Insert dv2;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Sales_Notes__c dv3 = new Sales_Notes__c(Account__c = a3.Id, Name = 'Dealer Visit', Description__c = 'This is testing number 3' );
        Insert dv3;
    }
}