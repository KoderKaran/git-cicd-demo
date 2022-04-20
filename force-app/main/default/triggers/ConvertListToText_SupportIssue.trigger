trigger ConvertListToText_SupportIssue on Support_Issue_Code__c (before insert, before update) {
 for(Support_Issue_Code__c c : Trigger.new) {
       if(!String.isBlank(c.Related_Categories_picklist__c)){
            List<String> pickValuesI = c.Related_Categories_picklist__c.split(';');
            String pickValuesStrI ='' ;
            for(String str : pickValuesI){
                         pickValuesStrI = pickValuesStrI + '\n' + str;
            }
            c.Related_Categories__c = pickValuesStrI;
       }
           
       if(!String.isBlank(c.Related_Product_Category_picklist__c)){       
            List<String> pickValuesP = c.Related_Product_Category_picklist__c.split(';');
            String pickValuesStrP ='' ;
            for(String str : pickValuesP){
                         pickValuesStrP = pickValuesStrP + '\n' + str;
           }  
           c.Related_Product_Category__c = pickValuesStrP;
         } 
        
        
        if(String.isBlank(c.Related_Categories_picklist__c)){
                     c.Related_Categories__c = '';
        }
        if(String.isBlank(c.Related_Product_Category_picklist__c)){
                     c.Related_Product_Category__c = '';
        }
      }
    }