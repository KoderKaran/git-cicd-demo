({
	doInit : function(cmp, event, helper) {
        var usrId = $A.get("$SObjectType.CurrentUser.Id");
        cmp.set("v.userId", usrId);
        helper.getUsername(cmp, event);
        
    },
	goToProfile : function(cmp, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        var recordId = cmp.get("v.recordId");
        urlEvent.setParams({
          "url": "/profile/" + userId
        });
        urlEvent.fire();
    },
    goToSettings : function(cmp, event, helper) {
    	var userId = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/settings/" + userId
        });
        urlEvent.fire();
    },
    logOut : function(cmp, event, helper) {
        var url = location.hostname;
        var technicianPart = $A.get("$Label.c.part_url");       
        window.location.replace("https://" + url + technicianPart + "/secur/logout.jsp");
    }
})