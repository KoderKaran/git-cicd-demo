public with sharing class DealerScoringController {

    public static Set<String> NUMBER_TYPES = new Set<String> { 'date', 'datetime', 'integer', 'currency', 'double', 'percent' };

    private static Map<String, Schema.SObjectField> fieldMap = Account.sObjectType.getDescribe().fields.getMap();

    public static Map<String, Field> accountFields {
        get {
            if (accountFields == null) {
                accountFields = getFieldsMap();
            }
            return accountFields;
        }
        private set;
    }

    public class PicklistOption {

        public PicklistOption(Schema.PicklistEntry picklistEntry) {
            this.label = picklistEntry.getLabel();
            this.value = picklistEntry.getValue();
        }

        @AuraEnabled
        public String value { get;set; }
        
        @AuraEnabled
        public String label { get;set; }
    }

	public class Field {

        public Field(Schema.DescribeFieldResult objectField) {
            this.name = objectField.getName();
            this.label = objectField.getLabel();
            this.maxLength = objectField.getLength();
            this.type = String.valueOf(objectField.getType());

            if (this.type == String.valueOf(Schema.DisplayType.Picklist)) {
                this.options = new List<PicklistOption>();
                for (Schema.PicklistEntry picklistEntry : objectField.getPicklistValues()) {
                    this.options.add(new PicklistOption(picklistEntry));
                }
            }
            if (this.type == String.valueOf(Schema.DisplayType.Reference)) {
                this.lookupType = String.valueOf(objectField.getReferenceTo()).substringBetween('(',')');
            }
        }

        @AuraEnabled
        public Integer maxLength { get; set; }
        
        @AuraEnabled
        public String name { get; set; }
        
        @AuraEnabled
        public String label { get; set; }
        
        @AuraEnabled
        public String type { get; set; }

        @AuraEnabled
        public String lookupType { get; set; }

        @AuraEnabled
        public List<PicklistOption> options { get; set; }
    }

    public class FieldScoringWrapper {

        public FieldScoringWrapper(Field currField) {
            this.fieldName = currField.name;
            this.fieldLabel = currField.label;
            this.fieldType = currField.type;
            this.maxLength = currField.maxLength;
            if (this.fieldType == String.valueOf(Schema.DisplayType.Picklist)) {
                this.options = currField.options;
            }
            if (this.fieldType == String.valueOf(Schema.DisplayType.Reference)) {
                this.lookupType = currField.lookupType;
            }
        }

        public FieldScoringWrapper(DealerFieldScoring__c fieldScoring) {

            Field objectField = accountFields.get(fieldScoring.DealerField__c);

            this.fieldName = fieldScoring.DealerField__c;
            this.fieldLabel = objectField.label;
            this.fieldType = objectField.type;
            this.fieldValue = fieldScoring.FieldValue__c;
            this.fieldValueLow = fieldScoring.FieldValueLow__c;
            this.fieldValueHigh = fieldScoring.FieldValueHigh__c;
            this.scores = Integer.valueOf(fieldScoring.Scores__c);
            this.id = fieldScoring.Id;

            if (this.fieldType == String.valueOf(Schema.DisplayType.Picklist)) {
                this.options = objectField.options;
            }
            if (this.fieldType == String.valueOf(Schema.DisplayType.Reference)) {
                this.lookupType = objectField.lookupType;
                //SOQL limits?
                String query = 'SELECT Name FROM ' + this.lookupType + ' WHERE Id = \'' + this.fieldValue + '\'';
                List<sObject> lookupRecords = Database.query(query);
                this.lookupValue = (!lookupRecords.isEmpty()) ? String.valueOf(lookupRecords[0].get('Name')) : '';
            }
        }

        @AuraEnabled
        public Integer maxLength { get; set; }

        @AuraEnabled
        public String fieldName { get;set; }

        @AuraEnabled
        public String fieldLabel { get;set; }

        @AuraEnabled
        public String fieldType { get;set; }

        @AuraEnabled
        public String fieldValue { get;set; }

        @AuraEnabled
        public String fieldValueLow { get;set; }

        @AuraEnabled
        public String fieldValueHigh { get;set; }

        @AuraEnabled
        public Integer scores { get;set; }

        @AuraEnabled
        public String lookupValue { get;set; }

        @AuraEnabled
        public String lookupType { get; set; }

        @AuraEnabled
        public List<PicklistOption> options { get; set; }

        @AuraEnabled
        public String id { get;set; }
    }

    @AuraEnabled
    public static List<FieldScoringWrapper> getNewRows(String currFieldString, Integer fieldCount) {
        List<FieldScoringWrapper> newRows = new List<FieldScoringWrapper>();

        for (Integer i = 0; i < fieldCount; i++) {

            newRows.add(new FieldScoringWrapper(
                (Field)JSON.deserialize(currFieldString, Field.class)
            ));
        }

        return newRows;
    }

    @AuraEnabled
    public static FieldScoringWrapper getNewRow(String currFieldString) {
        return new FieldScoringWrapper(
            (Field)JSON.deserialize(currFieldString, Field.class)
        );
    }

    @AuraEnabled
    public static Map<String, Field> getAccountFields() {
                
        return accountFields;
    }

    @AuraEnabled
    public static void updatePointValues(String fieldScoringsString) {
        List<FieldScoringWrapper> fieldScorings = (List<FieldScoringWrapper>)JSON.deserialize(
            fieldScoringsString, List<FieldScoringWrapper>.class
        );

        List<DealerFieldScoring__c> fieldScoringsToUpdate = new List<DealerFieldScoring__c>();
        for (FieldScoringWrapper wrapper : fieldScorings) {
            fieldScoringsToUpdate.add(
                new DealerFieldScoring__c(
                    Id = wrapper.id,
                    DealerField__c = wrapper.fieldName,
                    Scores__c = wrapper.scores
                )
            );
        }

        try {

            update fieldScoringsToUpdate;
        }
        catch(DmlException exc) {
            throw new AuraHandledException(exc.getMessage());
        }
    }

    @AuraEnabled
    public static void saveFieldScoring(String fieldScoringsString) {
        List<FieldScoringWrapper> fieldScorings = (List<FieldScoringWrapper>)JSON.deserialize(
            fieldScoringsString, List<FieldScoringWrapper>.class
        );

        List<DealerFieldScoring__c> fieldScoringsToUpsert = new List<DealerFieldScoring__c>();
        for (FieldScoringWrapper wrapper : fieldScorings) {
            fieldScoringsToUpsert.add(
                new DealerFieldScoring__c(
                    Id = wrapper.id,
                    DealerField__c = wrapper.fieldName,
                    FieldValue__c = wrapper.fieldValue,
                    FieldValueHigh__c = wrapper.fieldValueHigh,
                    FieldValueLow__c = wrapper.fieldValueLow,
                    FieldType__c = wrapper.fieldType,
                    Scores__c = wrapper.scores
                )
            );
        }

        validateFields(fieldScoringsToUpsert);

        try {

            upsert fieldScoringsToUpsert;
        }
        catch(DmlException exc) {
            throw new AuraHandledException(exc.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteSavedScoringsByName(String recordName) {

        delete [
            SELECT Id
            FROM DealerFieldScoring__c
            WHERE DealerField__c =: recordName
        ];
    }

    @AuraEnabled
    public static void deleteSavedScoring(Id recordId) {

        delete [
            SELECT Id 
            FROM DealerFieldScoring__c 
            WHERE Id =: recordId
        ];
    }

    @AuraEnabled
    public static List<FieldScoringWrapper> getSavedScorings() {

        List<FieldScoringWrapper> wrappers = new List<FieldScoringWrapper>();
        for (DealerFieldScoring__c fieldScoring : [
            SELECT DealerField__c, FieldValue__c, FieldValueHigh__c, FieldValueLow__c, 
                Scores__c, FieldType__c, CreatedDate
            FROM DealerFieldScoring__c
            ORDER BY CreatedDate DESC
        ]) {
            wrappers.add(
                new FieldScoringWrapper(fieldScoring)
            );
        }
        return wrappers;
    }
    
    
    private static Map<String, Field> getFieldsMap() {

        Map<String,Field> labelToField = new Map<String,Field>();
        List<String> fieldLabels = new List<String>();
        String duplicateLabel;

        List<Field> allFields = new List<Field>();
        for (Schema.SObjectField objectField : fieldMap.values()) {
            Field newField = new Field(objectField.getDescribe());

            if (labelToField.containsKey(newField.label)) {
                duplicateLabel = newField.label + ' (2)';
                newField.label = duplicateLabel;
                labelToField.put(duplicateLabel, newField);
                fieldLabels.add(duplicateLabel);
                continue;
            }

            fieldLabels.add(newField.label);
            labelToField.put(newField.label, newField);
        }

        fieldLabels.sort();

        List<Field> sortedFields = new List<Field>();
        for (String fieldLabel : fieldLabels) {
            sortedFields.add(labelToField.get(fieldLabel));
        }

        Map<String,Field> nameToFieldMap = new Map<String,Field>();

        for (Field field : sortedFields) {
            nameToFieldMap.put(field.name, field);
        }

        return nameToFieldMap;
    }

    public static void validateFields(List<DealerFieldScoring__c> fieldScoringsToValidate) {

        Map<String, List<DealerFieldScoring__c>> scoringsMap = new Map<String, List<DealerFieldScoring__c>>();

        for (DealerFieldScoring__c fieldScoring : [
            SELECT DealerField__c, FieldValue__c, FieldValueHigh__c, FieldValueLow__c, 
                Scores__c, FieldType__c
            FROM DealerFieldScoring__c
        ]) {

            if (!scoringsMap.containsKey(fieldScoring.DealerField__c)) {
                scoringsMap.put(fieldScoring.DealerField__c, new List<DealerFieldScoring__c>());
            }
            scoringsMap.get(fieldScoring.DealerField__c).add(fieldScoring);
        }

        for (DealerFieldScoring__c scoringToValidate : fieldScoringsToValidate) {

            if (!scoringsMap.containsKey(scoringToValidate.DealerField__c)) {
                continue;
            }

            if (String.valueOf(scoringToValidate.FieldType__c).toLowerCase() == 'picklist') {

                validatePicklist(scoringToValidate, scoringsMap.get(scoringToValidate.DealerField__c));
            }
            if (String.valueOf(scoringToValidate.FieldType__c).toLowerCase() == 'boolean') {

                validateCheckbox(scoringToValidate, scoringsMap.get(scoringToValidate.DealerField__c));
            }
            if (NUMBER_TYPES.contains(String.valueOf(scoringToValidate.FieldType__c).toLowerCase())) {

                validateNumber(scoringToValidate, scoringsMap.get(scoringToValidate.DealerField__c));
            }

            if (!scoringsMap.containsKey(scoringToValidate.DealerField__c)) {
                scoringsMap.put(scoringToValidate.DealerField__c, new List<DealerFieldScoring__c>());
            }
            scoringsMap.get(scoringToValidate.DealerField__c).add(scoringToValidate);
        }
    }

    private static void validateCheckbox(DealerFieldScoring__c scoringToValidate, List<DealerFieldScoring__c> scorings) {

        if (scorings.size() > 1) {
            throw new AuraHandledException('Points for this field are already specified!');
        }
        if (!scorings.isEmpty() && scorings[0].FieldValue__c == scoringToValidate.FieldValue__c) {
            throw new AuraHandledException('Checkbox values should be different!');
        }
    }

    private static void validatePicklist(DealerFieldScoring__c scoringToValidate, List<DealerFieldScoring__c> scorings) {

        Field picklistField = accountFields.get(scoringToValidate.DealerField__c);

        Set<String> valueSet = new Set<String> { scoringToValidate.FieldValue__c };
        for (DealerFieldScoring__c scoring : scorings) {
            valueSet.add(scoring.FieldValue__c);
        }

        if (scorings.size() == picklistField.options.size()) {
            throw new AuraHandledException('Points for this field are already specified!');
        }

        if (valueSet.size() < picklistField.options.size()) {
            throw new AuraHandledException('Each picklist value should have points associated with it!');
        }
    }

    private static void validateNumber(DealerFieldScoring__c scoringToValidate, List<DealerFieldScoring__c> scorings) {

        if (!scorings.isEmpty()) {

            List<DealerFieldScoring__c> scoringList = new List<DealerFieldScoring__c>(scorings);
            scoringList.add(scoringToValidate);

            for (Integer i = 0; i < scoringList.size() - 1; i++) {
                for (Integer j = i + 1; j < scoringList.size(); j++) {
                    if (numberRangeOverlaps(
                        Decimal.valueOf(scoringList[i].FieldValueLow__c), Decimal.valueOf(scoringList[i].FieldValueHigh__c), 
                        Decimal.valueOf(scoringList[j].FieldValueLow__c), Decimal.valueOf(scoringList[j].FieldValueHigh__c))) {

                        throw new AuraHandledException('No two ranges should overlap one another!');
                    }
                }
            }

        }
    }

    private static Boolean numberRangeOverlaps(Decimal a_start, Decimal a_end, Decimal b_start, Decimal b_end) {
        if (a_start <= b_start && b_start <= a_end) return true; // b starts in a
        if (a_start <= b_end   && b_end   <= a_end) return true; // b ends in a
        if (b_start <  a_start && a_end   <  b_end) return true; // a in b
        return false;
    }
}