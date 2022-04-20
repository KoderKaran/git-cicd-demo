@isTest
private class ContactTriggerHandlerTest {
    @testSetup static void setup(){
        
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        
        for(Integer i =0 ; i< 3; i++){
            Account testAcc = new Account();
            testAcc.Name = 'Test Account '+ i;
            
            accList.add(testAcc);
        }
    	
        insert accList;
        
        for(Account acc: accList){
            for(Integer i =0; i<3;i++){
                Contact c = new Contact();
                c.AccountId = acc.Id;
                c.LastName = 'Test test '+ i;
                c.eCom_Primary_User__c = true;
                conList.add(c);
            }
        }
        
        if(!conList.isEmpty()){
            insert conList;
        }      
    }

    
    testMethod static void checkNewContact(){
        Account existingAcc = [SELECT ID FROM Account LIMIT 1];
        String errorMsg;
        
        Test.startTest();
        Contact newCon = new Contact();
        newCon.AccountId = existingAcc.Id;
        newCon.LastName = 'Test New';
        newCon.eCom_Primary_User__c = true;
        
        try{
        	insert newCon;
        Test.stopTest();
        }catch(Exception e){
            errorMsg = e.getMessage();
        }
        
        Contact c = [SELECT ID FROM Contact WHERE LastName = 'Test New'];
        
        System.assertEquals(true ,c!=null, 'Not able to add another primary');        
    }
}