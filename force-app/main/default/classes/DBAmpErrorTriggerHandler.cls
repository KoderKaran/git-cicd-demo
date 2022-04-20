public class DBAmpErrorTriggerHandler {
	
    public static List<Database.SaveResult> handleDbAmpErrorInsert(List<dbampErrors__c> dbAmpErrors){
        List<ErrorHandler.ErrorDataContainer> errorContainers = new List<ErrorHandler.ErrorDataContainer>();
        for(dbampErrors__c error:dbAmpErrors){
            String relatedObject = getRelatedObjectGivenId(error?.SalesforceID__c);
            String relatedFunctionality = getRelatedFunctionalityGivenObject(relatedObject);
            errorContainers.add(new ErrorHandler.ErrorDataContainer(
            	ErrorOriginType.DBAMP_JOB,
                error?.Operation__c,
                '',
                new Map<String,Object>{'Salesforce Id'=>error?.SalesforceID__c},
                'DBAmp Job Error',
                error?.Error__c,
                error?.Error__c,
                relatedFunctionality,
                relatedObject
            ));
        }
        return ErrorHandler.handleMultipleExceptions(errorContainers);
    }
    
    private static String getRelatedObjectGivenId(String idString){
        try{
			return Id.valueOf(idString)?.getSobjectType()?.getDescribe()?.getName();
        }catch(Exception e){
         	return 'Unknown';   
        }
    }
    
    private static String getRelatedFunctionalityGivenObject(String objectName){
        if(objectName == null) return 'Unknown';
        if(objectName.contains('Account')){
            return 'Account';
        }else if(objectName.contains('Loyalty')){
            return 'Loyalty';
        }else{
            return 'Unknown';
        }
    }
    
}