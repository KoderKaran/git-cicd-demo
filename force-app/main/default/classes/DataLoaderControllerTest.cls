@isTest
public with sharing class DataLoaderControllerTest {
    
    @TestSetup
    static void generateTestUsers(){
        Id salesProfileId = [SELECT Id FROM Profile WHERE Name='Sales - SSA' LIMIT 1].Id;
        User salesUser = new User(
            FirstName = 'Test',
            LastName = 'Sales User',
            UserName = 'test' + DateTime.now().getTime() + '@salesusertest.com',
            Email = 'test@salesusertest.com',
            CommunityNickname = 'TestSales',
            Alias = 'tssu',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = salesProfileId
        );
        insert salesUser;
    }

    private static List<Data_Loader_Procedure__mdt> generateTestMetadata(Integer numberOfMetadata, List<String> profileNames){
        List<Data_Loader_Procedure__mdt> dataLoaderProcedures = new List<Data_Loader_Procedure__mdt>();
        Integer profileCounter = 0;
        for(Integer i=0; i<numberOfMetadata; i++){
            String profileName = profileNames == null || profileNames.isEmpty() ? 'Any' : profileNames.get(profileCounter);
            dataLoaderProcedures.add(new Data_Loader_Procedure__mdt(
                Active__c = true,
                CSVs_Required__c = 'Test1,Test2,Test3',
                Procedure_Apex_Class__c = 'LoyaltyProcedureStrategy',
                Profiles_With_Access__c = profileName
            ));
            profileCounter = (profileCounter + 1) > profileNames.size() ? 0 : profileCounter+1;
        }
        return dataLoaderProcedures;
    }

    @isTest
    static void getDataLoaderProcedures_givenSalesUser_returnsCorrectDataLoaderProcedures(){
        List<Data_Loader_Procedure__mdt> customMetadatas = DataLoaderControllerTest.generateTestMetadata(3, new List<String>{'Any','Sales - SSA','System Administrator'});
        List<Data_Loader_Procedure__mdt> getDataLoaderProceduresResults;

        User salesUser = [SELECT Id FROM User WHERE Email = 'test@salesusertest.com' LIMIT 1];

        //Integer expectedNumberOfDataLoaderProcedures = 2;

        Test.startTest();
            System.runAs(salesUser){
                getDataLoaderProceduresResults = DataLoaderController.getDataLoaderProcedures();
            }
        Test.stopTest();

        //System.debug(getDataLoaderProceduresResults);
        //System.assertEquals(expectedNumberOfDataLoaderProcedures, getDataLoaderProceduresResults.size()); 
    }

    @isTest
    static void performDataLoadProcedure_givenValidFilesAndProcedureName_returnsDataLoaderAuraResults(){
        List<Data_Loader_Procedure__mdt> customMetadatas = DataLoaderControllerTest.generateTestMetadata(3, new List<String>{'Any','Sales - SSA','System Administrator'});
        List<Object> files = new List<Object>{
            new Map<Object,Object>{
                'name' => 'test-account-load-csv',
                'file'=> 'Name\n' +
                         'Test-Account'
            }
        };

        Integer expectedAccountIds = 1;
        List<String> accIdsInserted = new List<String>();

        Test.startTest();
            DataLoaderResults.DataLoaderAuraResults auraResults= DataLoaderController.performDataLoadProcedure(files, 'test');
            for(Map<String,String> row:auraResults.tableRows.get('Inserted Accounts')){
                accIdsInserted.add(row.get('Id'));
            }
        Test.stopTest();

        System.debug(accIdsInserted);
        System.assertEquals(expectedAccountIds, accIdsInserted.size());
    }

}