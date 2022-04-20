global without sharing class ApexDebugLog{

    // define structure of a log
    public virtual class Log{
        public String Type;
        public String ApexClass;
        public String Method;
        public String RecordId;
        public String Message;
        public String StackTrace;
    }
    
    // Error type, extends from Log
    public class Error extends Log{
        public Error(String cls, String routine, String recId, Exception ex){
            this.Type = 'Error';
            this.ApexClass = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = ex.getMessage();
            this.StackTrace = ex.getStackTraceString();
        }
    }

	// Information type, extends from Log
    public class Information extends Log{
        public Information(String cls, String routine, String recId, String msg){
            this.Type = 'Information';
            this.ApexClass = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = msg;
            this.StackTrace = NULL;
        }
    }

    // method to be used by other Apex classes
    public void createLog(Log log){
        try{
            // Ensure that we're well within the Governor Limits becuase we plan do do another DML statement.
            if((Limits.getDMLRows() < Limits.getLimitDMLRows()) && (Limits.getDMLStatements() < Limits.getLimitDMLStatements()))
            {
                Apex_Debug_Log__c apexDebuglog = new Apex_Debug_Log__c(
                    Type__c         = log.Type,
                    Apex_Class__c   = log.ApexClass,
                    Method__c       = log.Method,
                    Record_Id__c    = log.RecordId,
                    Message__c      = log.Message,
                    Stack_Trace__c  = log.StackTrace
                );

                Database.insert(apexDebuglog, FALSE);
            }
            else{
                System.debug('The Governor Limits have already been exhausted and hence failed to create a Apex Log!');
            }
        }
        catch(DMLException ex){
            System.debug('Something fatal has occurred and hence failed to create a Log! Error:' + ex.getMessage());
        }
    }

    // method to be used by JavaScript for lightning components
    webService
    static void createLog(String log){
        try{
            /*
                Expects a JSON in the form - 
                {
                    "Type"       : "---",
                    "ApexClass"  : "---",
                    "Method"     : "---",
                    "RecordId"   : "---",
                    "Message"    : "---",
                    "StackTrace" : "---",
                }
            */

            /*Deserialize the same to create an instance of the virtual class - ApexDebugLog.Log*/
            ApexDebugLog.Log logToCreate = (ApexDebugLog.Log)JSON.deserialize(log, ApexDebugLog.Log.class);
            
            new ApexDebugLog().createLog(logToCreate);
        }
        catch(Exception ex){
            System.debug('Something fatal has occurred and hence failed to create a Log! Error:' + ex.getMessage());
        }
    }
}