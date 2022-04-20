public without sharing class ProductRMA {
    
    
    @AuraEnabled
	public Static CaseProduct__c getCaseProduct(String casePrdId,Integer qty){

	return [Select Id,Name,Add_to_List__c,C4_Item__c,Case__c,Case__r.casenumber,Cause_Code__c,Cause_Code_2__c
            	,Cause_Type__c,Certified_Driver__c,Control_Method_Used__c,Corrective_Action__c,Detail__c
            	,Third_Party_Type__c,Disposition__c,DOA__c,Driver_Creator_Driver_Team_Use_Only__c,ECO_Level__c
                ,Estimated_Hardware_Repair_Charge__c,Estimated_Software_Repair_Charge__c
            	,Hardware_Repair_Charge_Amount__c,Interop_Review_Driver_Team_Use_Only__c,Issue__c,Item__c,MacID__c
            	,MacID_Lookup__c,Third_Party_Make__c,Manufacture_Date__c,Third_Party_Model__c,New_Email_RMA_Sent__c
            	,No_Troubleshooting__c,Number_of_Task_Sent__c,Outbound_Product__c,PreviousVersion__c,Product__c
            	,Product_Returned__c,Product_Type__c,Quantity__c,Reason_for_Call__c,Restock_Fee__c
            	,Return_Shipment_Priority__c,RMA__c,RMA_Outcome__c,RMA_Reason__c,RMA_Received_Date__c,RMA_Type__c
            	,SAP_Solution_Code__c,Serial_Number__c,Ship_Date__c,Shipment_Priority__c,Solution__c,Solution_Detail__c
            	,Special_Offer__c,Subject__c,Symptom__c,Troubleshooting__c,Symptom_Other_Detail__c,Time_Delayed_Task__c
            	,Type__c,UK__c,Version__c,Wave_Reason__c,Warehouse_Error__c,Original_Sale_Price__c
            	,Sales_Order_Number__c,Product_Condition__c
            from CaseProduct__c where Id = :casePrdId ];
	}
    
    @AuraEnabled 
    public static List<CaseProduct__c> cloneCaseProduct(CaseProduct__c caseProdData,Integer qty) {
        List<CaseProduct__c> clonedCaseProducts = new List<CaseProduct__c>();
        System.debug('caseProdData==>'+caseProdData);
        System.debug('qty==>'+qty);
        for(Integer i=0;i<qty;i++) {
            
            clonedCaseProducts.add(caseProdData.clone(false,true,false,false));
        }
        return clonedCaseProducts;
    }
    @AuraEnabled
	public Static CaseProduct__c[] getProduct(String rid){

	return [Select Id,Name,Case__c,Case__r.casenumber,Cause_Code__c,Cause_Type__c,Disposition__c,MacID__c,
            Product_Condition__c,Product_Returned__c,Quantity__c,Return_Region__c,
            RMA_Received_Date__c,Serial_Number__c from CaseProduct__c where id = :rid ];
	}
    
    
     @AuraEnabled
	public Static String saveproducts(List<CaseProduct__c> prdlist,String Causecode,string causetype,
                                      String disp,String retreg,CaseProduct__c caseProd){
        System.debug('Causecode==>'+Causecode);
        System.debug('causetype==>'+causetype);
        System.debug('retreg==>'+retreg);
                                          
        
        for(CaseProduct__c cp : prdlist){
        	cp.Product_Returned__c = true;
            cp.Cause_Code__c = Causecode;
            cp.Cause_Type__c = causetype; 
            cp.Disposition__c = disp;
            cp.Return_Region__c = retreg;
            cp.RMA_Received_Date__c = System.today();
			cp.Quantity__c = 1;
			cp.Status__c='Item received at warehouse';
			cp.User_that_received_Product__c = UserInfo.getUserId(); 
            
            
           
        }
        insert prdlist;
        if(caseProd != null) {            
            if(caseProd.Quantity__c == prdlist.size()) {
                delete caseProd;
                return 'Case';
            }else {
                caseProd.Quantity__c =   (caseProd.Quantity__c - prdlist.size());
                update caseProd;
            }            
        }
        
        return 'Success';
    }
   
    @AuraEnabled
	public Static String saveSingleProduct(String prodId,String Causecode,string causetype,
                                      String disp,String retreg,String prodCondition,String serialNum,String macId){
      CaseProduct__c cp = new CaseProduct__c();
      cp.Id = prodId;
	  cp.Product_Returned__c = true;
      cp.Cause_Code__c = Causecode;
      cp.Cause_Type__c = causetype; 
      cp.Disposition__c = disp;
      cp.Return_Region__c = retreg;
      cp.RMA_Received_Date__c = System.today();
	  cp.Quantity__c = 1;
	  cp.Status__c='Item received at warehouse';
	  cp.User_that_received_Product__c = UserInfo.getUserId();
      cp.Serial_Number__c = serialNum;
      cp.MacID__c = macId;
      cp.Product_Condition__c = prodCondition;
      update cp;
      return 'Success';
    }
    @AuraEnabled 
    public static Map<String, String> getCond(){
        Map<String, String> options = new Map<String, String>();
       
        Schema.DescribeFieldResult fieldResult = CaseProduct__c.Product_Condition__c.getDescribe();
        
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    	
}