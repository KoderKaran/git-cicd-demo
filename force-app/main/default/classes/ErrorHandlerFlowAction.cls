public class ErrorHandlerFlowAction {

    @InvocableMethod(label='Handle Error Logging from Flows/Process Builders' category='Error Log')
    public static List<Boolean> handleFlowError(List<FlowErrorData> flowErrorData){
        List<ErrorHandler.ErrorDataContainer> errorDataContainers = new List<ErrorHandler.ErrorDataContainer>();
        for(FlowErrorData flowError:flowErrorData){
            if(flowError.errorMessage != null){
                errorDataContainers.add(
                    new ErrorHandler.ErrorDataContainer(
                        stringToErrorOriginType(flowError.originType),flowError.originName,flowError.originFailurePoint,convertRelatedFunctionalityListToMap(flowError.variablesOfInterest != null ? flowError.variablesOfInterest : new List<String>{flowError.variablesOfInterestString}),
                        flowError.errorType,flowError.errorMessage,flowError.errorStackTrace,flowError.relatedFunctionality,flowError.relatedObject
                    )
                );
            }
        }
        System.debug(errorDataContainers);
        List<Database.SaveResult> dbSaveResults = ErrorHandler.handleMultipleExceptions(errorDataContainers);
        List<Boolean> successes = new List<Boolean>();
        for(Database.SaveResult dsr:dbSaveResults){
            successes.add(dsr.isSuccess());
        }

        return successes;
    }

    private static Map<String,Object> convertRelatedFunctionalityListToMap(List<String> variablesOfInterest){
        Map<String,Object> variablesOfInterestMap = new Map<String,Object>();
        for(String variableName:variablesOfInterest){
            variablesOfInterestMap.put(variableName, '');
        }
        return variablesOfInterestMap;
    }

    private static ErrorOriginType stringToErrorOriginType(String errorString){
        switch on errorString {
            when 'Flow' {	
                return ErrorOriginType.FLOW;	
            }	
            when 'Process Builder' {		
                return ErrorOriginType.PROCESS_BUILDER;	
            }
            when 'Apex Class' {	
                return ErrorOriginType.APEX_CLASS;		
            }
            when 'Apex Trigger' {		  
                return ErrorOriginType.APEX_TRIGGER;	
            }
        }
        return null;
    }

    public class FlowErrorData {
        @InvocableVariable(label='Error Origin Type' description='Possible valid values: Apex Class, Apex Trigger, Flow, Process Builder')        
        public String originType;
        @InvocableVariable(label='Error Origin Name' description='API name of the origin of the error.')
        public String originName;
        @InvocableVariable(label='Error Origin Failure Point' description='The name of the method of a class, the element of a flow or the branch of process builder where the error occurred')
        public String originFailurePoint;
        @InvocableVariable(label='Error Variables of Interest' description='A list of the names of variables that were important in the location the error occured')
        public List<String> variablesOfInterest;
        @InvocableVariable(label='Error Variables of Interest (String)' description='A list of the names of variables that were important in the location the error occured')
        public String variablesOfInterestString;
        @InvocableVariable(label='Error Type' description='The type of error that has occurred. Ex: NullPointerException')
        public String errorType;
        @InvocableVariable(label='Error Message' description='The error message that has occurred')
        public String errorMessage;
        @InvocableVariable(label='Error Stack Trace' description='The stack trace of the error that has occurred')
        public String errorStackTrace;
        @InvocableVariable(label='Error Related Functionality' description='The functionality related to the error that has occurred')
        public String relatedFunctionality;
        @InvocableVariable(label='Error Related Object' description='The object related to the error that has occurred')
        public String relatedObject;
    }

}