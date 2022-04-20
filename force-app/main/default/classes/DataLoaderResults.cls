public with sharing class DataLoaderResults {
    private List<String> tableNames;
    private final Map<String,List<String>> tableColumns = new Map<String,List<String>>();
    private Map<String,List<Map<String,String>>> tableRows = new Map<String,List<Map<String,String>>>();

    public Boolean setTables(List<String> newTables){
        if(this.tableNames == null && newTables != null && newTables.size() > 0){
            for(String tableName:newTables){
                if(String.isBlank(tableName)){
                    return false;
                }
            }
            this.tableNames = newTables;
            for(String tableName:this.tableNames){
                this.tableRows.put(tableName, new List<Map<String,String>>());
            }
        }
        return true;
    }

    public void setTableColumns(String tableName, List<String> newColumns){
        if(!this.tableColumns.containsKey(tableName) && String.isNotBlank(tableName) && newColumns != null && newColumns.size() > 0){
            this.tableColumns.put(tableName, newColumns);
        }
    }

    public Boolean addTableRow(String tableName, Map<String,String> tableRow){
        if(String.isNotBlank(tableName) && tableRow != null && tableRow.keySet().size() > 0){
            List<String> currTableColumns = this.tableColumns.get(tableName);
            if(tableRow.keySet().size() > currTableColumns.size()) return false;
            for(String tableColumn:tableRow.keySet()){
                if(!currTableColumns.contains(tableColumn)){
                    return false;
                }
            }
            this.tableRows.get(tableName).add(tableRow);
            return true;
        }
        return false;
    }

    public List<Map<String,String>> addMultipleTableRows(String tableName,List<Map<String,String>> newRows){
        List<Map<String,String>> failures = new List<Map<String,String>>();
        for(Map<String,String> newRow:newRows){
            if(!this.addTableRow(tableName, newRow)){
                failures.add(newRow);
            }
        }
        return failures;
    }

    public List<String> getSetOfValuesInColumn(String tableName, String columnName){
        Set<String> values = new Set<String>();
        for(Map<String,String> row:this.tableRows.get(tableName)){
            for(String rowColumn:row.keySet()){
                if(rowColumn.equals(columnName)){
                    String value = row.get(rowColumn);
                    if(String.isNotBlank(value)){
                        values.add(value);
                    }
                }
            }
        }
        return new List<String>(values);
    }

    public DataLoaderAuraResults getAuraResults(){
        DataLoaderAuraResults dlar = new DataLoaderAuraResults();
        dlar.tableColumns = this.tableColumns;
        dlar.tableRows = this.tableRows;
        return dlar;
    }

    public class DataLoaderAuraResults{
        @AuraEnabled
        public Map<String,List<String>> tableColumns;
        @AuraEnabled
        public Map<String,List<Map<String,String>>> tableRows;
        @AuraEnabled
        public Boolean isCsvRemaining;
        @AuraEnabled
        public List<Object> unprocessedCsvs;
    }

}