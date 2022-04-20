public class AnnouncementBarController {

    @AuraEnabled
    public static Announcement_Banner__c getAnnouncement()
    {           
       return  [SELECT Id, Banner_Text__c, Detail_Text__c 
                FROM Announcement_Banner__c
                WHERE Active__c = true
                LIMIT 1];   
    }    
}