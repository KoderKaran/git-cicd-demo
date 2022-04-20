({
	getUserPhoto : function(component, event) {
        
        var usrId = $A.get("$SObjectType.CurrentUser.Id");

        var action = component.get("c.getUserPhoto");
        action.setParams({
            "userId" : usrId
        });
        action.setCallback(this, function(response) {
            var userPhoto = response.getReturnValue();
            component.set("v.userPhoto", userPhoto);
        });

        $A.enqueueAction(action);
    }, 

    /*getCommunityTopics : function(component, event) {
        var action = component.get("c.getTopics");
        action.setParams({
            itemId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var topics = response.getReturnValue();
            component.set("v.topics", topics);
            console.log(topics);
        });

        $A.enqueueAction(action);
    }*/
})