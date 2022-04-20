({
    GetDeliveries : function(cmp, event) {
        var action = cmp.get("c.GetSalesOrderInformation");   
        
        action.setParams({
            "caseID": cmp.get("v.recordId"),
            "salesNumber": cmp.get("v.salesNumber"),
            "beginDate": cmp.get("v.beginDate"),
            "endDate": cmp.get("v.endDate")           
        });
        action.setCallback(this, function(response) {         
            var state = response.getState();            
            if (cmp.isValid() && state === "SUCCESS") 
            {   
                var stringdata = response.getReturnValue();         
                var data = JSON.parse(response.getReturnValue());			            
                var temojson = JSON.parse(JSON.stringify(data).split('items').join('_children'));
                cmp.set("v.gridData",  temojson);
                
                if (cmp.get("v.gridData") === null)
                {             
                    cmp.set("v.ShowPanel", "NoWarrantyFound");        
                }               
                else
                {
                   cmp.set("v.ShowPanel", "ResultMessage");
                }            
            }
            else 
            {
                console.log("state " + state);
                console.log("cmp.isValid(): " + cmp.isValid());
                cmp.set("v.ShowPanel", "ErrorMessage");
            }            
        });
        
        $A.enqueueAction(action);    
    }    
})