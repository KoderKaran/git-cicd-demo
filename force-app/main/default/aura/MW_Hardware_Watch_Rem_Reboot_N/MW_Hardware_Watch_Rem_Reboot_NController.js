({        
    EA5TroubshootClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "EA5TroubshootClick" });        
        cmpEvent.fire(); 
    },
    EA3TroubshootClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "EA3TroubshootClick" });        
        cmpEvent.fire(); 
    },  
    EA1TroubshootClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "EA1TroubshootClick" });        
        cmpEvent.fire(); 
    },
    CA10TroubshootClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "CA10TroubshootClick" });        
        cmpEvent.fire(); 
    },
    CA1TroubshootClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "CA1TroubshootClick" });        
        cmpEvent.fire(); 
    },      
    HC250TroubshootClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "HC250TroubshootClick" });        
        cmpEvent.fire(); 
    },      
    HC800TroubshootClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "HC800TroubshootClick" });        
        cmpEvent.fire(); 
    },
    BackButtonClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareWatchRemRebootN_Back" });        
        cmpEvent.fire(); 
    },
    IDKClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "IDKClick" });        
        cmpEvent.fire(); 
    }
})