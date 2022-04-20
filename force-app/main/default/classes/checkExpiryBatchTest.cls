@isTest
public class checkExpiryBatchTest {
	static testMethod void lessDateToday() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now();
            acc.X90_Days_Check__c = false; 
            acc.X60_Days_Check__c = false;
            acc.X30_Days_Check__c = false;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            checkExpiryBatch obj = new checkExpiryBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    static testMethod void thirtyDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 30;
            acc.X90_Days_Check__c = false; 
            acc.X60_Days_Check__c = false;
            acc.X30_Days_Check__c = false;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            checkExpiryBatch obj = new checkExpiryBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    static testMethod void sixtyDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 60;
            acc.X90_Days_Check__c = false; 
            acc.X60_Days_Check__c = false;
            acc.X30_Days_Check__c = false;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            checkExpiryBatch obj = new checkExpiryBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    static testMethod void ninetyDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 90;
            acc.X90_Days_Check__c = false; 
            acc.X60_Days_Check__c = false;
            acc.X30_Days_Check__c = false;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            checkExpiryBatch obj = new checkExpiryBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
        static testMethod void negativeDays() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecType;
            acc.FirstName ='TestFirstName'+i; 
            acc.LastName ='TestLastName'+i;
            acc.X4Sight_Expiration__pc = datetime.now() + 500;
            acc.X90_Days_Check__c = false; 
            acc.X60_Days_Check__c = false;
            acc.X30_Days_Check__c = false;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();
        
        checkExpiryBatch obj = new checkExpiryBatch();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
    static testMethod void withContact() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount';
        insert acc1;
        
        Account acc = new Account();
        acc.RecordTypeId = personAccountRecType;
        acc.FirstName ='TestFirstName';
        acc.LastName ='TestLastName';
        acc.X4Sight_Expiration__pc = datetime.now() + 90;
        acc.X90_Days_Check__c = false; 
        acc.X60_Days_Check__c = false;
        acc.X30_Days_Check__c = false;
        acc.Dealer_of_Record__c = acc1.Id;        
        insert acc;
        
        
        Contact con = new Contact();
        con.AccountId = acc1.Id;
        con.Primary_User__c = true;
        con.LastName = 'TestLastNameCon';
        insert con;
        
        Test.startTest();

            checkExpiryBatch obj = new checkExpiryBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
      static testMethod void withContactTrue() 
    {
        Id personAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount';
        insert acc1;
        
        Account acc = new Account();
        acc.RecordTypeId = personAccountRecType;
        acc.FirstName ='TestFirstName';
        acc.LastName ='TestLastName';
        acc.X4Sight_Expiration__pc = datetime.now() + 90;
        acc.X90_Days_Check__c = false; 
        acc.X60_Days_Check__c = false;
        acc.X30_Days_Check__c = false;
        acc.Dealer_of_Record__c = acc1.Id;    
        acc.ExpirationBoolean__c = true;
        insert acc;
        
        
        Contact con = new Contact();
        con.AccountId = acc1.Id;
        con.Primary_User__c = true;
        con.LastName = 'TestLastNameCon';
        insert con;
        
        Test.startTest();

            checkExpiryBatch obj = new checkExpiryBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}