({
	doInit:function(component, userID) { 
        //var action = component.get("c.getUserProfileInfo");
        var action = component.get("c.getUserImageURL");      
        action.setParams({ "userId" : userID});
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === 'ERROR') {
                 alert('user profile info error');
            } else {
                var img = response.getReturnValue().Avatar_URL__c;
                if (img && img.length !== 0) {
                    component.set("v.photo", img);
                }
                //component.set("v.photo", response.getReturnValue().Avatar_URL__c);
            }

        });
        
       
        $A.enqueueAction(action); 
	}
})