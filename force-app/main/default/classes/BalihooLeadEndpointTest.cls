/**
  *
  * ===============================================================================================
  * Version        Date              Author             Comment
  * ===============================================================================================
  * Initial        15-July-2016      Ganesh Shinde      This test class is for class 'BalihooLeadEndpoint'
  *                                                     class.        
  *
**/

@isTest
public class BalihooLeadEndpointTest {
    /*
     * public static String responseJson = '{"location_key":"SOU973-1", "returnurl":"http://local.control4.com/soundtechsystemsinc1-34983/portsaintlucie-fl",'+
     *   '"email":"georgesori@gmail.com", "brand_key":"controlfour", "location_id":"e61c2cfe-f922-4281-9e94-0bd9fb48bca7", "lastName":"Sori",'+
     *   '"firstName":"George", "affiliateemail":"kevin@soundtechsystems.com", "notes":"Lead Capture Form", "tactic_id":"B1fuYvUx", "phone":"7724754157",'+
     *   '"comments":"Trying to get some information on Control4 for a new house i will be building. Looking for zone home audio in at least 3 rooms, lighting control, and home automation options."}';
     */
    
    public static String responseJson = '{"location_key":"NAV901", "returnurl":"http://local.control4.com/navesinktechnologygroup1-07702/shrewsbury-nj",'+
        '"email":"michael.defazio@rbccm.com", "lastName":"DeFazio",'+
        '"firstName":"Michael", "affiliateemail":"cjay@navesinktechnology.com", "notes":"Lead Capture Form", "phone":"212 428-6307",'+
        '"comments":"Hi guys.. we used you to install our system at 66 Grange in FH.. our TVs aren\'t working correctly. Can some one please call my wife back at 917 797 0731 to come and take care of it. Thanks."}';
    
    public static String errorJSONResponse = '';
    
    /**
    *  Test data for Account object.
    */
    public static List<Account> createAccountData() {
        RecordType recordType = [ SELECT Id
                                  FROM RecordType 
                                  WHERE SObjectType = 'Account' 
                                  AND IsPersonType = True 
                                  limit 1 ];
        RecordType BRrecordType = [ SELECT Id
                                  FROM RecordType 
                                  WHERE SObjectType = 'Account' 
                                  AND IsPersonType = False 
                                  limit 1 ];
        
        List<Account> listAccount = new List<Account>();
        for (Integer i = 0 ; i < 2 ; i++) {
            Account objAccount = new Account();
            if (i < 1 ) {
                objAccount.FirstName = 'TestFirst';
                objAccount.LastName = 'TestLast';
                objAccount.PersonEmail = 'michael.defazio@rbccm.com';
                objAccount.RecordTypeId = recordType.Id;
            }else {
                objAccount.Name = 'Test Account';
                objAccount.Primary_Account_Email__c = 'kevin@soundtechsystems.com';
                objAccount.Site = 'NAV901';
                objAccount.RecordTypeId = BRrecordType.Id;
            }
            listAccount.add(objAccount);
        }
        return listAccount;
    }
    
    /**
    *  Test data for Lead object.
    */
    public static Lead createLeadData() {
        Lead objLead = new Lead();
        objLead.LastName = 'TestLead';
        objLead.Company = 'Simplus';
        objLead.Status = 'New';
        objLead.Email = 'michael.defazio@rbccm.com';
        return objLead;
    }   
    
    /**
    *  method to check BalihooLead and Opportunity records are created if Account Exists.
    */
    static testMethod void testBalihooLeadWithAccount() {
        List<Account> listAccount = createAccountData();
        insert listAccount;
        RestRequest req = new RestRequest(); 
        RestResponse resp = new RestResponse();
        Test.startTest();
            req.requestURI = '/services/apexrest/balihoolead'; //Request URL
            req.httpMethod = 'POST'; //HTTP Request Type
            req.requestBody = Blob.valueof(responseJson);
            RestContext.request = req;
            RestContext.response= resp;
            String strResponse = BalihooLeadEndpoint.postData();
            List<Balihoo_Lead__c> listBalihooLead = [Select Id, 
                                                            Account__c,
                                                            Dealer__c,
                                                            Lead__c
                                                     From Balihoo_Lead__c];
            System.assertEquals(listBalihooLead.size(), 1);
            System.assertEquals(listBalihooLead[0].Account__c, listAccount[0].Id);
            System.assertEquals(listBalihooLead[0].Dealer__c, listAccount[1].Id);
        Test.stopTest();
    }
    
