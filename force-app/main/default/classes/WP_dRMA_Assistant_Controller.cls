public class WP_dRMA_Assistant_Controller {
    
    static map<Id,list<Id>> productIdsMap = new map<Id,list<Id>>();
    static set<Id> parentProductIds;
    static list<Id> childProductIds;    
    
    @AuraEnabled  
    public static Product2 GetProduct(Id productID)
    {       
        return [select id, Name from Product2 where id = :productID];
    }
    
    //get the products in Tree.
    @AuraEnabled
    public static Object GetProductTreeData(Id parentId, Id caseId, string stockType, string stockTypeReason){
        
        system.debug(stockTypeReason);
        
        Case c = [SELECT Id, Account.SAP_Instance__c FROM Case WHERE Id = :caseId];   
        
        list<Product_Relationships__c> prList = [SELECT Parent__c
                                                 , Parent__r.ProductCode
                                                 , Parent__r.Name
                                                 , Child__c
                                                 , Child__r.ProductCode
                                                 , Child__r.Name
                                                 , B_Stock__r.ProductCode
                                                 , B_Stock__r.Name
                                                 , B_Stock__c                                                 
                                                 , Bx_Stock__r.ProductCode
                                                 , Bx_Stock__r.Name
                                                 , Bx_Stock__c
                                                 , C_Stock__r.ProductCode
                                                 , C_Stock__r.Name
                                                 , C_Stock__c
                                                 , Alternative_Product__r.ProductCode
                                                 , Alternative_Product__r.Name
                                                 , Alternative_Product__c
                                                 , Parent__r.HALLAM_Inventory__c
                                                 , Parent__r.DALLAS_Inventory__c
                                                 , Parent__r.CVG_Inventory__c
                                                 , Parent__r.PDX_Inventory__c
                                                 , Parent__r.SLC_Inventory__c
                                                 , Parent__r.SAN_Inventory__c
                                                 , Parent__r.YORK_Inventory__c
                                                 , Child__r.HALLAM_Inventory__c
                                                 , Child__r.DALLAS_Inventory__c
                                                 , Child__r.CVG_Inventory__c
                                                 , Child__r.PDX_Inventory__c
                                                 , Child__r.SLC_Inventory__c
                                                 , Child__r.SAN_Inventory__c
                                                 , Child__r.YORK_Inventory__c
                                                 , B_Stock__r.HALLAM_Inventory__c
                                                 , B_Stock__r.DALLAS_Inventory__c
                                                 , B_Stock__r.CVG_Inventory__c
                                                 , B_Stock__r.PDX_Inventory__c
                                                 , B_Stock__r.SLC_Inventory__c
                                                 , B_Stock__r.SAN_Inventory__c
                                                 , B_Stock__r.YORK_Inventory__c                                                 
                                                 , Bx_Stock__r.HALLAM_Inventory__c
                                                 , Bx_Stock__r.DALLAS_Inventory__c
                                                 , Bx_Stock__r.CVG_Inventory__c
                                                 , Bx_Stock__r.PDX_Inventory__c
                                                 , Bx_Stock__r.SLC_Inventory__c
                                                 , Bx_Stock__r.SAN_Inventory__c
                                                 , Bx_Stock__r.YORK_Inventory__c
                                                 , C_Stock__r.HALLAM_Inventory__c
                                                 , C_Stock__r.DALLAS_Inventory__c
                                                 , C_Stock__r.CVG_Inventory__c
                                                 , C_Stock__r.PDX_Inventory__c
                                                 , C_Stock__r.SLC_Inventory__c
                                                 , C_Stock__r.SAN_Inventory__c
                                                 , C_Stock__r.YORK_Inventory__c  
                                                 , Alternative_Product__r.HALLAM_Inventory__c
                                                 , Alternative_Product__r.DALLAS_Inventory__c
                                                 , Alternative_Product__r.CVG_Inventory__c
                                                 , Alternative_Product__r.PDX_Inventory__c
                                                 , Alternative_Product__r.SLC_Inventory__c
                                                 , Alternative_Product__r.SAN_Inventory__c
                                                 , Alternative_Product__r.YORK_Inventory__c  
                                                 FROM Product_Relationships__c 
                                                 WHERE Parent__c =: parentId
                                                 	and Child__c != :parentId
                                                 ORDER BY parent__c];
        
        list<ProductWrapper> pwList = new list<ProductWrapper>(); 
        Id previousParent; 
        
        for(Product_Relationships__c pr: prList){           
            if (pr.Parent__c != null)
            {                              
                if (pr.Parent__c != previousParent)
                {
                    previousParent = pr.Parent__c;                    
                    ProductWrapper w = new ProductWrapper();
                    w.KeyField = pr.Parent__c;
                    w.stockType = 'A';
                    w.productCode = pr.Parent__r.ProductCode;
                    w.productName = pr.Parent__r.Name;  
                    w.stockTypeReason  = stockTypeReason;
                    switch on c.Account.SAP_Instance__c {
                        when 'SAP_NC', 'SAP_US' {
                            w.inventory = ((pr.Parent__r.DALLAS_Inventory__c == null) ? 0 : pr.Parent__r.DALLAS_Inventory__c) 
                                + ((pr.Parent__r.CVG_Inventory__c == null) ? 0 : pr.Parent__r.CVG_Inventory__c)
                                + ((pr.Parent__r.PDX_Inventory__c == null) ? 0 : pr.Parent__r.PDX_Inventory__c)
                                + ((pr.Parent__r.SLC_Inventory__c == null) ? 0 : pr.Parent__r.SLC_Inventory__c)
                                + ((pr.Parent__r.SAN_Inventory__c == null) ? 0 : pr.Parent__r.SAN_Inventory__c);
                        }	
                        when 'SAP_UK' {
                            w.inventory = pr.Parent__r.YORK_Inventory__c == null ? 0 : pr.Parent__r.YORK_Inventory__c; 
                        }
                        when 'SAP_AU' {
                            w.inventory = pr.Parent__r.HALLAM_Inventory__c == null ? 0 : pr.Parent__r.HALLAM_Inventory__c; 
                        }
                    }
                    
                    
                    List<Items> items = new List<Items>();
                    for (Product_Relationships__c pr2: prList)
                    {
                        if (pr.Parent__c == pr2.Parent__c && !String.isBlank(pr2.Child__c))
                        {                           
                            Items item = new Items();
                            item.KeyField = pr2.Child__c;
                            item.productCode = pr2.Child__r.ProductCode;
                            item.productName = pr2.Child__r.Name;
                            switch on c.Account.SAP_Instance__c {
                                when 'SAP_NC', 'SAP_US' {
                                    item.inventory = ((pr2.Child__r.DALLAS_Inventory__c == null) ? 0 : pr2.Child__r.DALLAS_Inventory__c) 
                                        + ((pr2.Child__r.CVG_Inventory__c == null) ? 0 : pr2.Child__r.CVG_Inventory__c)
                                        + ((pr2.Child__r.PDX_Inventory__c == null) ? 0 : pr2.Child__r.PDX_Inventory__c)
                                        + ((pr2.Child__r.SLC_Inventory__c == null) ? 0 : pr2.Child__r.SLC_Inventory__c)
                                        + ((pr2.Child__r.SAN_Inventory__c == null) ? 0 : pr2.Child__r.SAN_Inventory__c); 
                                }	
                                when 'SAP_UK' {
                                    item.inventory = pr2.Child__r.YORK_Inventory__c == null ? 0 : pr2.Child__r.YORK_Inventory__c; 
                                }
                                when 'SAP_AU' {
                                    item.inventory = pr2.Child__r.HALLAM_Inventory__c == null ? 0 : pr2.Child__r.HALLAM_Inventory__c; 
                                }
                            }
                            
                            item.items = newChild(pr2.Child__c, c);                            
                            items.add(item);
                        }
                    }                   
                    
                    w.items = items;
                    pwList.add(w); 
                    system.debug(w);
                }
                
                // Bx Stock
                if (!String.isBlank(pr.Bx_Stock__c))
                {                 
                    ProductWrapper w = new ProductWrapper();
                    w.KeyField = pr.Bx_Stock__c;
                    w.stockType = 'Bx';
                    w.productCode = pr.Bx_Stock__r.ProductCode;
                    w.productName = pr.Bx_Stock__r.Name;
                    w.stockTypeReason  = stockTypeReason;
                    switch on c.Account.SAP_Instance__c {
                        when 'SAP_NC', 'SAP_US' {
                            w.inventory = ((pr.Bx_Stock__r.DALLAS_Inventory__c == null) ? 0 : pr.Bx_Stock__r.DALLAS_Inventory__c) 
                                + ((pr.Bx_Stock__r.CVG_Inventory__c == null) ? 0 : pr.Bx_Stock__r.CVG_Inventory__c)
                                + ((pr.Bx_Stock__r.PDX_Inventory__c == null) ? 0 : pr.Bx_Stock__r.PDX_Inventory__c)
                                + ((pr.Bx_Stock__r.SLC_Inventory__c == null) ? 0 : pr.Bx_Stock__r.SLC_Inventory__c)
                                + ((pr.Bx_Stock__r.SAN_Inventory__c == null) ? 0 : pr.Bx_Stock__r.SAN_Inventory__c);
                        }	
                        when 'SAP_UK' {
                            w.inventory = pr.Bx_Stock__r.YORK_Inventory__c == null ? 0 : pr.Bx_Stock__r.YORK_Inventory__c; 
                        }
                        when 'SAP_AU' {
                            w.inventory = pr.Bx_Stock__r.HALLAM_Inventory__c == null ? 0 : pr.Bx_Stock__r.HALLAM_Inventory__c; 
                        }
                    }
                    
                    pwList.add(w); 
                }
                
                // B Stock
                if (!String.isBlank(pr.B_Stock__c))
                {                 
                    ProductWrapper w = new ProductWrapper();
                    w.KeyField = pr.B_Stock__c;
                    w.stockType = 'B';
                    w.productCode = pr.B_Stock__r.ProductCode;
                    w.productName = pr.B_Stock__r.Name;
                    w.stockTypeReason  = stockTypeReason;
                    switch on c.Account.SAP_Instance__c {
                        when 'SAP_NC', 'SAP_US' {
                            w.inventory = ((pr.B_Stock__r.DALLAS_Inventory__c == null) ? 0 : pr.B_Stock__r.DALLAS_Inventory__c) 
                                + ((pr.B_Stock__r.CVG_Inventory__c == null) ? 0 : pr.B_Stock__r.CVG_Inventory__c)
                                + ((pr.B_Stock__r.PDX_Inventory__c == null) ? 0 : pr.B_Stock__r.PDX_Inventory__c)
                                + ((pr.B_Stock__r.SLC_Inventory__c == null) ? 0 : pr.B_Stock__r.SLC_Inventory__c)
                                + ((pr.B_Stock__r.SAN_Inventory__c == null) ? 0 : pr.B_Stock__r.SAN_Inventory__c); 
                        }	
                        when 'SAP_UK' {
                            w.inventory = pr.B_Stock__r.YORK_Inventory__c == null ? 0 : pr.B_Stock__r.YORK_Inventory__c; 
                        }
                        when 'SAP_AU' {
                            w.inventory = pr.B_Stock__r.HALLAM_Inventory__c == null ? 0 : pr.B_Stock__r.HALLAM_Inventory__c; 
                        }
                    }                   
                    
                    pwList.add(w); 
                }
                
                
                // C Stock
                if (!String.isBlank(pr.C_Stock__c))
                {                 
                    ProductWrapper w = new ProductWrapper();
                    w.KeyField = pr.C_Stock__c;
                    w.stockType = 'C';
                    w.productCode = pr.C_Stock__r.ProductCode;
                    w.productName = pr.C_Stock__r.Name;
                    w.stockTypeReason  = stockTypeReason;
                    switch on c.Account.SAP_Instance__c {
                        when 'SAP_NC', 'SAP_US' {
                            w.inventory = ((pr.C_Stock__r.DALLAS_Inventory__c == null) ? 0 : pr.C_Stock__r.DALLAS_Inventory__c) 
                                + ((pr.C_Stock__r.CVG_Inventory__c == null) ? 0 : pr.C_Stock__r.CVG_Inventory__c)
                                + ((pr.C_Stock__r.PDX_Inventory__c == null) ? 0 : pr.C_Stock__r.PDX_Inventory__c)
                                + ((pr.C_Stock__r.SLC_Inventory__c == null) ? 0 : pr.C_Stock__r.SLC_Inventory__c)
                                + ((pr.C_Stock__r.SAN_Inventory__c == null) ? 0 : pr.C_Stock__r.SAN_Inventory__c);
                        }	
                        when 'SAP_UK' {
                            w.inventory = pr.C_Stock__r.YORK_Inventory__c == null ? 0 : pr.C_Stock__r.YORK_Inventory__c; 
                        }
                        when 'SAP_AU' {
                            w.inventory = pr.C_Stock__r.HALLAM_Inventory__c == null ? 0 : pr.C_Stock__r.HALLAM_Inventory__c; 
                        }
                    }                    
                    
                    pwList.add(w); 
                }
                
                if (!String.isBlank(pr.Alternative_Product__c))
                {                 
                    ProductWrapper w = new ProductWrapper();
                    w.KeyField = pr.Alternative_Product__c;
                    w.productCode = pr.Alternative_Product__r.ProductCode;
                    w.productName = pr.Alternative_Product__r.Name;
                    w.stockTypeReason  = stockTypeReason;
                    switch on c.Account.SAP_Instance__c {
                        when 'SAP_NC', 'SAP_US' {
                            w.inventory = ((pr.Alternative_Product__r.DALLAS_Inventory__c == null) ? 0 : pr.Alternative_Product__r.DALLAS_Inventory__c) 
                                + ((pr.Alternative_Product__r.CVG_Inventory__c == null) ? 0 : pr.Alternative_Product__r.CVG_Inventory__c)
                                + ((pr.Alternative_Product__r.PDX_Inventory__c == null) ? 0 : pr.Alternative_Product__r.PDX_Inventory__c)
                                + ((pr.Alternative_Product__r.SLC_Inventory__c == null) ? 0 : pr.Alternative_Product__r.SLC_Inventory__c)
                                + ((pr.Alternative_Product__r.SAN_Inventory__c == null) ? 0 : pr.Alternative_Product__r.SAN_Inventory__c);
                        }	
                        when 'SAP_UK' {
                            w.inventory = pr.Alternative_Product__r.YORK_Inventory__c == null ? 0 : pr.Alternative_Product__r.YORK_Inventory__c; 
                        }
                        when 'SAP_AU' {
                            w.inventory = pr.Alternative_Product__r.HALLAM_Inventory__c == null ? 0 : pr.Alternative_Product__r.HALLAM_Inventory__c; 
                        }
                    }
                    
                    pwList.add(w); 
                }               
            }
            
        } //end of for        
        
        // Calc Recommended SKU
        pwList = CalcRecommendation(pwList, c.Account.SAP_Instance__c, stockType);
        
        return pwList;
    }
    
    public static List<ProductWrapper> CalcRecommendation(List<ProductWrapper> pwList, string sapInstance, string stockType)
    {
        // Here is the order for stock types Alternative, A, Bx, B, C
        // If we don't have inventory, we give them the next best stock that has inventory       

        
        for (ProductWrapper pw : pwList)
        {
            if ((stockType == 'C' && pw.stockType == 'C' && pw.inventory > 0) ||
                (stockType == 'B' && pw.stockType == 'B' && pw.inventory > 0) ||
                (stockType == 'Bx' && pw.stockType == 'Bx' && pw.inventory > 0) ||
                (stockType == 'A' && pw.stockType == 'A' && pw.inventory > 0) ||
                (stockType == 'Alternative' && pw.stockType == 'Alternative' && pw.inventory > 0))                
            {   
				pw.recommended = pw.KeyField;  
                pw.stockTypeReason = pw.stockTypeReason == null ? 'Use ' + pw.stockType + ' Stock' : pw.stockTypeReason + ' Use ' + pw.stockType + ' Stock';               
                break;                
            }
            else if (stockType == 'C' && pw.stockType == 'C' && pw.inventory == 0)
            {           
                pw.stockTypeReason = pw.stockTypeReason == null ? 'There is no C type inventory.' : pw.stockTypeReason + ' There is no C type inventory.';
                pw.stockType = 'B';
                pw.recommended = '0'; 
                pwList = CalcRecommendation(pwList, sapInstance, pw.stockType);
            }
            else if (stockType == 'B' && pw.stockType == 'B' && pw.inventory == 0)
            {
                pw.stockTypeReason = pw.stockTypeReason == null ? 'There is no B type inventory.' : pw.stockTypeReason + ' There is no B type inventory.';
                pw.stockType = 'Bx';
                pw.recommended = '0'; 
                pwList = CalcRecommendation(pwList, sapInstance, pw.stockType); 
            }
            else if (stockType == 'Bx' && pw.stockType == 'Bx' && pw.inventory == 0)
            {
                pw.stockTypeReason = pw.stockTypeReason == null ? 'There is no Bx type inventory.' : pw.stockTypeReason + ' There is no Bx type inventory.';                
                pw.stockType = 'A';
                pw.recommended = '0'; 
                pwList = CalcRecommendation(pwList, sapInstance, pw.stockType); 
            }
            else if (stockType == 'A' && pw.stockType == 'A' && pw.inventory == 0)
            {
                pw.stockTypeReason = pw.stockTypeReason == null ? 'There is no A type inventory.' : pw.stockTypeReason + ' There is no A type inventory.';                   
                pw.stockType = 'Alternative';
                pw.recommended = '0'; 
                pwList = CalcRecommendation(pwList, sapInstance, pw.stockType); 
            }            
            else if (stockType == 'Alternative' && pw.inventory == 0)
            {
                pw.stockTypeReason = pw.stockTypeReason == null ? 'There is no alternative type inventory.' : pw.stockTypeReason + ' There is no alternative type inventory.'; 
                pw.recommended = '0'; 
            }
            else if (stockType == 'C') // catch the instance where there is not a mapping for C stock in product relationships table
            {
                pw.stockTypeReason = pw.stockTypeReason == null ? 'There is no C inventory mapping.' : pw.stockTypeReason + ' There is no C inventory mapping.';
                pw.stockType = 'B';
                pw.recommended = '0'; 
                pwList = CalcRecommendation(pwList, sapInstance, pw.stockType);            
            }
            else if (stockType == 'B') // catch the instance where there is not a mapping for B stock in product relationships table
            {
                pw.stockTypeReason = pw.stockTypeReason == null ? 'There is no B inventory mapping.' : pw.stockTypeReason + ' There is no B inventory mapping.';
                pw.stockType = 'Bx';
                pw.recommended = '0'; 
                pwList = CalcRecommendation(pwList, sapInstance, pw.stockType);            
            }
            else if (stockType == 'Bx') // catch the instance where there is not a mapping for Bx stock in product relationships table
            {
                pw.stockTypeReason = pw.stockTypeReason == null ? ' There is no Bx inventory mapping.' : pw.stockTypeReason + ' There is no Bx inventory mapping.';                
                pw.stockType = 'A';
                pw.recommended = '0'; 
                pwList = CalcRecommendation(pwList, sapInstance, pw.stockType);                
            }
            else if (stockType == 'A') // catch the instance where there is not a mapping for A stock in product relationships table
            {
                pw.stockTypeReason = pw.stockTypeReason == null ? 'There is no A type inventory.' : pw.stockTypeReason + ' There is no A type inventory.';                   
                pw.stockType = 'Alternative';
                pw.recommended = '0'; 
                pwList = CalcRecommendation(pwList, sapInstance, pw.stockType);                
            }                
        }        
        
        return pwList;
    }
    
    private static List<Items> newChild(Id parentID, Case c)
    {
        list<Product_Relationships__c> prList = [SELECT Parent__c
                                                 , Parent__r.ProductCode
                                                 , Parent__r.Name
                                                 , Child__c
                                                 , Child__r.ProductCode
                                                 , Child__r.Name
                                                 , Child__r.HALLAM_Inventory__c
                                                 , Child__r.DALLAS_Inventory__c
                                                 , Child__r.FRESNO_Inventory__c
                                                 , Child__r.CVG_Inventory__c
                                                 , Child__r.PDX_Inventory__c
                                                 , Child__r.SLC_Inventory__c
                                                 , Child__r.SAN_Inventory__c
                                                 , Child__r.YORK_Inventory__c
                                                 FROM Product_Relationships__c 
                                                 WHERE Parent__c =: parentId 
                                                 ORDER BY parent__c];
        
        list<Items> itemList = new list<Items>();
        set<Id> newParents = new set<Id>();       
        Id previousParent; 
        
        for(Product_Relationships__c pr: prList){           
            if (pr.Parent__c != null)
            {                              
                if (pr.Parent__c != previousParent)
                {
                    previousParent = pr.Parent__c;                  
                    
                    List<Items> items = new List<Items>();
                    for (Product_Relationships__c pr2: prList)
                    {
                        if (pr.Parent__c == pr2.Parent__c)
                        {
                            Items item = new Items();
                            item.KeyField = pr2.Child__c;
                            item.productCode = pr2.Child__r.ProductCode;
                            item.productName = pr2.Child__r.Name;
                            switch on c.Account.SAP_Instance__c {
                                when 'SAP_NC', 'SAP_US' {
                                    item.inventory = ((pr2.Child__r.DALLAS_Inventory__c == null) ? 0 : pr2.Child__r.DALLAS_Inventory__c) 
                                        + ((pr2.Child__r.CVG_Inventory__c == null) ? 0 : pr2.Child__r.CVG_Inventory__c)
                                        + ((pr2.Child__r.PDX_Inventory__c == null) ? 0 : pr2.Child__r.PDX_Inventory__c)
                                        + ((pr2.Child__r.SLC_Inventory__c == null) ? 0 : pr2.Child__r.SLC_Inventory__c)
                                        + ((pr2.Child__r.SAN_Inventory__c == null) ? 0 : pr2.Child__r.SAN_Inventory__c); 
                                }	
                                when 'SAP_UK' {
                                    item.inventory = pr2.Child__r.YORK_Inventory__c == null ? 0 : pr2.Child__r.YORK_Inventory__c; 
                                }
                                when 'SAP_AU' {
                                    item.inventory = pr2.Child__r.HALLAM_Inventory__c == null ? 0 : pr2.Child__r.HALLAM_Inventory__c; 
                                }
                            } 
                            
                            if (!String.isBlank(pr2.Child__c))  
                            {
                                item.items = newChild(pr2.Child__c, c);    
                            }                                  
                            itemList.add(item);
                        }                        
                    }
                } 
            }
        } //end of for     
        
        return itemList;
    }
    
    
    
    //Wrapper Class for Parent Products and Child Products.
    public Class ProductWrapper{
        @AuraEnabled
        public String KeyField {get;set;}
        @AuraEnabled
        public String stockType {get;set;}  
        @AuraEnabled
        public String stockTypeReason {get;set;}           
        @AuraEnabled
        public String productCode {get;set;}
        @AuraEnabled
        public String productName {get;set;}
        @AuraEnabled
        public Decimal inventory {get;set;}      
        @AuraEnabled
        public String recommended {get;set;}        
        @AuraEnabled
        public List<Items> items {get;set;}
    }
    
    //Child Products
    public Class Items{
        @AuraEnabled
        public String KeyField {get;set;}
        @AuraEnabled
        public String productCode {get;set;}
        @AuraEnabled
        public String productName {get;set;}
        @AuraEnabled
        public Decimal inventory {get;set;}
        @AuraEnabled
        public List<Items> items {get;set;}
    }    
}