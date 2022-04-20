global class assignLeadToTerritoriesScheudle implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        String strFields = '';

        for(String strField : Schema.SObjectType.Lead.fields.getMap().keySet()) {
            strFields += strField + ', ';
        }

        if(test.isRunningtest()) {
            strFields = 'Id, Name, Country, State, PostalCode, ';
        }
        
        String m_strAllLeadFields = strFields.substring(0, strFields.length() - 2);
        String strFilterInQuery = 'WHERE No_Mass_Update__c != true';
        String strQuery = 'SELECT ' + m_strAllLeadFields + ' FROM Lead ' + strFilterInQuery;

        Map<Id, Lead> leadmap = new Map<Id, Lead>();
        ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadmap);
        Database.executeBatch(reassignLeadBatchJob, 1);
    }
    
}