    /**
    *  method to check saveLead is working as expected if both Account and Lead are present.
    */
    static testMethod void saveBalihooLeadWithAccount() {
        List<Account> listAccount = createAccountData();
        insert listAccount;
        
        Lead objLead = createLeadData();
        insert objLead;
        BalihooLeadEndpoint objBalLeadEP = new BalihooLeadEndpoint();
        Test.startTest();
            BalihooLeadEndpoint.BalihooLead objBL = (BalihooLeadEndpoint.BalihooLead)JSON.deserialize(
                responseJson, BalihooLeadEndpoint.BalihooLead.class);
            Balihoo_Lead__c objBalihooLead = BalihooLeadEndpoint.saveLead(objBL);
            System.assertEquals(objBalihooLead.Account__c, listAccount[0].Id);
            System.assertEquals(objBalihooLead.Dealer__c, listAccount[1].Id);
        Test.stopTest();
    }
    
    /**
    *  method to check saveLead is working as expected if only Lead is present.
    */
    static testMethod void saveBalihooLeadWithLead() {
        Lead objLead = createLeadData();
        insert objLead;
        
        BalihooLeadEndpoint objBalLeadEP = new BalihooLeadEndpoint();
        Test.startTest();
            BalihooLeadEndpoint.BalihooLead objBL = (BalihooLeadEndpoint.BalihooLead)JSON.deserialize(
                responseJson, BalihooLeadEndpoint.BalihooLead.class);
            Balihoo_Lead__c objBalihooLead = BalihooLeadEndpoint.saveLead(objBL);
            System.assertEquals(objBalihooLead.Lead__c, objLead.Id);
        Test.stopTest();
    }
    
    /**
    *  method to check saveLead is working as expected if neither Lead nor Account records are present.
    */
    static testMethod void saveBalihooLeadWithoutAccountAndLead() {
        List<Account> listAccount = createAccountData();
        listAccount[0].PersonEmail = 'nomatch@account.com';
        insert listAccount;
    
        Test.startTest();
            BalihooLeadEndpoint.BalihooLead objBL = (BalihooLeadEndpoint.BalihooLead)JSON.deserialize(
                responseJson, BalihooLeadEndpoint.BalihooLead.class);
            Balihoo_Lead__c objBalihooLead = BalihooLeadEndpoint.saveLead(objBL);
            System.assertEquals(objBalihooLead.Account__c, null);
            //System.assertEquals(objBalihooLead.Dealer__c, null);
            System.assertNotEquals(objBalihooLead.Lead__c, null);
        Test.stopTest();
    }
    
    /**
    *  method to check postData method is working as expected if JSON is not passed correctly.
    */
    static testMethod void checkJSONError() {
        List<Account> listAccount = createAccountData();
        insert listAccount;
        RestRequest req = new RestRequest(); 
        RestResponse resp = new RestResponse();
        Test.startTest();
            req.requestURI = '/services/apexrest/balihoolead'; //Request URL
            req.httpMethod = 'POST'; //HTTP Request Type
            req.requestBody = Blob.valueof(errorJSONResponse);
            RestContext.request = req;
            RestContext.response= resp;
            String strResponse = BalihooLeadEndpoint.postData();
            System.assert(strResponse.contains('500'));
        Test.stopTest();
    }
    
    /**
    *  method to check whether opportunity is created.
    */
    static testMethod void checkOppIsCreated() {
        Lead objLead = createLeadData();
        insert objLead;
        String firstName = 'Test';
        String lastName = 'Name';
        Test.startTest();
            Id recordId = BalihooLeadEndpoint.createOpportunity(objLead.Id, null, firstName, lastName);
            List<Opportunity> listOpportunity = [Select Id, 
                                                        Associated_Lead__c
                                                 From Opportunity
                                                 Where Associated_Lead__c =: objLead.Id];
            System.assertEquals(1, listOpportunity.size());
            System.assertEquals(objLead.Id, listOpportunity[0].Associated_Lead__c);
        Test.stopTest();
    }
    
    /**
    *  method to check whether it fetched all existing accounts or leads.
    */
    static testMethod void checkRecordsAreFetched() {
        Lead objLead = createLeadData();
        insert objLead;
        
        List<Account> listAccount = createAccountData();
        insert listAccount;
        String objectName = 'Account';
        String newObjectName = '';
        List<String> lstAccountsFields = new List<String>();
        lstAccountsFields.add('IsPersonAccount = True');
        Test.startTest();
            Id recordId = [Select Id from Account where IsPersonAccount = true ORDER BY CreatedDate DESC Limit 1].Id;
            System.assertEquals(recordId, listAccount[0].Id);
        Test.stopTest();
    }
}