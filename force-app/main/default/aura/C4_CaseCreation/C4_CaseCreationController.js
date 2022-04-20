({ 
    doInit : function(component, event, helper) {
        component.set("v.ContactId", helper.getUrlParameter("id")); // for Salesforce Classic ..... This will most likely never be used in classic. Rip this code out later
        
        if (component.get("v.ContactId") === undefined )
        {             
            component.set("v.ContactId", component.get("v.recordId")); // Salesforce Lightning
        }
        else
        {
            component.set("v.IsSalesforceClassic", 'true'); // This is for backwards compatibility with saleforce classic. Rip this out when we no longer user Salesforce classic.
        }
        
        var action = component.get("c.getContactName");
        //var contactId = component.get("v.recordId");
        //var contactId = component.get("v.ContactId");
        action.setParams({"contactId" : component.get("v.ContactId")});
        action.setCallback(this, function(response) {           
            var state = response.getState();
            
            if (response.getState() != "SUCCESS") {
                return;
            } else {
                if(response.getReturnValue().length == 0) {
                    
                } else {
                    component.set("v.CaseInfo", response.getReturnValue());                    
                    //var caseInfo = response.getReturnValue().Status; 
                    
                    helper.PopulateStatus(component, event, helper);
                    helper.PopulateOrigin(component, event, helper);
                    helper.PopulateAccount(component, event, helper); 
                    helper.PopulateController(component, event, helper); 
                    helper.PopulateSoftwareVersion(component, event, helper); 
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
    CaseCreationClick : function(component, event, helper) {
           let button = event.getSource();
           button.set('v.disabled',true);
        
        if (component.get("v.IsSalesforceClassic") == 'false')
        {
            helper.LightningCaseCreation(component, event, helper);
        } 
        else
        {
            helper.ClassicCaseCreation(component, event, helper); 
        }
    },
    CloseWindowClick : function(component, event, helper)
    {
		window.close();    
	}
    
})