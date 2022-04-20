@isTest
public class OpportunitiesTest 
{
    Static testMethod void OpportunitiesTrigger()
    {
        //Creating the account for testing
        account a1 = new account(name = 'test'); 
        Insert a1;
        //Creating the Contact w/email
        contact con = new contact(lastname ='testing', firstname = 'testcontact',email='testingit@gmail.com', accountid = a1.Id);
        Insert con;
        //Creating the account for testing
        account a2 = new account(name = 'tester', Dealer_Visit__c = Date.today().addDays(-2)); 
        Insert a2;
        //Creating the Contact w/email
        contact con1 = new contact(lastname ='tester', firstname = 'testercontact',email='testerit@gmail.com', accountid = a2.Id);
        Insert con1;
        //Creating the account for testing
        account a3 = new account(name = 'testing it', Dealer_Visit__c = Date.today().addDays(-2), Weekly_Dealer_Visits__c = 1); 
        Insert a3;
        //Creating the Contact w/email
        contact con2 = new contact(lastname ='tester', firstname = 'testercontact',email='testerit@gmail.com', accountid = a3.Id);
        Insert con2;
        //Creating the Lead
        Lead ld1 = new Lead(lastname = 'lead', firstname = 'test', RecordTypeId = '012500000005dacAAA', Status = 'New', Dealer__c = a1.Id, Dealer_2__c = a2.Id, Dealer_3__c = a3.Id,
                            LeadSource = 'Planning Guide', Email = 'leadtest@control4.com', Phone = '7867123794', Company = 'Lead Test', 
                            Entertainment__c = 'One Room', Smart_Phone_User__c = True, Energy_Efficient__c = True);
        Insert ld1;
        
        Lead ld2 = new Lead(lastname = 'lead', firstname = 'Commit', RecordTypeId = '012500000005dacAAA', Status = 'Sent to Dealer', Dealer__c = a2.Id, Opportunity_Probability__c = 40,
                            LeadSource = 'Planning Guide', Email = 'leadtestCommitted@control4.com', Phone = '7867123794', Company = 'Lead Test', 
                            Entertainment__c = 'One Room', Smart_Phone_User__c = True, Energy_Efficient__c = True);
        Insert ld2;
        
        //Creating the Opportunities
        List<Opportunity> opportunityList = new List<Opportunity>();
        Opportunity newOpp = new Opportunity();
        newOpp.name = 'Test Opp';
        newOpp.StageName = 'New';
		newOpp.CloseDate = System.today();
        newOpp.AccountId = a2.Id ;
        newOpp.Associated_Lead__c = ld2.Id;
        opportunityList.add(newOpp);
        
        Opportunity newOpp1 = new Opportunity();
        newOpp1.name = 'Test Opp 1';
        newOpp1.StageName = 'New';
		newOpp1.CloseDate = System.today();
        newOpp1.AccountId = a1.Id;
        newOpp1.Associated_Lead__c = ld1.Id;
        opportunityList.add(newOpp1);
        
        Opportunity newOpp2 = new Opportunity();
        newOpp2.name = 'Test Opp 2';
        newOpp2.StageName = 'New';
		newOpp2.CloseDate = System.today();
        newOpp2.AccountId = a2.Id;
        newOpp2.Associated_Lead__c = ld1.Id;
        opportunityList.add(newOpp2);
        
        Opportunity newOpp3 = new Opportunity();
        newOpp3.name = 'Test Opp 3';
        newOpp3.StageName = 'New';
		newOpp3.CloseDate = System.today();
        newOpp3.AccountId = a3.Id;
        newOpp3.Associated_Lead__c = ld1.Id;
        opportunityList.add(newOpp3);
      
        insert opportunityList;
        
        Test.startTest(); 
   
        List<Opportunity> opps2 = [Select Id from Opportunity where AccountId = :a2.Id and Associated_Lead__c = :ld2.Id];
        opps2[0].Probability = 20;
        Update opps2;
               
        List<Opportunity> opps = [Select Id from Opportunity where AccountId = :a1.Id];
        System.AssertEquals(1, opps.size());      
        opps[0].StageName = 'Closed Won';
        Update opps;
        
        Test.stopTest(); 
        
        // Should create three opps for separate dealers
        opps = [Select Id, AccountId from Opportunity where Associated_Lead__c = :ld1.Id];
        System.AssertEquals(3, opps.size());
        System.AssertNotEquals(opps[0].AccountId, opps[1].AccountId);
        System.AssertNotEquals(opps[0].AccountId, opps[2].AccountId);
        System.AssertNotEquals(opps[1].AccountId, opps[2].AccountId);
        
        
        opps = [Select Id, StageName, Probability from Opportunity where AccountId = :a1.Id];        
        ld1 = [select Id, Status, Opportunity_Stage__c, Opportunity_Probability__c from Lead where Id = :ld1.Id];
        System.AssertEquals('Installed', ld1.Status);
        System.assertEquals('Closed Won', ld1.Opportunity_Stage__c);
        System.assertEquals(100, ld1.Opportunity_Probability__c);
                
    }
}