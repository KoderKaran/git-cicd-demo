({
    NewFormInit : function(cmp, event, helper) {
        //cmp.set("v.mainPanel", true);
        cmp.set("v.rmaId", "");      
        cmp.set("v.isRMA", false); 
        cmp.set("v.warPanel", false);         
        cmp.set("v.itemPanel", false);
        cmp.set("v.clonePanel", false);    
        cmp.set("v.warEdit", true);
        cmp.set("v.nsoSOisDisabled", true);        
        cmp.set("v.nso", false);
        cmp.set("v.nsoReason", "- None -");
        cmp.set("v.supportProd", []);
        cmp.set("v.issue", []);
        cmp.set("v.item", []);
        cmp.set("v.outboundItem", []);
        cmp.set("v.outcome", "");
        cmp.set("v.notes", "");
        cmp.set("v.version", "");
        cmp.set("v.quantity", 1);
        cmp.set("v.failUpdate", false);
        cmp.set("v.damageTransit", false);
        cmp.set("v.failBox", false);
        cmp.set("v.ovrcIssue", false);
        cmp.set("v.noTroubleshoot", false);
        cmp.set("v.isSerialized", false);
        cmp.set("v.InWarranty", false);
        cmp.set("v.InWarrantyReason", "");
        //helper.InitCustomValues(cmp, event)
    },
  	WarrantyPanelReset : function(cmp, event, helper) {
        cmp.set("v.warPanel", false);         
        cmp.set("v.itemPanel", false);
        cmp.set("v.clonePanel", false);    
        cmp.set("v.warEdit", true);
        cmp.set("v.nsoSOisDisabled", true);
        cmp.set("v.nso", false);
        cmp.set("v.nsoReason", "- None -");
        cmp.set("v.item", []);
        cmp.set("v.outboundItem", []);
        cmp.set("v.outcome", ""); 
        cmp.set("v.InWarranty", false);
        cmp.set("v.InWarrantyReason", "");
    },
    validFormCheck : function(cmp, event) 
    {
        if (cmp.get("v.isRMA"))
        {
            if ((!Array.isArray(cmp.get("v.supportProd")) || !cmp.get("v.supportProd").length) || 
                (!Array.isArray(cmp.get("v.issue")) || !cmp.get("v.issue").length) ||
                (!Array.isArray(cmp.get("v.item")) || !cmp.get("v.item").length)|| 
                (!Array.isArray(cmp.get("v.outboundItem")) || !cmp.get("v.outboundItem").length) ||
                (cmp.get("v.MacSerServ") === undefined) || (cmp.get("v.MacSerServ").match(/^ *$/) !== null) || // null means MacSerServ has a string in it
                (cmp.get("v.SalesNumber") === undefined) || 
                (cmp.get("v.SalesNumber") === 'NOT FOUND') ||
                (isNaN(cmp.get("v.SalesNumber")) && cmp.get("v.SalesNumber") === 'NOT FOUND') ||
                (cmp.get("v.nso")== '' && cmp.get("v.SalesNumber") == '') ||
                (cmp.get("v.nso")== '' && cmp.get("v.nsoReason") === "- None -") ||
                (cmp.get("v.inWarrantyExceptionPicklistValue") == "None")
               ) {
                cmp.set("v.saveDisabled", true);
            } else {
               cmp.set("v.saveDisabled", false);
            }
        }
        else
        {
            if (!Array.isArray(cmp.get("v.supportProd")) || !cmp.get("v.supportProd").length || !Array.isArray(cmp.get("v.issue")) || !cmp.get("v.issue").length) {
                cmp.set("v.saveDisabled", true);
            } else {
               cmp.set("v.saveDisabled", false);
            }
        }
    },
    CheckQuantity : function(cmp, event) 
    {
        var action = cmp.get("c.GetIsSerialized");

        action.setParams({
            "productID": cmp.get("v.item")[0] ? cmp.get("v.item")[0].id : ''
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var isSerialized = response.getReturnValue();

                //console.log("v.isSerialized");
                //console.log(isSerialized);

                if (isSerialized == true)
                {
                    cmp.set("v.quantity", 1);
					cmp.set("v.isSerialized", true);
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    InitOutcomeList : function(cmp, event, caseId) {

        var action = cmp.get("c.GetOutcomeList");
        
        action.setParams({
            "caseId": caseId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var outcomes = response.getReturnValue(); 
                cmp.set("v.outcomeList", outcomes);
                setTimeout(() => { cmp.set("v.outcome", "None - Out of Warranty"); }, 50); // bug, needs time. I don't know why
            }
        }); 
        
        $A.enqueueAction(action);
    },
    InitShipmentList : function(cmp, event, helper) {
        var action = cmp.get("c.GetShipmentList");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var issueCodes = response.getReturnValue(); 
                cmp.set("v.shipmentList", issueCodes);              
            }
        }); 
        
        $A.enqueueAction(action);
    },
    GetRMARecords : function(cmp, event) {
        var action = cmp.get("c.GetRMARecords");
        var caseID = cmp.get("v.recordId");
        
        action.setParams({
            "caseID": caseID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                cmp.set("v.rmaList", response.getReturnValue());
               
                if (cmp.get("v.rmaList").length === 0)
                {
                    cmp.set("v.mainPanel", true);
                }
                else
                {
                    cmp.set("v.mainPanel", false);
                }
            }
            
            //cmp.set("v.Spinner", false);
        }); 
        $A.enqueueAction(action);
    },
    InitCustomValues : function(cmp, event) {
        var action = cmp.get("c.GetCustomValues");
        
        action.setParams({
            "caseID": cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var cust = response.getReturnValue() 
                cmp.set("v.shipping", cust.Shipping);
               
                if (cust.CreditOnly)
                {
                    cmp.set("v.IsCreditOnlyAccount", true);
                }
                else
                {
                   	cmp.set("v.IsCreditOnlyAccount", false); 
                }                
            }
        }); 
        
        $A.enqueueAction(action);
    },    
    HelpSave : function(cmp, event, helper) {

        //console.log("v.rmaId:  " + cmp.get("v.rmaId"));
        //console.log("v.caseID:  " + caseID);
        //console.log("v.notes:  " + cmp.get("v.notes"));
        //console.log("v.supportProd:  " + cmp.get("v.supportProd")[0] ? cmp.get("v.supportProd")[0].id : '');
        //console.log("v.version:  " + cmp.get("v.version"));
        //console.log("v.issue:  " + cmp.get("v.issue")[0] ? cmp.get("v.issue")[0].id : '');
        //console.log("v.isRMA:  " + cmp.get("v.isRMA"));
        //console.log("v.MacSerServ:  " + cmp.get("v.MacSerServ"));
        //console.log("v.item:  " + cmp.get("v.item")[0] ? cmp.get("v.item")[0].id : '');
        //console.log("v.sku:  " + cmp.get("v.item")[0] ? cmp.get("v.item")[0].subtitle : '');
        //console.log("v.SalesNumber:  " + cmp.get("v.SalesNumber"));
        //console.log("v.SalesNumberViaAutomation:  " + cmp.get("v.SalesNumberViaAutomation"));
        //console.log("v.nsoReason:  " + cmp.get("v.nsoReason"));
        //console.log("v.outcome:  " + cmp.get("v.outcome"));
        //console.log("v.outboundItem:  " + cmp.get("v.outboundItem")[0] ? cmp.get("v.outboundItem")[0].id : '');
        //console.log("v.miscPartReason:  " + cmp.get("v.miscPartReason"));
        //console.log("v.shipping:  " + cmp.get("v.shipping"));
        //console.log("v.quantity:  " + cmp.get("v.quantity"));
        //console.log("v.failUpdate:  " + cmp.get("v.failUpdate"));
        //console.log("v.damageTransit:  " + cmp.get("v.damageTransit"));
        //console.log("v.failBox:  " + cmp.get("v.failBox"));
        //console.log("v.ovrcIssue:  " + cmp.get("v.ovrcIssue"));
        //console.log("v.noTroubleshoot:  " + cmp.get("v.noTroubleshoot"));
        //console.log("v.InWarranty:  " + cmp.get("v.InWarranty"));
        //console.log("v.inWarrantyReason:  " + cmp.get("v.InWarrantyReason"));

        var caseID = cmp.get("v.recordId");
        var action = cmp.get("c.SaveRMA");

        action.setParams({
            "rmaId" : cmp.get("v.rmaId"),
            "caseId": caseID,
            "notes": cmp.get("v.notes"),
            "supportProd": cmp.get("v.supportProd")[0] ? cmp.get("v.supportProd")[0].id : '',
            "version" : cmp.get("v.version"),
            "issue" : cmp.get("v.issue")[0] ? cmp.get("v.issue")[0].id : '',
            "isRMA" : cmp.get("v.isRMA"), 
            "macSerServ" : cmp.get("v.MacSerServ"),
            "item" : cmp.get("v.item")[0] ? cmp.get("v.item")[0].id : '',
            "sku" : cmp.get("v.item")[0] ? cmp.get("v.item")[0].subtitle : '',
            "salesNumber" : cmp.get("v.SalesNumber"),
            "SalesNumberViaAutomation" : cmp.get("v.SalesNumberViaAutomation"),
            "nsoReason" : cmp.get("v.nsoReason"),
            "outcome" : cmp.get("v.outcome"),
            "outboundItem" : cmp.get("v.outboundItem")[0] ? cmp.get("v.outboundItem")[0].id : '',
            "miscPartReason" : cmp.get("v.miscPartReason"),           
            "shipping" : cmp.get("v.shipping"),
            "quantity" : cmp.get("v.quantity"),
            "failUpdate" : cmp.get("v.failUpdate"),
            "damageTransit" : cmp.get("v.damageTransit"),
            "failBox" : cmp.get("v.failBox"),
            "ovrcIssue" : cmp.get("v.ovrcIssue"),
            "noTroubleshoot" : cmp.get("v.noTroubleshoot"),
            "inWarranty" : cmp.get("v.InWarranty"),
            "inWarrantyReason" : cmp.get("v.InWarrantyReason"),
            "inWarrantyException" : cmp.get("v.inWarrantyExceptionPicklistValue")
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
                    cmp.set("v.rmaName", r);

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "The RMA has been saved",
                        "duration" : "6500",
                        "type": "success", 
                        "message": "RMA goodness has been had"
                    });
                    toastEvent.fire();
                }

                $A.get('e.force:refreshView').fire();
            }

            cmp.set("v.Spinner", false);
        });

        $A.enqueueAction(action);

        var warrantyPicklistValue = cmp.get("v.inWarrantyExceptionPicklistValue");
        var exceptionWrapperData = cmp.get("c.exceptionMetadata");
        exceptionWrapperData.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {

                var r = response.getReturnValue();
                if(r.includes(warrantyPicklistValue)) {

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Need Approval",
                        "duration" : "6500",
                        "type": "success",
                        "message": "Need approval for the selected In Warranty Reason."
                    });
                    toastEvent.fire();
                }
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(exceptionWrapperData);
    },
    HelpGetRMA : function(cmp, row, helper) {

        var action = cmp.get("c.GetRMA");

        action.setParams({
            "rmaId": cmp.get("v.rmaId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var rma = response.getReturnValue();

                var sList = cmp.get("v.supportProd");
                sList.push({
                    'icon': 'standard:products',
                    'id': rma.SupportedProduct,
                    'sObjectType': 'Product',
                    'subtitle': rma.SupportedProductSKU,
                    'title': rma.SupportedProductName
                });
                cmp.set("v.supportProd", sList);

                cmp.set("v.version", rma.Version);

                var rList = cmp.get("v.issue");
                rList.push({
                    'icon': 'standard:product_required',
                    'id': rma.Issue,
                    'sObjectType': 'Product',
                    'subtitle': rma.IssueHelp,
                    'title': rma.IssueName
                });

                cmp.set("v.issue", rList);
                cmp.set("v.isRMA", rma.RMA);
                cmp.set("v.itemPanel", true);
                cmp.set("v.warEdit", false);
                cmp.set("v.nsoSOisDisabled", false);
                cmp.set("v.MacSerServ", rma.MacSerServ);

                var iList = cmp.get("v.item");
                iList.push({
                    'icon': 'standard:products',
                    'id': rma.Item,
                    'sObjectType': 'Product',
                    'subtitle': rma.ItemSKU,
                    'title': rma.ItemName
                });
                cmp.set("v.item", iList);

                var oList = cmp.get("v.outboundItem");
                oList.push({
                    'icon': 'standard:products',
                    'id': rma.OutboundItem,
                    'sObjectType': 'Product',
                    'subtitle': rma.OutboundSKU,
                    'title': rma.OutboundName
                });
                cmp.set("v.outboundItem", oList);

                cmp.set("v.SalesNumber", rma.SalesNumber);

                if (rma.NSOReason !== undefined && rma.NSOReason !== "Best Guess Found")
                {
                	cmp.set("v.nso", true);
                	cmp.set("v.nsoReason", rma.NSOReason);
                }
                else
                {
                	cmp.set("v.nso", false);
                	cmp.set("v.nsoReason", "- None -");
                }
                
                cmp.set("v.InWarranty", rma.InWarranty); 
                cmp.set("v.InWarrantyReason", rma.InWarrantyReason); 
                cmp.set("v.outcome", rma.RMAOutcome);               
                cmp.set("v.shipment", rma.Shipping);
                cmp.set("v.quantity", rma.Quantity);                
                cmp.set("v.failUpdate", rma.FailedUpdate);
                cmp.set("v.damageTransit", rma.DamagedTransit);
                cmp.set("v.failBox", rma.OutBoxfailure);
                cmp.set("v.ovrcIssue", rma.OvrCIssue);
                cmp.set("v.noTroubleshoot", rma.NoTroubleshooting);
            }
        }); 
        
        $A.enqueueAction(action);
    },
    handleDelete : function(cmp, row, helper) {
        //Call Apex class and pass CaseProduct list parameters
        var action = cmp.get("c.DeleteRMA");
        
        action.setParams({
            "rmaId": row.id
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
                    
                    // Delete from RMA list
                    var rmaList = cmp.get("v.rmaList");        	
                    var index = rmaList.findIndex(function (rmaList) { 
                        return rmaList.id === row.id;
                    });
                    
                    //console.log("index " + index);
                    rmaList.splice(index, 1);
                    cmp.set("v.rmaList", rmaList);                
                    
                    if (cmp.get("v.rmaList").length === 0)
                    {
                        //cmp.set("v.mainPanel", true);
                        helper.NewFormInit(cmp, event, helper);
                    }
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "The RMA has been deleted",
                        "duration" : "6500",
                        "type": "success", 
                        "message": "Gone are the days of that RMA"
                    });
                    toastEvent.fire();
                    
                    $A.get('e.force:refreshView').fire();
                }
            }
        }); 
        
        $A.enqueueAction(action);
    },
    GetWarrantyException : function(cmp, event, caseId) {

        var action = cmp.get("c.getCaseRecord");
        action.setParams({
            "caseId": caseId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var r = response.getReturnValue();
                if(r.length > 0) {

                    cmp.set("v.inWarrantyExceptionPicklistValue", r);
                }
            }
        });

        $A.enqueueAction(action);
    }
})