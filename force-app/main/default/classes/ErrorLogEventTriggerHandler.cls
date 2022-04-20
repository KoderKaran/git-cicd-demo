public with sharing class ErrorLogEventTriggerHandler {
    private static final String APEX_CLASS = ErrorOriginType.APEX_CLASS.name();  
    private static final String APEX_TRIGGER = ErrorOriginType.APEX_TRIGGER.name();
    private static final String FLOW = ErrorOriginType.FLOW.name();
    private static final String PROCESS_BUILDER = ErrorOriginType.PROCESS_BUILDER.name();
    private static final String DBAMP_JOB = ErrorOriginType.DBAMP_JOB.name();
    // private static final String AURA_COMPONENT = ErrorOriginType.AURA_COMPONENT.name();
    // private static final String LWC = ErrorOriginType.LWC.name();
    private static final String VISUALFORCE_PAGE = ErrorOriginType.VISUALFORCE_PAGE.name();

    private static final Map<String,String> ORIGIN_TYPE_TO_PICKLIST = new Map<String,String>{APEX_CLASS => 'Apex Class', APEX_TRIGGER => 'Apex Trigger', FLOW => 'Flow', PROCESS_BUILDER => 'Process Builder', VISUALFORCE_PAGE => 'Visualforce Page', DBAMP_JOB => 'DBAmp Job'};

    private static final String INTERNAL_ORIGIN_LOCATION_TEMPLATE ='<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/{0}>{1}</a>';
    private static final String INTERNAL_OBJECT_LOCATION_TEMPLATE = '<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/setup/ObjectManager/lookupRedirect?lookup=entityByApiName&apiName={0}>{1}</a>';
    private static final String INTERNAL_FLOW_LOCATION_TEMPLATE = '<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/builder_platform_interaction/flowBuilder.app?flowId={0}>{1}</a>';

    private static final Map<String,String> SEVERITY_TO_ERROR_TYPE = getSeverityToErrorTypeMap();

    private static final String UNKNOWN = 'Unknown';
    private static final String ACTIVE = 'Active';

    private static Map<String,String> getSeverityToErrorTypeMap(){
        Map<String,String> tempSeverityToErrorType = new Map<String,String>();
        for(Error_Log_Severity_Rule__mdt errorRule:[SELECT Id, Severity__c, Interested_Error_Types__c FROM Error_Log_Severity_Rule__mdt]){
            if(errorRule.Severity__c != null && errorRule.Interested_Error_Types__c != null){
                tempSeverityToErrorType.put(errorRule.Severity__c, errorRule.Interested_Error_Types__c);
            }
        }
        return tempSeverityToErrorType;
    }

    public static void handleErrorLogEventInsert(List<Error_Log_Event__e> errorLogEvents){
        List<Error_Log__c> allErrorLogs = new List<Error_Log__c>();
        Map<String, Map<String, List<Error_Log__c>>> originNamesToErrorLogs = new Map<String, Map<String, List<Error_Log__c>>>();

        List<String> apexClassNames = new List<String>();
        List<String> apexTriggerNames = new List<String>();
        List<String> flowNames = new List<String>();
        List<String> auraComponentNames = new List<String>();
        List<String> lwcNames = new List<String>();
        List<String> vfPageNames = new List<String>();

        for(Error_Log_Event__e errorLogEvent:errorLogEvents){
            Error_Log__c errorLogToAdd = getErrorLogToAdd(errorLogEvent);

            if(errorLogEvent.Origin_Type__c != null && errorLogEvent.Origin_Name__c != null){
                if(originNamesToErrorLogs.containsKey(errorLogEvent.Origin_Type__c)){
                    Map<String, List<Error_Log__c>> tempNameToErrorLogs = originNamesToErrorLogs.get(errorLogEvent.Origin_Type__c);
                    if(tempNameToErrorLogs.containsKey(errorLogEvent.Origin_Name__c)){
                        List<Error_Log__c> tempErrorLogs = tempNameToErrorLogs.get(errorLogEvent.Origin_Name__c);
                        tempErrorLogs.add(errorLogToAdd);
                        tempNameToErrorLogs.put(errorLogEvent.Origin_Name__c, tempErrorLogs); 
                    }else{
                        tempNameToErrorLogs.put(errorLogEvent.Origin_Name__c, new List<Error_Log__c>{errorLogToAdd});
                    }
                    originNamesToErrorLogs.put(errorLogEvent.Origin_Type__c, tempNameToErrorLogs);
                }else{
                    originNamesToErrorLogs.put(errorLogEvent.Origin_Type__c, new Map<String, List<Error_Log__c>>{errorLogEvent.Origin_Name__c => new List<Error_Log__c>{errorLogToAdd}});
                }

                String currOriginType = errorLogEvent.Origin_Type__c;
                if(currOriginType.equals(APEX_CLASS)){
                    apexClassNames.add(errorLogEvent.Origin_Name__c);
                }else if(currOriginType.equals(APEX_TRIGGER)){
                    apexTriggerNames.add(errorLogEvent.Origin_Name__c);
                }else if(currOriginType.equals(FLOW) || currOriginType.equals(PROCESS_BUILDER)){
                    flowNames.add(errorLogEvent.Origin_Name__c);
                }else if(currOriginType.equals(VISUALFORCE_PAGE)){
                    vfPageNames.add(errorLogEvent.Origin_Name__c);
                }

                // else if(currOriginType.equals(AURA_COMPONENT)){
                //     auraComponentNames.add(errorLogEvent.Origin_Name__c);
                // }else if(currOriginType.equals(LWC)){
                //     lwcNames.add(errorLogEvent.Origin_Name__c);
                // }
            }
            
            if(errorLogEvent.Error_Message__c != null && errorLogEvent.Error_Type__c != null && errorLogEvent.Error_Stacktrace__c != null){
                allErrorLogs.add(errorLogToAdd);
            }
        }

        if(apexClassNames.size() > 0){  
            parseErrorLogOriginInformation(APEX_CLASS, apexClassNames, originNamesToErrorLogs);
        }
        if(apexTriggerNames.size() > 0){
            parseErrorLogOriginInformation(APEX_TRIGGER, apexTriggerNames, originNamesToErrorLogs);
        }
        if(flowNames.size() > 0){
            parseErrorLogOriginInformation(FLOW, flowNames, originNamesToErrorLogs);
        }
        // if(auraComponentNames.size() > 0){
        //     parseErrorLogOriginInformation(AURA_COMPONENT, auraComponentNames, originNamesToErrorLogs);
        // }
        // if(lwcNames.size() > 0){
        //     parseErrorLogOriginInformation(LWC, lwcNames, originNamesToErrorLogs);
        // }
        if(vfPageNames.size() > 0){
            parseErrorLogOriginInformation(VISUALFORCE_PAGE, vfPageNames, originNamesToErrorLogs);
        }

        insert allErrorLogs;
    }

    private static Error_Log__c getErrorLogToAdd(Error_Log_Event__e errorLogEvent){
        return new Error_Log__c(
            Origin_Type__c = String.isBlank(errorLogEvent.Origin_Type__c) ? null : ORIGIN_TYPE_TO_PICKLIST.get(errorLogEvent.Origin_Type__c),
            Origin_Failure_Point__c = errorLogEvent.Origin_Failure_Point__c,
            Variables_of_Interest__c = errorLogEvent.Variables_of_Interest__c,
            Error_Type__c = errorLogEvent.Error_Type__c,
            Error_Severity__c = getSeverityOfError(errorLogEvent.Error_Type__c),
            Error_Message__c = errorLogEvent.Error_Message__c,
            Error_Stacktrace__c = errorLogEvent.Error_Stacktrace__c,
            Related_Functionality__c = errorLogEvent.Related_Functionality__c,
            Related_Object__c = String.isBlank(errorLogEvent.Related_Object__c) ? null : getRelatedObjectLink(errorLogEvent.Related_Object__c)
        );
    }

    private static String getSeverityOfError(String errorType){
        for(String severity:SEVERITY_TO_ERROR_TYPE.keySet()){
            if(SEVERITY_TO_ERROR_TYPE.get(severity).containsIgnoreCase(errorType)){
                return severity;
            }
        }
        return UNKNOWN;
    }

    private static String getRelatedObjectLink(String objectApiName){
        String objectLabel = Schema.getGlobalDescribe()?.get(objectApiName)?.getDescribe()?.getLabel();
        return objectLabel == null ? 'Invalid Object API Name Provided' : String.format(INTERNAL_OBJECT_LOCATION_TEMPLATE, new List<String>{objectApiName, objectLabel});
    }

    @TestVisible
    private static void parseErrorLogOriginInformation(String originType, List<String> originLocations, Map<String, Map<String, List<Error_Log__c>>> originNamesToErrorLogs){
        Map<String, List<Error_Log__c>> originToErrors = originNamesToErrorLogs.get(originType);
        if(originType.equals(APEX_CLASS)){
            parseApexClassOriginInformation(originToErrors, originLocations);
        }else if(originType.equals(APEX_TRIGGER)){
            parseApexTriggerOriginInformation(originToErrors, originLocations);
        }else if(originType.equals(FLOW) || originType.equals(PROCESS_BUILDER)){
            parseFlowOriginInformation(originToErrors, originLocations);
        }else if(originType.equals(VISUALFORCE_PAGE)){
            parseVisualForceOriginInformation(originToErrors, originLocations);
        }
        
        // else if(originType.equals(AURA_COMPONENT)){
        //     parseAuraComponentOriginInformation(originToErrors, originLocations);
        // }else if(originType.equals(LWC)){
        //     parseLWCOriginInformation(originToErrors, originLocations);
        // }
    }

    private static void parseApexClassOriginInformation(Map<String, List<Error_Log__c>> originToErrors, List<String> apexClassNames){
        for(ApexClass apexClass:[SELECT Id, Name, LastModifiedById FROM ApexClass WHERE Name IN: apexClassNames]){
            List<Error_Log__c> errorsFromCurrentClass = originToErrors.get(apexClass.Name);
            for(Error_Log__c errorLog:errorsFromCurrentClass){
                errorLog.Origin_Location__c = String.format(INTERNAL_ORIGIN_LOCATION_TEMPLATE, new List<String>{apexClass.Id, apexClass.Name});
                errorLog.Origin_Last_Modified_By__c	= apexClass.LastModifiedById;
            }
        }
    }

    private static void parseApexTriggerOriginInformation(Map<String, List<Error_Log__c>> originToErrors, List<String> apexTriggerNames){
        for(ApexTrigger apexTrigger:[SELECT Id, Name, LastModifiedById FROM ApexTrigger WHERE Name IN: apexTriggerNames]){
            List<Error_Log__c> errorsFromCurrentTrigger = originToErrors.get(apexTrigger.Name);
            for(Error_Log__c errorLog:errorsFromCurrentTrigger){
                errorLog.Origin_Location__c = String.format(INTERNAL_ORIGIN_LOCATION_TEMPLATE, new List<String>{apexTrigger.Id, apexTrigger.Name});
                errorLog.Origin_Last_Modified_By__c	= apexTrigger.LastModifiedById;
            }
        }
    }

    private static void parseFlowOriginInformation(Map<String, List<Error_Log__c>> originToErrors, List<String> flowNames){
        Map<Error_Log__c,String> errorLogToLastModifiedUserName = new Map<Error_Log__c,String>();
        for(FlowDefinitionView currFlowDefinition:[SELECT Id, Label, ActiveVersionId, LastModifiedBy, ApiName FROM FlowDefinitionView WHERE ApiName IN: flowNames]){            
            List<Error_Log__c> errorsFromCurrentFlow = originToErrors.get(currFlowDefinition.ApiName);
            for(Error_Log__c errorLog:errorsFromCurrentFlow){
                errorLog.Origin_Location__c = String.format(INTERNAL_FLOW_LOCATION_TEMPLATE, new List<String>{currFlowDefinition.ActiveVersionId, currFlowDefinition.Label});
                errorLogToLastModifiedUserName.put(errorLog, currFlowDefinition.LastModifiedBy);
            }
        }
        Map<String, String> userNameToId = new Map<String, String>();
        for (User u: [SELECT Id, Name FROM User WHERE Name IN:errorLogToLastModifiedUserName.values()]){
            userNameToId.put(u.Name, u.Id);
        }
        for(Error_Log__c errorLog:errorLogToLastModifiedUserName.keySet()){
            Id userLastModified = userNameToId.get(errorLogToLastModifiedUserName.get(errorLog));
            if(userLastModified != null){
                errorLog.Origin_Last_Modified_By__c = userLastModified;
            }
        }
    }

    private static void parseVisualForceOriginInformation(Map<String, List<Error_Log__c>> originToErrors, List<String> vfPageNames){
        for(ApexPage vfPage:[SELECT Id, Name, LastModifiedById FROM ApexPage WHERE Name IN: vfPageNames]){
            List<Error_Log__c> errorsFromCurrentVfPage = originToErrors.get(vfPage.Name);
            for(Error_Log__c errorLog:errorsFromCurrentVfPage){
                errorLog.Origin_Location__c = String.format(INTERNAL_ORIGIN_LOCATION_TEMPLATE, new List<String>{vfPage.Id, vfPage.Name});
                errorLog.Origin_Last_Modified_By__c	= vfPage.LastModifiedById;
            }
        }
    }
}

    // private static void parseAuraComponentOriginInformation(Map<String, List<Error_Log__c>> originToErrors, List<String> auraComponentNames){
    //     for(AuraComponentBundle auraComponentBundle:[SELECT Id,DeveloperName,MasterLabel,LastModifiedById FROM AuraDefinitionBundle WHERE DeveloperName IN: auraComponentNames]){
    //         List<Error_Log__c> errorsFromAuraComponent = originToErrors.get(auraComponentBundle.DeveloperName);
    //         for(Error_Log__c errorLog:errorsFromAuraComponent){
    //             errorLog.Origin_Location__c = String.format(INTERNAL_ORIGIN_LOCATION_TEMPLATE, new List<String>{auraComponentBundle.Id, auraComponentBundle.MasterLabel});
    //             errorLog.Origin_Last_Modified_By__c	= auraComponentBundle.LastModifiedById;
    //         }
    //     }
    // }

    // private static void parseLWCOriginInformation(Map<String, List<Error_Log__c>> originToErrors, List<String> lightningComponentNames){
    //     for(LightningComponentBundle lightningComponentBundle:[SELECT Id,DeveloperName FROM LightningComponentBundle WHERE DeveloperName IN: lightningComponentNames]){
    //         List<Error_Log__c> errorsFromLightningComponent = originToErrors.get(lightningComponentBundle.DeveloperName);
    //         for(Error_Log__c errorLog:errorsFromLightningComponent){
    //             errorLog.Origin_Location__c = String.format(INTERNAL_ORIGIN_LOCATION_TEMPLATE, new List<String>{lightningComponentBundle.Id, lightningComponentBundle.DeveloperName});
    //             //errorLog.Origin_Last_Modified_By__c	= apexTrigger.LastModifiedById;
    //         }
    //     }
    // }