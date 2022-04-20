@isTest
public class SentRemindersTest 
{
    static testMethod void ThreeMonthReminder()
    {
        //Creating a User for OwnerID
        User u1 = new User(LastName = 'Testerson', FirstName = 'Test', Email = 'ttestersone@control4.com', Username = 'ttestersone@control4.com', Alias = 'ttest', 
                           CommunityNickname = 'ttest', TimeZoneSidKey = 'America/Mazatlan', LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', 
                           ProfileId = '00e50000000nR4CAAU', LanguageLocaleKey = 'en_US');
        Insert u1;
        //Creating the account for testing
        account a1 = new account(name = 'test', OwnerId = u1.Id, AccountNumber = 'test1234'); 
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        //Creating a case with the required fields to meet trigger rule(ie Case must have Reminders set = to false)
        Case cs = new Case(Accountid = a1.Id, ContactId = con.Id, RecordTypeID= '012500000005I5BAAU',Status = 'Open',  Origin = 'Inbound Phone Call', 
                           Subject = 'testing for apex class', Description = 'this needs to be a long description', Update_RMA_Task__c = False, BOM_Status__c = 'Pending', 
                           X3_Month_Reminder__c = False, X3_Week_Reminder__c = False, Reminders_Sent__c = False, MSRP_Amount__c = '$1,200');
        Insert cs;
        //Must set each Reminder to True separately so that they will create the Reminder Tasks.
        System.runAs(u1)
        {
            if(cs.Status == 'Open')
            {
                cs.Status = 'Closed';
                update cs;
            }
            if(cs.X3_Week_Reminder__c == False)
            {
                cs.X3_Week_Reminder__c = True;
                update cs;
            }
            if(cs.X3_Month_Reminder__c == False)
            {
                cs.X3_Month_Reminder__c = True;
                cs.X3_Week_Reminder__c = True;
                update cs;
            }
            if(cs.Reminders_Sent__c = False)
            {
                cs.Reminders_Sent__c = True;
                update cs;
            }
        }
    }
}