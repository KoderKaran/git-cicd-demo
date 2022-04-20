public class CSVParser {
    public List<String> headers = new List<String>();
    public List<List<String>> values = new List<List<String>>();
    public Boolean isCsvRemaining;
    public String remainingCsv;

    public CSVParser(String csv, Integer batchSize){
        System.debug('$$$' + csv);
        if(csv == null){
            return;
        }
        List<String> csvSplit = csv.split('\\n');
        Integer csvRows = csvSplit.size();
        Integer iterStop = (csvRows - batchSize) < 0 ? 0 : (csvRows - batchSize);
        this.headers = this.processRow(csvSplit.get(0).toLowercase().removeEnd('\r'));
        for(Integer i=csvRows-1; i>=iterStop; i--){
            List<String> rowSplit = this.processRow(csvSplit.remove(i).toLowercase().removeEnd('\r'));
            if(rowSplit.size() == 0 || i == 0){
                continue;
            }
            values.add(rowSplit);
        }
        this.remainingCsv = String.join(csvSplit, '\n');
        this.isCsvRemaining = csvSplit.size() > 0;
    }

    private List<String> processRow(String row){
        List<String> rowCharacters = row.split('');
        String newRow = '';
        Boolean inQuotes = false;
        String falseCommaIdentifier = '<!FALSE COMMA WAS HERE!>';
        for(String rowChar:rowCharacters){
            if(rowChar.equals('"')){
                inQuotes = !inQuotes;
                continue;
            }
            if(rowChar.equals('')){
                continue;
            }
            if(inQuotes && rowChar.equals(',')){
                newRow += falseCommaIdentifier;
            }else{
                newRow += rowChar;
            }
        }
        List<String> newRowSplit = newRow.split(',');
        List<String> finalRow = new List<String>();
        for(String rowElement:newRowSplit){
            finalRow.add(rowElement.replaceAll(falseCommaIdentifier, ','));
        }
        return finalRow;
    }

    // public List<String> getAllHeaderValues(String headerValue){
    //     Integer indexOfHeader = this.headers.indexOf(headerValue.toLowerCase());
    //     if(indexOfHeader == -1){
    //         throw new InvalidHeaderException('Invalid Header ' + headerValue);
    //     }
    //     List<String> valuesToReturn = new List<String>();
    //     for(Integer i=0; i<this.values.size(); i++){
    //         valuesToReturn.add(this.values.get(i).get(indexOfHeader));
    //     }
    //     return valuesToReturn;
    // }

    // public List<sObject> upsertCSVs(sObjectType targetObjectType, String keyFieldName){
    //     String objectName = targetObjectType.getDescribe().getLocalName();
    //     List<sObject> csvRecords = this.csvToSObjects(targetObjectType, this.headers);
    //     List<Object> keyFieldValues = new List<Object>();
    //     for(sObject csvRecord:csvRecords){
    //         keyFieldValues.add(csvRecord.get(keyFieldName));
    //     }
    //     List<sObject> existingRecords = Database.query(this.buildQueryWithKeyField(objectName, keyFieldName, keyFieldValues));
    //     Map<Object, sObject> keyFieldToCSVRecords = this.buildKeyFieldToRecordsMap(keyFieldName, csvRecords);
    //     Map<Object, sObject> keyFieldToExistingRecords = this.buildKeyFieldToRecordsMap(keyFieldName, existingRecords);
    //     List<sObject> resultRecords = new List<sObject>();
    //     for(Object key:keyFieldValues){
    //         sObject csvRecord = keyFieldToCSVRecords.get(key);
    //         if(!keyFieldToExistingRecords.containsKey(key)){
    //             resultRecords.add(csvRecord);
    //             continue;
    //         }
    //         sObject existingRecord = keyFieldToExistingRecords.get(key);
    //         for(String field:this.headers){
    //             existingRecord.put(field, csvRecord.get(field));
    //         }
    //         resultRecords.add(existingRecord);
    //     }
    //     Schema.SobjectField keySObjectField = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(keyFieldName);
    //     Database.UpsertResult[] dbUpsertResults = Database.upsert(resultRecords, keySObjectField, false);
    //     //process results
    //     return resultRecords;
    // }

    // private String buildQueryWithKeyField(String objectName, String keyFieldName, List<Object> keyFieldValues){
    //     return 'SELECT Id, ' + String.join(this.headers, ',') + ' FROM ' + objectName + ' WHERE ' + keyFieldName + ' IN (' + String.join(keyFieldValues, ',') + ')';
    // }

    // private Map<Object, sObject> buildKeyFieldToRecordsMap(String keyFieldName, List<sObject> records){
    //     Map<Object, sObject> keyFieldToRecords = new Map<Object, sObject>();
    //     for(sObject record:records){
    //         keyFieldToRecords.put(record.get(keyFieldName), record);
    //     }
    //     return keyFieldToRecords;
    // }

    // public List<sObject> csvToSObjects(sObjectType targetObjectType, List<String> headersToConvert){
    //     List<sObject> sObjects = this.initializeBlanksObjects(targetObjectType);
    //     if(headersToConvert == null || headersToConvert.size() == 0){
    //         headersToConvert = this.headers;
    //     }
    //     for(Integer i=0; i<this.values.size(); i++){
    //         List<String> rows = this.values.get(i);
    //         for(Integer j=0; j<rows.size(); j++){
    //             Schema.SObjectField field = this.getSObjectField(targetObjectType, this.headers.get(j));
    //             if(field == null){
    //                 continue;
    //             }
    //             if(headersToConvert.contains(field.getDescribe().getLocalName())){
    //                 sObjects.get(i).put(field.getDescribe().getLocalName(), this.fieldToCorrectType(rows.get(j), field));
    //             }
    //         }
    //     }
    //     return sObjects;
    // }

    public Map<String,sObject> csvToSObjectsMappedToKeyField(sObjectType targetObjectType, List<String> headersToConvert, String keyField){
        List<sObject> sObjects = this.initializeBlanksObjects(targetObjectType);
        Map<String,sObject> keyFieldToSObjects = new Map<String,sObject>();
        Integer keyFieldIndex = this.headers.indexOf(keyField);
        if(keyFieldIndex == -1){
            throw new InvalidHeaderException('Invalid Header ' + keyFieldIndex);
        }
        for(Integer i=0; i<this.values.size(); i++){
            List<String> rows = this.values.get(i);
            sObject result = sObjects.get(i);
            for(String fieldLabel:headersToConvert){
                if(this.headers.contains(fieldLabel)){
                    Schema.SObjectField field = this.getSObjectField(targetObjectType, fieldLabel);
                    if(field == null){
                        continue;
                    }
                    result.put(field.getDescribe().getLocalName(), this.fieldToCorrectType(rows.get(this.headers.indexOf(fieldLabel)), field));
                }
            }
            keyFieldToSObjects.put(rows.get(keyFieldIndex).toUpperCase(),result);
        }
        return keyFieldToSObjects;
    }

    private List<sObject> initializeBlanksObjects(sObjectType targetObjectType){
        List<sObject> sObjects = new List<sObject>();
        for(Integer i=0; i<this.values.size(); i++){
            sObjects.add(targetObjectType.newSObject());
        }
        return sObjects;
    }

    private Schema.SObjectField getSObjectField(sObjectType targetObjectType, String fieldLabel){
        Map<String,Schema.SObjectField> mfields = targetObjectType.getDescribe().fields.getMap();
        for(String strField:mfields.keySet()){
            SObjectField fl = mfields.get(strField);
            if(fieldLabel == fl.getDescribe().getlabel()){
                return fl;
            }
        }
        return null;
    }

    private Object fieldToCorrectType(String value, Schema.SObjectField field){
        Schema.SOAPType fieldType = field.getDescribe().getSoapType();
        switch on fieldType{ 
            when DATE{
                return Date.parse(value);
            }
            when DATETIME{
                return DateTime.parse(value);
            }
            when ID{
                return Id.valueOf(value);
            }
            when INTEGER, DOUBLE{
                return Double.valueOf(value);
            }
            when BOOLEAN {
                return Boolean.valueOf(value);
            }
        }
        return value;
    }
    public class InvalidHeaderException extends Exception{}
}