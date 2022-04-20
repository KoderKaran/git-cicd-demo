({   
    doInit : function(cmp, event, helper){
        cmp.set('v.gridColumns',[
            {label:'SKU', fieldName:'productCode', type:'text', initialWidth: 150, hideDefaultActions: true},
            {label:'Name', fieldName:'productName', type:'text', hideDefaultActions: true},
            {label:'Inventory', fieldName:'inventory', type:'text', initialWidth: 20, hideDefaultActions: true}
            
            //{label:'Child', fieldName:'Parent__c',  type: 'url',
            //typeAttributes: {label: { fieldName: 'productCode' }, target: '_blank'}                        
        ]);                  
    },
    handleProdEvent : function(cmp, event, helper) {
        if (event.getParam("ProductId"))
        {
            cmp.set("v.productId", event.getParam("ProductId"));
            cmp.set("v.stockType", event.getParam("StockType"))
            cmp.set("v.stockTypeReason", event.getParam("StockTypeReason"))
            cmp.set("v.WarrantyStart", event.getParam("WarrantyStart"));
        	cmp.set("v.WarrantyEnd", event.getParam("WarrantyEnd"));
            cmp.set("v.InWarranty", event.getParam("InWarranty"));
            cmp.set("v.SerialCode", event.getParam("SerialCode"));
            cmp.set("v.ItemSKU", event.getParam("ItemSKU"));
            cmp.set("v.ItemName", event.getParam("ItemName"));
			cmp.set("v.ShowWarrantyPanal", event.getParam("ShowWarrantyPanal"));      
            
			// These are asynchronous call outs called a promise patterned after this guide 
			// https://medium.com/salesforce-zolo/the-easy-guide-to-understanding-js-promises-78f5f19539e0            
            function asycCalls(resolve, reject) {
                helper.getSubProducts(cmp, event, resolve, reject); 
                
            }         
            
            var myPromise = new Promise(asycCalls);            
            myPromise.then(
                function () {
              $A.enqueueAction(cmp.get('c.onSelected'));
            }, 
            function () {
              console.log('There was an error');
            });
            // This is the end of the promise section
            
            cmp.set("v.showComponent", true);     

            if (event.getParam("InWarranty"))
            {
              cmp.set("v.showDetails", false);   
            }
        }
        else
        {
            cmp.set("v.showComponent", false);  
        }
    },
    handleOutboundSelectedEvent  : function(cmp, event, helper)
    {        
        if (event.getParam("ProductId") !== '')
        {
            cmp.set("v.productId", event.getParam("ProductId"));
			cmp.set("v.showDetails", true);
        }
        else
        {
            cmp.set("v.showDetails", false);
        }
    },
    onSelected : function(cmp, event, helper)
    {
        //console.log("Doing onSelected");
        var tempList = [];
        var selectRows  = cmp.find("subProdTreegridID").getSelectedRows()
        
        if(selectRows.length > 0)
        {
            selectRows.forEach(record => {tempList.push(record.KeyField);})
			
            if (selectRows.length == 1)
            {
            	 cmp.set("v.previous", selectRows[0].KeyField);                             
            }
            else
            {                                         
            	var index = tempList.indexOf(cmp.get("v.previous"));
                if(index > -1){
                	selectRows.splice(index, 1);
                	cmp.set("v.previous", selectRows[0].KeyField); 
                }          
            }                                
            
            cmp.set("v.selectedRows", selectRows[0].KeyField);
            cmp.set("v.productId", selectRows[0].KeyField);
            //cmp.set("v.showDetails", true);
            
            var appEvent = $A.get("e.c:WP_dRMA_OutboundProduct_Event");
            appEvent.setParams({
                "ProductId" : selectRows[0].KeyField,
                "ProductCode" : selectRows[0].productCode,
                "ProductName" : selectRows[0].productName
                
            });
            appEvent.fire();
        }
    }
})