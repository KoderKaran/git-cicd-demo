({
	goToHome : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        var recordId = component.get("v.recordId");
        urlEvent.setParams({
          "url": "/"
        });
        urlEvent.fire();
    },
    goToQuestions : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        var recordId = component.get("v.recordId");
        urlEvent.setParams({
          "url": "/questions"
        });
        urlEvent.fire();
        //question/:feedItemId
    },
    goToIdeas : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        var recordId = component.get("v.recordId");
        urlEvent.setParams({
          "url": "/"
        });
        urlEvent.fire();
    },
    goToBlogs : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        var recordId = component.get("v.recordId");
        urlEvent.setParams({
          "url": "/"
        });
        urlEvent.fire();
    },
    searchResults : function(component, event, helper) {
        var searchQuery = document.getElementById('searchFieldId').value;
        if (searchQuery === '') {
            document.getElementById('searchFieldId').placeholder = 'Please enter search criteria'
        } else {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": "/global-search/" + document.getElementById('searchFieldId').value
            });
            urlEvent.fire();
        }
    },
    checkEnterButton : function(component, event, helper) {
        if (event.which === 13 || event.keyCode === 13) {
            $A.enqueueAction(component.get('c.searchResults'));
        }
    },
})