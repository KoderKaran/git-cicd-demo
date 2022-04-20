/**
* This class is used to move and/or copy certifications between contact objects
* 	- Search() is used by the lookup field on the component to search for Contacts. This method returns List<LookupSearchResult> back to the Lightning component  
*	- getCertifications() is used to return a list certification to the Lightning component
*	- copyCertifications() is used to copy certifications between contact objects
*	- moveCertifications() is used to move certifications between contact objects
*/
public class C4_CertificationManagerController {

    private final static Integer MAX_RESULTS = 5;
    
    @AuraEnabled
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
		// This method is for the search field. This searches for Contacts
        // Prepare query paramters
        searchTerm += '*';
        
        // Execute search query
        List<List<SObject>> searchResults = [FIND :searchTerm IN Name FIELDS RETURNING
            Contact (Id, Name, AccountName__c WHERE id NOT IN :selectedIds)
            LIMIT :MAX_RESULTS];
        
        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Extract Contacts & convert them into LookupSearchResult
        String contactIcon = 'standard:contact';
        Contact [] contacts = ((List<Contact>) searchResults[0]);
        for (Contact contact : contacts) {
           // string accountName = [select Id, Name from account where Id = contact.A];
            results.add(new LookupSearchResult(contact.Id, 'Contact', contactIcon, contact.Name, 'Account • '+ contact.AccountName__c));
        }

        return results;       
    }
    
    @AuraEnabled
    public static List<C4_Training_Certification__c> getCertifications(Id contactId) {
       return [Select Id, Name, toLabel(Type__c), Training_Date__c, Training_Location__c From C4_Training_Certification__c Where Contact__c = :contactId];
    }
    
    @AuraEnabled
    public static String moveCertifications(Id toContactId, Id fromContactId, List<Id> certIdList) {
       
        List<C4_Training_Certification__c> certList = [select id, Contact__c, Contact__r.Name, Move_Copy_History__c from C4_Training_Certification__c where Id in :certIdList];

        for (C4_Training_Certification__c cert : certList)
        {
        	string moveCopyHistory = cert.Move_Copy_History__c == null ? ('|Moved From_' + cert.Contact__r.Name + '_' + cert.Contact__c + '_' + DateTime.now() +'|') : (cert.Move_Copy_History__c + 'Moved From_' + cert.Contact__r.Name + '_' + cert.Contact__c + '_' + DateTime.now() +'|');
            cert.Contact__c = toContactId;
            cert.Move_Copy_History__c = moveCopyHistory.right(131072);
        }
        
		update certList;
        
       return toContactId + '  ' + fromContactId + '  ' + certIdList.Size(); // This string is not used in the client. It can be used for testing if needed.
    }
    
    @AuraEnabled
    public static String copyCertifications(Id toContactId, Id fromContactId, List<Id> certIdList) {
       
        List<C4_Training_Certification__c> insertList = new List<C4_Training_Certification__c>();
        List<C4_Training_Certification__c> certList = [select id, Name, Cert_Sync__c, Type__c, Certified__c, Comments__c, Contact__c, Contact__r.Name, CreatedById, Get_It_Together_Location__c, Grade__c, Installer_Survey__c, LastModifiedById, Module__c, Move_Copy_History__c, Q1_Received_Manual__c, Q2_Would_manual_be_useful__c, Q3_Rate_Manual_Usefulness__c, Q4_Take_Manual_On_Job__c, Q5_How_log_did_you_use_this__c, Q6_Areas_of_Value__c, Q7_Additional_Comments__c, TBD__c, TBD_Color__c, Training_Date__c, Training_Location__c from C4_Training_Certification__c where Id in :certIdList];
        
        for (C4_Training_Certification__c cert : certList)
        {
            string moveCopyHistory = cert.Move_Copy_History__c == null ? ('|Copied From_' + cert.Contact__r.Name + '_' + cert.Contact__c + '_' + DateTime.now() +'|') : (cert.Move_Copy_History__c + 'Copied From_' + cert.Contact__r.Name + '_' + cert.Contact__c + '_' + DateTime.now() +'|');
            C4_Training_Certification__c newCert = new C4_Training_Certification__c (Cert_Sync__c = cert.Cert_Sync__c
                                                                                 , Type__c = cert.Type__c
                                                                                 //, Certified__c = cert.Certified__c // This is a formula field. Cannot write to this field.
                                                                                 , Comments__c = cert.Comments__c
                                                                                 , Contact__c = toContactId
                                                                                 , CreatedById = cert.CreatedById
                                                                                 , Get_It_Together_Location__c = cert.Get_It_Together_Location__c
                                                                                 , Grade__c = cert.Grade__c
                                                                                 , Installer_Survey__c = cert.Installer_Survey__c
                                                                                 , LastModifiedById = cert.LastModifiedById
                                                                                 , Module__c = cert.Module__c
                                                                                 , Move_Copy_History__c = moveCopyHistory.right(131072)
                                                                                 , Q1_Received_Manual__c = cert.Q1_Received_Manual__c
                                                                                 , Q2_Would_manual_be_useful__c = cert.Q2_Would_manual_be_useful__c
                                                                                 , Q3_Rate_Manual_Usefulness__c = cert.Q3_Rate_Manual_Usefulness__c
                                                                                 , Q4_Take_Manual_On_Job__c = cert.Q4_Take_Manual_On_Job__c
                                                                                 , Q5_How_log_did_you_use_this__c = cert.Q5_How_log_did_you_use_this__c
                                                                                 , Q6_Areas_of_Value__c = cert.Q6_Areas_of_Value__c
                                                                                 , Q7_Additional_Comments__c = cert.Q7_Additional_Comments__c
                                                                                 , TBD__c = cert.TBD__c
                                                                                 , TBD_Color__c = cert.TBD_Color__c
                                                                                 , Training_Date__c = cert.Training_Date__c
                                                                                 , Training_Location__c = cert.Training_Location__c           
            																	);

            insertList.Add(newCert);            
        }

		insert insertList;        
        
       return toContactId + '  ' + fromContactId + '  ' + certIdList.Size();  // This string is not used in the client. It can be used for testing if needed.
    }
 
	// Container class to define the structure of the LookupSearchResult object
    private class LookupSearchResult {
        
        private Id id;
        private String sObjectType;
        private String icon;
        private String title;
        private String subtitle;
    
        public LookupSearchResult(Id id, String sObjectType, String icon, String title, String subtitle) {
            this.id = id;
            this.sObjectType = sObjectType;
            this.icon = icon;
            this.title = title;
            this.subtitle = subtitle;
        }
        
        @AuraEnabled
        public Id getId() {
            return id;
        }
    
        @AuraEnabled
        public String getSObjectType() {
            return sObjectType;
        }
    
        @AuraEnabled
        public String getIcon() {
            return icon;
        }
    
        @AuraEnabled
        public String getTitle() {
            return title;
        }
    
        @AuraEnabled
        public String getSubtitle() {
            return subtitle;
        }
    }
}