({    
	handleShowModal: function(component, event, helper) {   
        var modalBody;    
        $A.createComponent("c:" + component.get("v.modalContainer"), {},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       //header: "Which Light Switch Do You Own?",
                                       body: modalBody, 
                                       cssClass: "slds-modal_small",
                                       showCloseButton: true
                                   })   
                               }
                           });
    },
    HoverImage : function(component, event, helper) {      
        component.set("v.ImageToggle", component.get("v.label")); 
	},   
    NoMouseOver : function(component, event, helper) {      
        component.set("v.ImageToggle","");   
	},
})