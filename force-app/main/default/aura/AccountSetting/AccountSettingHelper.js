({
	doInit:function(component) {
        var action = component.get("c.getContact");
        var userId = component.get("v.recordId");
        console.log(userId);
        action.setParams({"userId" : userId});
        action.setCallback(this, function(response) {           
            var state = response.getState();
           if (response.getState() != "SUCCESS") {
                return;
            } else {
                console.log(response.getReturnValue());
                	component.set("v.contact", response.getReturnValue());

            
            }
        });
       
        $A.enqueueAction(action); 
	}
})