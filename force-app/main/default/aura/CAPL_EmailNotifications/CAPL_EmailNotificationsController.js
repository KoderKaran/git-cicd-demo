({
	doInit : function(component, event, helper) {
        helper.fetchCurrentUserId(component, event);
		helper.fetchUserEmailNotifications(component, event);
	},

	changeEmailNotification : function(component, event, helper) {
		// var flag = 0;
		
		// document.getElementById("PreferencesDisableBookmarkEmailBox").checked = true;

		var member = component.get("v.member");

		member[event.target.id] = !member[event.target.id];

		console.log('changed value -> ' + member.PreferencesDisProfPostCommentEmail);

		var action = component.get("c.updateEmailNotifications");
		action.setParams({"member" : member});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	$A.get('e.force:refreshView').fire();
            } 
        });
        $A.enqueueAction(action);
	},
})