({
    GetWarranty : function(component, event, url, searchType) {
        var action = component.get("c.GetWarrantyInformation");
        console.log(url);
        action.setParams({
            "url": url
        });
        action.setCallback(this, function(response) {         
            var state = response.getState();
            console.log('Respose State: ' + state);            
            if (component.isValid() && state === "SUCCESS") {           
                var parsedJSon = JSON.parse(response.getReturnValue());            

                if (parsedJSon.response.status === "ERROR")
                {
                    console.log("Server returned Error message");
                    component.set("v.ShowPanel", "ErrorMessage");
                }
                else
                {
                    component.set("v.WarrantyHistory", parsedJSon.response.payload.querydata.data);      
                    if (component.get("v.WarrantyHistory") === null){             
                        component.set("v.ShowPanel", "NoWarrantyFound");        
                    }               
                    else
                    {
                        if (searchType === "Exact"){
                            component.set("v.ShowPanel", "ResultMessage");                        
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
                            }                   
                        }
                        else 
                        {                   
                            for (var rows in parsedJSon.response.payload.querydata.data.row)
                            {
                                if (parsedJSon.response.payload.querydata.data.row[rows].transaction_type_code === 'SHIPMENT')
                                {
                                    
                                    component.set("v.WarrantyHeader", parsedJSon.response.payload.querydata.data.row[rows]);  
                                    //console.log("Sample Header",parsedJSon.response.payload.querydata.data.row[rows]);
                                    break;
                                }
                            }                    
                        }
                    }
                }
                
                //console.log(component.get("v.WarrantyHistory"));                
            }
            else {                
                component.set("v.ShowPanel", "ErrorMessage");
            }            
        });
        
        $A.enqueueAction(action);    
    }
})