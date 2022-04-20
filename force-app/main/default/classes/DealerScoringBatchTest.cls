@isTest
private class DealerScoringBatchTest {

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
                DealerField__c = 'Site',
                FieldValue__c = 'Test2',
                FieldType__c = 'text',
                Scores__c = 2
            )
        );

        listToInsert.add(
            new DealerFieldScoring__c(
                DealerField__c = 'NumberOfEmployees',
                FieldValueLow__c = '4',
                FieldValueHigh__c = '10',
                FieldType__c = 'number',
                Scores__c = 3
            )
        );

        insert listToInsert;

        Id dealerRecordTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get(DealerScoringBatch.ACCOUNT_RECORD_TYPE).getRecordTypeId();

        Account testAcc = new Account(
            Name = 'Test1',
            Site = 'Test2',
            NumberOfEmployees = 5,
            RecordTypeId = dealerRecordTypeId
        );

        insert testAcc;
    }
	
	@isTest 
    static void DealerScoringBatchTest() {
		
        Test.startTest();
        Database.executeBatch(new DealerScoringBatch());
        Test.stopTest();

        Account acc = [
            SELECT DealerScore__c
            FROM Account
            LIMIT 1
        ];

        List<AggregateResult> res = [
            SELECT SUM(Scores__c) scores
            FROM DealerFieldScoring__c
        ];

        System.assertEquals(res[0].get('scores'), acc.DealerScore__c);
	}
	
	
}