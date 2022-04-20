({

    goToPreviousPage: function() {

        var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    },

    generateSavedObjectTypesAndValues: function(component, helper) {

        var savedObjects = component.get('v.savedObjects');
        var nameToLabel = component.get('v.nameToLabel');
        var savedObjectsWithTypes = [];
        var fieldType;
        var fieldName;
        savedObjects.forEach(function(object) {
            var fieldType = helper.generateFieldType(object.fieldType.toLowerCase());
            if (fieldType == 'boolean') {
                object.fieldValue = (object.fieldValue == 'true' ? true : false);
            }
            object.type = fieldType;
            savedObjectsWithTypes.push(object);
        });
        component.set('v.savedObjects', savedObjectsWithTypes);
    },

    generateFieldType: function(fieldType) {
        var generateFieldType;

        switch(fieldType) {
            case 'date': {
                generateFieldType = 'date';
                break;
            }
            case 'time':
            case 'datetime': {
                generateFieldType = 'dateTime';
                break;
            }
            case 'boolean': {
                generateFieldType = 'checkbox';
                break;
            }
            case 'currency':
            case 'double':
            case 'integer':
            case 'percent': {
                generateFieldType = 'number';
                break;
            }
            case 'textarea': {
                generateFieldType = 'textArea';
                break;
            }
            case 'picklist': {
                generateFieldType = 'select'
                break;
            }
            case 'reference': {
                generateFieldType = 'lookup';
                break;
            }
            default: {
                generateFieldType = 'text';
            }
        }
        return generateFieldType;
    },

    refreshSelectedField: function(component, helper) {

        var selectedField = component.get('v.accountFields')[component.get('v.selectedFieldName')];
        component.set('v.selectedField', selectedField);
        component.set('v.selectedFieldType', helper.generateFieldType(selectedField.type.toLowerCase()));
    },

    prepareBooleanElements: function(component) {

        var getNewRows = component.get('c.getNewRows');
        var selectedField = component.get('v.selectedField');
        getNewRows.setParams({
            currFieldString: JSON.stringify(selectedField),
            fieldCount: '2'
        });
        getNewRows.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") { 
                var returnValue = response.getReturnValue();

                returnValue[0].fieldValue = true;
                returnValue[1].fieldValue = false;

                var objectsToSave = component.get('v.objectsToSave');
                objectsToSave.push(returnValue[0]);
                objectsToSave.push(returnValue[1]);
                component.set('v.objectsToSave', objectsToSave);
            }
        });
        $A.enqueueAction(getNewRows);

    },

    prepareSelectElements: function(component, options) {

        var getNewRows = component.get('c.getNewRows');
        var selectedField = component.get('v.selectedField');
        getNewRows.setParams({
            currFieldString: JSON.stringify(selectedField),
            fieldCount: selectedField.options.length.toString()
        });
        getNewRows.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") { 
                var objectsToSave = component.get('v.objectsToSave');
                var returnValue = response.getReturnValue();

                for (var i = 0; i < returnValue.length; i++) {
                    returnValue[i].fieldValue = selectedField.options[i].value
                    returnValue[i].options[i].selected = true;

                    objectsToSave.push(returnValue[i]);
                }

                component.set('v.objectsToSave', objectsToSave);
            }
        });
        $A.enqueueAction(getNewRows);
    },

    prepareNewElement: function(component) {

        var getNewRow = component.get('c.getNewRow');
        var selectedField = component.get('v.selectedField');
        getNewRow.setParams({
            currFieldString: JSON.stringify(selectedField)
        });
        getNewRow.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                var objectsToSave = component.get('v.objectsToSave');
                objectsToSave.push(returnValue);
                component.set('v.objectsToSave', objectsToSave);
            }
        });
        $A.enqueueAction(getNewRow);
    },

    saveObjects: function(component) {

        var saveObjects = component.get('c.saveFieldScoring');

        saveObjects.setParams({
            fieldScoringsString: JSON.stringify(component.get('v.objectsToSave'))
        });
        saveObjects.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") { 
                var savedObjects = component.get('v.savedObjects');
                savedObjects.push(JSON.stringify(response.getReturnValue()));
                component.set('v.savedObjects', savedObjects);
            }
            else if (response.getState() === "ERROR") {

                var errors = saveObjects.getError();
                var errorMessage = document.getElementById("error-message");

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMessage.innerHTML = errors[0].message;
                        errorMessage.classList.remove("slds-hide");
                        setTimeout(
                            function() {
                                errorMessage.classList.add('slds-hide');
                            }, 4000
                        )
                        return;
                    }

                }
            }
        });
        $A.enqueueAction(saveObjects);
    },

    updatePoints: function(component) {

        var saveObjects = component.get('c.updatePointValues');
        var successMessage = document.getElementById('success-message');

        var objectsToUpdate = [];
        component.get('v.savedObjects').forEach(function(object) {
            if (object.scores == null) {
                object.scores = 0
            }
            if (object.scores > 999999999) {
                object.score = 999999999;
            }
            objectsToUpdate.push(object);
        });

        saveObjects.setParams({
            fieldScoringsString: JSON.stringify(objectsToUpdate)
        });
        saveObjects.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                successMessage.classList.remove('slds-hide');
                setTimeout(
                    function() {
                        successMessage.classList.add('slds-hide');
                    }, 2000
                )
            }
        });
        $A.enqueueAction(saveObjects);
    },

    cleanObjects: function(component) {
        component.set('v.objectsToSave', []);
    },

    refreshSavedObjects: function(component, helper) {

        var getSavedObjects = component.get('c.getSavedScorings');
        getSavedObjects.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {  
                component.set('v.savedObjects', response.getReturnValue());
            }

            this.generateSavedObjectTypesAndValues(component, helper);
        });
        $A.enqueueAction(getSavedObjects); 

    },

    bindDateValueToElement: function(component, event) {

        var elementToUpdate = event.getSource().get('v.labelClass');
        var valueType = event.getSource().get('v.label');
        var objectsToUpdate = component.get('v.objectsToSave');
        var indexOfElement = objectsToUpdate.indexOf(elementToUpdate);
        var convertedValue = Date.parse(event.getSource().get('v.value'))

        if (valueType == 'Low Value') {
            elementToUpdate.fieldValueLow = convertedValue;
        } else {
            elementToUpdate.fieldValueHigh = convertedValue;
        }

        component.set('v.objectsToSave', objectsToUpdate);
    },

    bindPicklistValueToElement: function(component, event) {

        var elementToUpdate = event.getSource().get('v.labelClass');
        var objectsToUpdate = component.get('v.objectsToSave');
        var indexOfElement = objectsToUpdate.indexOf(elementToUpdate);
        elementToUpdate.fieldValue = event.getSource().get('v.value');
        objectsToUpdate[indexOfElement] = elementToUpdate;
        component.set('v.objectsToSave', objectsToUpdate);
    },

    deletePicklistCheckboxRecords: function(component, helper, savedRecordName) {

        var deleteScorings = component.get('c.deleteSavedScoringsByName');
        deleteScorings.setParams({
            recordName: savedRecordName
        });
        deleteScorings.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {  

                var savedObjects = component.get('v.savedObjects');

                for(var i = savedObjects.length - 1; i >= 0; i--) {
                    if (savedObjects[i].fieldName == savedRecordName) {
                        savedObjects.splice(i, 1);
                    }
                }

                // savedObjects.forEach(function(object) {
                //     if (object.fieldName == savedRecordName) {
                //         savedObjects.splice(savedObjects.indexOf(object), 1);
                //     }
                // });

                component.set('v.savedObjects', savedObjects);
                // this.refreshSavedObjects(component, helper)
            }
        });

        $A.enqueueAction(deleteScorings);
    },

    deletePreparedElement: function(component, event) {

        var preparedElement = event.getSource().get('v.name');
        var objectsToSave = component.get('v.objectsToSave');
        objectsToSave.splice(objectsToSave.indexOf(preparedElement), 1);
        component.set('v.objectsToSave', objectsToSave);
    },

    deleteSavedRecord: function(component, savedRecordId) {

        var deleteScoring = component.get('c.deleteSavedScoring');
        deleteScoring.setParams({
            recordId: savedRecordId
        });
        deleteScoring.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {  
                console.log('element deleted');
            }
        });

        $A.enqueueAction(deleteScoring);
    },

    validateField: function(component, event, helper) {

        var currentField = component.get('v.selectedField');
        var currentType = currentField.type.toLowerCase();
        var newScorings = component.get('v.objectsToSave');

        newScorings.forEach(function(scoring) {
            if (scoring.scores > 999999999) {
                throw new Error("Score value " + scoring.scores + " is too high");
            }
        });

        switch (currentType) {

            case 'boolean':
                this.validateCheckbox(currentField, newScorings);
                break;
            case 'integer':
            case 'currency':
            case 'double':
            case 'percent':
            case 'date':
            case 'datetime':
                this.validateNumber(currentField, newScorings);
                break;
            case 'picklist':
                this.validatePicklist(currentField, newScorings);
                break;
            default:
                this.validateText(currentField, newScorings);
        }
    },

    validateCheckbox: function(field, records) {

        if (records.length != 2) {
            throw new Error("Checkbox should have only two values!");
        }
        if (records[0].fieldValue == records[1].fieldValue) {
            throw new Error("Checkbox values should be different!");
        }
        for (var i = 0; i < records.length; i++) {
            if (records[i].scores == null) {
                throw new Error("Each option should have points associated with it!");
            }
        }
    },

    validatePicklist: function(field, records) {

        var valueSet = new Set();
        for (var i = 0; i < records.length; i++) {
            valueSet.add(records[i].fieldValue);
        }

        if (valueSet.size != records.length) {
            throw new Error("The same Picklist value should not be used more than once!");
        }

        if (records.length != field.options.length) {
            throw new Error("Each picklist value should have points associated with it!");
        }

        for (var i = 0; i < records.length; i++) {
            if (records[i].scores == null) {
                throw new Error("Each option should have points associated with it!");
            }
        }
    },

    validateNumber: function(field, records) {

        for (var i = 0; i < (records.length == 1 ? records.length : records.length - 1); i++) {
            if (records[i].fieldValueLow == null || records[i].fieldValueHigh == null) {
                throw new Error("There should be Low and High number entered for each value!");
            }
            if (records[i].fieldValueLow >= records[i].fieldValueHigh) {
                throw new Error("High value should be bigger than Low value!");
            }
            if (records[i].scores == null) {
                throw new Error("Each option should have points associated with it!");
            }
            for (var j = i + 1; j < records.length; j++) {
                if (j == records.length - 1) {
                    if (records[j].fieldValueLow == null || records[j].fieldValueHigh == null) {
                        throw new Error("There should be Low and High number entered for each value!");
                    }
                    if (records[j].scores == null) {
                        throw new Error("Each option should have points associated with it!");
                    }
                }

                if (this.numberRangeOverlaps(records[i].fieldValueLow, records[i].fieldValueHigh, 
                    records[j].fieldValueLow, records[j].fieldValueHigh)) {
                    throw new Error("No two ranges should overlap one another!");
                }
            }
        }
    },

    numberRangeOverlaps: function(a_start, a_end, b_start, b_end) {
        if (a_start <= b_start && b_start <= a_end) return true; // b starts in a
        if (a_start <= b_end   && b_end   <= a_end) return true; // b ends in a
        if (b_start <  a_start && a_end   <  b_end) return true; // a in b
        return false;
    },

    validateText: function(field, records) {

        for (var i = 0; i < records.length; i++) {
            if (!records[i].fieldValue || records[i].fieldValue.replace(/\s/g, '') == '') {
                throw new Error("Each value should have something entered in it!");
            }
            if (records[i].scores == null) {
                throw new Error("Each option should have points associated with it!");
            }
        }
    }

})