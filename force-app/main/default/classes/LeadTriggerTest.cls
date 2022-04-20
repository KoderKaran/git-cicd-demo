@isTest
public class LeadTriggerTest {
    
    @testSetup 
    static void setup() {
        List<Profile> sysAd = [select id, name from Profile where  name = 'System Administrator'];
        User u = new User(firstname= 'sysAdUser',
                          lastname='XXXX',
                          Alias='sysAdU',
                          email = 'sysAdU@test.com',
                          username= 'sysAdU@test.com', 
                          profileId= sysAd[0].id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles');
        insert u;    
        

        id perAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account a1 = new Account(
            Name = 'Business Account',
            Phone = '64654312354');
        Insert a1;
        Account a2 = new Account(
            RecordTypeId = perAccRT,
            LastName = 'Person',
            Firstname = 'account', personemail = 'lead01email@test.com');
        Insert a2;    
        
        Account a3 = new Account(
            RecordTypeId = perAccRT,
            LastName = 'Personal',
            Firstname = 'accountant',
            Phone = '000002');
        Insert a3;
        
        //dealer accounts
        List<Account> dealerAccts = new List<Account>();
        for(Integer i=0;i<4;i++) {
            dealerAccts.add(new Account(Name = 'Dealer '+i, Dealer_Lead_Primary_Contact_Email__c = i+'TEsT@TEST.COM'));
        }
        dealerAccts[0].Dealer_Lead_Primary_Contact_Email__c = null;
        insert dealerAccts ;    
        contact con = new contact(
            lastname ='testing',
            firstname = 'testcontact',
            email='testingit@gmail.com', 
            accountid = dealerAccts[0].Id);
        Insert con;
        
        Territory_Setup__c terr = new Territory_Setup__c(
            Next_Mass_Update_Date_Lead__c = system.today(),
            Status__c='on');
        Insert terr;
        
        
        List<Lead> leadList = new List<Lead>();
        id leadDSRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
        id leadTSRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Telesales').getRecordTypeId();
        
        
        
        for(Integer i=0;i<14;i++){
            Lead newLead = new Lead();
            newLead.RecordTypeId = leadTSRT ;
            newLead.LastName = 'Sample' + i;
            newLead.Stage__c = 'New';
            newLead.Theater_Type__c = 'Dedicated';
            newLead.Audio_Zones_Qty__c  = 1;
            newLead.Lighting_Design_Type__c = '1';
            newLead.Wireless_High_Throughput_Devices__c = 1;
            
            newLead.Run_Lead_Assignment__c = false;
            newLead.email = 'lead0'+i+'email@test.com';
            newlead.Lead_Message__c = 'test';
            newlead.phone = '+9617024724' + i;
            newlead.Status_Previous_Value__c = 'New';
            newlead.Pardot_Lead_Record_Type__c = 'Builder Lead';
            leadList.add(newLead);
            system.debug('RODNEY TEST CLASS '+newLead);
        }  
        leadlist[0].Dealer__c = dealerAccts[0].id;
        leadlist[0].Pardot_Lead_Record_Type__c = 'Telesales';
        leadlist[0].Dealer_2__c = dealerAccts[1].id;
        leadlist[0].Dealer_3__c = dealerAccts[2].id;
        leadlist[0].Customer_Contact_Attempts__c = '1';
        leadlist[10].Customer_Contact_Attempts__c = '1';
        leadlist[1].Pardot_Lead_Record_Type__c = 'Telesales';
        leadlist[1].Customer_Contact_Attempts__c = '1';
        leadlist[2].Customer_Contact_Attempts__c = '1';
        
        system.debug('RODNEY LEAD LIST '+leadlist);
        insert leadlist;    
    }
    
    @isTest 
    public static void createLead(){
        test.startTest();
        List<Lead> leadList = new List<Lead>();
        List <Group> grpList = new list <Group>();
        Group Telesales_Archive = new Group(Name='Telesales_Archive', Type='Queue');
        Group Telesales = new Group(Name='Telesales',  Type='Queue');
        grpList.add(Telesales_Archive);
        grpList.add(Telesales);
        insert grpList;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            List <QueuesObject> QList = new List<QueuesObject >();
            QueuesObject TAQueue = new QueueSObject(QueueID = Telesales_Archive.id, SObjectType = 'Lead');
            QList.add(TAQueue);
            
            QueuesObject TQueue = new QueueSObject(QueueID = Telesales.id, SObjectType = 'Lead');
            QList.add(TQueue);
            insert QList;
        }
                
        for(Integer i=0;i<10;i++){
            Lead newLead = new Lead();
            newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
            newLead.LastName = 'Sample' + i;
            newLead.Stage__c = 'New';
            newLead.Theater_Type__c = 'Dedicated';
            newLead.Audio_Zones_Qty__c  = 1;
            newLead.Lighting_Design_Type__c = '1';
            newLead.Wireless_High_Throughput_Devices__c = 1;
            newLead.Run_Lead_Assignment__c = false;
            newLead.Pardot_Lead_Record_Type__c = 'Telesales';
            leadList.add(newLead);
        }
        leadlist[4].ownerid=Telesales_Archive.id;
        leadlist[5].ownerid=Telesales.id;      
        insert leadList;
        test.stopTest();
    }
    
