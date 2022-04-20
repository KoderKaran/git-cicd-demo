@isTest
private class ConvertListToText_SupportProduct_Test {
   @isTest static void addProductCategoryTest() {
                     
        Support_Product__c newProduct = new Support_Product__c(Name = 'Test Class Complete'); 
       
        
         string cValue = 'Video';
         string bValue = 'Control4';
         string tValue = 'Hardware';
       
        newProduct.Product_Category__c = cValue;
        newProduct.Brand__c = bValue;
        newProduct.Type__c = tValue;
         insert newProduct;
        
       //update product categories multip picklist with 1 item then no items      
        update newProduct;
        newProduct.Product_Category__c = 'Security';
        System.debug('Categories update' + newProduct.Product_Category__c);
       
        update newProduct;
        newProduct.Product_Category__c = '';
        System.debug('Categories update' + newProduct.Product_Category__c);
       

       
       //update brand picklist 1 item then no items
        update newProduct;
        newProduct.Brand__c = 'Control4';
        System.debug('Categories update' + newProduct.Brand__c);
       
        update newProduct;
        newProduct.Brand__c = '';
        System.debug('Categories update' + newProduct.Brand__c);
     
       
       //update Type picklist 1 item, then no items
        update newProduct;
        newProduct.Brand__c = 'Hardware';
        System.debug('Categories update' + newProduct.Brand__c);
       
        update newProduct;
        newProduct.Brand__c = '';
        System.debug('Categories update' + newProduct.Brand__c);
       
     
                    
    }
}