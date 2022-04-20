@isTest
private class ConvertListToText_SupportIssue_Test {
   @isTest static void addIssueCategoryTest() {
                     
        Support_Issue_Code__c newIssue = new Support_Issue_Code__c(Name = 'Test Class Complete'); 
       
        
         string cValues = 'Video; Audio; Lighting';
         string pValues = 'Control4; Binary';
       
        newIssue.Related_Categories_picklist__c = cValues;
        newIssue.Related_Product_Category_picklist__c = pValues;
         insert newIssue;
          
       //update related categories picklist with 2 items, then 1 item, then no items
        update newIssue;
        newIssue.Related_Categories_picklist__c = 'Power; Zigbee';
        System.debug('Categories update' + newIssue.Related_Categories_picklist__c);
       
        update newIssue;
        newIssue.Related_Categories_picklist__c = 'LCD Display';
        System.debug('Categories update' + newIssue.Related_Categories_picklist__c);
       
        update newIssue;
        newIssue.Related_Categories_picklist__c = '';
        System.debug('Categories update' + newIssue.Related_Categories_picklist__c);
       
       
       //update related products picklist with 2 items, then 1 item, then no items
        update newIssue;
        newIssue.Related_Product_Category_picklist__c = 'Pakedge';
        System.debug('Categories update' + newIssue.Related_Product_Category_picklist__c);
       
        update newIssue;
        newIssue.Related_Product_Category_picklist__c = 'Triad';
        System.debug('Categories update' + newIssue.Related_Product_Category_picklist__c);
       
        update newIssue;
        newIssue.Related_Product_Category_picklist__c = '';
        System.debug('Categories update' + newIssue.Related_Product_Category_picklist__c);
                    
    }
}