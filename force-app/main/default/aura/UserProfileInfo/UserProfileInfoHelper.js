({
	doInit:function(component, userID) { 
        var action = component.get("c.getUserProfileInfo");
        action.setParams({ "userId" : userID});
        action.setCallback(this, function(response) { 
               
            var state = response.getState();
            if (state === 'ERROR') {
                 alert('user profile info error');
            } else {
                console.log(response.getReturnValue());
                component.set("v.userInfo", response.getReturnValue());         
            }
        });        
       
        $A.enqueueAction(action); 
	},

	showToast : function(type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            type: type,
            message: message,
            key: type
        });
        toastEvent.fire();
    }
})