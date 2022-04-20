({
	getUsername : function(cmp, event) {
		var action = cmp.get("c.fetchUser");
        action.setCallback(this, function(response) {
        	console.log(response.getReturnValue());
	        cmp.set("v.user", response.getReturnValue());
        });

        $A.enqueueAction(action);
	},
	/*getUserPhoto : function(cmp, event) {
		var userPhoto = '';

        var action = cmp.get("c.getUserPhoto");
        action.setParams({
        	userId : usrId
        });
        action.setCallback(this, function(response) {
            userPhoto = response.getReturnValue();
            console.log('userPhoto: ' + userPhoto);
            if (userPhoto && userPhoto.length !== 0) {
                cmp.set("v.userPhoto", userPhoto);
                console.log('here');
            } else {
                cmp.set("v.userPhoto", '');
                console.log('there');
            }
        });

        $A.enqueueAction(action);
	}*/
})