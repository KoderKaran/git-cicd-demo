@isTest
private class DealerScoringControllerTest {

    @testSetup
    static void setup() {

        List<DealerFieldScoring__c> listToInsert = new List<DealerFieldScoring__c>();
        listToInsert.add(
            new DealerFieldScoring__c(
                DealerField__c = 'Name',
                FieldValue__c = 'Test1',
                FieldType__c = 'text',
                Scores__c = 1
            )
        );

        listToInsert.add(
            new DealerFieldScoring__c(
                DealerField__c = 'LastName',
                FieldValue__c = 'Test2',
                FieldType__c = 'text',
                Scores__c = 2
            )
        );

        listToInsert.add(
            new DealerFieldScoring__c(
                DealerField__c = 'FirstName',
                FieldValue__c = 'Test3',
                FieldType__c = 'text',
                Scores__c = 3
            )
        );

        insert listToInsert;
    }

    static void validationSetup() {
        List<DealerFieldScoring__c> scoringsToInsert = new List<DealerFieldScoring__c>{
            new DealerFieldScoring__c(
                DealerField__c = 'Application_Date__c',
                FieldValueLow__c = '12345',
                FieldValueHigh__c = '12350',
                FieldType__c = 'date',
                Scores__c = 3
            ),
            new DealerFieldScoring__c(
                DealerField__c = 'Store_Number__c',
                FieldValueLow__c = '123',
                FieldValueHigh__c = '125',
                FieldType__c = 'integer',
                Scores__c = 3
            ),
            new DealerFieldScoring__c(
                DealerField__c = 'Deleted',
                FieldValue__c = 'true',
                FieldType__c = 'boolean',
                Scores__c = 3
            ),
            new DealerFieldScoring__c(
                DealerField__c = 'Deleted',
                FieldValue__c = 'false',
                FieldType__c = 'boolean',
                Scores__c = 3
            ),
            new DealerFieldScoring__c(
                DealerField__c = 'Account_Status__c',
                FieldValue__c = 'Active',
                FieldType__c = 'picklist',
                Scores__c = 3
            ),
            new DealerFieldScoring__c(
                DealerField__c = 'Account_Status__c',
                FieldValue__c = 'Inactive',
                FieldType__c = 'picklist',
                Scores__c = 4
            ),
            new DealerFieldScoring__c(
                DealerField__c = 'Account_Status__c',
                FieldValue__c = 'Terminated',
                FieldType__c = 'picklist',
                Scores__c = 5
            )
        };

        insert scoringsToInsert;
    }

    @isTest
    static void validationTest() {

        validationSetup();

        String wrapperDate = generateFieldScoringWrapper('Application_Date__c', 'date', '12300', '12350', 4);
        String wrapperNumber = generateFieldScoringWrapper('Store_Number__c', 'integer', '124', '125', 4);
        String wrapperBoolean = generateFieldScoringWrapper('Deleted', 'boolean', 'true', 4);
        String wrapperPicklist = generateFieldScoringWrapper('Account_Status__c', 'picklist', 'Terminated', 4);

        Test.startTest();

        try {
            DealerScoringController.saveFieldScoring(wrapperDate);
        } catch (AuraHandledException exc) {
            System.assertEquals(exc.getMessage(), 'Script-thrown exception');
        }

        try {
            DealerScoringController.saveFieldScoring(wrapperNumber);
        } catch (AuraHandledException exc) {
            System.assertEquals(exc.getMessage(), 'Script-thrown exception');
        }

        try {
            DealerScoringController.saveFieldScoring(wrapperBoolean);
        } catch (AuraHandledException exc) {
            System.assertEquals(exc.getMessage(), 'Script-thrown exception');
        }

        try {
            DealerScoringController.saveFieldScoring(wrapperPicklist);
        } catch (AuraHandledException exc) {
            System.assertEquals(exc.getMessage(), 'Script-thrown exception');
        }

        Test.stopTest();
    }
	
	@isTest 
    static void getAccountFieldsTest() {
		
        Map<String, DealerScoringController.Field> fields;

        Test.startTest();
        fields = DealerScoringController.getAccountFields();
        Test.stopTest();

        System.assertEquals(Account.sObjectType.getDescribe().fields.getMap().size(), fields.size());
	}

