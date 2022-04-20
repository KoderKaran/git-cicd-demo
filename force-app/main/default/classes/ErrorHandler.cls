public class ErrorHandler {
    
    public static Database.SaveResult handleException(ErrorDataContainer errorData){
        List<Database.SaveResult> saveResults = handleMultipleExceptions(new List<ErrorDataContainer>{errorData});
        return saveResults.size() > 0 ? saveResults[0] : null;
    }

    public static List<Database.SaveResult> handleMultipleExceptions(List<ErrorDataContainer> errorDataContainers){
        System.debug('in publish');
        return Eventbus.publish(getErrorLogEventsToPublish(errorDataContainers));
    }

    @TestVisible
    private static List<Error_Log_Event__e> getErrorLogEventsToPublish(List<ErrorDataContainer> errorDataContainers){
        List<Error_Log_Event__e> errorLogEvents = new List<Error_Log_Event__e>();
        for(ErrorDataContainer errorData:errorDataContainers){
            if(!errorData.isEmpty){
                errorLogEvents.add(getErrorLogEvent(errorData));
            }
        }
        return errorLogEvents;
    }

    private static Error_Log_Event__e getErrorLogEvent(ErrorDataContainer errorData){
        return new Error_Log_Event__e(
            Origin_Type__c = errorData.originType == null ? null : errorData.originType.name(),
            Origin_Name__c = errorData?.originName,
            Origin_Failure_Point__c = errorData?.originFailurePoint,
            Variables_of_Interest__c = parseVariablesOfInterest(errorData?.variablesOfInterest),
            Error_Type__c = errorData?.errorType,
            Error_Message__c = errorData?.errorMessage,
            Error_Stacktrace__c = errorData?.errorStackTrace,
            Related_Functionality__c = errorData?.relatedFunctionality,
            Related_Object__c = errorData?.relatedObject
        );
    }

    @TestVisible
    private static String parseVariablesOfInterest(Map<String,Object> variablesOfInterest){
        if(variablesOfInterest == null){
            return 'No variables of interest';
        }
        List<String> stringVariablesOfInterest = new List<String>();
        String template = '{0}: {1}';
        for(String variableName:variablesOfInterest.keySet()){
            stringVariablesOfInterest.add(String.format(template, new List<Object>{variableName, variablesOfInterest.get(variableName)}));
        }
        return String.join(stringVariablesOfInterest, ', ');
    }


    public class ErrorDataContainer{
        public ErrorOriginType originType{get;set{
            originType = value;
            isEmpty = false;
        }}
        public String originName{get;set{
            originName = value;
            isEmpty = false;
        }}
        public String originFailurePoint{get;set{
            originFailurePoint = value;
            isEmpty = false;
        }}
        public Map<String,Object> variablesOfInterest{get;set{
            variablesOfInterest = value;
            isEmpty = false;
        }}
        public String errorType{get;set{
            errorType = value;
            isEmpty = false;
        }}
        public String errorMessage{get;set{
            errorMessage = value;
            isEmpty = false;
        }}
        public String errorStackTrace{get;set{
            errorStackTrace = value;
            isEmpty = false;
        }}
        public String relatedFunctionality{get;set{
            relatedFunctionality = value;
            isEmpty = false;
        }}
        public String relatedObject{get;set{
            relatedObject = value;
            isEmpty = false;
        }}

        private Boolean isEmpty {
            get;
            private set;
        }

        public ErrorDataContainer(){
            this.isEmpty = true;
        }

        public ErrorDataContainer(ErrorOriginType originType, String originName, String originFailurePoint, Map<String,Object> variablesOfInterest, String errorType, String errorMessage, String errorStackTrace, String relatedFunctionality, String relatedObject){
            this.isEmpty = true;
            this.originType = originType;
            this.originName = originName;
            this.originFailurePoint = originFailurePoint;
            this.variablesOfInterest = variablesOfInterest;
            this.errorType = errorType;
            this.errorMessage = errorMessage;
            this.errorStackTrace = errorStackTrace;
            this.relatedFunctionality = relatedFunctionality;
            this.relatedObject = relatedObject;
        }

    }
}