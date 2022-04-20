@isTest
public class checkExpiryBatchScheduleTest {

     static testMethod void testschedule() {
        Test.StartTest();
        checkExpiryBatchSchedule skedule = new checkExpiryBatchSchedule();
        String timeOfRun = '0 0 * * * ?'; //every hour is scheduling 
        system.schedule('Test Schedule  - checkExpiryBatchSchedule', timeOfRun, skedule);
        Test.stopTest();
     } 
}