({
    TroubleshootClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermV1Reboot_Click" });        
        cmpEvent.fire(); 
	},
    GuideClick : function(component, event, helper) {
        var win = window.open('https://www.control4.com/docs/product/wireless-thermostat-v2/user-guide/english/latest/wireless-thermostat-v2-user-guide-rev-a.pdf ', '_blank'); 
  		win.focus();  
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermV1_Back" });        
        cmpEvent.fire(); 
	}
})