@isTest
public class CaseCreationController_Test {
    
    @isTest
    static void testSearch()
    {
        Id [] fixedResults = new Id[1];      
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account acc = new Account();
        // for person accounts we can not update the Name field instead we have to update the    FirstName and LastName individually
        acc.FirstName = 'Test';
        acc.LastName = 'Name';
        acc.RecordType = personAccountRecordType;
        insert acc;            
        
        fixedResults.add(acc.Id);        
        Test.setFixedSearchResults(fixedResults);
        
        List<String> selectedIds = new List<String>();        
        System.assertEquals(1, CaseCreationController.search('Test', selectedIds).size());
        System.assertEquals(acc.Id, CaseCreationController.search('Test', selectedIds).get(0).getId());    
    }
    
    @isTest
    static void testgetContactName()
    {
        RecordType bussinessAccount =  [SELECT Id FROM RecordType WHERE Name = 'Business Account' and SObjectType = 'Account'];
        Account acc = new Account(name='Test Account', RecordType = bussinessAccount);
        insert acc;
        
        Contact con = new Contact(
            Firstname = 'TestFirstname',
            Lastname = 'TestLastname',
            Email = '',
            MobilePhone = '',
            AccountId = acc.Id,
            Description = '');
        
        insert con; 
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Tech Support').getRecordTypeId();
        
        Case testCase = new Case(
            RecordTypeId = caseRecordTypeId,
            AccountId = acc.Id,
            ContactId = con.Id,
            Subject = 'Test Case'    
        );
        
        insert testCase;   
        
        List<CaseCreationController.CaseDataTranferObject> caseDTOList = new List<CaseCreationController.CaseDataTranferObject>();
        
        Test.startTest();
        	caseDTOList.Add(CaseCreationController.getContactName(con.Id));
        Test.stopTest();
        
        System.assertEquals(caseDTOList.size(), 1);          
    }
    
    @isTest
    static void testcreateCase()
    {
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account personAcc = new Account();
        // for person accounts we can not update the Name field instead we have to update the    FirstName and LastName individually
        personAcc.FirstName = 'Test';
        personAcc.LastName = 'Name';
        personAcc.RecordType = personAccountRecordType;
        insert personAcc;  
        
        
        RecordType bussinessAccount =  [SELECT Id FROM RecordType WHERE Name = 'Business Account' and SObjectType = 'Account'];
        Account acc = new Account(name='Test Account', RecordType = bussinessAccount);
        insert acc;
        
        Contact con = new Contact(
            Firstname = 'TestFirstname',
            Lastname = 'TestLastname',
            Email = '',
            MobilePhone = '',
            AccountId = acc.Id,
            Description = '');
        
        insert con; 
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Tech Support').getRecordTypeId();
        
        Test.startTest();
        	string testResults = CaseCreationController.createCase(con.Id, acc.Id, 'Phone', personAcc.Id, 'TestControl4name', 'TestController', 'TestSoftwareVersion', 'TestSubject', 'TestDescription');
        Test.stopTest();
        
        System.assertEquals(testResults.contains('true'), false);         
    }   
}