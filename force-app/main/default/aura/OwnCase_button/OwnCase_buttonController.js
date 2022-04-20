({
    handleClick : function (cmp, event, helper) {
        
        var caseObj = new sforce.SObject("Case"); 
        caseObj.Id = '{!Case.Id}'; 
        caseObj.OwnerId = '{!User.Id}';
		var result = sforce.connection.update([caseObj]); 
		window.location.href=window.location.href;
        
        alert("You clicked: " + event.getSource().get("v.label"));
    } 
});