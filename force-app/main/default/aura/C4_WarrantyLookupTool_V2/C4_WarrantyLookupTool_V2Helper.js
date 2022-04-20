({
    GetWarranty : function(component, event, helper, url) {
        //console.log("Call GetWarrantyHistory");
        var action = component.get("c.GetWarrantyInformation");
        console.log(url);
        action.setParams({
            "url": url
        });
        action.setCallback(this, function(response) {         
            var state = response.getState();            
            if (component.isValid() && state === "SUCCESS") {
                //console.log("Response Success"); 				
                var parsedJSon = JSON.parse(response.getReturnValue());         
                component.set("v.WarrantyHistory", parsedJSon.response.payload.querydata.data);
                
                if (component.get("v.WarrantyHistory") === null)
                {
                  component.set("v.ShowPanel", "NoWarrantyFound");  
                }
                else
                {
                  component.set("v.ShowPanel", "ResultMessage"); 
                }
                
                //console.log(parsedJSon);
                //console.log("test"); 
                console.log(component.get("v.WarrantyHistory"));                
            }
            else {
                console.log("GetWarrantyHistory Response Error");
                component.set("v.ShowPanel", "ErrorMessage");
            }            
        }); 
        $A.enqueueAction(action);    
	}
})