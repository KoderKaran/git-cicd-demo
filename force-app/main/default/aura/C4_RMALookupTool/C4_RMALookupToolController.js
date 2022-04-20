({ 
    waiting: function(component, event, helper) 
    {
        component.set("v.IsSpinner", true);
    },
    doneWaiting: function(component, event, helper) 
    {
        component.set("v.IsSpinner", false);
    },
    GetRMAButtonClick: function(component, event, helper)
    {  	   
		helper.GetRMAInfo(component, event, helper);
    },    
    ClearScreen: function(component){
        component.set("v.ShowPanel", "NoValue");
    },
    GetRMAInformationKeyCheck: function(component, event, helper){
        if(event.which == 13) {
      		helper.GetRMAInfo(component, event, helper);
        }
    },
})