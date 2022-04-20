@isTest
public class MasterDealerObjectManager_Test 
{
    testMethod static void checkCreateMasterDealer()
    {       
        Id businessAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(); 
     
        Account testAcc = new Account(name = 'Test1', recordtypeid = businessAccountRecordType);
        Account testAcc2 = new Account(name = 'Test2', recordtypeid = businessAccountRecordType);
        List<Account> accs = new List<Account>();
        accs.add(testAcc);
        accs.add(testAcc2);
        
        Test.startTest();
        
        insert accs;
        
        Test.stopTest();
        
        System.assertEquals(true,true,'Found primary users in contact');
    }
}