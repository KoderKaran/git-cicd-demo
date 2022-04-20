({
    GetProductRecord: function(cmp, event, productId) {
        var action = cmp.get("c.GetProduct");
        
        action.setParams({
            "productID": productId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var product = response.getReturnValue(); 
                
                //console.log("ReturnedProduct");
                //console.log(product);
                
                cmp.set("v.product", product);
                //cmp.set("v.showDetails", true);
            }
        }); 
        $A.enqueueAction(action);
    },
    getSubProducts : function(cmp, event, resolve, reject) {

        var action = cmp.get('c.GetProductTreeData');    
        var caseID = cmp.get("v.recordId");

        action.setParams({
            "parentId" : cmp.get("v.productId"),
            "caseId" : caseID,
            "stockType" :  cmp.get("v.stockType"),
            "stockTypeReason" : cmp.get("v.stockTypeReason")
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){                
                var data = response.getReturnValue();
                cmp.set('v.gridData', JSON.parse(JSON.stringify(data).split('items').join('_children')));

                var gridData = cmp.get("v.gridData");
                gridData.push({
                    'KeyField': '01t1T000005694HQAQ',
                    'inventory': '',
                    'productCode': 'MISC-PART',
                    'productName': 'Miscellaneous or Replacement Part'
                });
                
                cmp.set("v.gridData", gridData);                      
       
        		for ( var i = 0; i < gridData.length; i++ ) 
                {
   
                    if (gridData[i].recommended != undefined)
                    {
                        if (gridData[i].recommended != 0)
                        {
                            var selectedData = [];
                            cmp.set("v.stockType", gridData[i].stockType);
                            cmp.set("v.stockTypeReason", gridData[i].stockTypeReason);
                            selectedData.push( gridData[i].recommended);                         
                            cmp.set("v.selectedRows", selectedData);
                            resolve();
                        }  
                    }
                }         
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log('**error Message-->'+errors[0].message);
                         reject();
                    }
                }
            }
		});
        
		$A.enqueueAction(action); 
    }//,
//    getSubProducts2 : function(cmp, event) {

//        var action = cmp.get('c.GetProductTreeData');    
//        var caseID = cmp.get("v.recordId");
        
//        action.setParams({
//            "parentId" : cmp.get("v.productId"),
//            "caseId" : caseID,
//            "stockType" :  cmp.get("v.stockType"),
//            "stockTypeReason" : cmp.get("v.stockTypeReason")
//        });
        
//		AuraPromise.serverSideCall(action, cmp).then(
//            function(){
//                var state = response.getState();
//                console.log("Here is the state");
                
//                console.log(state);
//            }        
//        )        
        
        //action.setCallback(this,function(response){
        //    var state = response.getState();
            
        //    if(state === "SUCCESS"){                
        //        var data = response.getReturnValue();
        //        cmp.set('v.gridData', JSON.parse(JSON.stringify(data).split('items').join('_children')));
                
        //        console.log("getSubProducts");                
        //        console.log(cmp.get("v.gridData"));                   
                
        //        var gridData = cmp.get("v.gridData");
        //        gridData.push({
        //            'KeyField': '01t1T000005694HQAQ',
        //            'inventory': '',
        //            'productCode': 'MISC-PART',
        //            'productName': 'Miscellaneous or Replacement Part'
        //        });
                
        //        cmp.set("v.gridData", gridData);                      
       
        //		for ( var i = 0; i < gridData.length; i++ ) 
        //        {
   
        //            if (gridData[i].recommended != undefined)
        //            {
        //                if (gridData[i].recommended != 0)
        //                {
        //                    console.log(gridData[i].recommended);
        //                    var selectedData = [];
        //                    console.log("hello");
        //                    cmp.set("v.stockType", gridData[i].stockType);
        //                    cmp.set("v.stockTypeReason", gridData[i].stockTypeReason);
        //                    selectedData.push( gridData[i].recommended);                         
        //                    cmp.set("v.selectedRows", selectedData);
        //                }  
        //            }
        //        }         
                
        //    }else if(state === "ERROR"){
        //        var errors = action.getError();
        //        if(errors){
        //            if(errors[0] && errors[0].message){
        //                console.log('**error Message-->'+errors[0].message);
        //            }
        //        }
        //    }
		//});
        
		//$A.enqueueAction(action); 
   // }
})