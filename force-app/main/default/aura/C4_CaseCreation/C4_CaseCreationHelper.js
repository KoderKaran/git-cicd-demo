({
    LightningCaseCreation : function(component, event, helper) {
        var ContactId = component.get("v.ContactId");        
        var Origin = component.get("v.SelectedOrigin");        
        var AccountId = component.get("v.SelectedAccount");
        var selectionHelper = component.get("v.selection")[0];
        var selection = selectionHelper == undefined ? null : selectionHelper.id;
        var MyControl4Name = component.get("v.MyControl4Name");       
        var Controller = component.get("v.SelectedController");
        var SoftwareVersion = component.get("v.SelectedSoftwareVersion");
        var Subject = component.get("v.Subject");
        var Description = component.get("v.Description");        
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
        else if (Subject === undefined || Subject === '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Missing Data",
                message: "Populate the Subject field",
                type: "Error"
            });
            toastEvent.fire();  
        }
            else
            {  
                // document.getElementById("creatcasebutton").disabled=true;
                createCase.setParams(
                    {contactId:ContactId, accountId:AccountId, origin:Origin, customer:selection, mycontrol4name:MyControl4Name, controller:Controller, softwareVersion:SoftwareVersion, subject:Subject, description:Description}
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
    ClassicCaseCreation : function(component, event, helper) {
        var ContactId = component.get("v.ContactId");        
        var Origin = component.get("v.SelectedOrigin");        
        var AccountId = component.get("v.SelectedAccount");
        var selectionHelper = component.get("v.selection")[0];
        var selection = selectionHelper == undefined ? null : selectionHelper.id;
        var MyControl4Name = component.get("v.MyControl4Name");       
        var Controller = component.get("v.SelectedController");
        var SoftwareVersion = component.get("v.SelectedSoftwareVersion");
        var Subject = component.get("v.Subject");
        var Description = component.get("v.Description");        
        var createCase = component.get("c.createCase");       
        
        console.log(Description);
        
        if (AccountId === null)
        {
            component.set("v.createCaseMessage", "Populate the Account field");   
            component.set("v.createCaseStatus", "Error");
        }
        else if (Subject === undefined || Subject === '')
        {
            component.set("v.createCaseMessage", "Populate the Subject field");   
            component.set("v.createCaseStatus", "Error");
        }
            else
            {  
                //document.getElementById("creatcasebutton").disabled=true;
                createCase.setParams(
                    {contactId:ContactId, accountId:AccountId, origin:Origin, customer:selection, mycontrol4name:MyControl4Name, controller:Controller, softwareVersion:SoftwareVersion, subject:Subject, description:Description}
                );
                
                createCase.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (component.isValid() && state === "SUCCESS") {
                        var result = response.getReturnValue();               
                        if(result.includes("true")){
                            result = result.replace("true","");                     
                            
                            //let button = component.find('creatcasebutton');
                            //button.set('v.disabled',true);
                            
                            window.location.href = 'https://control4--fullsandb.cs97.my.salesforce.com/' + result;
                            
                            // Show success message
                            //component.set("v.createCaseMessage", "Case Created");   
                            //component.set("v.createCaseStatus", "Success");
                        }
                        else {
                            component.set("v.createCaseMessage", result);   
                            component.set("v.createCaseStatus", "Error");
                        }
                    }
                    else {
                        component.set("v.createCaseMessage", result);   
                        component.set("v.createCaseStatus", "Error");
                    }
                });               
                
                $A.enqueueAction(createCase);
            }
    },
    getUrlParameter : function(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            if (sParameterName[0] === sParam) {      
                return sParameterName[1] === undefined ? true : sParameterName[1];               
            }
        }
    },
    PopulateStatus : function(component, event, helper) {
        var cases = component.get("v.CaseInfo").Status;        
        var statusList = [];
        
        for (var i in cases)
        {
            var status = {'label': cases[i], 'value': cases[i]};
            statusList.push(status);
        }                    
        
        component.set("v.Status", statusList);      
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
    },
    PopulateController : function(component, event, helper) {
        var controllers = component.get("v.CaseInfo").Controller;        
        var controllerList = [];
        
        for (var i in controllers)
        {
            controllerList.push({'label': controllers[i], 'value': controllers[i]});
        }                    
        
        component.set("v.Controller", controllerList);      
    },
    PopulateSoftwareVersion : function(component, event, helper) {
        var versions = component.get("v.CaseInfo").SoftwareVersion;        
        var SoftwareVersionList = [];
        
        for (var i in versions)
        {
            SoftwareVersionList.push({'label': versions[i], 'value': versions[i]});
        }                    
        
        component.set("v.SoftwareVersion", SoftwareVersionList);      
    }   
})