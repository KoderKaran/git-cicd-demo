({
    GetWarranty : function(cmp, resolve, reject, productCode, type) {
       
        //var url = 'https://erp.control4.com/C4Test/query/SF_GetWarranty.aspx?type=' + type + '&code=' + productCode;         
        var url = 'https://erp.control4.com/Default/query/SF_GetWarranty.aspx?type=' + type + '&code=' + productCode;     
        
        //console.log(url);
        var action = cmp.get("c.GetWarrantyInformation");

        action.setParams({
            "url": url
        });
        action.setCallback(this, function(response) {         
            var state = response.getState();            
            if (cmp.isValid() && state === "SUCCESS") 
            {           
                var parsedJSON = JSON.parse(response.getReturnValue());               
                //console.log('parsedJSON');
                //console.log(parsedJSON);
                //console.log(cmp.get("v.productCode"));
                if (parsedJSON.response.status === 'ERROR')
                {
                    cmp.set("v.ShowPanel", "error");
                    cmp.set("v.errorMessage", parsedJSON.response.payload.message);
                    reject();
                }
                else                    
                {
                    if (parsedJSON.response.payload.querydata.data === null)
                    {                   
                        console.log('Nothing was returned from ' + type + ' search'); 
                        if (type === 'exact')
                        {
                           resolve();    
                        }
                        else if (type === 'contains')
                        {
                           cmp.set("v.ShowPanel", "noresults");
                           resolve(); 
                        }
                                  
                    }               
                    else
                    {  
        				cmp.set("v.ShowPanel", "default");
                        var evt = cmp.getEvent("WP_dRMA_Warranty_Result_Event");
                        evt.setParams({
                            "MacSerServ" : productCode,
                            "ItemId" : parsedJSON.response.payload.querydata.data.row.Warranty_salesforce_product_id,
                            "ItemName" : parsedJSON.response.payload.querydata.data.row.Warranty_product_sku_name,
                            "ItemSKU" : parsedJSON.response.payload.querydata.data.row.Warranty_product_sku_id,
                            "InWarranty" : parsedJSON.response.payload.querydata.data.row.is_in_warranty,
                            "SalesNumber" : parsedJSON.response.payload.querydata.data.row.Warranty_order_id,  
                            "StockType" : parsedJSON.response.payload.querydata.data.row.Warranty_stock_type,
                            "StockTypeReason" : parsedJSON.response.payload.querydata.data.row.Warranty_stock_type_reason,
                            "WarrantyStart" : parsedJSON.response.payload.querydata.data.row.Warranty_start_date,
                            "WarrantyEnd" : parsedJSON.response.payload.querydata.data.row.Warranty_end_date,
                            "SerialCode" : parsedJSON.response.payload.querydata.data.row.Warranty_serial_code
                        });
                        evt.fire();
                        
                        resolve();
                    }
                }
            }
            else 
            {
                cmp.set("v.ShowPanel", "error");
                cmp.set("v.errorMessage", parsedJSON.response.payload.message);                
                reject();
            }            
        });
        
        $A.enqueueAction(action);    
    }

})