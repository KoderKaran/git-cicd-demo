@Istest
Private class CAMRelatedCases_Test {
    
   static testMethod void test1(){
        Account acc = new Account();
        acc.name= 'test';
        acc.Type = 'Prospect';
        insert acc;
        
        case c = new case();
        c.subject = 'test case';
        c.Status = 'New';
        c.AccountId = acc.id;
        insert c;
      ApexPages.StandardController sc = new ApexPages.StandardController(acc);
      CAMRelatedCases testAccPlan = new CAMRelatedCases(sc);
      testAccPlan.getmyCaseList();
   
    }
}