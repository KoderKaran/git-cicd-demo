@isTest
public class ContactRecursionCheck_Test {

     testMethod static void testForOnce()
     {
        boolean testval = ContactRecursionCheck.RunOnceCheck();
        System.assertEquals(testval,true,'This is the correct Result');
     }
    
     testMethod static void testForTwice()
     {
         boolean testval = ContactRecursionCheck.RunOnceCheck();
		 testval = ContactRecursionCheck.RunOnceCheck();
         System.assertEquals(testval,false,'This is the correct Result');
     }
}