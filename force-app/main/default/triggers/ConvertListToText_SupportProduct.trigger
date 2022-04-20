trigger ConvertListToText_SupportProduct on Support_Product__c (before update) {
 for(Support_Product__c c : Trigger.new) {
        if(!String.isBlank(c.Product_Category__c)){       
           String productCat = c.Product_Category__c;
           c.Product_Category_searchText__c  = productCat;
         } 
           
       if(!String.isBlank(c.Brand__c)){       
           String brandText = c.Brand__c;
           c.Brand_searchText__c = brandText;
         } 
     
      if(!String.isBlank(c.Type__c)){       
           String typeText = c.Type__c;
           c.Type_searchText__c = typeText;
         } 
        
        
        if(String.isBlank(c.Product_Category__c)){
                     c.Product_Category_searchText__c = '';
        }
        if(String.isBlank(c.Brand__c)){
                     c.Brand_searchText__c = '';
        }
        if(String.isBlank(c.Type__c)){
                     c.Type_searchText__c = '';
        }
      }
}