public with sharing class CustomLookUpCtrl {

	@AuraEnabled
    public static List<sObject> fetchLookUpValues(String searchKeyWord, String objectName) {
        System.debug('ObjectName-->' + objectName);
        String searchKey = searchKeyWord + '%';
        
        List<sObject> returnList = new List<sObject>();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'SELECT id, Name FROM ' + objectName + ' WHERE Name LIKE :searchKey order by CreatedDate DESC limit 5';
        List<sObject> lstOfRecords = Database.query(sQuery);

        System.debug('lstOfRecords-->' + lstOfRecords);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}