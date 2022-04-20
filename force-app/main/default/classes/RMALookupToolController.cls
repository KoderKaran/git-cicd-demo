public class RMALookupToolController {
    
    @AuraEnabled    
    public static List<CaseProduct__c> GetRMAInformation (string searchString)
    {  
        List<CaseProduct__c> caseProducts = [SELECT Id, MacID__c, Name, Sales_Order_Number__c, Sales_Order_Date__c, RMA_Type__c, Case__c, Case__r.Subject, Case__r.CaseNumber, Case__r.Contact.Id, Case__r.Contact.Name, Case__r.Account.Id, Case__r.Account.Name, Case__r.Account.SAP_ACCOUNT_ID__c FROM CaseProduct__c WHERE MacID__c = :searchString];      
        
		return caseProducts;
    }         
}