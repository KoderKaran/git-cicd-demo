({
	"doInit" : function(cmp,event) {
        
        console.log('prod rec id ' +cmp.get("v.recordId"));                       
        var action = cmp.get("c.getProduct");
        action.setParams({ "rid" : cmp.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var res = response.getReturnValue();
                if(res){                   
                    console.log('res-> ' + res[0].Quantity__c);
					var qty = res[0].Quantity__c;
                    //var constone = 1;
                    if(qty != 1){
                    	console.log('inside');    
                    	cmp.set("v.singqty", false);    
                    }
                    cmp.set("v.singleproduct", res[0]);
                }                  
            }     
            else if (state === "INCOMPLETE") {
                console.log('incomplete');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });       
        $A.enqueueAction(action);
    },
    cloneProducts:function(cmp,event) {
        var prdqty = cmp.get("v.singleproduct").Quantity__c;        
        var qty = cmp.get("v.qty");
        
        if(qty > prdqty){
            console.log('inside product qty check');  
              
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":"Error!",
                "type":"Error",
                "message":"Quantity should be less than or equal to "+prdqty
            });
            toastEvent.fire();
        }else{
            cmp.set('v.cloneProduct',true);
        	cmp.set('v.isShowQuantity',false);
        }        
    }
})