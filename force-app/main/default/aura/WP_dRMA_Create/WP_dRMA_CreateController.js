({ 
    doInit : function(cmp, event, helper) {

        console.log("doInit of WP_dRMA_Create.cmp RecordId = " + cmp.get("v.recordId"));

        var actions = [
            { label: 'Edit', name: 'edit', iconName: 'utility:edit' },
            { label: 'Delete', name: 'delete', iconName: 'utility:delete' }
        ];

        cmp.set('v.rmaListColumns', [
            {type: 'action', iconName: 'standard:product', typeAttributes: { rowActions: actions }},
            {label: 'Product', fieldName: 'name', type: 'text', initialWidth: 80, hideDefaultActions: true, wrapText: true},
            {label: 'RMA', fieldName: 'rma', type: 'text', initialWidth: 20, hideDefaultActions: true, wrapText: true},
            {label: 'Mac, Serial, Service Tag', fieldName: 'macID', type: 'text', initialWidth: 165, hideDefaultActions: true, wrapText: false},
            {label: 'Support Product', fieldName: 'supProdName', type: 'text', initialWidth: 150, hideDefaultActions: true, wrapText: true},  
            {label: 'Product', fieldName: 'itemName', type: 'text', initialWidth: 300, hideDefaultActions: true, wrapText: true}
        ]);

        helper.InitOutcomeList(cmp, event, cmp.get("v.recordId")); 
        helper.InitShipmentList(cmp, event, helper);
        helper.GetRMARecords(cmp, event);
        helper.InitCustomValues(cmp, event);
        helper.GetWarrantyException(cmp, event, cmp.get("v.recordId"));
    },
  
 // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },    
    handle_Warranty_Result : function (cmp, event, helper) {
        
        if (event.getParam("MacSerServ") === "WarrantyPanelReset")
        {
            helper.WarrantyPanelReset(cmp, event, helper);
        }
        else
        {            
            cmp.set("v.warEdit", true); 
            cmp.set("v.nsoSOisDisabled", true); 
            cmp.set("v.ItemSKU", event.getParam("ItemSKU"));
            cmp.set("v.ItemName", event.getParam("ItemName"));
            cmp.set("v.SalesNumber", event.getParam("SalesNumber"));
            cmp.set("v.SalesNumberViaAutomation", true);
            cmp.set("v.WarrantyStart", event.getParam("WarrantyStart"));
            cmp.set("v.WarrantyEnd", event.getParam("WarrantyEnd"));     
            cmp.set("v.SerialCode", event.getParam("SerialCode"));       
            cmp.set("v.MacSerServ", event.getParam("MacSerServ"));            
            cmp.set("v.InWarranty", event.getParam("InWarranty"));
            cmp.set("v.InWarrantyReason", "Warranty found via automation");
            cmp.set("v.StockType", event.getParam("StockType")); 
            cmp.set("v.StockTypeReason", event.getParam("StockTypeReason")); 
            cmp.set("v.warPanel", true);
            cmp.set("v.item", []); // init the field     
            
            var itemList = cmp.get("v.item");
            itemList.push({
                'icon': 'standard:products',
                'id': event.getParam("ItemId"),
                'sObjectType': 'Product',
                'subtitle': event.getParam("ItemSKU"),
                'title':  event.getParam("ItemName"),
            });
            cmp.set("v.item", itemList);  
            
            // logic for RMA outcome field            
            if (cmp.get("v.InWarranty") === 'true') 
            {
                if (cmp.get("v.IsCreditOnlyAccount"))
                {
                    cmp.set("v.outcomeList", ["Credit Only"]);
                	cmp.set("v.outcome", "Credit Only");
                }
                else 
                {    
                    cmp.set("v.outcomeList", ["Advanced Replacement", "Credit Only"]); // order matters, refresh issues
                	cmp.set("v.outcome", "Advanced Replacement"); 
                }               
            }
            else 
            {
                cmp.set("v.outcomeList", ["None - Out of Warranty","Repair - Out of Warranty","Repair Kit - Out of Warranty"]); // order matters, refresh issues
                setTimeout(() => { cmp.set("v.outcome", "None - Out of Warranty"); }, 50); // bug, needs time. I don't know why
            }           
        }        
    },    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        //alert('Showing Details: ' + JSON.stringify(row));
        
        switch (action.name) {
            case 'edit':   
                cmp.set("v.rmaId", row.id);
                cmp.set("v.mainPanel", true);
                helper.HelpGetRMA(cmp, helper);                
                break;
            case 'delete':
                helper.handleDelete(cmp, row, helper);                
                if (cmp.get("v.rmaList").length === 0) {
                    cmp.set("v.mainPanel", true);
                }
                break;
        }
    },
    searchSupportProd : function(cmp, event, helper) {
        cmp.find('lookupSupportProd').search(cmp.get('c.search'));
    },
    searchIssue : function(cmp, event, helper) {
        cmp.find('lookupIssue').search(cmp.get('c.searchIssues'));
    },
    searchItem : function(cmp, event, helper) {
        cmp.find('lookupItem').search(cmp.get('c.searchItems'));       
    },
    searchOutboundItem : function(cmp, event, helper) {
        cmp.find('lookupOutboundItem').search(cmp.get('c.outboundItems'));
    },
    nsoChanged : function(cmp, event, helper) {    
        if (!cmp.get("v.nso")) {            
            cmp.set("v.nsoSOisDisabled", false);
 			cmp.set("v.nsoReason", "- None -");
        }
        else
        {
            cmp.set("v.nsoSOisDisabled", true);
            cmp.set("v.nsoReason", "- None -");
        	cmp.set("v.SalesNumber", ""); 
        }

        helper.validFormCheck(cmp, event);
    },  
//Start

InWarrantyChanged : function(cmp, event, helper) {
    if (!cmp.get("v.InWarranty") && cmp.get("v.inWarrantyExceptionPicklistValue") == "None") {
        cmp.set("v.warrentyisDisabled",false); 
    }
    else
    {
        cmp.set("v.warrentyisDisabled", true);
    }

    helper.validFormCheck(cmp, event);
},


//Stop

   /* InWarrantyChanged : function(cmp, event, helper) {    
        if (!cmp.get("v.InWarranty")) {
 			cmp.set("v.InWarrantyReason", "");
             cmp.set("v.isWarrantyReasonSelected", false);
             cmp.set("v.InWarranty", false);
        }
       
    }, */
    ManualChanged : function(cmp, event, helper) {           
        cmp.set("v.item", []);
        cmp.set("v.outboundItem", []);
        cmp.set("v.SalesNumber", ""); 
        cmp.set("v.nsoReason", "- None -");        
	    cmp.set("v.InWarranty", false); 
        cmp.set("v.InWarrantyReason", "");

        console.log(cmp.get("v.outcome"));
        

        if (cmp.get("v.itemPanel") === true) {
            cmp.set("v.warEdit", false);
            cmp.set("v.nsoSOisDisabled", false);            
            cmp.set("v.warPanel", false); 
        }
        else {
            cmp.set("v.warPanel", false);
            cmp.set("v.warEdit", true);
            cmp.set("v.nsoSOisDisabled", true);  
        }
        
        helper.InitOutcomeList(cmp, event, cmp.get("v.recordId")); 
        //helper.InitCustomValues(cmp, event);
        //cmp.set("v.outcome", "None - Out of Warranty");
        console.log(cmp.get("v.outcome")); 
    },    
//    minus : function(cmp, event, helper) {
//        var q = cmp.get("v.quantity") ;
//        if (q > 1) {
//            cmp.set("v.quantity", q -1);
//        }        
//    },
//   plus : function(cmp, event, helper) {
//        cmp.set("v.quantity", cmp.get("v.quantity") + 1);        
//    },    
    handleOutboundProdEvent : function(cmp, event, helper) {
        cmp.set("v.outboundItem", []); 
        var itemList = cmp.get("v.outboundItem");
        itemList.push({
            'icon': 'standard:products',
            'id': event.getParam("ProductId"),
            'sObjectType': 'Product',
            'subtitle': event.getParam("ProductCode"),
            'title': event.getParam("ProductName")
        });
        cmp.set("v.outboundItem", itemList); 
    },
    validateForm : function(cmp, event, helper)
    {
        helper.validFormCheck(cmp, event);       
	},
    outboundChanged : function(cmp, event, helper) {
        
        // show misc description field
        if(cmp.get("v.outboundItem") && cmp.get("v.outboundItem").length)
        {            
            if (cmp.get("v.outboundItem")[0].subtitle === "MISC-PART")
            {
                cmp.set("v.miscPartPanel", true);   
            }
            else
            {
                cmp.set("v.miscPartPanel", false);
            }
        }
                      
        // fire event to show inventory levels on WP_dRMA_Assistant
         var evt = $A.get("e.c:WP_dRMA_OutboundSelected_Event");
        evt.setParams({
            "ProductId" : (cmp.get("v.outboundItem") && cmp.get("v.outboundItem").length) ? cmp.get("v.outboundItem")[0].id : []
        });
        evt.fire();      

        
        helper.validFormCheck(cmp, event);
    },    
    itemChanged : function(cmp, event, helper) {      
        var item =  event.getParam("value");        
        console.log("item:  "+item);
        var evt = $A.get("e.c:WP_dRMA_Product_Event");
        evt.setParams({
            "ProductId" : (Array.isArray(item) && item.length) ? item[0].id : '',
            "StockType" : cmp.get("v.StockType"),
            "StockTypeReason" : cmp.get("v.StockTypeReason"),
            "WarrantyStart" : cmp.get("v.WarrantyStart"),
            "WarrantyEnd": cmp.get("v.WarrantyEnd"),
            "SerialCode": cmp.get("v.SerialCode"),
            "InWarranty": cmp.get("v.InWarranty"),
            "ItemSKU": cmp.get("v.ItemSKU"),
            "ItemName": cmp.get("v.ItemName"),            
            "ShowWarrantyPanal": cmp.get("v.warPanel")
        });
        evt.fire();      
        
        helper.validFormCheck(cmp, event);
        //helper.CheckQuantity(cmp, event);        
    },
    New : function(cmp, event, helper) {
        helper.NewFormInit(cmp, event, helper);
        cmp.set("v.mainPanel", true); 
    },
    save : function(cmp, event, helper) {
            cmp.set("v.Spinner", true);
            helper.HelpSave(cmp, event, helper);
            helper.NewFormInit(cmp, event, helper)
            helper.GetRMARecords(cmp, event);
            cmp.set("v.mainPanel", false);
    },
    saveAndClone : function(cmp, event, helper) { 
        cmp.set("v.Spinner", true);
        helper.HelpSave(cmp, event, helper);        
        cmp.set("v.rmaId", "");
        cmp.set("v.mainPanel", true);
        cmp.set("v.clonePanel", true);        
    },
    saveAndNew : function(cmp, event, helper) {
        cmp.set("v.Spinner", true);
        helper.HelpSave(cmp, event, helper);
        helper.NewFormInit(cmp, event, helper)
        cmp.set("v.mainPanel", true); 
    },
    cancel : function(cmp, event, helper) {       
        helper.NewFormInit(cmp, event, helper);       
        helper.GetRMARecords(cmp, event);
        cmp.set("v.mainPanel", false);
    },
    closeModel: function(cmp, event, helper) {
        cmp.set("v.isModalOpen", false);
        cmp.set("v.isErrorModal", false);
    }
});