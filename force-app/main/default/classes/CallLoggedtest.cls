@isTest
public class CallLoggedtest 

{
    Static testMethod void CallLoggedtest()
    {
        //Creating the account for testing
        account a1 = new account(name = 'test'); 
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='2testing', firstname = '2testcontact',email='2testingit@gmail.com', accountid = a1.Id);
        Insert con;
        //Creating the account for testing
        account a2 = new account(name = '3tester', Dealer_Visit__c = Date.today().addDays(-2),Current_Quarter_Commitment__c = 2500); 
        Insert a2;
        //Creating the Contact w/email
        contact con1 = new contact(lastname ='t3ester', firstname = '3testercontact',email='3testerit@gmail.com', accountid = a2.Id);
        Insert con1;
        //Creating the account for testing
        account a3 = new account(name = '3testing it', Dealer_Visit__c = Date.today().addDays(-2), Weekly_Dealer_Visits__c = 1); 
        Insert a3;
        //Creating the Contact w/email
        contact con2 = new contact(lastname ='3tester', firstname = '3testercontact',email='3testerit@gmail.com', accountid = a2.Id);
        Insert con2;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Task dv = new Task(WhatID = a1.Id, Subject = 'Dealer Call', Description = 'T3his is testing number 1' );
        Insert dv;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Task dv1 = new Task(WhatID = a1.Id, Subject = 'Call', Description = 'This is testing number 2' );
        Insert dv1;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Task dv2 = new Task(WhatID = a2.Id, Subject = 'Call 11/2/2015', Description = 'This is testing number 3',Change_Quarter_Commitment__c = 25500.55, Changed_Quarter__c = '4th');
        Insert dv2;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Task dv3 = new Task(WhatID = a3.Id, Subject = 'Call', Description = 'This is testing number 3' );
        Insert dv3;
        Task dv4 = new Task(Subject = 'call logged', Description = 'This is testing number 4' );
        Insert dv4;
    }
}