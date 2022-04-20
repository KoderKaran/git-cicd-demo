({
	doInit : function(component, event, helper) {
		component.set("v.spinner", true);
            
        //var userId = $A.get("$SObjectType.CurrentUser.Id");  // This isn't needed    
        var recordId = component.get("v.recordId");           
           
        helper.doInit(component, recordId);

		component.set("v.spinner", false); 
	}
})