@isTest
public class Dealer4SightExpireNotifier_Test {
     
    static testMethod void testschedule() {
        Test.StartTest();
        Dealer4SightExpireNotifier notifier = new Dealer4SightExpireNotifier();
        String timeOfRun = '0 0 * * * ?'; //every hour is scheduling 
        system.schedule('Test Schedule  - Dealer4SightExpireNotifier', timeOfRun, notifier);
        Test.stopTest();
     } 
}