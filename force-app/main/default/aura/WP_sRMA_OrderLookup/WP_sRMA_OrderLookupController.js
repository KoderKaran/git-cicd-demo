({ 
    doInit: function (cmp, event, helper) {
        cmp.set('v.gridColumns', [{label: 'Sales Number', fieldName: 'SalesNumber', type: 'text', initialWidth: 130},
                                  {label: 'Date', fieldName: 'SalesDate', type: 'text', initialWidth: 100},
                                  {label: 'SKU', fieldName: 'DLN1_ItemCode', type: 'text', initialWidth: 190},
                                  {label: 'Description', fieldName: 'DLN1_Dscription', type: 'text'},
                                  {label: 'SO Qty', fieldName: 'RDR1_Quantity', type: 'number', initialWidth: 90},   
                                  {label: 'DL Qty', fieldName: 'DLN1_Quantity', type: 'number', initialWidth: 90},           
                                  {label: 'Price', fieldName: 'DLN1_Price', type: 'currency', initialWidth: 110},
                                  {label: 'Total', fieldName: 'DLN1_LineTotal', type: 'currency', initialWidth: 110}, 
                                 ]); 
            
		var date = new Date();
		cmp.set("v.beginDate", new Date(date.getTime() - (30 * 24 * 60 * 60 * 1000)).toISOString().slice(0,10));  // 30 Days back
		cmp.set("v.endDate", new Date().toJSON().slice(0,10));                                  
		helper.GetDeliveries(cmp, event, '');  
    },
    waiting: function(cmp, event, helper) 
    {
        cmp.set("v.IsSpinner", true);
    },
    doneWaiting: function(cmp, event, helper) 
    {
        cmp.set("v.IsSpinner", false); 
    },   
    GetDeliveries: function(cmp, event, helper)
    {                             
        helper.GetDeliveries(cmp, event);
    },
    ClearScreen: function(cmp){
        cmp.set("v.ShowPanel", "NoValue");
    },
    handleRemoveItem: function(cmp, event, helper)
    {                                  
        var params = event.getParams();
        var selectedRows =  cmp.get('v.previousSelectedRows');
        var index = -1;//selectedRows.indexOf(params.KeyField);
       
        for(var i = 0; i < selectedRows.length; i++) {
        if(selectedRows[i].KeyField === params.KeyField) {
            	index = i;
        	}
    	}

        selectedRows.splice(index, 1);   
        cmp.set('v.selectedRows', selectedRows);                                  
                                  
        if (params.KeyField === "ResetForm") // The form is reset when RMA's are created
        {
            var arr = cmp.get("v.gridData");
            arr.splice(0, arr.length);
            cmp.set('v.gridData', arr);
            cmp.set('v.gridExpandedRows', []);
            cmp.set("v.ShowPanel", "BlankMessage");  
        }            
    },
    onSelected : function(cmp, event, helper)
    {
        var data = cmp.get('v.gridData');
        var selectedRows = event.getParam('selectedRows');
        var previousSelectedRows = cmp.get('v.previousSelectedRows');       
        var previousKeyFields = previousSelectedRows.map(function (item) {return item.KeyField;});       
		var selectedKeyFields = selectedRows.map(function (item) {return item.KeyField;});  
        
        // Unselected ones
        var remove = previousKeyFields.filter(x => !selectedKeyFields.includes(x));      

        for (var r = 0; r < remove.length; r++)
        {
            var appEvent = $A.get("e.c:WP_sRMAEvent");
            appEvent.setParams({"ActionType" : 'Remove', "KeyField" : remove[r]});        
            appEvent.fire();                     
        }        
        
        for (var j = 0; j < data.length; j++)
        {          
        	for (var k = 0; k < data[j]['_children'].length; k++)
            {
                for (var sr = 0; sr < selectedRows.length; sr++)
                {                       
                    if (!previousKeyFields.includes(data[j]['_children'][k].KeyField) && selectedRows[sr].KeyField === data[j]['_children'][k].KeyField)             
                    {                       
                        var appEvent = $A.get("e.c:WP_sRMAEvent");
                        appEvent.setParams(
                            {"ActionType" : 'Add',
                             "KeyField" : selectedRows[sr].KeyField,
                             "SalesNumber" : data[j].SalesNumber,
                             "SalesDate" : data[j].SalesDate,
                             "SKU" : selectedRows[sr].DLN1_ItemCode,
                             "Quantity" : "1",
                             "MaxQuantity" : selectedRows[sr].DLN1_Quantity,
                             "Price" : selectedRows[sr].DLN1_Price}
                        );        
                        appEvent.fire();                         
                    }
                }
            }
    	}
        
        cmp.set('v.previousSelectedRows', selectedRows );
    }          
})