({   
    EA5TroubshootClick : function(component, event, helper) {
            var cmpEvent = component.getEvent("bubblingEvent");
            cmpEvent.setParams({"ComponentAction" : "EA5Click" });        
            cmpEvent.fire(); 
        },
    EA3TroubshootClick : function(component, event, helper) {
            var cmpEvent = component.getEvent("bubblingEvent");
            cmpEvent.setParams({"ComponentAction" : "EA3Click" });        
            cmpEvent.fire(); 
        },      
    EA1TroubshootClick : function(component, event, helper) {
            var cmpEvent = component.getEvent("bubblingEvent");
            cmpEvent.setParams({"ComponentAction" : "EA1Click" });        
            cmpEvent.fire(); 
        },
    CA10TroubshootClick: function(component, event, helper) {
            var cmpEvent = component.getEvent("bubblingEvent");
            cmpEvent.setParams({"ComponentAction" : "CA10Click" });        
            cmpEvent.fire(); 
        },    
    CA1TroubshootClick : function(component, event, helper) {
            var cmpEvent = component.getEvent("bubblingEvent");
            cmpEvent.setParams({"ComponentAction" : "CA1Click" });        
            cmpEvent.fire(); 
        },           
    HC800TroubshootClick : function(component, event, helper) {
            var cmpEvent = component.getEvent("bubblingEvent");
            cmpEvent.setParams({"ComponentAction" : "HC800Click" });        
            cmpEvent.fire(); 
        },
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "BackClick" });        
        cmpEvent.fire(); 
	},   
    IDKClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "IDKClick" });        
        cmpEvent.fire(); 
	}   
})