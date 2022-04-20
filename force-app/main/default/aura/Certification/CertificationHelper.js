({
	doInit:function(component) {
        var action = component.get("c.getCertification");
        var userId = component.get("v.recordId");      
        action.setParams({"userId" : userId});
        action.setCallback(this, function(response) {           
            var state = response.getState();
           if (response.getState() != "SUCCESS") {
                return;
            } else {
                if(response.getReturnValue().length == 0) {

                } else {
                	component.set("v.certification", response.getReturnValue());
                }
            }
        });
       
        $A.enqueueAction(action); 
	}
})