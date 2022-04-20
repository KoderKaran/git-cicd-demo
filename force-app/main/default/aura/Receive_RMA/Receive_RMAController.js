({
    "doInit" : function(cmp,event) {
        console.log('case id ' +cmp.get("v.caseid"));
        console.log('qty' +cmp.get("v.qty"));                
        var action = cmp.get("c.getCaseProduct");
        var cc;
        action.setParams({ 
            "casePrdId" : cmp.get("v.caseProdId"),
            "qty" : cmp.get("v.qty") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordData = response.getReturnValue();
                cmp.set('v.caseProd',recordData);
                console.log('Server-> ' + JSON.stringify(recordData));
                var actionClone = cmp.get("c.cloneCaseProduct");
                actionClone.setParams({ 
                    "caseProdData" : cmp.get('v.caseProd'),
                    "qty" : cmp.get("v.qty") 
                });
                actionClone.setCallback(this, function(responseinner) {
                    console.log('Called Second action');
                    var clonedRecords = responseinner.getReturnValue();
                    console.log('clonedRecords====>>>'+JSON.stringify(clonedRecords));
                    cmp.set("v.products", clonedRecords);
                });
                $A.enqueueAction(actionClone);
                
            }
            else if (state === "INCOMPLETE") {
              
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

       
        $A.enqueueAction(action);
        
        var action = cmp.get("c.getCond");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var condMap = [];
                for(var key in result){
                    condMap.push({key: key, value: result[key]});
                }
                cmp.set("v.condMap", condMap);
            }
        });
        $A.enqueueAction(action);
        
        /*var action = cmp.get("c.getCaucode");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var causeMap = [];
                for(var key in result){
                    causeMap.push({key: key, value: result[key]});
                }                
                cmp.set("v.causeMap", causeMap);
            }
        });
        $A.enqueueAction(action);
        
        var action = cmp.get("c.getCautype");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var causetypeMap = [];
                for(var key in result){
                    causetypeMap.push({key: key, value: result[key]});
                }
                cmp.set("v.causetypeMap", causetypeMap);
            }
        });
        $A.enqueueAction(action);
        
        var action = cmp.get("c.getDisposition");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var DispMap = [];
                for(var key in result){
                    DispMap.push({key: key, value: result[key]});
                }
                cmp.set("v.DispMap", DispMap);
            }
        });
        $A.enqueueAction(action);
        
        var action = cmp.get("c.getRetuRe");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var RetRegMap = [];
                for(var key in result){
                    RetRegMap.push({key: key, value: result[key]});
                }
                cmp.set("v.RetRegMap", RetRegMap);
            }
        });
        $A.enqueueAction(action);
                 
        console.log('cc before ' + cc);
        cmp.find("Causecodpick").set("v.value", cc);
        console.log('cc after' +cmp.get("v.causecode"));
        
        cmp.set('v.validate', function() {
           var saveip = cmp.get('v.truthy');
           if(!saveip) {
               // If the component is valid...
               return { isValid: true };
           }
           else {
               // If the component is invalid...
               return { isValid: false, errorMessage: 'A value is required.' };
           }});*/       
        
        
    },
    asdf:  function(component, event, helper) {
        console.log("here I am");
         var addad = component.find("aa2");
        addad.focus();
    },
    saveProducts: function(component, event, helper) {
       
        console.log('Inside save');
        console.log('Products ' +component.get("v.products"));
        
        let button = event.getSource();
        button.set('v.disabled',true);
        
        var action = component.get("c.saveproducts");
        //event.preventDefault();
        //var fields = event.getParam("fields");
        var caseId = component.get("v.caseProd").Case__c;
        console.log('fields.Cause_Type__c===>'+component.find("causeType").get("v.value"));
        console.log('fields.causeCode===>'+component.find("idxCauseCode").get("v.value"));
        console.log('fields.disposition===>'+component.find("disposition").get("v.value"));
        console.log('fields.returnRegion===>'+component.find("returnRegion").get("v.value"));
        action.setParams({ "prdlist" : component.get("v.products"), 
                         	"Causecode" : component.find("idxCauseCode").get("v.value"),
					        "causetype" : component.find("causeType").get("v.value"),
                            "disp" : component.find("disposition").get("v.value"),
                            "retreg" : component.find("returnRegion").get("v.value"),
                            "caseProd" : component.get("v.caseProd")                         
                         });
        /*action.setParam({ "Causecode" : component.get("v.causecode") });
        action.setParam({ "causetype" : component.get("v.causeType") });
        action.setParam({ "disp" : component.get("v.Disposition") });
        action.setParam({ "retreg" : component.get("v.ReturnRegion") });
        action.setParam({ "recdate" : component.get("v.RecDate") });*/

        
        action.setCallback(this, function(response) {
            console.log('***Inside Callback***');
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('Server-> ' + result);
                component.set("v.truthy", false);
                if(result == 'Case') {
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": caseId,
                      "slideDevName": "Case"
                    });
                    navEvt.fire();
                }else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The records has been saved successfully.",
                        "type":"Success"
                    });
                    toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                }
                /*event.preventDefault();
                var fields = event.getparam("fields");
                component.find("cpeditform").submit(fields);*/
            }
            else if (state === "INCOMPLETE") {
               
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        
        $A.enqueueAction(action);
        
    }
})