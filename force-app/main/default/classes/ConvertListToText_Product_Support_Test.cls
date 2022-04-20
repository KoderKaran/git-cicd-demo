@isTest
private class ConvertListToText_Product_Support_Test {
   @isTest static void addProductCategoryTest() {
                     
        Product2 newProduct = new Product2(Name = 'Test Class Complete'); 
       
        
         string cValue = 'Driver';
         string bValue = 'Control4';
         string tValue = 'Hardware';
       
        newProduct.Category_picklist__c = cValue;
        newProduct.Brand_picklist__c = bValue;
        newProduct.Product_Type_picklist__c = tValue;
        newProduct.IsActive = True; 
         insert newProduct;
        
       //update product categories multip picklist with 1 item then no items      
        update newProduct;
        newProduct.Category_picklist__c = 'Routers';
        System.debug('Categories update' + newProduct.Category_picklist__c);
       
        update newProduct;
        newProduct.Category_picklist__c = '';
        System.debug('Categories update' + newProduct.Category_picklist__c);
       

       
       //update brand picklist 1 item then no items
        update newProduct;
        newProduct.Brand_picklist__c = 'Control4';
        System.debug('Brand update' + newProduct.Brand_picklist__c);
       
        update newProduct;
        newProduct.Brand_picklist__c = '';
        System.debug('Brand update' + newProduct.Brand_picklist__c);
     
       
       //update Type picklist 1 item, then no items
        update newProduct;
        newProduct.Product_Type_picklist__c = 'Hardware';
        System.debug('Type update' + newProduct.Product_Type_picklist__c);
       
        update newProduct;
        newProduct.Product_Type_picklist__c = '';
        System.debug('Type update' + newProduct.Product_Type_picklist__c);
     
                    
    }
}