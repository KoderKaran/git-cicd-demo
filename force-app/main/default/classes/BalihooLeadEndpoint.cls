/**
  *
  * ===============================================================================================
  * Version        Date              Author           Comment
  * ===============================================================================================
  * Initial        15-July-2016      Ganesh Shinde    This class deserilaizes the balihoo json data and 
  *                            create a balihoo lead record. 
  *                                                 
**/
@RestResource(urlMapping='/balihoolead/*')
global without sharing class BalihooLeadEndpoint {
    
    @HttpPost   
    global static String postData() {
        //Returns the RestRequest object for our Apex REST method.  
        RestRequest request = RestContext.request;  
        String sf_jsonResponse = '';
        
        try{
            //Request body with data in JSON format  
            String jSONRequestBody=request.requestBody.toString().trim();
            //Deserializes the input JSON string into an Customer object  
            BalihooLead objCustomers = (BalihooLead)JSON.deserializeStrict(jSONRequestBody,BalihooLead.class);
            
      if(objCustomers != null) {
        Balihoo_Lead__c objBlLead = saveLead(objCustomers);
        Database.SaveResult saveResult = Database.insert(objBlLead);
        if (saveResult.isSuccess()) {
          sf_jsonResponse = '{"response": {"statusCode": "200", "message": "Balihoo lead record is inserted in Salesforce"}}';
        } else {
          sf_jsonResponse = '{"response": {"statusCode": "400", "message": "Please Provide valid Json request"}}';
        }
        return sf_jsonResponse;
      }
      
        } catch(exception ex) {
          sf_jsonResponse = '{"response": {"statusCode": "500", "message": "'+ex.getMessage()+'"}}';
          return sf_jsonResponse;
        }
          return sf_jsonResponse;  
                   
    }
    
     /** 
  * method to save the Balihoo Lead record
    **/
    public static Balihoo_Lead__c saveLead(BalihooLead objCustomers) {
      Balihoo_Lead__c objBlLead = new Balihoo_Lead__c();
      if (objCustomers != null) {
        list<String> lstOfFields = new list<String>();
        
        Id recordIdToLookup = null;
        Id affiliateIdToLookup = null;
        Id OpportunityId = null;
            // Find person accounts matching the email address
        if (String.isNotBlank(objCustomers.email)) {
        // recordIdToLookup = fetchExisitingRecord(lstOfFields, 'Account');
        recordIdToLookup = fetchCustomerAccount(objCustomers.email);
        if(recordIdToLookup != null){
          objBlLead.Account__c = recordIdToLookup;
        }
        }
        
        if (objCustomers.location_key != null) {
         if(objCustomers.location_key.contains('-')){
              objBlLead.Location_key__c = objCustomers.location_key.substring(0, objCustomers.location_key.lastIndexOf('-'));
              objCustomers.location_key = objCustomers.location_key.substring(0, objCustomers.location_key.lastIndexOf('-'));
         } else        
              objBlLead.Location_key__c = objCustomers.location_key; 
         }
        
        
        if (String.isNotBlank(objCustomers.location_Key)) {
          lstOfFields.clear();
        affiliateIdToLookup = fetchAffilicate(objCustomers.location_Key);
        system.debug('Inside Id:'+affiliateIdToLookup);
        if(affiliateIdToLookup != null){
          objBlLead.Dealer__c = affiliateIdToLookup;
        }
        }
        
            // Find existing leads 
        if (recordIdToLookup == null || objBlLead.Account__c != NULL) {
          lstOfFields.clear();
          recordIdToLookup = fetchLead(objCustomers.email);
          if(recordIdToLookup != null){ 
          objBlLead.Lead__c = recordIdToLookup;
        }
        }
            
            // No existing leads, create new lead and link to record
        if( recordIdToLookup == null || objBlLead.Lead__c == NULL ) {
                // Set lead to auto-assign
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true;
                Lead l = createLead(objCustomers, affiliateIdToLookup );//new Lead(FirstName = objCustomers.firstName, LastName = objCustomers.lastName, Email = objCustomers.email, Phone = objCustomers.phone);
                l.setOptions(dmo);
                Insert l;
                recordIdToLookup = l.Id;
                objBlLead.Lead__c = l.Id;
                
                l.Status = 'Sent to dealer';
                Update l;
                
                
        }
        //Changes done by Alvin
         // OpportunityId = createOpportunity(recordIdToLookup, affiliateIdToLookup, objCustomers.firstName, objCustomers.lastName);
            
       /* System.debug('Record Id:'+recordIdToLookup);
        if (objCustomers.location_key != null) {
          String[] arrTest = objCustomers.location_key.split('-');
          if (String.isNotBlank(arrTest[0])) 
          objBlLead.Location_key__c = arrTest[0];
        }*/
      
      objBlLead.Opportunity__c = fetchOpportunity(recordIdToLookup);
      objBlLead.Returnurl__c = objCustomers.returnurl;
      objBlLead.Email__c = objCustomers.email;
      objBlLead.Last_Name__c = objCustomers.lastName;
      objBlLead.First_Name__c = objCustomers.firstName;
      objBlLead.Affiliate_Email__c = objCustomers.affiliateemail;
      objBlLead.Notes__c = objCustomers.notes;
      objBlLead.Phone__c = objCustomers.phone;
      objBlLead.Comments__c = objCustomers.comments;
      }
      return objBlLead;
    }
    
    /** 
  * method to create opportunity 
    **/
    public static Id createOpportunity (Id associatedRecord, Id recordId, String firstName, String lastName) {
      Opportunity objOpp = new Opportunity (); 
      Id oppId = null;
        objOpp.AccountId = recordId;
      String strRecordId = (String)associatedRecord;
       if (strRecordId.startswith('001')) {
         objOpp.Associated_Account__c = associatedRecord;
       } else {
         objOpp.Associated_Lead__c = associatedRecord;
       }
       
       objOpp.Name = firstName +' '+lastName;
       objOpp.CloseDate = Date.today() + 30;
       objOpp.StageName = 'Sent to Dealer';
       //objOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Balihoo').getRecordTypeId();

       
       Database.insert(objOpp);
     if (objOpp.Id != null) {
       return oppId = objOpp.Id; 
     }
     return oppId;
    }
    
    public static Id fetchCustomerAccount(String email){
        Account a;
        try{
          a = [select Id from Account where IsPersonAccount = True AND PersonEmail = :email ORDER BY CreatedDate DESC LIMIT 1];
        } catch (Exception e){
            // No account with that email
            return null;
        }
        return a.Id;
    }
    
    public static Id fetchAffilicate(String locKey){
        Account a;
        try{
            a = [select Id from Account where IsPersonAccount = false AND (AccountNumber = :locKey OR SAP_ACCOUNT_ID__c = :locKey OR Site = :locKey) ORDER BY CreatedDate DESC LIMIT 1];
        } catch (Exception e){
            // No account matching
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            return null;
        }
        return a.Id;
    }
    
    public static Id fetchLead(String email){
        Lead l;
        try{
            l = [select Id from Lead where isConverted = False AND Email = :email ORDER BY CreatedDate DESC Limit 1];
        } catch (Exception e){
            return null;
        }
        return l.Id;
    }
    
    public static Id fetchOpportunity(Id leadId){
        Opportunity o;
        try{
            o = [select Id from Opportunity where Associated_Lead__c =: leadId ORDER BY CreatedDate DESC Limit 1];
        } catch (Exception e){
            return null;
        }
        return o.Id;
    }
    
    public static Lead createLead(BalihooLead objBaLead, Id affiliateIdToLookup){
        Lead l = new Lead();
        l.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Telesales').getRecordTypeId();
        l.FirstName = objBaLead.firstName;
        l.LastName = objBaLead.lastName;
        l.Email = objBaLead.email;
        l.Phone = objBaLead.phone;
        l.Status = 'New';
        if(affiliateIdToLookup!= null){
            l.Dealer__c = affiliateIdToLookup;
        }
        l.Original_Referring_URL__c = objBaLead.returnurl;
        l.Lead_Message__c = objBaLead.comments;
        l.From_Balihoo__c = true;
        return l;
    }
    
    public class BalihooLead {
        public string location_key; //"SOU973-1", 
        public string returnurl; //"http://local.control4.com/soundtechsystemsinc1-34983/portsaintlucie-fl", 
        public string email; //"georgesori@gmail.com", 
        public string brand_key; //"controlfour", 
        public string location_id; //"e61c2cfe-f922-4281-9e94-0bd9fb48bca7", 
        public string lastName; //"Sori", 
        public string firstName; //"George", 
        public string affiliateemail; //"kevin@soundtechsystems.com", 
        public string notes; //"Lead Capture Form", 
        public string tactic_id; //"B1fuYvUx", 
        public string phone; //"7724754157", 
        public string comments; //"Trying to get some information on Control4 for a new house i will be building. Looking for zone home audio in at least 3 rooms, lighting control, and home automation options." 
    }
   
}