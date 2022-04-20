public class CaseCreationController {

    private final static Integer MAX_RESULTS = 6;
    
    @AuraEnabled(cacheable=true) 
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
    // This method is for the search field. This searches for Contacts
        // Prepare query paramters
        searchTerm += '*';
        
        // Execute search query
        //List<List<SObject>> searchResults = [FIND :searchTerm IN Name FIELDS RETURNING
        //    Account (Id, Name, AccountName__c WHERE id NOT IN :selectedIds and ispersonaccount = true)
        //    LIMIT :MAX_RESULTS];
        
        List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING
            Account (Id, MyControl4_Name__pc, Name, AccountName__c WHERE id NOT IN :selectedIds and ispersonaccount = true)
            LIMIT :MAX_RESULTS];
        
        
        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Extract Contacts & convert them into LookupSearchResult
        String contactIcon = 'standard:person_account';
        Account [] accounts = ((List<Account>) searchResults[0]);
        for (Account account : accounts) {
           // string accountName = [select Id, Name from account where Id = contact.A];
            results.add(new LookupSearchResult(account.Id, 'Account', contactIcon,  account.AccountName__c, account.MyControl4_Name__pc));
        }

        return results;       
    }
    
    @auraEnabled
    public static CaseDataTranferObject getContactName(string contactId)
    {      
        CaseDataTranferObject caseDTO = new CaseDataTranferObject();
        
        // Get the Origin picklist values
        Schema.DescribeFieldResult origins = Case.Origin.getDescribe();        
        for( Schema.PicklistEntry f : origins.getPicklistValues())
        {
            caseDTO.Origin .add(f.getValue());
        }         

        // Get the Status picklist values
        Schema.DescribeFieldResult statuses = Case.status.getDescribe();        
        for( Schema.PicklistEntry f : statuses.getPicklistValues())
        {
            caseDTO.Status .add(f.getValue());
        }   
        
        // Get the Accounts 
        for (AccountContactRelation account : [select AccountId, Account.Name, Account.SAP_ACCOUNT_ID__c from AccountContactRelation where ContactId = :contactId and Account.Account_Status__c = 'Active']) 
        {
            caseDTO.Account.Add(account);       
        }      
        
        // Get Controllers
        caseDTO.Controller.Add('Unknown'); 
        for (C4_Controller__mdt label : [SELECT MasterLabel, orderby__c FROM C4_Controller__mdt ORDER BY orderby__c]) 
        {
            caseDTO.Controller.Add(label.Masterlabel);       
        }
        
        // Get Software Versions
        caseDTO.SoftwareVersion.Add('Unknown'); 
        for (C4_Controller_Software__mdt label : [SELECT MasterLabel, orderby__c FROM C4_Controller_Software__mdt ORDER BY orderby__c asc]) 
        {
            caseDTO.SoftwareVersion.Add(label.Masterlabel);       
        }
        
        return caseDTO;       
    } 
    
    @auraEnabled
    public static string createCase(string contactId, string accountId, string origin, string customer, string mycontrol4name, string controller, string softwareVersion, string subject, string description)
    {         
        try {
            
            Case caseObj = new Case(ContactId = contactId,
                                    AccountId = accountId,
                                    Status = 'Open',
                                    PersonAccount__c = customer,
                                    MyControl4_Name__c =  mycontrol4name,            
                                    Origin = origin,
                                    Customer_Controller__c =  controller,   
                                    Customer_Software_Version__c =  softwareVersion,  
                                    Subject =  subject,
                                    Description =  description);                
            insert caseObj;
            
          return 'true' + caseObj.Id;
        } 
        catch(DmlException e) 
        {
            return 'Error: ' + e.getMessage();            
        }
    }
    

    public class CaseDataTranferObject {
        
        @AuraEnabled
        public string ContactName;
        
        @AuraEnabled
        public List<string> Origin = new List<string>();

        @AuraEnabled
        public List<string> Status = new List<string>();
        
        @AuraEnabled
        public List<AccountContactRelation> Account = new List<AccountContactRelation>();
        
        @AuraEnabled
        public List<string> Controller = new List<string>();
        
        @AuraEnabled
        public List<string> SoftwareVersion = new List<string>();
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