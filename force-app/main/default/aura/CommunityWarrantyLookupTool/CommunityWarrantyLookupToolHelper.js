({
    GetWarranty : function(component, event, url, searchType) {
        var action = component.get("c.GetWarrantyInformation");
        console.log("start of component");
        action.setParams({
            "url": url
        });
        action.setCallback(this, function(response) {         
            var state = response.getState();            
            if (component.isValid() && state === "SUCCESS") {           
                var parsedJSon = JSON.parse(response.getReturnValue());    
                
      
				console.log("found warranty data");
                component.set("v.WarrantyHistory", parsedJSon.response.payload.querydata.data);  


                
                if (component.get("v.WarrantyHistory") === null){             
                    
                    component.set("v.ShowPanel", "NoWarrantyFound"); 
                    
                }               
                else
                {
                    if (searchType === "Exact"){
                        component.set("v.ShowPanel", "ResultMessage");  
                        				console.log("exact match ");

                    }
                    else{
                        component.set("v.ShowPanel", "FuzzyResults");
                    }
                    
                    //Populate Header Row
                    if (parsedJSon.response.payload.querydata.data.row.length === undefined) // undefined means there is only 1 row in the result set
                    {                    
                        if (parsedJSon.response.payload.querydata.data.row.transaction_type_code === 'SHIPMENT')
                        { 
                            component.set("v.WarrantyHeader", parsedJSon.response.payload.querydata.data.row); 
                                
                                console.log("only found 1 row for warranty");
                                component.set("v.WarrantyHeader", parsedJSon.response.payload.querydata.data.row);  
                                component.set("v.OutputSKU", parsedJSon.response.payload.querydata.data.row.product_sku_id);
                 				component.set("v.salesOrderNumber", parsedJSon.response.payload.querydata.data.row.order_id);
                				component.set("v.SF_productCode", parsedJSon.response.payload.querydata.data.row.productcode);
                				component.set("v.OutputProductName", parsedJSon.response.payload.querydata.data.row.product_sku_name);
                				component.set("v.OutputMACId", parsedJSon.response.payload.querydata.data.row.serial_code);
                         }                   
                    }
                    else 
                    {                   
                        for (var rows in parsedJSon.response.payload.querydata.data.row)
                        {
                            if (parsedJSon.response.payload.querydata.data.row[rows].transaction_type_code === 'SHIPMENT')
                            {
                                console.log("found multiple rows took first shipment row");

                                component.set("v.WarrantyHeader", parsedJSon.response.payload.querydata.data.row[rows]);  
                                component.set("v.OutputSKU", parsedJSon.response.payload.querydata.data.row[rows].product_sku_id);
                 				component.set("v.salesOrderNumber", parsedJSon.response.payload.querydata.data.row[rows].order_id);
                				component.set("v.SF_productCode", parsedJSon.response.payload.querydata.data.row[rows].productcode);
                				component.set("v.OutputProductName", parsedJSon.response.payload.querydata.data.row[rows].product_sku_name);
                				component.set("v.OutputMACId", parsedJSon.response.payload.querydata.data.row[rows].serial_code);
                                console.log(parsedJSon.response.payload.querydata.data.row[rows].product_sku_); 
                                break;
                            }
                        }                    
                    }
                }
                
                console.log(component.get("v.WarrantyHistory"));                
            }
            else {
                component.set("v.ShowPanel", "ErrorMessage");
            }            
        });
        
        $A.enqueueAction(action);    
    }
})