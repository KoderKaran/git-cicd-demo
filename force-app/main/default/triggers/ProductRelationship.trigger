trigger ProductRelationship on Product_Relationships__c (before insert,before update) 
{    
         
    set<Id> parentProdIds = new set<Id>();
    List<Product_Relationships__c> prodlist = new List<Product_Relationships__c>();
    
    for(Product_Relationships__c NEWPR:Trigger.new)
    {
        if (NEWPR.Parent__c != NULL)
        {
            parentProdIds.add(NEWPR.Parent__c);
        }
    }
    
    
    
    if(parentProdIds != null && !parentProdIds.isEmpty()){
        prodlist = [select id,Parent__c,Child__c,B_Stock__c,Bx_Stock__c,C_Stock__c, Alternative_Product__c 
                    from Product_Relationships__c where id Not in:Trigger.New AND Parent__c IN:parentProdIds];
    }
    
    if(prodlist != null && !prodlist.isEmpty()){
        for(Product_Relationships__c NEWPR:Trigger.new)
        {
            for(Product_Relationships__c PRT: prodlist)
            {
                if (NEWPR.Parent__c != NULL)
                {
                    if(NEWPR.Parent__c==PRT.Parent__c && PRT.Child__c!= Null && NEWPR.Child__c==PRT.Child__c)
                    {   
                        NEWPR.adderror('Already exist same PARENT and CHILD in Product RelationShip object');
                    }
             
                    if (NEWPR.Parent__c==PRT.Parent__c  && (PRT.B_Stock__c != Null || PRT.Bx_Stock__c != Null || PRT.C_Stock__c != Null ) && (NEWPR.B_Stock__c != Null || NEWPR.Bx_Stock__c != Null || NEWPR.C_Stock__c != Null ))
                    {   
                        NEWPR.adderror('Already Parent Product  may contains any of B/BX/C_Stock in Product RelationShip object');
                    }
                }
            }
        }
    }
}