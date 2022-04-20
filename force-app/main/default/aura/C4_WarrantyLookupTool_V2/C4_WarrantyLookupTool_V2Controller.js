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
       //serviceTag = 'ST184915290Z842A';
	   //productSKU = 'LUM-510-TUR-A-WH';
	   //dealerSCode = 'S033343'; 
        
        var serviceTag = document.getElementById("text-input-serviceTag").value.trim();
        var productSKU = document.getElementById("text-input-productSKU").value.trim();
        var dealerSCode = document.getElementById("text-input-dealerSCode").value.trim();
        
        var url = 'https://erp.control4.com/query/GetWarrantyServiceTag_V2.aspx?ServiceTag=' + serviceTag + '&ProductSKU=' + productSKU + '&DealerSCode=' + dealerSCode;
    	helper.GetWarranty(component, event, helper, url);
	},    
    GetWarrantyMacSerial: function(component, event, helper)
    {  
       //serviceTag = '000FFF000082BFB4';
               
        var macSerial = document.getElementById("text-input-productId").value.trim();
        
        var url = 'https://erp.control4.com/query/GetWarrantyMacSerial_V2.aspx?MacSerial=' + macSerial;
    	helper.GetWarranty(component, event, helper, url);
	},
    ClearScreen: function(component){
         component.set("v.ShowPanel", "NoValue");
	},
    ServiceTagKeyCheck: function(component, event, helper){
         if(event.which == 13) {
        var serviceTag = document.getElementById("text-input-serviceTag").value.trim();
        var productSKU = document.getElementById("text-input-productSKU").value.trim();
        var dealerSCode = document.getElementById("text-input-dealerSCode").value.trim();
        
        var url = 'https://erp.control4.com/query/GetWarrantyServiceTag_V2.aspx?ServiceTag=' + serviceTag + '&ProductSKU=' + productSKU + '&DealerSCode=' + dealerSCode;
        helper.GetWarranty(component, event, helper, url);             
        }
    },
    MacSerialServiceIDKeyCheck: function(component, event, helper){
         if(event.which == 13) {
        var macSerial = document.getElementById("text-input-productId").value.trim();
        
        var url = 'https://erp.control4.com/query/GetWarrantyMacSerial_V2.aspx?MacSerial=' + macSerial;             
    	helper.GetWarranty(component, event, helper, url);           
        }
    }
})