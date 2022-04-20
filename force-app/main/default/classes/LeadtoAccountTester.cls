@isTest
public class LeadtoAccountTester {
    static testMethod void LeadtoAccountTester()
        
    {
        test.startTest();
        //Creating the account for testing
        account a1 = new account(
            RecordTypeId = '012500000005Jxs',  
            Type = 'Customer', 
            FirstName = 'test', 
            LastName = 'Sacks', 
            PersonEmail = 'tester.devon@devons.com'); 
        Insert a1;
        
        account a2 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks2', 
             PersonEmail = 'tester.devon2@devons.com'); 
        Insert a2;
        
        account a3 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks3', 
             PersonEmail = 'tester.devon3@devons.com',
        	 Phone = '8525254613'); 
        Insert a3;
        
        account a4 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks4', 
             PersonEmail = 'tester.devon4@devons.com',
        	 Phone = '8525251246'); 
        Insert a4;
        
        account a5 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks5', 
             PersonEmail = 'tester.devon6@devons.com',
        	 Phone = '8525251221'); 
        Insert a5;
        
        
        
        //Creating the Lead for testing
        lead nl = new lead();
            nl.FirstName = 'Test';
            nl.lastname = 'Sacks'; 
            nl.Email = 'tester.devon@tevons.com';
            nl.Phone = '211151123';
        Insert nl;
        
        lead n2 = new lead(
             FirstName = 'Test',
             lastname = 'Sacks', 
             Email = 'tester.devon2@devons.com',
             Phone = '211151124');
        Insert n2;
        
        lead n3 = new lead(
             FirstName = 'Test',
             lastname = 'Sacks', 
             Email = 'tester.devon3@devons.com',
             Phone = '3214577845');
        Insert n3;
        
        lead n4 = new lead(
             FirstName = 'Test',
             lastname = 'Sacks',
             Phone = '8525251246');
        Insert n4;
        
        lead n5 = new lead(
             FirstName = 'Test',
             Lastname = 'Sacks', 
             Email = 'tester.what@devons.com',
             Phone = '865865251246');
        Insert n5;
        
        lead n6 = new lead(
             FirstName = 'Test',
             Lastname = 'Sacks',
             Phone = '865866661246');
        Insert n6;
        
        //Updating the account to check for other test API
        IF(a1.PersonEmail != nl.Email)
        {
            a1.PersonEmail = 'tester.devon@tevons.com';            
        }
        IF(a3.Phone != n3.Phone)
        {
            a3.Phone = '3214577845';            
        }
        
        IF(a5.PersonEmail != n5.Email){
            a5.PersonEmail = 'whatever@whatever.com';
        }
        IF(a5.Phone != n5.Phone){
            a5.Phone = '8525251221';
        }
        account a6 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks5', 
             PersonEmail = 'tester.what@devons.com',
        	 Phone = '8525201221'); 
        Insert a6;
        
        account a7 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks5', 
             PersonEmail = 'tester.notta@devons.com',
        	 Phone = '865866661246'); 
        Insert a7;
        
        lead n7 = new lead(
             FirstName = 'Test',
             Lastname = 'Sacks', 
             Phone = '865866661246');
        Insert n7;
        
        lead n8 = new lead(
             FirstName = 'Test',
             Lastname = 'Sacks', 
             Email = 'tester.notta@devons.com');
        Insert n8;
        
        lead n9 = new lead(
        	FirstName = 'Insert',
        	LastName = 'Test');
        Insert n9;
        
        If(n9.Email == ''){
           n9.Email = 'tester.cool@devons.com';
        }
        
        If(n9.Email == ''){
           n9.Email = 'tester.notta@devons.com';
        }
        lead n10 = new lead(
        	FirstName = 'Insert',
        	LastName = 'Test',
        	Email = '123@gmail.com',
        	Phone = '');
        Insert n10;
        
        account a9 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks50'); 
        Insert a9;
        
        If(n10.Phone == ''){
            n10.Phone = '86586544111';
        }
        
        If(n10.Phone == '86586544111'){
            n10.Phone = '865866661246';
        }
        
        lead n11 = new lead(
        	FirstName = 'Insertered',
        	LastName = 'Test');
        Insert n11;

        test.stopTest();
	}
}