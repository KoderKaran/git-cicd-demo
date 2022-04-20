public with sharing class SerialNumberTrackingController {
    private final Case cas;
    public String serialNum { get; set; }
    public Integer itemNum{ get; set; }
    public Boolean selected{ get; set; }
    public Boolean oneChosen{ get; set; }
    public Boolean noneChosen{ get; set; }
   // public List<Case> caseList{ get; set; }
    
    public Boolean serialNumberSaved{ get; set; }
    public Id currentRecordId{ get; set; }
    public List<CaseProduct__c> deleteList{ get; set; }
    public List<CaseProduct__c> prodList{ get; set; }
    public List<CaseProduct__c> topList{ get; set; }
    public List<CaseProduct__c> newReturnedProductList{ get; set; }
    public List<CaseProduct__c> tempList{ get; set; }
    public List<CaseProduct__c> finalBottomList{ get; set; }
    
    public SerialNumberTrackingController(ApexPages.StandardController stdController) 
    {
        deleteList =new List<CaseProduct__c> ();
        this.cas = (Case)stdController.getRecord();
        serialNum = null;
        oneChosen = false;
        noneChosen = true;
        itemNum = 0;
        selected = false;
        serialNumberSaved = false;
  
         currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');      
        
        
        tempList = new List<CaseProduct__c>();
        topList = new List<CaseProduct__c>();
        newReturnedProductList = new List<CaseProduct__c> ();
         finalBottomList = new List<CaseProduct__c> ();
        queryCase();
    }
    public void queryCase()
    {
        system.debug(' ****************************************************************** ' );
        prodList = [Select Id,Name,Add_to_List__c,C4_Item__c,Case__c,Cause_Code__c,Cause_Code_2__c,Cause_Type__c,Certified_Driver__c,Control_Method_Used__c
                ,Corrective_Action__c,Detail__c,Third_Party_Type__c,Disposition__c,DOA__c,Driver_Creator_Driver_Team_Use_Only__c,ECO_Level__c
                ,Estimated_Hardware_Repair_Charge__c,Estimated_Software_Repair_Charge__c,Hardware_Repair_Charge_Amount__c
                ,Interop_Review_Driver_Team_Use_Only__c,Issue__c,Item__c,MacID__c,MacID_Lookup__c,Third_Party_Make__c
                ,Manufacture_Date__c,Third_Party_Model__c,New_Email_RMA_Sent__c,No_Troubleshooting__c,Number_of_Task_Sent__c
                ,Outbound_Product__c,PreviousVersion__c,Product__c,Product_Returned__c,Product_Type__c,Quantity__c
                ,Reason_for_Call__c,Restock_Fee__c,Return_Shipment_Priority__c,RMA__c,RMA_Outcome__c,RMA_Reason__c
                ,RMA_Received_Date__c,RMA_Type__c,SAP_Solution_Code__c,Serial_Number__c,Ship_Date__c,Shipment_Priority__c
                ,Solution__c,Solution_Detail__c,Special_Offer__c,Subject__c,Symptom__c,Troubleshooting__c
                ,Symptom_Other_Detail__c,Time_Delayed_Task__c,Type__c,UK__c,Version__c,Wave_Reason__c,Warehouse_Error__c
        From CaseProduct__c where Case__c =:cas.Id ];
        System.Debug('topList: ---------> '+topList);
        for(CaseProduct__c c:prodList)
        {
             
            if(c.Quantity__c == 0)//if the quantity is 0 delete from SF
                deleteList.add(c);
            if(c.Add_to_List__c == true)
                    c.Add_to_List__c = false;
            if(c.Troubleshooting__c == null)
                    c.Troubleshooting__c = 'N/A';
            if(c.Quantity__c != 0 && c.Product_Returned__c == false)
            {
                topList.add(c);
            }
            if(c.Product_Returned__c == true)
            {
                finalBottomList.add(c);
            }
            
        }
          system.debug('====================================================== ' );
    }
        /*pagereference p = apexpages.Currentpage();
        apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Total Number of reloads: ' + (myInt++));
        apexpages.addmessage(msg);
        return p;*/
    public PageReference returnProd()
    {
        pagereference p = apexpages.Currentpage();
        integer count = 0;
        for(CaseProduct__c t:topList)
        {
            if(t.Add_to_List__c == true)
            {
                noneChosen = false;
            }
        }
        /*if(noneChosen = true)
        { 
            apexpages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a record to modify');
            apexpages.addmessage(msg);
            return p;
        }*/
       
        for(CaseProduct__c t:topList)
        {
            if(t.Add_to_List__c == true)count++;
            if(t.Add_to_List__c == true && count >1)
            {
                apexpages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose only 1 record to modify');
                apexpages.addmessage(msg);
                return p;
            }
        }
        
                
         if(itemNum ==0)
        {
            apexpages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a quantity larger than 0');
            apexpages.addmessage(msg);
            return p;
        }

        for(CaseProduct__c t:topList)
        {
            if(itemNum > t.Quantity__c && t.Add_to_List__c == true)
            {
                apexpages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a number less than, or equal to, the record quantity of: '+t.Quantity__c);
                apexpages.addmessage(msg);
                return p;
            }
            if(t.Add_to_List__c == true && itemNum <= t.Quantity__c)
            {
                tempList.add(t); 
                t.Quantity__c = t.Quantity__c -  itemNum;//remove from quantity once cloned
                if(t.Quantity__c == 0)deleteList.add(t);
                
            }
        }
        for(CaseProduct__c d:tempList)
        {
            
            for(Integer i =0;i<topList.size();i++)
            {
                if(topList[i].Id == d.Id )
                {
                    topList.remove(i); 
                }
            }

        }
        System.Debug('tempList: '+tempList);
        update tempList;
        for(CaseProduct__c v:topList)
        {
            if(v.Quantity__c == 0)deleteList.add(v);
        }
        CreateNewRecords();
        topList.clear();
        tempList.clear();
        insert newReturnedProductList;
        System.Debug('newReturnedProductList: '+newReturnedProductList);
        newReturnedProductList.clear();
        finalBottomList.clear();
        selected = false;
        itemNum = 0;
        System.Debug(deleteList);
        for(CaseProduct__c d:deleteList)
        {
            delete d;
        }
        deleteList.clear();
        queryCase();
        return null;
    }
    
    public void CreateNewRecords()
    {
        system.debug('tempList =====> ' + tempList);
        for(CaseProduct__c cp:tempList)
        {  
            system.debug('cp =====> ' + cp);
            for(Integer i =0;i<itemNum;i++)
            {
                CaseProduct__c ca = cp.clone(false, true, false, false);
                ca.Product_Returned__c = true;
                ca.RMA_Received_Date__c = Date.today();
                ca.Disposition__c = 'Return to A-Stock';
                ca.Cause_Type__c = 'Administrative';
                ca.Cause_code__c = 'Receiving';
                ca.Quantity__c = 1;
                system.debug(ca);
                newReturnedProductList.add(ca);
                System.Debug('added cloned product');
            }
        }
    }
    
    /* method updates MacId */
    public void updateMacId(){
        List<CaseProduct__c> updateMacIdList = new List<CaseProduct__c>(); 
        for(CaseProduct__c cp : finalBottomList){
            updateMacIdList.add(cp);    
        }
          
        if(updateMacIdList.size() > 0){
            serialNumberSaved = true;
          update updateMacIdList;
        }
        else{
            serialNumberSaved = false;
        }
        
    }
   
}