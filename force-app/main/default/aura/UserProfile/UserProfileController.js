({
	doInit : function(component, event, helper) {
		component.set("v.spinner", true);
		var userId = $A.get("$SObjectType.CurrentUser.Id");

		console.log ('cur user: ' + userId);
		var pageUrl = window.location.href;
		var urlId = pageUrl.substring(pageUrl.lastIndexOf('/') + 1, pageUrl.length);
		console.log ('urlId: ' + urlId);
		var idFromUrl = component.get("v.userId");
		console.log ('click user: ' + idFromUrl);
		console.log (userId !== '');
		console.log (userId.includes(idFromUrl));
		console.log (idFromUrl.includes(userId));
		if (userId !== '' && (userId.includes(idFromUrl) || idFromUrl.includes(userId))) {
			component.set("v.editMode", true);
		}
		helper.getUserAddressInformation(component, idFromUrl);
		helper.doInit(component, idFromUrl);

		component.set("v.spinner", false); 
	}
})