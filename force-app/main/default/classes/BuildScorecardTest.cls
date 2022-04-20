@isTest
public class BuildScorecardTest {
    @testSetup static void setupTest() {
        Period prd = [SELECT EndDate,StartDate FROM Period 
                    where Type = 'Quarter' AND StartDate <= TODAY AND EndDate >= TODAY];
        // Create 2 users
        Profile p = [select id 
                     from profile
                     WHERE UserType = 'Standard'
                     AND Name = 'System Administrator'
                     limit 1];   
        List<User> u = new List<User>();
            
        String testemail = 'puser000@amamama.com';
        u.add(new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Denver', 
                           alias='cspu', lastname='lastname'));
            
        testemail = 'puser001@amamama.com';
        u.add(new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Denver', 
                           alias='cspu2', lastname='lastname'));
            
        testemail = 'puser002@amamama.com';
        u.add(new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Denver', 
                           alias='cspu3', lastname='lastname'));
        System.runAs(new User(Id = UserInfo.getUserId())){
            Insert u;
        }
        
        // add scorecard for one user with values, most of which should be overwritten
        List<Scorecard__c> s = new List<Scorecard__c>();
        s.add(new Scorecard__c(OwnerId = u[0].Id, Start_Date__c = prd.StartDate, 
                               End_Date__c = prd.EndDate, Dealer_Calls__c = 100, 
                               Dealer_Visits__c = 200, 
                               New_Dealers__c = 300,
                               Revenue__c = 500.01,
                               Directors_Direction__c = 4,
                               Quarter_Focus__c = 16));
        
        s.add(new Scorecard__c(OwnerId = u[2].Id, Start_Date__c = prd.StartDate, 
                               End_Date__c = prd.EndDate, Dealer_Calls__c = 100, 
                               Dealer_Visits__c = 200, 
                               New_Dealers__c = 300,
                               Revenue__c = 500.01,
                               Directors_Direction__c = 4,
                               Quarter_Focus__c = 16));
        Insert s;
        // add accounts new
        List<Account> a = new List<Account>();
        for(Integer i = 0; i < 15; i++){
            a.add(new Account(Name = 'Test '+i, OwnerId = u[0].Id,
                             First_Order_Date__c = math.mod(i,2) == 0? prd.StartDate : prd.EndDate)); // Put records on the outsets of our periods to ensure proper collection
        }
        for(Integer i = 0; i < 25; i++){
            a.add(new Account(Name = 'Test '+i, OwnerId = u[1].Id,
                             First_Order_Date__c = math.mod(i,2) == 0? prd.StartDate : prd.EndDate)); // Put records on the outsets of our periods to ensure proper collection
        }
        // add accounts old
        for(Integer i = 0; i < 15; i++){
            a.add(new Account(Name = 'Test '+i, OwnerId = u[0].Id)); // Put records on the outsets of our periods to ensure proper collection
        }
        for(Integer i = 0; i < 25; i++){
            a.add(new Account(Name = 'Test '+i, OwnerId = u[1].Id)); // Put records on the outsets of our periods to ensure proper collection
        }
        Insert a;
        // add customer purchase history
        List<Customer_Purchase_History__c> c = new List<Customer_Purchase_History__c>();
        for(Account ac : a){
            c.add(new Customer_Purchase_History__c(Account__c = ac.Id, Start_Date__c = prd.StartDate, End_Date__c = prd.EndDate, Amount__c = 100));
        }
        Insert c;
        // add dealer visits for new and old
        List<Sales_Notes__c> d = new List<Sales_Notes__c>();
        for(Account ac : a){
            d.add(new Sales_Notes__c(OwnerId = ac.OwnerId, Account__c = ac.Id, Name = 'Dealer Visit'));
        }
        Insert d;
        // TODO: After Spring '16 GA release will need to implement Test.setCreatedDate(recordId, createdDatetime) for these  Sales_Notes__c records
        
        // add dealer calls
        List<Task> t = new List<Task>();
        for(Account ac : a){
            t.add(new Task(OwnerId = ac.OwnerId, WhatId = ac.Id, Subject = 'Call',
                           ActivityDate = ac.OwnerId == u[0].Id? prd.StartDate : prd.EndDate));
        }
        Insert t;
    }
    
    static testMethod void testScorecardValues() {
        // Using TODAY because I need to deal with CreatedDate issues, can fix after Spring '16 release
        Period prd = [SELECT EndDate,StartDate FROM Period 
                    where Type = 'Quarter' AND StartDate <= TODAY AND EndDate >= TODAY];
        Test.startTest();
        Map<Id, Scorecard__c> sc = BuildScorecard.buildScorecardForPeriod(prd);
        Test.stopTest();
        System.Debug(sc);
        
        User u1 = [select Id from User where alias = 'cspu'];
        User u2 = [select Id from User where alias = 'cspu2'];
        User u3 = [select Id from User where alias = 'cspu3'];
        
        Scorecard__c s = sc.get(u1.Id);
        System.AssertNotEquals(null, s);
        System.AssertEquals(15, s.New_Dealers__c);
        System.AssertEquals(30*100, s.Revenue__c);
        System.AssertEquals(30, s.Dealer_Visits__c);
        System.AssertEquals(30, s.Dealer_Calls__c);
        
        s = sc.get(u2.Id);
        System.AssertNotEquals(null, s);
        System.AssertEquals(25, s.New_Dealers__c);
        System.AssertEquals(50*100, s.Revenue__c);
        System.AssertEquals(50, s.Dealer_Visits__c);
        System.AssertEquals(50, s.Dealer_Calls__c);
        
        s = sc.get(u3.Id);
        System.AssertNotEquals(null, s);
        System.AssertEquals(0, s.New_Dealers__c);
        System.AssertEquals(0, s.Revenue__c);
        System.AssertEquals(0, s.Dealer_Visits__c);
        System.AssertEquals(0, s.Dealer_Calls__c);
    }
    
    static testMethod void test2() {
        
        // Using TODAY because I need to deal with CreatedDate issues, can fix after Spring '16 release        
        User u1 = [select Id from User where alias = 'cspu'];
        User u2 = [select Id from User where alias = 'cspu2'];
        User u3 = [select Id from User where alias = 'cspu3'];
        Test.startTest();
        BuildScorecard.updateScorecards();
        Test.stopTest();
        List<Scorecard__c> sc = [select Id, OwnerId, New_Dealers__c, Revenue__c, 
                                 Dealer_Visits__c, Dealer_Calls__c, Directors_Direction__c, Quarter_Focus__c
                                from Scorecard__c];
        System.AssertEquals(3, sc.size());
        for(Scorecard__c s : sc){
            if(s.OwnerId == u1.Id){
                System.AssertNotEquals(null, s);
                System.AssertEquals(15, s.New_Dealers__c);
                System.AssertEquals(30*100, s.Revenue__c);
                // TODO: Fix this for first day of quarter
                // System.AssertEquals(30, s.Dealer_Visits__c);
                System.AssertEquals(30, s.Dealer_Calls__c);
                System.AssertEquals(4, s.Directors_Direction__c);
                System.AssertEquals(16, s.Quarter_Focus__c);
            }
            if(s.OwnerId == u2.Id){
                System.AssertNotEquals(null, s);
                System.AssertEquals(25, s.New_Dealers__c);
                System.AssertEquals(50*100, s.Revenue__c);
                // TODO: Fix this for first day of quarter
                // System.AssertEquals(50, s.Dealer_Visits__c);
                System.AssertEquals(50, s.Dealer_Calls__c);
            }
            if(s.OwnerId == u3.Id){
                System.AssertNotEquals(null, s);
                System.AssertEquals(0, s.New_Dealers__c);
                System.AssertEquals(0, s.Revenue__c);
                System.AssertEquals(0, s.Dealer_Visits__c);
                System.AssertEquals(0, s.Dealer_Calls__c);
                System.AssertEquals(4, s.Directors_Direction__c);
                System.AssertEquals(16, s.Quarter_Focus__c);
            }
        }
    }
}