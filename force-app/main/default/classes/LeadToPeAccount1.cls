@isTest
public class LeadToPeAccount1 {
     
    Static testmethod void LeadtoPeAccount() {
        
        List<Account> listA = new List<Account>();
        
        account a6 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks5', 
             PersonEmail = 'tester.what@devons.com',
             Phone = '8525201221'); 
        listA.add(a6);
        
        account a7 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks5', 
             PersonEmail = 'tester.notta@devons.com',
             Phone = '865866661246'); 
        listA.add(a7);
        
        insert listA;
        
        test.startTest();
        
        List<Lead> listL = new List<Lead>();
        lead n7 = new lead(
             FirstName = 'Test',
             Lastname = 'Sacks', 
             Email = '',
             Phone = '865866661246');
        listL.add(n7);
        
        lead n8 = new lead(
             FirstName = 'Test',
             Lastname = 'Sacks', 
             Email = 'tester.notta@devons.com',
             Phone = '');
        insert n8;
        
        lead n9 = new lead(
            FirstName = 'Insert',
            LastName = 'Test',
            Email = '',
            Phone = '');
        listL.add(n9);
        /*
        If(n9.Email == ''){
           n9.Email = 'tester.cool@devons.com';
        }
        
        If(n9.Email == ''){
           n9.Email = 'tester.notta@devons.com';
        }*/
        lead n10 = new lead(
            FirstName = 'Insert',
            LastName = 'Test',
            Email = '123@gmail.com',
            Phone = '');
        listL.add(n10);
        
        account a9 = new account(
             RecordTypeId = '012500000005Jxs',  
             Type = 'Customer', 
             FirstName = 'Test', 
             LastName = 'Sacks50', 
             PersonEmail = '',
             Phone = ''); 
        Insert a9;
        
        lead n11 = new lead(
            FirstName = 'Insertered',
            LastName = 'Test',
            Email = '',
            Phone = '');
        listL.add(n11);
        
        insert ListL;
        
        test.stopTest();
        
    }

}