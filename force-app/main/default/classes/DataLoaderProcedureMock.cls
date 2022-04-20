@isTest
public class DataLoaderProcedureMock implements DataLoaderProcedureStrategy{

    private final DataLoaderResults dataLoaderResults;

    public DataLoaderProcedureMock(){
        dataLoaderResults = new DataLoaderResults();
        dataLoaderResults.setTables(new List<String>{'Inserted Accounts'});
        dataLoaderResults.setTableColumns('Inserted Accounts', new List<String>{'Id'});
    }

    public DataLoaderResults.DataLoaderAuraResults executeDataLoad(Map<String,CSVParser> files){
        CSVParser accountCsv = files.get('test-account-load-csv');
        List<Account> accs = new List<Account>();
        for(String accName:accountCsv.values.get(0)){
            accs.add(new Account(Name = accName));
        }
        List<Database.SaveResult> accountSrs = Database.insert(accs);
        for(Database.SaveResult sr:accountSrs){
            if(sr.isSuccess()){
                this.dataLoaderResults.addTableRow('Inserted Accounts', new Map<String,String>{'Id'=>sr.getId()});
            }
        }
        return this.dataLoaderResults.getAuraResults();
    }

}