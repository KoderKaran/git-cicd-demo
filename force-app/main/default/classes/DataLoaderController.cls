public class DataLoaderController {

    private static Integer BATCH_SIZE = 100; 

    @AuraEnabled(cacheable=true)
    public static List<Data_Loader_Procedure__mdt> getDataLoaderProcedures(){
        String profileName = '%'+[SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Profile.Name+'%';
        return [SELECT DeveloperName, Label, CSVs_Required__c, Procedure_Apex_Class__c FROM Data_Loader_Procedure__mdt WHERE Active__c = true AND (Profiles_With_Access__c LIKE: profileName OR Profiles_With_Access__c LIKE '%Any%')];
    }

    @AuraEnabled
    public static DataLoaderResults.DataLoaderAuraResults performDataLoadProcedure(List<Object> files, String procedureName){
        Boolean isTest = Test.isRunningTest();
        Map<String,CSVParser> nameToCsvContent = getNameToCsvContent(files);
        String procedureApexClass;
        if(!isTest){
            Data_Loader_Procedure__mdt procedure = [SELECT Batch_Size__c,Procedure_Apex_Class__c FROM Data_Loader_Procedure__mdt WHERE DeveloperName =: procedureName LIMIT 1];
            procedureApexClass = isTest ? procedureName : procedure.Procedure_Apex_Class__c;
            BATCH_SIZE = procedure.Batch_Size__c > 0.0 ? Integer.valueOf(procedure.Batch_Size__c) : BATCH_SIZE;
        }else{
            procedureApexClass = procedureName;
        }
        Type dataLoaderStrategyType = Type.forName(procedureApexClass);
        DataLoaderProcedureStrategy dataLoaderStrategy;
        if(isTest){
            dataLoaderStrategy = new DataLoaderProcedureMock(); 
        }else{
            dataLoaderStrategy = (DataLoaderProcedureStrategy)dataLoaderStrategyType.newInstance();
        }
        DataLoaderResults.DataLoaderAuraResults auraResults = dataLoaderStrategy.executeDataLoad(nameToCsvContent);
        for(String key:nameToCsvContent.keySet()){
            CSVParser csvParser = nameToCsvContent.get(key);
            if(csvParser.isCsvRemaining){
                auraResults.isCsvRemaining = true;
                auraResults.unprocessedCsvs = files;
                break;
            }
        }
        return auraResults;
    }

    private static Map<String,CSVParser> getNameToCsvContent(List<Object> files){
        Map<String,CSVParser> nameToCsvContent = new Map<String,CSVParser>();
        for(Integer i=0; i<files.size(); i++){
            Object oFile = files.remove(i); 
            Map<Object,Object> oFileMap = (Map<Object,Object>) oFile;
            String name = (String)oFileMap.get('name');
            String csvContents = (String)oFileMap.get('file');
            CSVParser csvParser = new CSVParser(csvContents, BATCH_SIZE);
            files.add(new Map<Object,Object>{'name' => name,'file' => csvParser.remainingCsv});
            nameToCsvContent.put(name,csvParser);
        }
        return nameToCsvContent;
    }
}