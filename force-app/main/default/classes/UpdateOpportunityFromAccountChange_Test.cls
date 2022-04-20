@isTest(SeeAllData=true)
public class UpdateOpportunityFromAccountChange_Test 
{    
   public static testMethod void UpdateOpportunityStage()
   {
        Id leadRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Control4 Dealer Lead').getRecordTypeId(); 
        Lead testlead = new Lead(Lastname = 'TestRecord654321', Company = 'TestCompany654321', recordtypeid = leadRecordType, email='no@no.com');
        insert testlead;
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testlead.id);
        lc.setConvertedStatus('Sent to ASM');
		lc.ownerid = '00550000002uqO8';
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());
        
        Account acc = [select ID from Account where name = 'TestCompany654321' LIMIT 1];
        acc.SAP_ACCOUNT_ID__c = 'ABC123';

        Test.startTest();        
       	update acc;        
        Test.stopTest();
   
   } 
    
}