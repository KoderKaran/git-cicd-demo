({
    validateCaseProductList: function(cmp, event) {
        //Validate all CaseProduct records
        var isValid = true;
        var cpList = cmp.get("v.cpList");
        
        for (var i = 0; i < cpList.length; i++) {
            if (!cpList[i].Reason || (cpList[i].Reason == 'Warehouse Error' && !cpList[i].WarehouseError)) 
            {
                //alert('Error: cannot be None' + (i + 1));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Picklist value cannot be - None - ",
                    "duration" : "6500",
                    "type": "error", 
                    "message": "Please select a valid value for all picklist values" 
                });
                toastEvent.fire();
                
                isValid = false;
                cmp.set("v.isBtnDisabled", "false");                
            }
        }
        
        return isValid;
    },
    
    InitReasonCodes: function(cmp, event) {
        var action = cmp.get("c.GetReasonCodes");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var reasonCodes = response.getReturnValue(); 
                cmp.set("v.reasonList", reasonCodes);
            }
        }); 
        $A.enqueueAction(action);
    },
    
    addCaseProductRecord: function(cmp, event) {
        var cpList = cmp.get("v.cpList");
        //Add New CaseProduct Record
        cpList.push({
            'sobjectType': 'CaseProduct__c',
            'Item__c': '',
            'Quantity__c': '',
            'Original_Sale_Price__c': ''
        });
        cmp.set("v.cpList", cpList);
    },
    
    ValidateAndAddSKU: function(cmp, event, helper) {
        var params = event.getParams();
        var action = cmp.get("c.ValidateProductSKU");        
        action.setParams({
            "productCode": params.SKU
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                var val = response.getReturnValue();
                
                if (val === "Success")
                {                     
                    var cpList = cmp.get("v.cpList");
                    cpList.push({
                        'sobjectType' : 'CaseProduct__c',
                        'KeyField' : params.KeyField,
                        'SalesNumber' : params.SalesNumber,
                        'SalesDate': params.SalesDate,
                        'SKU': params.SKU,
                        'Reason' : '',
                        'WarehouseError' : '',
                        'Quantity': params.Quantity,
                        'MaxQuantity': params.MaxQuantity,
                        'UnitPrice': params.Price,
                        'TotalPrice': params.Price
                    });
                    
                    cmp.set("v.cpList", cpList);
                    cmp.set("v.isBtnDisabled", "false");
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Invalid SKU",
                        "duration" : "6500",
                        "type": "error", 
                        "message": params.SKU + " does not exist in Salesforce" 
                    });
                    toastEvent.fire();
                }
            }
        }); 
        $A.enqueueAction(action);
    },
    
    CreateCaseProduct: function(cmp, event, helper) {
        //Call Apex class and pass CaseProduct list parameters
        var action = cmp.get("c.CreateCaseProduct");
        var s = JSON.stringify(cmp.get("v.cpList"));        
        
        action.setParams({
            "itemsJSON": JSON.stringify(cmp.get("v.cpList")),
            "caseId": cmp.get("v.recordId"),
            "sendViaTrigger": cmp.get("v.sendViaTrigger"),
            "noCreditMemo": cmp.get("v.noCreditMemo"),
            "optOutOfEmail": cmp.get("v.optOutOfEmail"),
            "notes": cmp.get("v.caseRecord.Description")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var r = response.getReturnValue();   
                
                if (r.includes("ERROR")) {                    
                    cmp.set("v.isErrorModal", true);
                    cmp.set("v.errorMessage", r);
                }
                else {                    
                    var arr = cmp.get("v.cpList");
                    arr.splice(0, arr.length);
                    console.log("arr " + arr);
                    
                    cmp.set('v.cpList', arr);               
                    cmp.set("v.isBtnDisabled", "true");
                    cmp.set("v.noCreditMemo", "false");
                    cmp.set("v.optOutOfEmail", "false");
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "The Return has been created",
                        "duration" : "6500",
                        "type": "success", 
                        "message": "There is no greater satisfaction than a successful return"
                    });
                    toastEvent.fire();
                    
                    var appEvent = $A.get("e.c:WP_sRMA_RemoveEvent");
                    appEvent.setParams(
                        {"KeyField" : 'ResetForm'}
                    );        
                    appEvent.fire(); 
                    
                    $A.get('e.force:refreshView').fire();
                }
            }
        }); 
        $A.enqueueAction(action);
    }
})