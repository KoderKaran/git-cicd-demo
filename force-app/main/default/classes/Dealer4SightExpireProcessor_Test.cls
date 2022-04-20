@isTest
public class Dealer4SightExpireProcessor_Test {
	
    static testMethod void lessDateToday() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0; i < 10; i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now();
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            Dealer4SightExpireProcessor obj = new Dealer4SightExpireProcessor();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
    static testMethod void thirtyDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0; i < 3; i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 30;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            Dealer4SightExpireProcessor obj = new Dealer4SightExpireProcessor();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    static testMethod void sixtyDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0; i < 3; i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 60;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            Dealer4SightExpireProcessor obj = new Dealer4SightExpireProcessor();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
    static testMethod void ninetyDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0; i < 3; i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 90;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            Dealer4SightExpireProcessor obj = new Dealer4SightExpireProcessor();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
    static testMethod void negativeDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0; i < 3; i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 29;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();
        
        Dealer4SightExpireProcessor obj = new Dealer4SightExpireProcessor();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }

    static testMethod void TooManyDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0; i < 3; i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 91;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();
        
        Dealer4SightExpireProcessor obj = new Dealer4SightExpireProcessor();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }

    
    static testMethod void accuontcontactrelationTest() 
    {
        Id BusinessAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a1 = new Account(RecordTypeId = BusinessAccountRecType, name = 'Test1');  
        insert a1;
        Account a2 = new Account(RecordTypeId = BusinessAccountRecType, name = 'Test2');  
        insert a2;
        

        
    	Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0; i < 3; i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 60;
            acc.Dealer_of_Record__c = a1.Id;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
              Contact c1 = new Contact(lastname = 'TestContact1', accountid = a1.Id, X4Sight_Subscription_Notifications__c = true);
        insert c1;
        Contact c2 = new Contact(lastname = 'TestContact2', accountid = a2.Id, X4Sight_Subscription_Notifications__c = true);
        insert c2;  
  
        c2.AccountID = a1.Id;
        update c2;
        c1.AccountID = a2.id;
        update c1;
		
        
        //accountcontactrelation r = new accountcontactrelation();
        //r.ContactId = c1.Id;
        //r.AccountId = a2.Id;
        //r.Roles = 'Evaluator';
        //insert r;

        //accountcontactrelation r2 = new accountcontactrelation();
        //r2.ContactId = c2.Id;
        //r2.AccountId = a1.Id;
        //r2.Roles = 'Evaluator';
        //insert r2;


        
        Test.startTest();
        
        Dealer4SightExpireProcessor obj = new Dealer4SightExpireProcessor();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();    
    }
}