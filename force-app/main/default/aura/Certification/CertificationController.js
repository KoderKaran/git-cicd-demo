({
	doInit : function(component, event, helper) {       
        var userId = component.get("v.recordId");       
        var currentuser = $A.get("$SObjectType.CurrentUser.Id");
       
        if (currentuser.substring(0, 15) != userId.substring(0, 15))
        {
            console.log("The ID's are not the same"); 
            $A.util.addClass(component.find("editProfileButton"),'toggle');  // Hide button    
        }         
        
		helper.doInit(component);		
	}

})