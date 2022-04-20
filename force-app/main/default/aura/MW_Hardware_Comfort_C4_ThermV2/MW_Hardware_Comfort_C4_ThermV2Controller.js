({
    TroubleshootClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermV2Reboot_Click" });        
        cmpEvent.fire(); 
	},
    GuideClick : function(component, event, helper) {
		//var cmpEvent = component.getEvent("bubblingEvent");
        //cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermV2Guide_Click" });        
        //cmpEvent.fire();
          var win = window.open('https://www.control4.com/docs/product/control4-wireless-thermostat-by-aprilaire/user-guide/english/latest/control4-wireless-thermostat-by-aprilaire-user-guide-rev-a.pdf', '_blank');
  		  win.focus();  
	},
    BackButtonClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("bubblingEvent");
        cmpEvent.setParams({"ComponentAction" : "MWHardwareComfortC4ThermV2_Back" });        
        cmpEvent.fire(); 
	}
})