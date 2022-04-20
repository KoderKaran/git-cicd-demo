@isTest
public class ErrorHandlerTest {
    @isTest static void handleException_givenValidErrorDataContainer_createsErrorLogRecord(){
        Integer expectedErrorLogs = 1;
        ErrorHandler.ErrorDataContainer errorDataContainer = getValidErrorDataContainers(expectedErrorLogs)[0];
        Database.SaveResult saveResult;

        Test.startTest();
            saveResult = ErrorHandler.handleException(errorDataContainer);
        Test.stopTest();
        
        System.assertEquals(true, saveResult.isSuccess());
        System.assertEquals(expectedErrorLogs, new List<Error_Log__c>([SELECT Id FROM Error_Log__c]).size());
    }

    @isTest static void handleException_givenInvalidErrorDataContainer_doesntCreateErrorLogRecord(){
        Integer expectedErrorLogs = 0;
        ErrorHandler.ErrorDataContainer errorDataContainer = new ErrorHandler.ErrorDataContainer();
        Database.SaveResult saveResult;

        Test.startTest();
            saveResult = ErrorHandler.handleException(errorDataContainer);
        Test.stopTest();
        
        System.assertEquals(null, saveResult);
        System.assertEquals(expectedErrorLogs, new List<Error_Log__c>([SELECT Id FROM Error_Log__c]).size());
    }

    @isTest static void handleMultipleExceptions_givenMultipleValidErrorDataContainers_createTheSameAmountOfErrorLogRecords(){
        Integer expectedErrorLogs = 10;
        List<ErrorHandler.ErrorDataContainer> errorDataContainers = getValidErrorDataContainers(expectedErrorLogs);
        List<Database.SaveResult> saveResults;

        Test.startTest();
            saveResults = ErrorHandler.handleMultipleExceptions(errorDataContainers);
        Test.stopTest();

        for(Database.SaveResult sr:saveResults){
            System.assertEquals(true, sr.isSuccess());
        }
        System.assertEquals(expectedErrorLogs, new List<Error_Log__c>([SELECT Id FROM Error_Log__c]).size());
    }

    @isTest static void handleMultipleExceptions_givenPartiallyValidErrorDataContainers_createsTheCorrectAmountOfErrorLogs(){
        Integer expectedErrorLogs = 5;
        Integer invalidErrorContainers = 5;
        List<ErrorHandler.ErrorDataContainer> errorDataContainers = getValidAndInvalidDataContainers(expectedErrorLogs, invalidErrorContainers);
        List<Database.SaveResult> saveResults;

        Test.startTest();
            saveResults = ErrorHandler.handleMultipleExceptions(errorDataContainers);
        Test.stopTest();

        for(Database.SaveResult sr:saveResults){
            System.assertEquals(true, sr.isSuccess());
        }
        Integer res = new List<Error_Log__c>([SELECT Id FROM Error_Log__c]).size();
        System.assertEquals(expectedErrorLogs, res, errorDataContainers);
    }

    @isTest static void handleMultipleExceptions_givenInvalidErrorDataContainers_createsNoErrorLogRecords(){
        Integer expectedErrorLogs = 0;
        Integer invalidErrorContainers = 10;
        List<ErrorHandler.ErrorDataContainer> errorDataContainers = getValidAndInvalidDataContainers(expectedErrorLogs, invalidErrorContainers);
        List<Database.SaveResult> saveResults;

        Test.startTest();
            saveResults = ErrorHandler.handleMultipleExceptions(errorDataContainers);
        Test.stopTest();

        for(Database.SaveResult sr:saveResults){
            System.assertEquals(true, sr.isSuccess());
        }
        System.assertEquals(expectedErrorLogs, new List<Error_Log__c>([SELECT Id FROM Error_Log__c]).size());
    }

    private static List<ErrorHandler.ErrorDataContainer> getValidAndInvalidDataContainers(Integer numOfValid, Integer numOfInvalid){
        List<ErrorHandler.ErrorDataContainer> errorContainers = getValidErrorDataContainers(numOfValid);
        for(Integer i=0; i<numOfInvalid; i++){
            errorContainers.add(new ErrorHandler.ErrorDataContainer());
        }
        return errorContainers;
    }

    private static List<ErrorHandler.ErrorDataContainer> getValidErrorDataContainers(Integer numberOfErrorDataContainers){
        List<ErrorHandler.ErrorDataContainer> errorContainers = new List<ErrorHandler.ErrorDataContainer>();
        for(Integer i=0; i<numberOfErrorDataContainers; i++){
            errorContainers.add(new ErrorHandler.ErrorDataContainer(
                ErrorOriginType.APEX_CLASS,
                'ErrorHandler',
                'handleException',
                new Map<String,Object>{'errorLogEvents' => null},
                'NullPointerException',
                'Attempted to de-reference null pointer.',
                'Error on line 10 of ErrorHandler.cls',
                'Error Logging',
                'Error_Log__c'
            ));
        }
        return errorContainers;
    }
}