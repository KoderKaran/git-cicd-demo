@isTest
public class DBAmpErrorTriggerHandlerTest {
    @isTest static void handleDbAmpErrorInsert_givenValidDbAmpErrors_generatesCorrectErrorLogs(){
        Integer expectedNumberOfErrorLogs = 5;
        List<Database.SaveResult> results;
        
        List<dbampErrors__c> dbAmpErrors = getValidDbAmpErrors(expectedNumberOfErrorLogs);
       
        Test.startTest();
        	results = DBAmpErrorTriggerHandler.handleDbAmpErrorInsert(dbAmpErrors);
        Test.stopTest();
       
        System.assertEquals(expectedNumberOfErrorLogs, results.size());
    }
    
    private static List<dbAmpErrors__c> getValidDbAmpErrors(Integer numOfErrorLogs){
        List<dbampErrors__c> dbAmpErrors = new List<dbampErrors__c>();
        for(Integer i=0; i<numOfErrorLogs; i++){
            dbAmpErrors.add(new dbampErrors__c(
            	Error__c='Error Message',
                Operation__c='Operation',
                TableName__c='TableName',
                SalesforceID__c='0011T00002QOXRiQAP'
            ));
        }
        insert dbAmpErrors;
        return dbAmpErrors;
    }
}