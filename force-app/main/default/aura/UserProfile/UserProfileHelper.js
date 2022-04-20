({
	doInit:function(component, userID) { 
        var action = component.get("c.getUserProfileInfo");
        action.setParams({ "userId" : userID});
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === 'ERROR') {
                 alert('user profile info error');
            } else {
                component.set("v.contact", response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
	},

    getUserAddressInformation:function(component, userID) { 
    var action = component.get("c.getUserProfileInfo");
        action.setParams({ "userId" : userID});
        action.setCallback(this, function(response) { 
               
            var state = response.getState();
            if (state === 'ERROR') {
                 alert('user profile info error');
            } else {
                console.log('userProfile: ' + response.getReturnValue());
                component.set("v.userProfile", response.getReturnValue());             
            }
        });       
       
        $A.enqueueAction(action);
    }
})