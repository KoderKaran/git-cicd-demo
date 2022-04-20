Public Class RMAFormController {
    public Id caseId{get;set{caseId = value;getCaseProducts();}} /** get set the variable for case Id take value from visual component.**/
    public Case c{get;set;}
    public Boolean hasScrap {get;set;}
    public Boolean hasVerifiedScrap {get;set;}
    public Boolean hasDefault {get;set;}
    public Boolean hasPortland {get;set;}
    public Boolean isSales {get;set;}
    public Boolean isOurFault {get;set;}
    public Boolean isTheirFault {get;set;}
    public String dealerType {get;set;}
    public String sapInstance {get;set;}
    public String accountGroup {get;set;}
    public Integer intCounter {get;set;}
 
    public RMAFormController() {
        if(!Test.isRunningTest()) // Cannot get the caseId from the URL while running the test class.
        {
        	caseId = ApexPages.currentPage().getParameters().get('caseId');
        }
    }
    
    public Map<String, List<CaseProduct__c>> getCaseProducts() {
        Map <String, List<CaseProduct__c>> mapCaseProd = new Map <String, List<CaseProduct__c>>();
        System.Debug('CaseIDD'+ caseId );
        List<Case> caseList = [Select Id
                               , Account.Name
                               , Account.SAP_ACCOUNT_ID__c
                               , Account.DealerType__c
                               , Account.SAP_Instance__c
                               , Account.BillingCountry
                               , Account.Account_Group__c
                               , CaseNumber
                               , Subject                               
                               , Origin
                               , MyControl4_Name__c
                               , SuppliedName
                               , Contact.Name                               
                               , SuppliedEmail
                               , Contact.Email
                               , SuppliedPhone
                               , Contact.Phone
                               , Owner.FirstName
                               , Owner.LastName
                               , Alternate_Ship_Address__c
                               , Alternate_Ship_To_Address__c
                               , Special_RMA_Instructions__c
                               , LastModifiedDate
                               , (SELECT Id,RMA__c, New_Email_RMA_Sent__c, MacID__c, Item__r.Name,Item__r.ProductCode,  Item__r.RMA_Location__c, Outbound_product__r.Name,  Outbound_product__r.ProductCode,  Quantity__c, Symptom__c, Symptom_Type__c, Shipment_Priority__c, RMA_Type__c, RMA_Outcome__c, Scrap__c FROM CaseProduct__r)
                               From Case 
                               where Id =:caseId];
        
        List<CaseProduct__c> listofProduct = [SELECT Id
                                              , RMA__c
                                              , New_Email_RMA_Sent__c
                                              , MacID__c
                                              , Item__r.ProductCode
                                              , Item__r.Name
                                              , Item__r.RMA_Location__c
                                              , Outbound_product__r.Name
                                              , Outbound_product__r.ProductCode
                                              , Quantity__c, Symptom__c
                                              , Symptom_Type__c
                                              , Shipment_Priority__c
                                              , RMA_Type__c
                                              , RMA_Outcome__c
                                              , Scrap__c
                                              , RMA_Reason__c
                                              , Item_Code__c  
                                              FROM CaseProduct__c 
                                              where Case__c =:caseId];
        
        
        c = caseList[0];
        hasScrap = false;
        hasVerifiedScrap = false;
        hasDefault = false;
        hasPortland = false;
        isSales = false;
        isOurFault = false;
        isTheirFault = false;
        intCounter = 0;       
        
        dealerType = caseList[0].Account.DealerType__c;
        sapInstance = caseList[0].Account.SAP_Instance__c;
        accountGroup = caseList[0].Account.Account_Group__c;        
     
        for(CaseProduct__c caseProd : listofProduct){ 
            if ((caseProd.Item_Code__c == 'C4-AMP108' || caseProd.Item_Code__c == 'C4-AMP108-BX' || caseProd.Item_Code__c == 'B-C4-AMP108') && (caseProd.RMA_Outcome__c != 'Repair - Out of Warranty' && caseProd.RMA_Outcome__c != 'Repair - Out of Warranty (PO Required)') )
            {
                intCounter++; 
            }
        }
        
        // this is a special use case. They want verifiedscrip if the only have one AMP108 product. If there are 2 or more they want it to act like a regular RMA.  
        if (intCounter == 1){
            hasVerifiedScrap = true; 
        }
        
        for(CaseProduct__c caseProd : listofProduct){ 
            if(caseProd.Item__r != null){
                if(caseProd.Item__r.RMA_Location__c == null){
                    caseProd.Item__r.RMA_Location__c = 'Default';
                }
                        
                
           		// scrap the product if it is Triad and in the UK and is a dealer. Be sure to "continue;" out of the loop. This case could test true in other if statements below
               if(sapInstance == 'UK' && !accountGroup.contains('Distributor') &&  caseProd.Item__r.RMA_Location__c.toUpperCase() == 'PDX' && caseProd.RMA_Outcome__c.contains('Advance Replacement')){
                    hasScrap =  true;
                    if(mapCaseProd.containsKey('SCRAP')){
                        List<CaseProduct__c> caseProdList = mapCaseProd.get('SCRAP');
                        caseProdList.add(caseProd); 
                        mapCaseProd.put('SCRAP',caseProdList);
                    } else{
                        mapCaseProd.put('SCRAP',new List<CaseProduct__c>{caseProd});
                    }
                   continue;
                } 
               
           		// This is for Repair in field. Be sure to "continue;" out of the loop. This case could test true in other if statements below
               if(sapInstance == 'UK' &&  accountGroup.contains('Distributor') &&  caseProd.Item__r.RMA_Location__c.toUpperCase() == 'PDX' && (caseProd.RMA_Outcome__c == 'Repair - In Warranty' || caseProd.RMA_Outcome__c == 'Repair - Out of Warranty'))
               {
                    if(mapCaseProd.containsKey('REPAIRINFIELD')){
                        List<CaseProduct__c> caseProdList = mapCaseProd.get('REPAIRINFIELD');
                        caseProdList.add(caseProd); 
                        mapCaseProd.put('REPAIRINFIELD',caseProdList);
                    } else{
                        mapCaseProd.put('REPAIRINFIELD',new List<CaseProduct__c>{caseProd});
                    }
                   continue;
                }


           		// This is for Repair in field. Be sure to "continue;" out of the loop. This case could test true in other if statements below
               if((sapInstance == 'UK' &&  accountGroup.contains('Distributor') &&  caseProd.Item__r.RMA_Location__c.toUpperCase() == 'PDX' ))   //////&& caseProd.RMA_Outcome__c.contains('Advance Replacement')))
                  {
                    if(mapCaseProd.containsKey('UKTRIADDISTRIBUTORS')){
                        List<CaseProduct__c> caseProdList = mapCaseProd.get('UKTRIADDISTRIBUTORS');
                        caseProdList.add(caseProd); 
                        mapCaseProd.put('UKTRIADDISTRIBUTORS',caseProdList);
                    } else{
                        mapCaseProd.put('UKTRIADDISTRIBUTORS',new List<CaseProduct__c>{caseProd});
                    }
                   continue;
                }                
                
                //if(caseProd.Item__r.RMA_Location__c.toUpperCase() == 'DEFAULT' && caseProd.RMA__c == 'Yes' && ( !caseProd.Scrap__c  || (!caseProd.Scrap__c && caseProd.RMA_Type__c == 'Sales' ))){
                if(caseProd.Item__r.RMA_Location__c.toUpperCase() == 'DEFAULT' && caseProd.RMA__c == 'Yes' && ( !caseProd.Scrap__c || caseProd.RMA_Type__c == 'Sales' )){
                    
                    if ((caseProd.Item_Code__c != 'C4-AMP108' && caseProd.Item_Code__c != 'C4-AMP108-BX' && caseProd.Item_Code__c != 'B-C4-AMP108') || ((caseProd.Item_Code__c == 'C4-AMP108' || caseProd.Item_Code__c == 'C4-AMP108-BX' || caseProd.Item_Code__c == 'B-C4-AMP108') && hasVerifiedScrap == false) || ((caseProd.Item_Code__c == 'C4-AMP108' || caseProd.Item_Code__c == 'C4-AMP108-BX' || caseProd.Item_Code__c == 'B-C4-AMP108') && (caseProd.RMA_Outcome__c == 'Repair - Out of Warranty' || caseProd.RMA_Outcome__c == 'Repair - Out of Warranty (PO Required)')))
                    {
                        hasDefault =  true;
                        if(mapCaseProd.containsKey('DEFAULT')){
                            List<CaseProduct__c> caseProdList = mapCaseProd.get('DEFAULT');
                            caseProdList.add(caseProd); 
                            mapCaseProd.put('DEFAULT',caseProdList);
                        } else{
                            mapCaseProd.put('DEFAULT',new List<CaseProduct__c>{caseProd});
                        }
                    }
                }
                //if(caseProd.Item__r.RMA_Location__c.toUpperCase() == 'PDX' && caseProd.RMA__c == 'Yes' && ( !caseProd.Scrap__c   || (!caseProd.Scrap__c && caseProd.RMA_Type__c == 'Sales' ) )){
                if(caseProd.Item__r.RMA_Location__c.toUpperCase() == 'PDX' && caseProd.RMA__c == 'Yes' && ( !caseProd.Scrap__c || caseProd.RMA_Type__c == 'Sales'  )){
                    
                    if ((caseProd.Item_Code__c != 'C4-AMP108' && caseProd.Item_Code__c != 'C4-AMP108-BX' && caseProd.Item_Code__c != 'B-C4-AMP108') || ((caseProd.Item_Code__c == 'C4-AMP108' || caseProd.Item_Code__c == 'C4-AMP108-BX' || caseProd.Item_Code__c == 'B-C4-AMP108') && hasVerifiedScrap == false) || ((caseProd.Item_Code__c == 'C4-AMP108' || caseProd.Item_Code__c == 'C4-AMP108-BX' || caseProd.Item_Code__c == 'B-C4-AMP108') && (caseProd.RMA_Outcome__c == 'Repair - Out of Warranty' || caseProd.RMA_Outcome__c == 'Repair - Out of Warranty (PO Required)')))
                    {
                        hasPortland =  true;
                        if(mapCaseProd.containsKey('PDX')){
                            List<CaseProduct__c> caseProdList = mapCaseProd.get('PDX');
                            caseProdList.add(caseProd); 
                            mapCaseProd.put('PDX',caseProdList);
                        } else{
                            mapCaseProd.put('PDX',new List<CaseProduct__c>{caseProd});
                        }
                    }
                }
                
                //if(caseProd.Item__r.RMA_Location__c.toUpperCase() == 'PDX' && caseProd.RMA__c == 'Yes' && ( !caseProd.Scrap__c   || (!caseProd.Scrap__c && caseProd.RMA_Type__c == 'Sales' ) )){
                if((caseProd.Item__r.RMA_Location__c.toUpperCase() == 'YORK' || caseProd.Item__r.RMA_Location__c.toUpperCase() == 'SLC' )&& caseProd.RMA__c == 'Yes' && ( !caseProd.Scrap__c || caseProd.RMA_Type__c == 'Sales'  )){
                    
                    if ((caseProd.Item_Code__c != 'C4-AMP108' && caseProd.Item_Code__c != 'C4-AMP108-BX' && caseProd.Item_Code__c != 'B-C4-AMP108') || ((caseProd.Item_Code__c == 'C4-AMP108' || caseProd.Item_Code__c == 'C4-AMP108-BX' || caseProd.Item_Code__c == 'B-C4-AMP108') && hasVerifiedScrap == false) || ((caseProd.Item_Code__c == 'C4-AMP108' || caseProd.Item_Code__c == 'C4-AMP108-BX' || caseProd.Item_Code__c == 'B-C4-AMP108') && (caseProd.RMA_Outcome__c == 'Repair - Out of Warranty' || caseProd.RMA_Outcome__c == 'Repair - Out of Warranty (PO Required)')))
                    {
                        //hasPortland =  true;
                        if(mapCaseProd.containsKey(caseProd.Item__r.RMA_Location__c.toUpperCase())){
                            List<CaseProduct__c> caseProdList = mapCaseProd.get(caseProd.Item__r.RMA_Location__c.toUpperCase());
                            caseProdList.add(caseProd); 
                            mapCaseProd.put(caseProd.Item__r.RMA_Location__c.toUpperCase(),caseProdList);
                        } else{
                            mapCaseProd.put(caseProd.Item__r.RMA_Location__c.toUpperCase(),new List<CaseProduct__c>{caseProd});
                        }
                    }
                }
            }
            
            //if(caseProd.Scrap__c && caseProd.RMA__c == 'Yes' && caseProd.RMA_Type__c != 'Sales'){
            if(caseProd.Scrap__c && caseProd.RMA__c == 'Yes' && caseProd.RMA_Type__c != 'Sales' && (caseProd.Item_Code__c != 'C4-AMP108' && caseProd.Item_Code__c != 'C4-AMP108-BX' && caseProd.Item_Code__c != 'B-C4-AMP108')){
                hasScrap =  true;
                if(mapCaseProd.containsKey('SCRAP')){
                    List<CaseProduct__c> caseProdList = mapCaseProd.get('SCRAP');
                    caseProdList.add(caseProd); 
                    mapCaseProd.put('SCRAP',caseProdList);
                } else{
                    mapCaseProd.put('SCRAP',new List<CaseProduct__c>{caseProd});
                }
            } 


            
            
            
            // Verified Scrap is a special use case. This is an AMP108 when we only have one AMP108 in the RMA. If the are more than one they follow the regular RMA process
            if(caseProd.RMA__c == 'Yes' && caseProd.RMA_Type__c != 'Sales' && !caseProd.Scrap__c){                         
                if((caseProd.Item_Code__c == 'C4-AMP108' || caseProd.Item_Code__c == 'C4-AMP108-BX' || caseProd.Item_Code__c == 'B-C4-AMP108')&& hasVerifiedScrap && caseProd.RMA_Outcome__c != 'Repair - Out of Warranty' && caseProd.RMA_Outcome__c != 'Repair - Out of Warranty (PO Required)')
                {
                    if(mapCaseProd.containsKey('VERIFIEDSCRAP')){
                        List<CaseProduct__c> caseProdList = mapCaseProd.get('VERIFIEDSCRAP');
                        caseProdList.add(caseProd); 
                        mapCaseProd.put('VERIFIEDSCRAP',caseProdList);
                    } else{
                        mapCaseProd.put('VERIFIEDSCRAP',new List<CaseProduct__c>{caseProd});
                    }
                }
            }
            
            if(caseProd.RMA_Type__c == 'Sales'){
                isSales = true;
                if(caseProd.RMA_Reason__c == 'Sales Key Error' || caseProd.RMA_Reason__c == 'Warehouse Error'){
                    isOurFault = true;
                } else if( caseProd.RMA_Reason__c == 'Dealer Order Error' || caseProd.RMA_Reason__c =='Dealer Stock Adjustment'){
                    isTheirFault = true;
                }
            }
        }
        System.Debug('Debugging'+ mapCaseProd); 
        
        
        return mapCaseProd;
    }                
                   
}