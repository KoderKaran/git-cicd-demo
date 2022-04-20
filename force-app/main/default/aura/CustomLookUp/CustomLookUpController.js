({  

	onfocus : function(component, event, helper) {
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close'); 
        var getInputkeyWord = '';
        helper.searchHelper(component, event, getInputkeyWord);
    },

    removeSelection : function(component, event, helper) {
    	var forclose = component.find("searchRes");
		$A.util.addClass(forclose, 'slds-is-close');
		$A.util.removeClass(forclose, 'slds-is-open');
    },

    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
		var getInputkeyWord = component.get("v.SearchKeyWord");
        if (getInputkeyWord.length > 0) {
			var forOpen = component.find("searchRes");
			$A.util.addClass(forOpen, 'slds-is-open');
			$A.util.removeClass(forOpen, 'slds-is-close');
			helper.searchHelper(component, event, getInputkeyWord);
        } else {  
			component.set("v.listOfSearchRecords", null); 
			var forclose = component.find("searchRes");
			$A.util.addClass(forclose, 'slds-is-close');
			$A.util.removeClass(forclose, 'slds-is-open');
		}   
	},
    
    /*  Function for clear the Record Selection 
     */
    clear :function(component, event, helper){
		var pillTarget = component.find("lookup-pill");
		var lookUpTarget = component.find("lookupField"); 

		$A.util.addClass(pillTarget, 'slds-hide');
		$A.util.removeClass(pillTarget, 'slds-show');

		$A.util.addClass(lookUpTarget, 'slds-show');
		$A.util.removeClass(lookUpTarget, 'slds-hide');

		component.set("v.SearchKeyWord", null);
		component.set("v.listOfSearchRecords", null );
		component.set("v.selectedRecord", "" ); 
		component.set("v.selectedRecordId", "");  
    },
    
    /*  This function call when the end User Select any record from the result list.   
     */  
    handleComponentEvent : function(component, event, helper) { 
		var selectedAccountGetFromEvent = event.getParam("recordByEvent");
		var selectedRecordId = event.getParam("recordByEventId");

		component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
		component.set("v.selectedRecordId", selectedRecordId);
       
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
      
        var forclose = component.find("searchRes");
		$A.util.addClass(forclose, 'slds-is-close');
		$A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
		$A.util.addClass(lookUpTarget, 'slds-hide');
		$A.util.removeClass(lookUpTarget, 'slds-show');  
	},
})