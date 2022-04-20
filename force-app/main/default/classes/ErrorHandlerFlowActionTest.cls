@isTest
public class ErrorHandlerFlowActionTest {
    @isTest static void handleFlowError_givenValidParameters_generatesCorrectErrorLog() {
        List<ErrorHandlerFlowAction.FlowErrorData> flowErrorData = getFlowDataError(true,1);
        List<Boolean> successes;
        Boolean expectedResult = true;

        Test.startTest();
            successes = ErrorHandlerFlowAction.handleFlowError(flowErrorData);
        Test.stopTest();

        System.assertEquals(expectedResult, successes.get(0));
    }

    @isTest static void handleFlowError_givenInvalidParameters_doesNotGenerateErrorLog() {
        List<ErrorHandlerFlowAction.FlowErrorData> flowErrorData = getFlowDataError(false,1);
        List<Boolean> successes;
        Integer expectedLength = 0;

        Test.startTest();
            successes = ErrorHandlerFlowAction.handleFlowError(flowErrorData);
        Test.stopTest();

        System.assertEquals(expectedLength, successes.size());
    }

    private static List<ErrorHandlerFlowAction.FlowErrorData> getFlowDataError(Boolean valid, Integer amount){
        List<ErrorHandlerFlowAction.FlowErrorData> flowDataErrors = new List<ErrorHandlerFlowAction.FlowErrorData>();
        for(Integer i=0; i<amount; i++){
            ErrorHandlerFlowAction.FlowErrorData flowErrorData = new ErrorHandlerFlowAction.FlowErrorData();
            if(valid){
                flowErrorData.originType = 'Flow';
                flowErrorData.originName = 'Test';
                flowErrorData.originFailurePoint = 'Flow Element';
                flowErrorData.variablesOfInterestString = 'variable1,variable2';
                flowErrorData.errorType = 'Null Pointer';
                flowErrorData.errorMessage = 'Test';
                flowErrorData.errorStackTrace = 'Test trace';
                flowErrorData.relatedFunctionality = 'Testing';
                flowErrorData.relatedObject = 'Error_Log__c';
            }
            flowDataErrors.add(flowErrorData);
        }
        return flowDataErrors;
    }
}