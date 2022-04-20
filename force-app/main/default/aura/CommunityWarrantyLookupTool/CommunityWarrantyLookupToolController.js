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
        helper.GetWarranty(component, event, url, searchType);
    },    
    GetWarrantyMacSerial: function(component, event, helper)
    {
        var searchType = 'Exact'//component.find("searchTypePickList").get("v.value");   
        var macSerial = document.getElementById("text-input-productId").value.trim();  
        //var macSerial = component.get("v.MacSerialServiceID"); 
        //var url = 'https://erp.control4.com/C4Test/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
 		var url = 'https://erp.control4.com/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
        component.set("v.MacSerialServiceID", macSerial);
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
            helper.GetWarranty(component, event, url, searchType);            
        }
    },
    MacSerialServiceIDKeyCheck: function(component, event, helper){
        if(event.which == 13) {
        var searchType = component.find("searchTypePickList").get("v.value");     
        var macSerial = document.getElementById("text-input-productId").value.trim();  
        //var url = 'https://erp.control4.com/C4Test/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
		var url = 'https://erp.control4.com/query/GetWarrantyMacSerial.aspx?@SearchType=' + searchType + '&MacSerial=' + macSerial;
        helper.GetWarranty(component, event, url, searchType);         
        }
    }
})