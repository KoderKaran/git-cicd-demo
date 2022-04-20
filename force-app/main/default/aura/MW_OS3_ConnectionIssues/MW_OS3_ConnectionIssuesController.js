({
    WifiClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "WifiClick" });        
        cmpEvent.fire(); 
    },
    SystemClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "SystemClick" });        
        cmpEvent.fire(); 
    },    
    C4Click : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "C4SystemClick" });        
        cmpEvent.fire(); 
    },
    BackButtonClick : function(component, event, helper) {
        var cmpEvent = component.getEvent("bubblingEvent");  
        cmpEvent.setParams({"ComponentAction" : "BackClick" });        
        cmpEvent.fire(); 
    }
})