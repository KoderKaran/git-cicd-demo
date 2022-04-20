({
    GetRMAInfo : function(component, event, helper) {
        var action = component.get("c.GetRMAInformation");
        var searchStr = document.getElementById("text-input-productId").value.trim();
        
        action.setParams({"searchString" : searchStr});
        action.setCallback(this, function(response) {         
            
            if (response.getState() != "SUCCESS") {
                	console.log("Error: response.getState() = ERROR");
                return;
            } else {
                if(response.getReturnValue().length == 0) {
                    component.set("v.searchString", searchStr);
                    component.set("v.ShowPanel", "NoWarrantyFound");                     
                } else {
                    component.set("v.ShowPanel", "ResultMessage");
                    component.set("v.RMAList", response.getReturnValue());
                    console.log(component.get("v.RMAList"));
                }
            }
        });
        
        $A.enqueueAction(action); 
    }
})