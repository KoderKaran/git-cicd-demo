({ 
    waiting: function(component, event, helper) 
    {
        component.set("v.IsSpinner", true);
    },
    doneWaiting: function(component, event, helper) 
    {
        component.set("v.IsSpinner", false);
    },
    GetWarrantyServiceTag: function(component, event, helper)
    {  	        
        var serviceTag = document.getElementById("text-input-serviceTag").value.trim();
        var productSKU = document.getElementById("text-input-productSKU").value.trim();
        var dealerSCode = document.getElementById("text-input-dealerSCode").value.trim();
        var searchType = serviceTag ? "Exact" : "Fuzzy";       
        //var url = 'https://erp.control4.com/C4Test/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType + '&ServiceTag=' + serviceTag + '&ProductSKU=' + productSKU + '&DealerSCode=' + dealerSCode;
        var url = 'https://erp.control4.com/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType + '&ServiceTag=' + serviceTag + '&ProductSKU=' + productSKU + '&DealerSCode=' + dealerSCode;
        // var url = 'https://erp.control4.com/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType  + '&ProductSKU=' + productSKU ;
        helper.GetWarranty(component, event, url, searchType);
    },    
    GetWarrantyMacSerial: function(component, event, helper)
    {
        var searchType = component.find("searchTypePickList").get("v.value");     
        var macSerial = document.getElementById("text-input-productId").value.trim();  
        //var url = 'https://erp.control4.com/C4Test/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
        var url = 'https://erp.control4.com/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
        helper.GetWarranty(component, event, url, searchType);
    },
    ClearScreen: function(component){
        component.set("v.ShowPanel", "NoValue");
    },
    ServiceTagKeyCheck: function(component, event, helper){
        if(event.which == 13) {
            var serviceTag = document.getElementById("text-input-serviceTag").value.trim();
            var productSKU = document.getElementById("text-input-productSKU").value.trim();
            var dealerSCode = document.getElementById("text-input-dealerSCode").value.trim();
            var searchType = serviceTag ? "Exact" : "Fuzzy";        
            //var url = 'https://erp.control4.com/C4Test/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType + '&ServiceTag=' + serviceTag + '&ProductSKU=' + productSKU + '&DealerSCode=' + dealerSCode;
            var url = 'https://erp.control4.com/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType + '&ServiceTag=' + serviceTag + '&ProductSKU=' + productSKU + '&DealerSCode=' + dealerSCode;
            // var url = 'https://erp.control4.com/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType  + '&ProductSKU=' + productSKU;
            helper.GetWarranty(component, event, url, searchType);            
        }
    },
    MacSerialServiceIDKeyCheck: function(component, event, helper){
        
            var searchType = "Exact";     
            var macSerial = document.getElementById("text-input-productId").value.trim();  
            //var url = 'https://erp.control4.com/C4Test/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
            var url = 'https://erp.control4.com/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
            helper.GetWarranty(component, event, url, searchType);         
        
    },
    
    rowOnclick: function(component, event, helper){
        //var selectedItem = event.getSource().getElement().getAttribute('data-value');
        //console.log(selectedItem);
        // component.set("v.WarrantyHistory",event.currentTarget.dataset.index);
        console.log(event);
        var ctarget = event.currentTarget; 
        console.log(ctarget);
        var test = ctarget.dataset.value;
        console.log(test);
        
         var searchType = component.find("searchTypePickList").get("v.value");     
           // var macSerial = document.getElementById("text-input-productId").value.trim();  
            //var url = 'https://erp.control4.com/C4Test/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
            var url = 'https://erp.control4.com/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + test;
            helper.GetWarranty(component, event, url, searchType);   
        
    },
    serviceOnclick: function(component, event, helper){
        //var selectedItem = event.getSource().getElement().getAttribute('data-value');
        //console.log(selectedItem);
        // component.set("v.WarrantyHistory",event.currentTarget.dataset.index);
        console.log(event);
        var ctarget = event.currentTarget; 
        console.log(ctarget);
        var test = ctarget.dataset.value;
        console.log(test);
        
        var productSKU = document.getElementById("text-input-productSKU").value.trim();
        var dealerSCode = document.getElementById("text-input-dealerSCode").value.trim();
        var searchType = "Exact";       
        //var url = 'https://erp.control4.com/C4Test/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType + '&ServiceTag=' + serviceTag + '&ProductSKU=' + productSKU + '&DealerSCode=' + dealerSCode;
        var url = 'https://erp.control4.com/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType + '&ServiceTag=' + test + '&ProductSKU=' + productSKU + '&DealerSCode=' + dealerSCode;
        // var url = 'https://erp.control4.com/query/GetWarrantyServiceTag.aspx?SearchType=' + searchType  + '&ProductSKU=' + productSKU ;
        helper.GetWarranty(component, event, url, searchType);
        
    },
    
})