    @isTest
    public static void LeadtoPeAccountphtest(){
        
        test.startTest();
        
        account a1 = new account();
        a1 = [select id from account where name ='Business Account' limit 1];
        
        contact con = new contact(
            lastname ='testing123',
            firstname = 'testcontact123',
            email='testingit123@gmail.com', 
            accountid = a1.Id);
        Insert con;
        
        List <Account> dealerAccts = new list <Account>();
        dealerAccts = [select id from account where name like '%dealer%'];
        List<Lead> leadList = new List<Lead>();
        for(Integer i=0;i<10;i++){
            Lead newLead = new Lead();
            newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
            newLead.LastName = 'Sample' + i;
            newLead.Stage__c = 'New';
            newLead.Theater_Type__c = 'Dedicated';
            newLead.Audio_Zones_Qty__c  = 1;
            newLead.Lighting_Design_Type__c = '1';
            newLead.Wireless_High_Throughput_Devices__c = 1;
            newLead.Dealer__c = dealerAccts[0].id;
            newLead.Dealer_2__c = dealerAccts[1].id;
            newLead.Dealer_3__c = dealerAccts[2].id;
            newLead.Pardot_Lead_Record_Type__c = 'Telesales';
            leadList.add(newLead);
        }      
        
        insert leadList;
        test.stopTest();       
    }
    
    @isTest
    public static void insertAndupdateleads(){
        
              
        test.startTest();
        List <Account> dealerAccts = new list <Account>();
        dealerAccts = [select id from account where name like '%dealer%'];
        List<Lead> leadList = new List<Lead>();
        id leadDSRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
        id leadTSRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Telesales').getRecordTypeId();
        
        for(Integer i=0;i<14;i++){
            Lead newLead = new Lead();
            newLead.RecordTypeId = leadTSRT ;
            newLead.LastName = 'Sample' + i;
            newLead.Stage__c = 'New';
            newLead.Theater_Type__c = 'Dedicated';
            newLead.Audio_Zones_Qty__c  = 1;
            newLead.Lighting_Design_Type__c = '1';
            newLead.Wireless_High_Throughput_Devices__c = 1;
            newLead.Dealer__c = dealerAccts[0].id;
            newLead.Dealer_2__c = dealerAccts[1].id;
            newLead.Dealer_3__c = dealerAccts[2].id;
            newLead.Run_Lead_Assignment__c = false;
            newLead.email = 'lead'+i+'email@test.com';
            newlead.Lead_Message__c = 'test';
            newlead.phone = '0000';
            newlead.Pardot_Lead_Record_Type__c = 'Telesales';
            newlead.Status_Previous_Value__c = 'New';
            leadList.add(newLead);
        }      
        //set status of leads 
        /*
        leadList[0].Status = 'Sent To Dealer';
        leadList[1].Status = 'Opportunity Created';
        leadList[2].Status = 'Installed';
        leadList[3].Status = 'Term Lead';
        leadList[4].Status = 'Attempting Contact';
        leadList[5].Status = 'Renewed Interest';
        */
        leadList[0].From_Balihoo__c = true;
        insert leadList;
        
        
        
        test.stopTest();       
    }
    
    @isTest
    public static void updateleads(){
        
        //User u = [select id from user where username = 'sysAdU@test.com' limit 1];
        List <Account> dealerAccts = new list <Account>();
        dealerAccts = [select id from account where name like '%dealer%'];
        List<Lead> leadList = new List<Lead>();
        leadList = [select id, Status, From_Balihoo__c, Dealer__c , Dealer_2__c ,Dealer_3__c , Run_Lead_Assignment__c  from lead limit 20];  
        //set status of leads 
        /*
        leadList[0].Status = 'Sent To Dealer';
        leadList[1].Status = 'Opportunity Created';
        leadList[2].Status = 'Installed';
        leadList[3].Status = 'Term Lead';
        leadList[4].Status = 'Attempting Contact';
        leadList[5].Status = 'Renewed Interest';
        */
        
       
        
        Opportunity op = new Opportunity ();
        op.Accountid = dealerAccts[0].id;
        op.Associated_Lead__c = leadList[7].id;
        op.StageName='New';
        op.name='Test';
        op.CloseDate = system.today();
        Test.startTest();
        insert op;
        
        leadList[0].From_Balihoo__c = true;
        
                
        leadList[0].Dealer__c = dealerAccts[1].id;
        leadList[0].Dealer_2__c = dealerAccts[2].id;
        leadList[0].Dealer_3__c = dealerAccts[0].id;
        leadList[0].Run_Lead_Assignment__c = true; 
        
         
        leadList[1].Dealer__c = null;
        leadList[1].Dealer_2__c = null;
        leadList[1].Dealer_3__c = null;
        leadList[1].Run_Lead_Assignment__c = true;
        
        leadlist[0].Customer_Contact_Attempts__c = '2';
        leadlist[10].Customer_Contact_Attempts__c = '6';
        
        leadList[0].Status = 'Attempting Contact';
        leadList[1].Status = 'Installed';
        leadList[2].Status = 'Sent To Dealer';
        leadList[3].Status = 'Sent To Dealer';
        leadList[4].Status = 'Sent To Dealer';
        
        leadList[5].Status = 'Sent To Dealer';
        leadList[6].Status = 'Opportunity Created';
        leadList[7].Status = 'Installed';
        leadList[8].Status = 'Term Lead';
        leadList[9].Status = 'Attempting Contact';
        leadList[10].Status = 'Renewed Interest';
        
        
        update leadList;
        Test.stopTest();   
        
            
    }
    
}