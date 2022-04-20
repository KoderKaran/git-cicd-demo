({
    getCommunityURL : function(component, event, helper) {

        var action = component.get("c.communityURL");
        var urlString = window.location.href;
        //filterText
        //if(urlString.contains('lastvisited')){
            component.set("v.filterText","Last Visited");
        //}
        
        action.setParams({
            "recId": component.get("v.recordId"),
            "urlString": urlString
        });

        action.setCallback(this, function(response){

            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var storeResponse = response.getReturnValue();
                component.set("v.communityURL", storeResponse);
                
            } else {
                let errors = response.getError();
                let errMessage = errors[0].message;
                let message = "The following error has occured : [" + errMessage + "]. Kindly contact an administrator for assistance.";
				console.log('BreadCrumbError >>' + message);
            }
        });
        $A.enqueueAction(action);
    },  
})