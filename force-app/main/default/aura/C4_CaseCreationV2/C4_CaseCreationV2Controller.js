({ 
    doInit : function(component, event, helper) {        
        var action = component.get("c.GetComponentData");
        action.setParams({"contactId" : component.get("v.recordId")});
        action.setCallback(this, function(response) {           
            var state = response.getState();
            
            if (response.getState() != "SUCCESS") {
                return;
            } else {
                if(response.getReturnValue().length == 0) {
                    
                } else {
                    component.set("v.CaseInfo", response.getReturnValue());                    
                    helper.PopulateOrigin(component, event, helper);
                    helper.PopulateAccount(component, event, helper); 
                }
            }
        });       
        
        $A.enqueueAction(action);         
    },
    lookupSearch : function(component, event, helper) {
        // Get the SampleLookupController.search server side action
        const serverSearchAction = component.get('c.search');
        // Passes the action to the Lookup component by calling the search method
        component.find('lookup').search(serverSearchAction);
    },   
    CreateCaseSalesRMA : function(component, event, helper) {
            helper.CaseCreation(component, event, helper, 'sRMA');
    },   
    CreatCaseDefectiveRMA : function(component, event, helper) {
            helper.CaseCreation(component, event, helper, 'dRMA');
    }    
})