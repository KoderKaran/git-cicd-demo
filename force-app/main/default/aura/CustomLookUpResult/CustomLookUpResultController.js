({	

	selectRecord : function(component, event, helper){      
		var getSelectRecord = component.get("v.oRecord");
		var recordId = component.get("v.oRecordId");
		// call the event   
		var compEvent = component.getEvent("oSelectedRecordEvent");
		compEvent.setParams({
			"recordByEvent" : getSelectRecord,
			"recordByEventId" : recordId
		});  
		compEvent.fire();
	},
})