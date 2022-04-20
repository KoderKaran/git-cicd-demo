@IsTest(SeeAllData=true)
public class AnnouncementBarController_Text {
    
    @isTest 
    static void testMain()
    {       
        Test.startTest();
				Announcement_Banner__c banner = AnnouncementBarController.getAnnouncement();
        Test.stopTest();
        
        System.assert(banner != null);  
    }
}