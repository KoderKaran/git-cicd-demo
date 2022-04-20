({
    init : function(component, event, helper) {
        
	   component.set("v.leadId", helper.getUrlParameter("id")); // Salesforce Classic
        
       if (component.get("v.leadId") === undefined )
        {             
            component.set("v.leadId", component.get("v.recordId")); // Salesforce Lightning
        }
        
        component.set("v.disabledSent", true);
        component.set("v.sendImmediately", []);
        component.set("v.sendLater", []);

        var id = component.get("v.leadId");
        var leadDealers = component.get("c.getDealers");

        leadDealers.setParams(
            {leadId:id}
        );

        leadDealers.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var displayedFirst = [], displayedAfter = [];
                var dealers = [];
                
                [].forEach.call(response.getReturnValue(), function(dealer) {
                    if (dealer.showroom) {
                        displayedFirst.push(dealer);
                    } else {
                        displayedAfter.push(dealer);
                    }
                });

                dealers = displayedFirst.concat(displayedAfter);

                component.set("v.dealers", dealers);             

                
                console.log('asdfadsfasdfasdf:   ' + dealers);
                if (component.get("v.dealers").length === 0)
                {
                    console.log('adsfaasdfasdfasdfasdfsdfasdfasdf');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Dealer Assignment",
                        message: "Please populate City, State, Country OR Zipcode",
                        type: "warning"
                    });
                    toastEvent.fire();
                }                
                
                
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

        $A.enqueueAction(leadDealers);
    },

    closeModal : function(component, event, helper) {
        window.close();
    },

    selectDealersItem : function(component, event, helper) {

        var dealers = component.get("v.dealers");
        var id = event.currentTarget.id;
        var index = id.split("_")[1];
        console.log("id " + id);
        console.log("index " + index);
        var prevValue = dealers[index].isSelected;
        dealers[index].isSelected = !prevValue;
        component.set("v.dealers", dealers);
    },

    selectNowItem : function(component, event, helper) {

        var dealers = component.get("v.sendImmediately");
        var id = event.currentTarget.id;
        var index = id.split("_")[1];
        console.log("id " + id);
        console.log("index " + index);
        var prevValue = dealers[index].isSelected;
        dealers[index].isSelected = !prevValue;
        component.set("v.sendImmediately", dealers);

        helper.buttonUpdate(component);
    },

    selectLaterItem : function(component, event, helper) {

        var dealers = component.get("v.sendLater");
        var id = event.currentTarget.id;
        var index = id.split("_")[1];
        console.log("id " + id);
        console.log("index " + index);
        var prevValue = dealers[index].isSelected;
        dealers[index].isSelected = !prevValue;
        component.set("v.sendLater", dealers);

    },

    moveToNow : function(component, event, helper) {

        var dealers = component.get("v.dealers");
        var sendImmediately = component.get("v.sendImmediately");

        for(var i = dealers.length - 1; i >= 0; i--) {
            if (dealers[i].isSelected) {
                dealers[i].isSelected = false;
                sendImmediately.push(dealers[i]);
                dealers.splice(i, 1);
            }
        }

        component.set("v.dealers", dealers);
        component.set("v.sendImmediately", sendImmediately);

        helper.buttonUpdate(component);
    },

    moveFromNow : function(component, event, helper) {

        var dealers = component.get("v.dealers");
        var sendImmediately = component.get("v.sendImmediately");

        for(var i = sendImmediately.length - 1; i >= 0; i--) {
            if (sendImmediately[i].isSelected) {
                sendImmediately[i].isSelected = false;
                dealers.push(sendImmediately[i]);
                sendImmediately.splice(i, 1);
            }
        }

        component.set("v.dealers", dealers);
        component.set("v.sendImmediately", sendImmediately);

        helper.buttonUpdate(component);
    },

    toggleTooltip : function(component, event, helper) {
        var target = event.currentTarget;
        console.log(target.dataset.index);
        var tooltip = document.getElementById(target.dataset.index);
        tooltip.classList.toggle('slds-hide');
    },

    moveToLater : function(component, event, helper) {

        var dealers = component.get("v.dealers");
        var sendLater = component.get("v.sendLater");

        for(var i = dealers.length - 1; i >= 0; i--) {
            if (dealers[i].isSelected) {
                dealers[i].isSelected = false;
                sendLater.push(dealers[i]);
                dealers.splice(i, 1);
            }
        }

        component.set("v.dealers", dealers);
        component.set("v.sendLater", sendLater);

        helper.buttonUpdate(component);
    },

    moveFromLater : function(component, event, helper) {

        var dealers = component.get("v.dealers");
        var sendLater = component.get("v.sendLater");

        for(var i = sendLater.length - 1; i >= 0; i--) {
            if (sendLater[i].isSelected) {
                sendLater[i].isSelected = false;
                dealers.push(sendLater[i]);
                sendLater.splice(i, 1);
            }
        }

        component.set("v.dealers", dealers);
        component.set("v.sendLater", sendLater);

        helper.buttonUpdate(component);
    },

    sendLeads : function(component, event, helper) {

        var id = component.get("v.leadId");
        var hours = component.get("v.hours");
        var sendImmediately = component.get("v.sendImmediately");
        var sendLater = component.get("v.sendLater");

        var sendLeads = component.get("c.sendLeadsToDealers");

        sendLeads.setParams(
            {leadId:id, sendImmediatelyJson:JSON.stringify(sendImmediately), interval:hours, sendLaterJson:JSON.stringify(sendLater)}
        );

        sendLeads.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // component.set("v.isSent", true);
                console.log('Success'); 
                window.close();
                // helper.refreshDealers(component);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

        $A.enqueueAction(sendLeads);
        $A.get('e.force:refreshView').fire();
    },

    openSetup : function(component, event, helper) {

        var id = component.get("v.leadId");
        var settingUrl = component.get("c.getSettingURL");

        settingUrl.setParams(
            {leadId:id}
        );

        settingUrl.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var setupUrl = response.getReturnValue();
                window.location.href = setupUrl;
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

        $A.enqueueAction(settingUrl);
    },

    toggleSpinner: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})