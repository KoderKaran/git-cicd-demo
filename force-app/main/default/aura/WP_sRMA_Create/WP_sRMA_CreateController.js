({
    doInit: function (cmp, event, helper) {
        helper.InitReasonCodes(cmp, event);   
    },
    addRow: function(cmp, event, helper) {
        helper.addCaseProductRecord(cmp, event);
    },     
    removeRow: function(cmp, event, helper) {
        var cpList = cmp.get("v.cpList"); 
        console.log(cmp.get("v.cpList"));
        var selectedItem = event.currentTarget;        
        var index = selectedItem.dataset.record;     
        var keyField = cpList[index].KeyField;    
        cpList.splice(index, 1);
        cmp.set("v.cpList", cpList);
        
        console.log(cmp.get("v.cpList"));
    },
    saveRMA: function(cmp, event, helper) {
        cmp.set("v.isBtnDisabled", "true"); // don't click btn twice
        if (helper.validateCaseProductList(cmp, event)) {
            helper.CreateCaseProduct(cmp, event);          
        }
    },
    changeQuantity: function(cmp, event, helper){
        var i = event.getSource().get('v.name');
        var quantity = parseInt(event.getSource().get('v.value'));  
        var min = event.getSource().get('v.min');
        var max = event.getSource().get('v.max');  
        
        if(quantity >= min && quantity <= max)
        {  
            var cpList = cmp.get("v.cpList");         
            
            var cp = {
                'sobjectType': 'CaseProduct__c',
                'KeyField': cpList[i].KeyField,
                'SalesNumber': cpList[i].SalesNumber,
                'SalesDate': cpList[i].SalesDate,
                'SKU': cpList[i].SKU,
                'Reason' : cpList[i].Reason,
                'WarehouseError' : cpList[i].WarehouseError,
                'Quantity': cpList[i].Quantity,
                'MaxQuantity': cpList[i].MaxQuantity,                
                'UnitPrice': cpList[i].UnitPrice,
                'TotalPrice': cpList[i].UnitPrice * quantity            
            }
            
            cpList.splice(i, 1, cp);
            cmp.set("v.cpList", cpList);
            cmp.set("v.isBtnDisabled", false);        
        }
        else
        {
            cmp.set("v.isBtnDisabled", true);
        }        
    },
    closeModel: function(cmp, event, helper) {
        cmp.set("v.isModalOpen", false);
        cmp.set("v.isErrorModal", false);
        cmp.set("v.isBtnDisabled", "false");
    },
    addRemoveRMAEvent : function(cmp, event, helper) {
        var params = event.getParams();
        
        if (params.ActionType == 'Add') 
        {
            helper.ValidateAndAddSKU(cmp, event);    
        }
        else if (params.ActionType == 'Remove')
        {          
            var cpList = cmp.get("v.cpList");
            
            for(var i = 0; i < cpList.length; i++) 
            {                
                if(cpList[i].KeyField === params.KeyField) {
                    cpList.splice(i, 1);
                    cmp.set("v.cpList", cpList);     
                }
            }
            
            if (cpList.length === 0)
            {
                cmp.set("v.isBtnDisabled", true);
            }
        }        
    }
})