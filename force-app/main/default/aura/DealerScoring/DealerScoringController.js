({

    init: function(component, event, helper) {

        var getAccountFields = component.get('c.getAccountFields');
        var accountNameToLabel = [];
        getAccountFields.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") { 
                var accountFieldMap = response.getReturnValue();
                component.set('v.nameToLabel', accountFieldMap);
                for (var key in accountFieldMap) {
                    accountNameToLabel.push({value:accountFieldMap[key].label, key:key});
                }
                component.set('v.accountNameToLabel', accountNameToLabel);
                component.set('v.accountFields', accountFieldMap);
            }
        });
        $A.enqueueAction(getAccountFields);

        helper.refreshSavedObjects(component, helper);
    }, 

    goBack: function(component, event, helper) {
        helper.goToPreviousPage();
    },

    showSavedObjects: function(component, event, helper) {

        if (component.get('v.areSavedObjectsShown')) {
            component.set('v.areSavedObjectsShown', false);
        } else {
            component.set('v.areSavedObjectsShown', true);
        }
    },

    deleteSavedElement: function(component, event, helper) {

        var preparedElement = event.getSource().get("v.name");
        var savedObjects = component.get('v.savedObjects');
        var elementToDelete = savedObjects[savedObjects.indexOf(preparedElement)];

        if (elementToDelete.type == 'select' || elementToDelete.type == 'checkbox') {
            if (confirm('All values for ' + elementToDelete.fieldLabel + ' are going to be deleted')) {
                helper.deletePicklistCheckboxRecords(component, helper, elementToDelete.fieldName);                
            }
            return;
        }

        savedObjects.splice(savedObjects.indexOf(preparedElement), 1);
        component.set('v.savedObjects', savedObjects);

        helper.deleteSavedRecord(component, elementToDelete.id);
    },

    deletePreparedElement: function(component, event, helper) {
        helper.deletePreparedElement(component, event);
    },

    bindPicklistValue: function(component, event, helper) {
        helper.bindPicklistValueToElement(component, event);
    },

    bindDateValue: function(component, event, helper) {
        helper.bindDateValueToElement(component, event);
    },

    saveCreatedObjects: function(component, event, helper) {

        try {
            helper.validateField(component, event, helper);
        } catch (err) {
            var errorMessage = document.getElementById("error-message");
            errorMessage.innerHTML = err.message;
            errorMessage.classList.remove("slds-hide");
            setTimeout(
                function() {
                    errorMessage.classList.add('slds-hide');
                }, 4000
            )
            return;
        }

        helper.saveObjects(component);
        helper.refreshSavedObjects(component, helper);
    },

    updatePoints: function(component, event, helper) {
        helper.updatePoints(component);
    },

    switchSelectField: function(component, event, helper) {

        if (component.get('v.selectedFieldName') == '0') {
            component.set('v.isEditMode', false);
            helper.cleanObjects(component);
            return;
        }

        component.set('v.isEditMode', true);

        helper.refreshSelectedField(component, helper);

        var selectedFieldType = component.get('v.selectedFieldType');

        switch(selectedFieldType) {
            case 'checkbox':
                helper.prepareBooleanElements(component);
                break;
            case 'select':
                helper.prepareSelectElements(component);
                break;
            default:
                helper.prepareNewElement(component);
                break;
        }

        helper.cleanObjects(component);
    },

    generateEmptyField: function(component, event, helper) {
        helper.prepareNewElement(component);
    },

    toggleSpinner: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})