    @isTest 
    static void getNewRowsTest() {
        
        List<DealerScoringController.FieldScoringWrapper> wrappers;
        Map<String, DealerScoringController.Field> fields = DealerScoringController.getAccountFields();

        Test.startTest();
        wrappers = DealerScoringController.getNewRows(
            JSON.serialize(fields.values()[0]),
            3
        );
        Test.stopTest();

        System.assertEquals(fields.values()[0].name, wrappers[0].fieldName);
        System.assertEquals(wrappers.size(), 3);
    }
	
	@isTest 
    static void getNewRowTest() {
		
        DealerScoringController.FieldScoringWrapper wrapper;
        Map<String, DealerScoringController.Field> fields = DealerScoringController.getAccountFields();

        Test.startTest();
        wrapper = DealerScoringController.getNewRow(
            JSON.serialize(fields.values()[0])
        );
        Test.stopTest();

        System.assertEquals(fields.values()[0].name, wrapper.fieldName);
	}

    @isTest 
    static void getSavedScoringsTest() {

        List<DealerFieldScoring__c> scorings = [
            SELECT Id
            FROM DealerFieldScoring__c
        ];

        Test.startTest();
        List<DealerScoringController.FieldScoringWrapper> wrappers = DealerScoringController.getSavedScorings();
        Test.stopTest();

        System.assertEquals(scorings.size(), wrappers.size());
    }

    @isTest 
    static void deleteSavedScoringTest() {

        List<DealerFieldScoring__c> oldScorings = [
            SELECT Id
            FROM DealerFieldScoring__c
        ];

        Test.startTest();
        DealerScoringController.deleteSavedScoring(oldScorings[0].Id);
        Test.stopTest();

        Integer newScoringsSize = [
            SELECT COUNT()
            FROM DealerFieldScoring__c
        ];

        System.assertEquals(oldScorings.size() - 1, newScoringsSize);
    }

    @isTest
    static void updateFieldValuesTest() {
        Integer newScore = 100;

        List<DealerScoringController.FieldScoringWrapper> wrappers = DealerScoringController.getSavedScorings();
        for (DealerScoringController.FieldScoringWrapper wrapper : wrappers) {
            wrapper.scores = newScore;
        }

        Test.startTest();
        DealerScoringController.updatePointValues(
            JSON.serialize(wrappers)
        );
        Test.stopTest();

        for (DealerFieldScoring__c newScoring : [
            SELECT Scores__c
            FROM DealerFieldScoring__c
        ]) {

            System.assertEquals(newScore, newScoring.Scores__c);
        }   
    }

	@isTest 
    static void saveFieldScoringTest() {

        Integer newScore = 100;

        List<DealerScoringController.FieldScoringWrapper> wrappers = DealerScoringController.getSavedScorings();
        for (DealerScoringController.FieldScoringWrapper wrapper : wrappers) {
            wrapper.scores = newScore;
        }

        Test.startTest();
        DealerScoringController.saveFieldScoring(
            JSON.serialize(wrappers)
        );
        Test.stopTest();

        for (DealerFieldScoring__c newScoring : [
            SELECT Scores__c
            FROM DealerFieldScoring__c
        ]) {

            System.assertEquals(newScore, newScoring.Scores__c);
        }   
    }

    private static String generateFieldScoringWrapper(String fieldName, String fieldType, String value, Integer scores) {
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        generator.writeStartObject();
        generator.writeStringField('fieldName', fieldName);
        generator.writeStringField('fieldType', fieldType);
        generator.writeStringField('fieldValue', value);
        generator.writeNumberField('scores', scores);

        return generator.getAsString();
    }

    private static String generateFieldScoringWrapper(String fieldName, String fieldType, String lowValue, String highValue, Integer scores) {

        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        generator.writeStartObject();
        generator.writeStringField('fieldName', fieldName);
        generator.writeStringField('fieldType', fieldType);
        generator.writeStringField('fieldValueLow', lowValue);
        generator.writeStringField('fieldValueHigh', highValue);
        generator.writeNumberField('scores', scores);

        return generator.getAsString();
    }
}