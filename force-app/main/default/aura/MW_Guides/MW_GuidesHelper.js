({
    LogAnalytics : function(analyticsAction, analyticsLabel) 
    {    
        if (analyticsAction != '' && analyticsLabel != '')
        {
            var analyticsInteraction = $A.get("e.forceCommunity:analyticsInteraction");
            analyticsInteraction.setParams({
                hitType : 'event',
                eventCategory : 'Guides',
                eventAction : analyticsAction,
                eventLabel : analyticsLabel,
                eventValue: 1                
            });
            analyticsInteraction.fire(); 
            
            console.log("Action: " + analyticsAction + '   Label: ' + analyticsLabel);
        }  		
    }
})