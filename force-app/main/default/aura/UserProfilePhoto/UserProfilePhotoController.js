({
	doInit : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");

		var idFromUrl = component.get("v.userId");
		if (userId && userId.includes(idFromUrl)) {
			component.set("v.editMode", true);

		}
		helper.doInit(component, idFromUrl);

	}
})