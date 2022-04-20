@isTest(seeAllData=true)
private class createAssetPrimaryControllerTest{
    @isTest
    static void testTrigger(){
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE Name = 'Person Account'];
        Date today = Date.today();
        Account account = new Account(RecordTypeId = rt.Id,
                                        FirstName = 'TestTest',
                                        LastName = 'Kyazma',
                                        MacAddress__pc = '98765',
                                        Controller_Software_Major__pc = 'xyz',
                                        Controller_Software_Minor__pc = 'abc',
                                        Controller_Software_Patch__pc = 22.00,
                                        Controller_Software_Build__pc = 'qrs',
                                        Active_Controller__pc = true,
                                        Primary_Controller__pc = 'lmn',
                                        Controller_Install_Date__pc = today,
                                        Controller_Last_Check_In__pc = today,
                                        OS_Last_Update__pc = today);

        insert account;

        account.OS_Last_Update__pc = today + 1;

        update account;


    }
}