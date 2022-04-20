@isTest
public class ErrorLogEventTriggerHandlerTest {
    @isTest static void handleErrorLogEventInsert_givenValidApexClassErrorLogEvents_createCorrectAmountOfErrorLogRecords(){
        Integer numOfErrorLogEvents = 10;
        ErrorOriginType expectedOriginType = ErrorOriginType.APEX_CLASS;
        String expectedOriginString = 'Apex Class';
        List<Error_Log_Event__e> errorLogEvents = getValidAndInvalidErrorLogEvents(expectedOriginType,numOfErrorLogEvents,0);

        Test.startTest();
            ErrorLogEventTriggerHandler.handleErrorLogEventInsert(errorLogEvents);
        Test.stopTest();

        List<Error_Log__c> results = [SELECT Id FROM Error_Log__c WHERE Origin_Type__c =: expectedOriginString];
        System.assertEquals(numOfErrorLogEvents, results.size());
    }

    @isTest static void handleErrorLogEventInsert_givenValidApexTriggerErrorLogEvents_createCorrectAmountOfErrorLogRecords(){
        Integer numOfErrorLogEvents = 10;
        ErrorOriginType expectedOriginType = ErrorOriginType.APEX_TRIGGER;
        String expectedOriginString = 'Apex Trigger';
        List<Error_Log_Event__e> errorLogEvents = getValidAndInvalidErrorLogEvents(expectedOriginType,numOfErrorLogEvents,0);

        Test.startTest();
            ErrorLogEventTriggerHandler.handleErrorLogEventInsert(errorLogEvents);
        Test.stopTest();

        List<Error_Log__c> results = [SELECT Id FROM Error_Log__c WHERE Origin_Type__c =: expectedOriginString];
        System.assertEquals(numOfErrorLogEvents, results.size());
    }

    @isTest static void handleErrorLogEventInsert_givenValidFlowErrorLogEvents_createCorrectAmountOfErrorLogRecords(){
        Integer numOfErrorLogEvents = 10;
        ErrorOriginType expectedOriginType = ErrorOriginType.FLOW;
        String expectedOriginString = 'Flow';
        List<Error_Log_Event__e> errorLogEvents = getValidAndInvalidErrorLogEvents(expectedOriginType,numOfErrorLogEvents,0);

        Test.startTest();
            ErrorLogEventTriggerHandler.handleErrorLogEventInsert(errorLogEvents);
        Test.stopTest();

        List<Error_Log__c> results = [SELECT Id FROM Error_Log__c WHERE Origin_Type__c =: expectedOriginString];
        System.assertEquals(numOfErrorLogEvents, results.size());
    }

    @isTest static void handleErrorLogEventInsert_givenValidAndInvalidApexClassErrorLogEvents_createCorrectAmountOfErrorLogRecords(){
        Integer numOfErrorLogEvents = 5;
        Integer numOfInvalidErrorLogEvents = 5;
        ErrorOriginType expectedOriginType = ErrorOriginType.APEX_CLASS;
        String expectedOriginString = 'Apex Class';
        List<Error_Log_Event__e> errorLogEvents = getValidAndInvalidErrorLogEvents(expectedOriginType,numOfErrorLogEvents,numOfInvalidErrorLogEvents);

        Test.startTest();
            ErrorLogEventTriggerHandler.handleErrorLogEventInsert(errorLogEvents);
        Test.stopTest();

        List<Error_Log__c> results = [SELECT Id FROM Error_Log__c WHERE Origin_Type__c =: expectedOriginString];
        System.assertEquals(numOfErrorLogEvents, results.size());
    }

    @isTest static void handleErrorLogEventInsert_givenValidAndInvalidApexTriggerErrorLogEvents_createCorrectAmountOfErrorLogRecords(){
        Integer numOfErrorLogEvents = 5;
        Integer numOfInvalidErrorLogEvents = 5;
        ErrorOriginType expectedOriginType = ErrorOriginType.APEX_TRIGGER;
        String expectedOriginString = 'Apex Trigger';
        List<Error_Log_Event__e> errorLogEvents = getValidAndInvalidErrorLogEvents(expectedOriginType,numOfErrorLogEvents,numOfInvalidErrorLogEvents);

        Test.startTest();
            ErrorLogEventTriggerHandler.handleErrorLogEventInsert(errorLogEvents);
        Test.stopTest();

        List<Error_Log__c> results = [SELECT Id FROM Error_Log__c WHERE Origin_Type__c =: expectedOriginString];
        System.assertEquals(numOfErrorLogEvents, results.size());
    }

    @isTest static void handleErrorLogEventInsert_givenValidAndInvalidFlowErrorLogEvents_createCorrectAmountOfErrorLogRecords(){
        Integer numOfErrorLogEvents = 5;
        Integer numOfInvalidErrorLogEvents = 5;
        ErrorOriginType expectedOriginType = ErrorOriginType.FLOW;
        String expectedOriginString = 'Flow';
        List<Error_Log_Event__e> errorLogEvents = getValidAndInvalidErrorLogEvents(expectedOriginType,numOfErrorLogEvents,numOfInvalidErrorLogEvents);

        Test.startTest();
            ErrorLogEventTriggerHandler.handleErrorLogEventInsert(errorLogEvents);
        Test.stopTest();

        List<Error_Log__c> results = [SELECT Id FROM Error_Log__c WHERE Origin_Type__c =: expectedOriginString];
        System.assertEquals(numOfErrorLogEvents, results.size());
    }

    private static List<Error_Log_Event__e> getValidAndInvalidErrorLogEvents(ErrorOriginType originType, Integer numOfValid, Integer numOfInvalid){
        List<ErrorHandler.ErrorDataContainer> errorContainers = getValidErrorDataContainers(originType, numOfValid);
        for(Integer i=0; i<numOfInvalid; i++){
            errorContainers.add(new ErrorHandler.ErrorDataContainer());
        }
        return ErrorHandler.getErrorLogEventsToPublish(errorContainers);
    }

    private static List<ErrorHandler.ErrorDataContainer> getValidErrorDataContainers(ErrorOriginType originType, Integer numberOfErrorDataContainers){
        String originName = getOriginName(originType);
        List<ErrorHandler.ErrorDataContainer> errorContainers = new List<ErrorHandler.ErrorDataContainer>();
        for(Integer i=0; i<numberOfErrorDataContainers; i++){
            errorContainers.add(new ErrorHandler.ErrorDataContainer(
                originType,
                originName,
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

    private static String getOriginName(ErrorOriginType originType){
        switch on originType{
            when APEX_CLASS {
                return 'ErrorLogEventTriggerHandler';
            }
            when APEX_TRIGGER {
                return 'ErrorLogEventTrigger';
            }
            when FLOW {
                return 'Tech_Support_Chat_Flow';
            }
            when else {
                return '';
            }
        }
    }

}