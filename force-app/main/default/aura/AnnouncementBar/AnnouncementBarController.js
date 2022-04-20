({
    doInit : function(component, event, helper) {
        component.set("v.DisplayButton", "false");
        
        var action = component.get("c.getAnnouncement");
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
                component.set('v.Announcement', response.getReturnValue());
                var detailTest = response.getReturnValue().Detail_Text__c;
                if (detailTest != null)
                {
                    component.set("v.DisplayButton", "true"); 
                }
                
            }
            else if (state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if(errors[0] && error[0].message){
                        console.log('Error Message: ' + errors[0].message);
                    }
                }
                else{
                    console.log('Unknown Error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    navigate: function(component, event, helper) {
        var announcementId =  component.get("v.Announcement").Id;
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/announcement-banner/'+announcementId,
            "isredirect" :false
        });
        urlEvent.fire();
    }
})