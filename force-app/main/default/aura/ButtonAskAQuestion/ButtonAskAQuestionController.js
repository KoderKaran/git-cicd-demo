({
	goToAsk : function(cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/ask-question" 
        });
        urlEvent.fire();
    },
})