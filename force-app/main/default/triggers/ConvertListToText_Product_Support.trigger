trigger ConvertListToText_Product_Support on Product2 (before insert, before update) {
 for(Product2 c : Trigger.new) {
        if(!String.isBlank(c.Category_picklist__c)){       
           String productCat = c.Category_picklist__c;
           c.Category_search_text__c  = productCat;
         } 
           
       if(!String.isBlank(c.Brand_picklist__c)){       
           String brandText = c.Brand_picklist__c;
           c.Brand_search_text__c = brandText;
         } 
     
      if(!String.isBlank(c.Product_Type_picklist__c)){       
           String typeText = c.Product_Type_picklist__c;
           c.Product_Type_search_text__c = typeText;
         } 
        
        
        if(String.isBlank(c.Category_picklist__c)){
                     c.Category_search_text__c = '';
        }
        if(String.isBlank(c.Brand_picklist__c)){
                     c.Brand_search_text__c = '';
        }
        if(String.isBlank(c.Product_Type_picklist__c)){
                     c.Product_Type_search_text__c = '';
        }
      }
}