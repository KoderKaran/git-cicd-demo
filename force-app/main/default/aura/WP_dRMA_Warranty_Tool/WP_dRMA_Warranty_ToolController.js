({ 
    LookupWarranty: function(cmp, event, helper)
    {  
        var productCode = cmp.get("v.productCode").trim();
        
        if (productCode.length > 5) // how many characters?
        {
            var evt = cmp.getEvent("WP_dRMA_Warranty_Result_Event"); // reset the form for the next search
            evt.setParams({
                "MacSerServ" : "WarrantyPanelReset"
            });
            evt.fire();
            
            cmp.set("v.progress", 0); 
            cmp.set("v.ShowPanel", "searching");
            
            var id = setInterval(frame, 100);
            function frame() { // slows down the progress towards the end
                if (cmp.get("v.progress") < 60) {
                    cmp.set("v.progress", cmp.get("v.progress") + 0.20);
                } 
                else if (cmp.get("v.progress") < 70) {
                    cmp.set("v.progress", cmp.get("v.progress") + 0.10);
                }
                    else if (cmp.get("v.progress") < 80) {
                        cmp.set("v.progress", cmp.get("v.progress") + 0.05);
                    }
                        else if (cmp.get("v.progress") < 90) {
                            cmp.set("v.progress", cmp.get("v.progress") + 0.03);
                        }  
            }
            
            // These are asynchronous call outs called a promise patterned after this guide 
            // https://medium.com/salesforce-zolo/the-easy-guide-to-understanding-js-promises-78f5f19539e0            
            function firstCall(resolve, reject) {
                //console.log('First Call'); 
                helper.GetWarranty(cmp, resolve, reject, productCode, 'exact'); 
            }
            function secondCall(resolve, reject) {
                //console.log('Second Call');
                helper.GetWarranty(cmp, resolve, reject, productCode, 'contains');
            }   
            
            var firstPromise = new Promise(firstCall);            
            firstPromise.then(
                function () {
                    //console.log(cmp.get("v.ShowPanel"));
                    if (cmp.get("v.ShowPanel") === "searching")
                    {
                        var secondPromise = new Promise(secondCall);
                        secondPromise.then(
                            function () {
                                // Success, do nothing
                            },
                            function () {
                                console.log('There was an error in secondPromise');
                            });                    
                    }
                }, 
                function () {
                    console.log('There was an error in firstPromise');
                });
            // This is the end of the promis section   
        }     
    },
    ClearScreen: function(cmp){
        //cmp.set("v.ShowPanel", "NoValue");
    },
    LookupWarrantyIDKeyCheck: function(cmp, event, helper){
        if(event.which == 13) {
            helper.GetWarranty(cmp);         
        }
    },
    closeModel: function(cmp, event, helper) {
        cmp.set("v.ShowPanel", "default");
    } 
})