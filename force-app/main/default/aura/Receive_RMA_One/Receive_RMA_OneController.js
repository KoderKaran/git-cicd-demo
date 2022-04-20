({
	handleOnSuccess : function(component, event, helper) {
		component.set("v.fail", true);
        console.log('inside success');
        //var record = event.getParam("response");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
    },
    doInit : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
    },
    saveProducts: function(component, event, helper) {
        var action = component.get("c.saveSingleProduct");
        console.log('====>>'+component.find("idxCauseCode").get("v.value"));
        console.log('====>>'+component.find("causeType").get("v.value"));
        console.log('====>>'+component.find("disposition").get("v.value"));
        console.log('====>>'+component.find("returnRegion").get("v.value"));
        console.log('====>>'+component.find("idxProdCondition").get("v.value"));
        console.log('====>>'+component.find("idxSerialNum").get("v.value"));
        console.log('====>>'+component.find("idxMacId").get("v.value"));
        action.setParams({ 
            "prodId" : component.get("v.recid"), 
            "Causecode" : component.find("idxCauseCode").get("v.value"),
            "causetype" : component.find("causeType").get("v.value"),
            "disp" : component.find("disposition").get("v.value"),
            "retreg" : component.find("returnRegion").get("v.value"),
            "prodCondition" : component.find("idxProdCondition").get("v.value"),
            "serialNum" : component.find("idxSerialNum").get("v.value"),
            "macId" : component.find("idxMacId").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "The record has been updated successfully.",
                "type":"Success"
            });
            toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
          }
        })
        $A.enqueueAction(action);
    }
    
})