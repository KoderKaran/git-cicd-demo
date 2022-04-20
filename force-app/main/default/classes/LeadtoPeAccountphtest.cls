@isTest
public class LeadtoPeAccountphtest {
    Static testmethod void LeadtoPeAccountphtest(){
        
        test.startTest();
        Account a1 = new Account(
        	Name = 'Business Account',
        	Phone = '64654312354');
        Insert a1;
        
        contact con = new contact(
            lastname ='testing',
            firstname = 'testcontact',
            email='testingit@gmail.com', 
            accountid = a1.Id);
        Insert con;
        
        Account a2 = new Account(
            RecordTypeId = '012500000005Jxs',
        	LastName = 'Person',
        	Firstname = 'account');
        Insert a2;
        
        Account a3 = new Account(
            RecordTypeId = '012500000005Jxs',
        	LastName = 'Personal',
        	Firstname = 'accountant',
        	Phone = '80180480888');
        Insert a3;
        
        Lead l1 = new Lead(
        	lastname = 'final',
            firstname = 'testing',
            phone = '804400440',
            email = 'Testing@gill.com');
        Insert l1;
         
        Lead l2 = new Lead(
        	lastname = 'final',
            firstname = 'tester',
            phone = '',
            email = '');
        Insert l2;
        
        If(l2.Phone != a3.Phone){
            l2.Phone = '80180480888';
        }
        
        Lead l3 = new Lead(
        	lastname = 'final',
            firstname = 'testing',
            phone = '8010101012',
            email = 'testingit@gmail.com');
        Insert l3;
        
        Lead l4 = new Lead(
        	lastname = 'final',
            firstname = 'testing',
            phone = '80180480888',
            email = '');
        Insert l4;
        
        Lead l5 = new Lead(
        	lastname = 'final',
            firstname = 'testing',
            phone = '64654312354',
            email = '');
        Insert l5;
        test.stopTest();
        
        
        
    }

}