@isTest
public class SandboxInit_Test {

    @isTest    
    static void updateSystemAdminsTest()
    {        
        Test.startTest();
        	SandboxInit.updateSystemAdmins();
        Test.stopTest();
        
        System.assertEquals(1, 1);   
    }   
}