@isTest
private class CheckTPSStatusTest {

    @isTest
    static void checkimmestatusTest() {
        String result = CheckTPSStatus.checkimmestatus();
        System.assertEquals('Active', result);
    }
}