global class DealerScoringBatch implements Database.Batchable<sObject>, Schedulable {
	
	private String query;
	private Map<String, List<DealerFieldScoring__c>> fieldScoringMap;
	public static String ACCOUNT_RECORD_TYPE = 'Business Account';
	public static Set<String> DATETIME_TYPES = new Set<String> {'date', 'datetime'};
	
	global DealerScoringBatch() {

		Id dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_RECORD_TYPE).getRecordTypeId();
		
		this.fieldScoringMap = new Map<String, List<DealerFieldScoring__c>>();
		for (DealerFieldScoring__c fieldScoring : [
			SELECT DealerField__c, FieldValue__c, FieldValueHigh__c, FieldValueLow__c, 
                Scores__c, FieldType__c
            FROM DealerFieldScoring__c
            ORDER BY DealerField__c
		]) {

			if (!this.fieldScoringMap.containsKey(fieldScoring.DealerField__c)) {
				this.fieldScoringMap.put(fieldScoring.DealerField__c, new List<DealerFieldScoring__c>());
			}
			this.fieldScoringMap.get(fieldScoring.DealerField__c).add(fieldScoring);
		}

		this.query = 'SELECT ' + String.join(new List<String>(this.fieldScoringMap.keySet()), ', ') + 
			' FROM Account WHERE RecordTypeId = \'' + dealerRecordTypeId + '\'';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Account> scope) {
		
		for (Account dealer : scope) {
			dealer.DealerScore__c = getDealerScores(dealer);
		}

		update scope;
	}
	
	global void finish(Database.BatchableContext BC) {		
	}

	global void execute(SchedulableContext sc)
    {       
        Database.executeBatch(new DealerScoringBatch());
    }

    private Integer	getDealerScores(Account currDealer) {

    	Integer scores = 0;

    	for (String dealerField : fieldScoringMap.keySet()) {

    		String fieldType = String.valueOf(fieldScoringMap.get(dealerField)[0].FieldType__c).toLowerCase();
    		String currValue = (DATETIME_TYPES.contains(fieldType)) ? 
    			String.valueOf(Datetime.valueOf(currDealer.get(dealerField)).getTime()) :
    			String.valueOf(currDealer.get(dealerField));

    		for (DealerFieldScoring__c fieldScoring : fieldScoringMap.get(dealerField)) {

    			if (String.isNotEmpty(fieldScoring.FieldValue__c)) {

    				if (currValue == null) {
    					continue;
    				}

    				if (currValue.toLowerCase() == String.valueOf(fieldScoring.FieldValue__c).toLowerCase()) {
    					scores += Integer.valueOf(fieldScoring.Scores__c);
    					break;
    				}
    			}
    			else if (String.isNotEmpty(fieldScoring.FieldValueLow__c) 
    				&& String.isNotEmpty(fieldScoring.FieldValueHigh__c)) {

    				Decimal low = Decimal.valueOf(fieldScoring.FieldValueLow__c);
    				Decimal high = Decimal.valueOf(fieldScoring.FieldValueHigh__c);
    				Decimal current = (String.isNotEmpty(currValue)) ? Decimal.valueOf(currValue) : 0;

    				if (current >= low && current < high) {
    					scores += Integer.valueOf(fieldScoring.Scores__c);
    					break;
    				}
    			}
    		}
    	}
    	return scores;
    }
}