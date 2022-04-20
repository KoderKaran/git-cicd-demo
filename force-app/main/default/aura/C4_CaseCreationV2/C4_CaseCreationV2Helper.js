({
    CaseCreation : function(component, event, helper, rmaType) {
        var ContactId = component.get("v.recordId");        
        var Origin = component.get("v.SelectedOrigin");        
        var AccountId = component.get("v.SelectedAccount");
        var createCase = component.get("c.createCase");       
        
        if (AccountId === null)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Missing Data",
                message: "Populate the Account field",
                type: "Error"
            });
            toastEvent.fire();
        }
            else
            {  
                createCase.setParams(
                    {contactId:ContactId, accountId:AccountId, origin:Origin, rmaType}
                );
                
                createCase.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (component.isValid() && state === "SUCCESS") {
                        var result = response.getReturnValue();               
                        if(result.includes("true")){
                            
                            // Show success message
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title: "Case Created",
                                message: "The case was successfully created",
                                type: "Success"
                            });
                            toastEvent.fire();                        
                            
                            // Navigate the browser to the case
                            var navEvt = $A.get("e.force:navigateToSObject");
                            //console.log("#####"+navEvt);
                            navEvt.setParams({
                                "recordId": result.replace("true","")
                            });
                            navEvt.fire();  
                        }
                        else {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title: "Error",
                                message: result,
                                type: "Error"
                            });
                            toastEvent.fire(); 
                        }
                    }
                    else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Error",
                            message: "Something weird happened. Please conntact your Saleforce Admin",
                            type: "Error"
                        });
                        toastEvent.fire();  
                    }
                });               
                
                $A.enqueueAction(createCase);
            }
    },
    PopulateOrigin : function(component, event, helper) {
        var origins = component.get("v.CaseInfo").Origin;        
        var originList = [];
        
        for (var i in origins)
        {
            originList.push({'label': origins[i], 'value': origins[i]});
        }                    
        
        component.set("v.Origin", originList);      
    },
    PopulateAccount : function(component, event, helper) {
        var accts = component.get("v.CaseInfo").Account;        
        var accountList = [];
        
        for (var i in accts)
        {
            var account = {'label': accts[i].Account.SAP_ACCOUNT_ID__c + ': ' + accts[i].Account.Name, 'value': accts[i].Account.Id};
            accountList.push(account);
        }                    
        
        component.set("v.Account", accountList);
        
        if (accountList.length == 1)
        {
            component.set("v.SelectedAccount", accts[0].Account.Id);
        }
    } 
})