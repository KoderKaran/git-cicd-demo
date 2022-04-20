({
	init : function(cmp, event, helper) {
    	var action = cmp.get("c.GetRMA_Type");
        
        action.setParams({
            'recId':cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var isTrue = true;
            var isFalse = false;
            if(state === "SUCCESS"){
                var rmatyp = response.getReturnValue();
                if(rmatyp === "Sales RMA"){
                    cmp.set('v.isSalesRMA',isTrue);
                    cmp.set('v.isDefectiveRMA',isFalse);
                    //alert('sales RMA-->'+cmp.get("v.isSalesRMA"));
                    //alert('defective RMA-->'+cmp.get("v.isDefectiveRMA"));
                }
                if(rmatyp === "Defective RMA"){
                    cmp.set('v.isSalesRMA',isFalse);
                    cmp.set('v.isDefectiveRMA',isTrue);
                    //alert('sales RMA-->'+cmp.get("v.isSalesRMA"));
                    //alert('defective RMA-->'+cmp.get("v.isDefectiveRMA"));
                }
                cmp.set('v.rmaType',rmatyp);
            }
        });
        $A.enqueueAction(action);
	},
})