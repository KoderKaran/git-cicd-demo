@isTest
public class CAMCallTest 
{
    Static testMethod void CAMCall()
    {
        //Creating the account for testing
        account a1 = new account(name = 'test'); 
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        //Creating a case with the required fields to meet trigger rule(ie Case must have Update RMA task = to false)
        Case cs = new Case(Account = a1, RecordTypeID = '012500000005eVdAAI', Status = 'Open', Origin = 'Inbound Phone Call', Subject = 'testing for apex class', 
                           Description = 'this needs to be a long description', Update_RMA_Task__c = False);
        Insert cs;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Task dv = new Task(WhatID = cs.Id, Subject = 'Dealer Call', Description = 'This is testing number 1' );
        Insert dv;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Task dv1 = new Task(WhatID = cs.Id, Subject = 'Call', Description = 'This is testing number 2' );
        Insert dv1;
        //Creating a note for Testing with subject as 'Dealer Visit' to set trigger
        Task dv2 = new Task(WhatID = cs.Id, Subject = 'Call 11/2/2015', Description = 'This is testing number 3' );
        Insert dv2;
    }
}