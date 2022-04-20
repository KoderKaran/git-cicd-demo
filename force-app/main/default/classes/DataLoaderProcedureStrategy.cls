public interface DataLoaderProcedureStrategy {
    DataLoaderResults.DataLoaderAuraResults executeDataLoad(Map<String,CSVParser> files);
}