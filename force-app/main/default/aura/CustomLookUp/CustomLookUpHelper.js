({

	searchHelper : function(component, event, getInputkeyWord) {
		var action = component.get("c.fetchLookUpValues");
		action.setParams({
			'searchKeyWord': getInputkeyWord,
			'objectName' : component.get("v.objectAPIName")
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var listOfSearchRecords = [];
				var storeResponse = response.getReturnValue();
				if (storeResponse.length == 0) {
					component.set("v.Message", 'No Result Found...');
				} else {
					component.set("v.Message", '');
				}
				for (var i = 0; i < storeResponse.length; i++) {
					listOfSearchRecords.push({value:storeResponse[i].Id, key:storeResponse[i].Name});
				}
				component.set("v.listOfSearchRecords", listOfSearchRecords);
			}
		}); 
		$A.enqueueAction(action);
	},
})