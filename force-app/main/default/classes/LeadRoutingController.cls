public with sharing class LeadRoutingController {

    @RemoteAction
    public static List<Lead_Territory__c> getLeadTerritories() {
        List<Lead_Territory__c> leadTerritories = [
            SELECT Name, Type__c, Effective_Date__c,
                Assigned_To_Type__c, Assigned_To_ID__c,
                Assigned_To__c, Order__c, of_Field_Criteria__c,
                of_Geographic_Criteria__c
            FROM Lead_Territory__c
            ORDER BY Order__c
        ];

        if(leadTerritories.isEmpty()) {
        	return null;
        }

        return leadTerritories;
    }

    @RemoteAction
    public static List<Lead_Territory_Geography__c> getGeographies(Id geographyId) {
    	List<Lead_Territory_Geography__c> geographies = [
			SELECT Lead_Territory__c, Country__c,
                State__c, Zip_End__c,
                Zip_Start__c
            FROM Lead_Territory_Geography__c
            WHERE Lead_Territory__c = :geographyId
            ORDER BY CreatedDate DESC
    	];

    	if(geographies.isEmpty()) {
    		return null;
    	}

    	return geographies;
    }

    @RemoteAction
    public static String removeGeography(Id geographyId) {
    	List<Lead_Territory_Geography__c> geography = [
			SELECT Id
            FROM Lead_Territory_Geography__c
            WHERE Id = :geographyId
    	];

    	if(geography.isEmpty()) {
    		return null;
    	}

		try {
			delete geography;
		} catch(DmlException e) {
			return null;
		}

		return 'Deleted';
    }

    @RemoteAction
    public static List<Lead_Territory_Field_Criteria__c> getCriterias(Id criteriaId) {
    	List<Lead_Territory_Field_Criteria__c> criterias = [
			SELECT Lead_Territory__c, Lead_Field__c,
                    Operator__c, Value__c
            FROM Lead_Territory_Field_Criteria__c
            WHERE Lead_Territory__c = :criteriaId
            ORDER BY CreatedDate DESC
    	];

    	if(criterias.isEmpty()) {
    		return null;
    	}

    	return criterias;
    }

    @RemoteAction
    public static GetValueByFieldWrapper getValueByField(String filedName) {
    	GetValueByFieldWrapper result = new GetValueByFieldWrapper();

    	String fieldType = getFieldType(filedName);

		if(fieldType == 'DATE' || fieldType == 'DATETIME') {
			result.isDate = true;
		} else if(fieldType == 'PICKLIST') {
			result.isPicklist = true;
			result.values = getPicklistValues('Lead', filedName);
		} else {
			result.isText = true;
		}

		return result;
    }

    private static String getFieldType(String filedName) {
    	Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap();

		Schema.DescribeFieldResult lfieldLabel = objectFields.get(filedName).getDescribe();
		Schema.DisplayType dType = lfieldLabel.getType();
		String fieldType = String.ValueOf(dType);

		return fieldType;
    }

    public class GetValueByFieldWrapper {
    	Boolean isDate = false;
    	Boolean isText = false;
    	Boolean isPicklist = false;

    	List<String> values = new List<String>();
    }

    private static List<String> getPicklistValues(String objectName, String fieldName) {
	      List<String> values = new List<String>();
	      List<String> types = new List<String>{objectName};
	      List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(types);

	      for(Schema.DescribeSobjectResult res : results) {
	         for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
	            if (entry.isActive()) {values.add(entry.getValue());}
	         }
	      }

	      return values;
    }

    @RemoteAction
    public static String removeCriteria(Id criteriaId) {
    	List<Lead_Territory_Field_Criteria__c> criteria = [
			SELECT Id
            FROM Lead_Territory_Field_Criteria__c
            WHERE Id = :criteriaId
    	];

    	if(criteria.isEmpty()) {
    		return null;
    	}

		try {
			delete criteria;
		} catch(DmlException e) {
			return null;
		}

		return 'Deleted';
    }

    @RemoteAction
    public static List<String> getTerritoryTypes() {
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Lead_Territory__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }

    @RemoteAction
    public static List<String> getAssignTypes() {
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Lead_Territory__c.Assigned_To_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }

    @RemoteAction
    public static List<Map<String, String>> getLeadFields() {
        Map<String, Schema.SObjectField> fieldMap = Lead.SObjectType.getDescribe().Fields.getMap();
        
        List<Map<String, String>> result = new List<Map<String, String>>();
        
        List<String> fieldLabels = new List<String>();
        List<String> fieldNames = new List<String>();

        for (Schema.SObjectField field: fieldMap.values()) {
            Schema.DescribeFieldResult fieldDes = field.getDescribe();

            result.add(new Map<String, String>{
            	'label' => fieldDes.getLabel(),
            	'value' => fieldDes.getName()
        	});
        }

        if(result.isEmpty()) {
        	return null;
        }

        return result;
    }

 	@RemoteAction
    public static List<SObject> getLookupValue(String objType, String q) {
    	List<SObject> retrievedVal = new List<SObject>();

    	String searchValue = '%' + q + '%';

    	if(objType == 'User') {
    		retrievedVal = [
                SELECT Name, Email
                FROM User 
                WHERE isActive = true
                    AND Name LIKE :searchValue
                LIMIT 5
            ];
    	} else if(objType == 'Lead Queue') {
    		retrievedVal = [
                SELECT Name
                FROM Group
                WHERE Type = 'Queue'
                    AND Name LIKE :searchValue
                LIMIT 5
            ];
    	}

    	if(retrievedVal.isEmpty()) {
    		return null;
    	}

    	return retrievedVal;
    }

    @RemoteAction
    public static Id upsertTerritory(Lead_Territory__c territory) {
    	try {
			upsert territory;
		} catch(DmlException e) {
			return null;
		}

		return territory.Id;
    }

    @RemoteAction
    public static Id upsertGeography(Lead_Territory_Geography__c geography) {
    	try {
			upsert geography;
		} catch(DmlException e) {
			return null;
		}

		return geography.Id;
    }

    @RemoteAction
    public static Id upsertCriteria(Lead_Territory_Field_Criteria__c criteria) {
    	try {
			upsert criteria;
		} catch(DmlException e) {
			return null;
		}

		return criteria.Id;
    }

    @RemoteAction
    public static Boolean updateTerritories(List<Lead_Territory__c> updatedTerritories) {
    	try {
    		update updatedTerritories;
    	} catch(DmlException e) {
    		return false;
    	}

    	return true;
    }

    @RemoteAction
    public static void setupStatus(String status) {
        Boolean hasLeadTerrtorySetup = false;
        for(Territory_Setup__c item : [
                SELECT Next_Mass_Update_Date_Lead__c, Status__c
                FROM Territory_Setup__c
                ORDER BY LastModifiedDate
                DESC LIMIT 1
            ]) {

            hasLeadTerrtorySetup = true;
            item.Status__c = status;
            update item;

            List<CronJobDetail> jobDetails = [SELECT Id FROM CronJobDetail WHERE Name = 'Mass Update Leads'];
            List<CronTrigger> conTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetailId in :jobDetails];
            database.delete([SELECT Job_ID__c FROM MassUpdateLeadJOBID__c WHERE Job_ID__c != null LIMIT 1]);
            
            for(CronTrigger conTrigger : conTriggers) {
                System.abortJob(conTrigger.Id); 
            }
            
            if(status == 'On') {
                if(item.Next_Mass_Update_Date_Lead__c != null) {
                    Date massUpdateDate = item.Next_Mass_Update_Date_Lead__c;
                    String year = string.valueOf(massUpdateDate.year());
                    String month = string.valueOf(massUpdateDate.month());
                    String day = string.valueOf(massUpdateDate.day());
                    
                    assignLeadToTerritoriesScheudle m = new assignLeadToTerritoriesScheudle();
                    String sch = '0 0 1 ' + day + ' ' + month + ' ? ' + year;
                    String jobID = system.schedule('Mass Update Leads', sch, m);
                    if(jobID != null) {
                        MassUpdateLeadJOBID__c newJob = new MassUpdateLeadJOBID__c(Name = 'Lead JOB', Job_ID__c = jobID);
                        insert newJob;
                    }
                }
            }
        }

        if(!hasLeadTerrtorySetup) {
            Territory_Setup__c theLeadTerr = new Territory_Setup__c(Status__c = status);
            insert theLeadTerr;
        }
    }

    @RemoteAction
    public static Territory_Setup__c getLeadTerritorySetup() {
    	List<Territory_Setup__c> leadTerrSetups = [
            SELECT Next_Mass_Update_Date_Lead__c, Status__c
            FROM Territory_Setup__c 
            ORDER BY LastModifiedDate
            DESC LIMIT 1
        ];

        Territory_Setup__c leadTerrSetup;

        if(!leadTerrSetups.isEmpty()) {
            leadTerrSetup = leadTerrSetups.get(0);
        } else {
            leadTerrSetup = new Territory_Setup__c(Status__c = 'On');

            try {
            	insert leadTerrSetup;
            } catch(DmlException e) {
            	return null;
            }
        }

        return leadTerrSetup;
    }

    @RemoteAction
    public static Boolean saveMassUpdatedDate(Id territoryId, String territoryNextMassUpdate, String territoryStatus) {
    	Territory_Setup__c territorySetup = new Territory_Setup__c(
    		Id = territoryId,
    		Next_Mass_Update_Date_Lead__c = Date.parse(territoryNextMassUpdate),
    		Status__c = territoryStatus
		);

    	if(territorySetup.Status__c == 'Off') {
    		return false;
    	}

        System.savePoint savepoint = Database.setSavePoint();

        try {
            upsert territorySetup;
            
            List<MassUpdateLeadJOBID__c> jobs = [SELECT Job_ID__c FROM MassUpdateLeadJOBID__c];
            
            for(MassUpdateLeadJOBID__c job : jobs) {
                if(job.Job_ID__c != null) {
                    System.abortJob(job.Job_ID__c); 
                }
            }

            if(!jobs.isEmpty()) {                
                delete jobs;
            }

            Date massUpdateDate = territorySetup.Next_Mass_Update_Date_Lead__c;

            String year = String.valueOf(massUpdateDate.year());
            String month = String.valueOf(massUpdateDate.month());
            String day = String.valueOf(massUpdateDate.day());

            assignLeadToTerritoriesScheudle m = new assignLeadToTerritoriesScheudle();

            String sch = '0 0 1 ' + day + ' ' + month + ' ? ' + year;
            String jobID = system.schedule('Mass Update Leads', sch, m);
            MassUpdateLeadJOBID__c newJob = new MassUpdateLeadJOBID__c(Name = 'Lead JOB', Job_ID__c = jobID);
            insert newJob;
        } catch(Exception ex) {
            Database.rollBack(savepoint);

            return false;
        }

    	return true;
    }

    @RemoteAction
    public static Boolean massUpdateTerritoriesImmed(Id territoryId, String territoryNextMassUpdate, String territoryStatus) {
        Territory_Setup__c territorySetup = new Territory_Setup__c(
    		Id = territoryId,
    		Next_Mass_Update_Date_Lead__c = Date.parse(territoryNextMassUpdate),
    		Status__c = territoryStatus
		);

        try {
            upsert territorySetup;
        } catch(DmlException e) {
            return false;   
        }

        if(territorySetup.Status__c == 'Off') {        
    		return false;
        }

        String strFields = '';

        for(String strField : Schema.SObjectType.Lead.fields.getMap().keySet()) {
            strFields += strField + ', ';
        }

        String m_strAllLeadFields = strFields.substring(0, strFields.length() - 2);
        String strFilterInQuery = 'WHERE No_Mass_Update__c != true';
        String strQuery = 'SELECT ' + m_strAllLeadFields + ' FROM Lead ' + strFilterInQuery;
        
        Map<Id, lead> leadmap = new Map<Id, Lead>();
        ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadmap);
        Database.executeBatch(reassignLeadBatchJob, 1);

        return true;
    }

    @RemoteAction
    public static List<Lead_Territory_Geography__c> insertNewLeadTerritoryGeosByCSV(Id territoryId, String assignmentsCSV) {
        List<Lead_Territory_Geography__c> csvAssignments = analyseCSVString(assignmentsCSV);

        List<Lead_Territory_Geography__c> needToInsertTerritoryGeos = new List<Lead_Territory_Geography__c>();
        for(Lead_Territory_Geography__c newLeadTerritoryGeo : csvAssignments) {  
            if(String.isNotBlank(territoryId)) {
                newLeadTerritoryGeo.Lead_Territory__c = territoryId;
                needToInsertTerritoryGeos.add(newLeadTerritoryGeo);
            }
        }

        if(needToInsertTerritoryGeos.isEmpty()) {
        	return null;
        }

        try {
            insert needToInsertTerritoryGeos;
        } catch(DmlException e) {
        	return null;
        }

        return needToInsertTerritoryGeos;
    }

    private static List<Lead_Territory_Geography__c> analyseCSVString(String assignmentCsv) {
        List<Lead_Territory_Geography__c> assignmentDetails = new List<Lead_Territory_Geography__c>();
        
        if(assignmentCsv != null && assignmentCsv != '') {    
            List<String> csvLines = assignmentCsv.split('\n');

            for(String csvLine : csvLines) {
                List<String> fieldValues = analyseCsvLine(csvLine);
                Lead_Territory_Geography__c detail = new Lead_Territory_Geography__c();

                for(Integer i = 0; i < fieldValues.size(); i++) {
                    if(i == 0) {
                        detail.Country__c = fieldValues.get(i);
                    } else if(i == 1) {
                        detail.State__c = fieldValues.get(i);
                    } else if(i == 2) {
                        detail.zip_Start__c = fieldValues.get(i);
                    } else if(i == 3) {
                        detail.zip_End__c = fieldValues.get(i);
                    }
                }
                
                assignmentDetails.add(detail);
            }
        }

        return assignmentDetails;
    }

    private static List<String> analyseCsvLine(String cvsLine) {
        List<String> analyseResults = new List<String>();
        
        if(cvsLine != null) {
            cvsLine = cvsLine.trim() + ',';

            Pattern cvsPattern = Pattern.compile('("[^"]*("{2})*[^"]*")*[^,]*,'); 
            Matcher cvsMatcher = cvsPattern.matcher(cvsLine);
            String tempCell;

            while(cvsMatcher.find()) {
                tempCell = cvsMatcher.group();
                tempCell = replaceDoubleQuotationMarks(tempCell);
                analyseResults.add(tempCell);
            }
        }

        return analyseResults;
    }

    private static String replaceDoubleQuotationMarks(String input) {
        if(String.isNotBlank(input)) {
            input = input.trim();

            if(input.startsWith('"')) {
                input = input.replaceAll('^"', '');
                input = input.replaceAll('",$', '');    
                input = input.replaceAll('""', '"');
            } else {
                input = input.replaceAll(',$','' );
            }
            
            return input;
        }

        return '';
    }

}