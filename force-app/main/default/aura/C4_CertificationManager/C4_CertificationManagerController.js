({
    lookupSearch : function(component, event, helper) {
        // Get the SampleLookupController.search server side action
        const serverSearchAction = component.get('c.search');
        // Passes the action to the Lookup component by calling the search method
        component.find('lookup').search(serverSearchAction);
    },
    
    getCertificationsAction :  function(component, event, helper) {
		component.set("v.Columns", [
        {label:"Training Date", fieldName:"Training_Date__c", type:"Date"},
        {label:"Training Location", fieldName:"Training_Location__c", type:"text"},   
  		{label:"Certification Type", fieldName:"Type__c", type:"text"}      
    	]);
      
        var action = component.get("c.getCertifications");
        action.setParams({
            contactId: component.get("v.selection[0].id")
        });
        
        action.setCallback(this, function(data) {
            var state = data.getState();
            if (state === "SUCCESS") {
                component.set("v.Certifications", data.getReturnValue());                 
            }
            else if (status === "INCOMPLETE") {
                console.log("No response from server or client is offline.")
                helper.toastThis("Server Side Error", "No response from server or client is offline")  
            }
            else if (state === "ERROR") {
               console.log("Error returned from server ");
               helper.toastThis("Server Side Error", "There server returned an error")
            }
        });
       
        $A.enqueueAction(action);
    },
    copyButtonClickAction :  function(component, event, helper) {
        var currentSelectedRows = component.get("v.currentSelectedRows") ;   
        
        var idSet = [];
       	for (var i = 0; i < currentSelectedRows.length; i++){
        	idSet.push(currentSelectedRows[i].Id);
       	}	 
        
        var action = component.get("c.copyCertifications");
        action.setParams({
            toContactId: component.get("v.recordId"),
        	fromContactId: component.get("v.selection[0].id"),
        	certIdList: idSet  
        });
 
        $A.enqueueAction(action);
        
        // refresh the contact's related list
        $A.get('e.force:refreshView').fire();
             
        // deselect all rows in the certifications data table
  		component.find("certDatatable").set("v.selectedRows", []);     
    },
    moveButtonClickAction :  function(component, event, helper) {
        var currentSelectedRows = component.get("v.currentSelectedRows") ;   
        
        var idSet = [];
       	for (var i = 0; i < currentSelectedRows.length; i++){
        	idSet.push(currentSelectedRows[i].Id);
       	}	 
        
        var action = component.get("c.moveCertifications");
        action.setParams({
            toContactId: component.get("v.recordId"),
        	fromContactId: component.get("v.selection[0].id"),
        	certIdList: idSet  
        });

        // No Callback currently needed
//        action.setCallback(this, function(response) {
//            var state = response.getState();
//            if (state === "SUCCESS") {
//                component.set("v.testing", response.getReturnValue());
//               // console.log(response.getReturnValue());
//            }
//         });
        
        $A.enqueueAction(action);
        
        // refresh the contact's related list
        $A.get('e.force:refreshView').fire();
             
        // Refresh the components certification list
  		var a = component.get('c.getCertificationsAction');
        $A.enqueueAction(a);        
    },
    // this clears the component
    clearForm: function (component, event) {        	
 		component.find("lookup").clearform();
    },
    // This identifies the selected rows in the certifications data table
    updateSelectedText: function (component, event) {
       	var selectedRows = event.getParam('selectedRows');
    	component.set("v.currentSelectedRows", selectedRows);            
    }
    // This is where the JavaScript methods ends that govern the certifications list   
})