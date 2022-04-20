({
	doInit : function(component, leadId) {
		var action = component.get("c.getLeadInfo");
        action.setParams({
            "leadId": component.get("v.leadId"),
            "leadName": component.get("v.leadName"),
            "leadStreet": component.get("v.leadStreet"),
            "leadCity": component.get("v.leadCity"),
            "leadState": component.get("v.leadState"),
            "leadCountry": component.get("v.leadCountry"),
            "leadPostalCode": component.get("v.leadPostalCode"),
        });

        component.set("v.enableTv", false);
        component.set("v.enableSmart", false);
        component.set("v.enableMusic", false);
        component.set("v.enableSecurity", false);
        component.set("v.enableClimate", false);
        component.set("v.enableKeypad", false);
        component.set("v.enableTvRemote", false);
        component.set("v.enableBoxTv", false);
        component.set("v.enableBoxSmart", false);
        component.set("v.disableWhenBoxSmart", false);
        component.set("v.enableBoxMusic", false);
        component.set("v.enableOtherHome", false);
        component.set("v.disableWhenBoxMusic", false);

        component.set("v.tvNonPotentialValue", 0);
        component.set("v.tvPotentialValue", 0);

        component.set("v.climatePotentialValue", 0);
        component.set("v.climateNonPotentialValue", 0);

        component.set("v.securityPotentialValue", 0);
        component.set("v.securityNonPotentialValue", 0);

        component.set("v.squarePotentialValue", 0);
        component.set("v.squareNonPotentialValue", 0);

        component.set("v.musicPotentialValue", 0);
        component.set("v.musicNonPotentialValue", 0);

        component.set("v.smartPotentialValue", 0);
        component.set("v.smartNonPotentialValue", 0);

        component.set("v.musicNumberRooms", 0);
        component.set("v.musicNonPotentialCurrency", 0);

        var numberRooms  = component.find("selectBuildingNumberRooms").set("v.value",0); 

        action.setCallback(this, function (response) {
            if (response.getState() === "ERROR") {
              var errors = response.getError();
              //if (errors) {
              //    if (errors[0] && errors[0].message) {
              //        console.log("Error message: " +
              //                 errors[0].message);
              //   }
              //} else {
                  console.log("Unknown error");
              //}
            }
            if (response.getState() === "SUCCESS" && response.getReturnValue() !== null) {
                component.set('v.lead', response.getReturnValue());
              } else {
            }

        });
        $A.enqueueAction(action);
	},

  enableAllTv : function(component, event) {
        var masterTv = component.find("master_checkbox_tv");
        var buttonSingleRemoteTv  = component.find("buttonSingleRemote");
        var buttonTvRemote  = component.find("buttonTvRemote");
        var buttonKeypad  = component.find("buttonKeypad");
        var textBoxTv =  component.find("textBoxTv");
        var val = masterTv.get("v.value");
        var noTv  = component.find("selectNumberTv");

        buttonSingleRemoteTv.set("v.value", val);
        buttonTvRemote.set("v.value", val);
        buttonKeypad.set("v.value", val);

        if (val == true) {
          component.set("v.enableTv", true);
          component.set("v.enableKeypad", true);
          component.set("v.enableTvRemote", true);
          component.set("v.tvNonPotentialValue", 0);
          component.set("v.tvPotentialValue", 0);
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);    
        } else {
          component.set("v.enableTv", false);
          component.set("v.enableKeypad", false);
          component.set("v.enableTvRemote", false);
          component.set("v.enableBoxTv", false);
          textBoxTv.set("v.value", null);
          component.set("v.noOfTv", '');
          noTv.set("v.value", '');
          component.set("v.listTv", []);  
          component.set("v.tvNonPotentialValue", 0);
          component.set("v.tvPotentialValue", 0);
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);
          $A.util.removeClass(textBoxTv, 'invalidInput');
          $A.util.removeClass(noTv, 'invalidInput');
          $A.util.removeClass(component.find("fteError1"), "show");
          $A.util.removeClass(component.find("fteError7"), "show");
        }
    },

    enableAllSmart : function(component, event) {
        var masterSmart = component.find("master_checkbox_smart");
        var buttonEveryRoomSmart  = component.find("buttonEveryRoomSmart");
        var buttonMainHomeAreasSmart  = component.find("buttonMainHomeAreasSmart");
        var buttonBedroomsSmart  = component.find("buttonBedroomsSmart");
        var textBoxSmart =  component.find("textBoxSmart");
        var textTotalRooms = component.find("selectBuildingNumberRooms");
        var val = masterSmart.get("v.value");

        buttonEveryRoomSmart.set("v.value", val);
        buttonMainHomeAreasSmart.set("v.value", val);
        buttonBedroomsSmart.set("v.value", val);

        if (val == true) {
          component.set("v.enableSmart", true);
          component.set("v.disableWhenBoxSmart", true);
          component.set("v.smartPotentialValue", 0);
          component.set("v.smartNonPotentialValue", 0);
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event); 
        } else {
          component.set("v.enableSmart", false);
          component.set("v.enableBoxSmart", false);
          component.set("v.disableWhenBoxSmart", false);
          component.set("v.smartPotentialValue", 0);
          component.set("v.smartNonPotentialValue", 0);   
          textBoxSmart.set("v.value", '');
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event); 
		      component.set("v.listSmart", []);  
          $A.util.removeClass(textBoxSmart, 'invalidInput');
          $A.util.removeClass(component.find("fteError2"), "show");
          $A.util.removeClass(textTotalRooms, 'invalidInput');
          $A.util.removeClass(component.find("fteError8"), "show");

        }
    },

    enableAllMusic : function(component, event) {
        var masterMusic = component.find("master_checkbox_music");
        var buttonEveryRoomMusic  = component.find("buttonEveryRoomMusic");
        var buttonMainHomeAreasMusic  = component.find("buttonMainHomeAreasMusic");
        var buttonBedroomsMusic  = component.find("buttonBedroomsMusic");
        var buttonOutdoorMusic  = component.find("buttonOutdoorMusic");
        var textBoxMusic =  component.find("textBoxMusic");
        var textTotalRooms = component.find("selectBuildingNumberRooms");
        var val = masterMusic.get("v.value");

        buttonEveryRoomMusic.set("v.value", val);
        buttonMainHomeAreasMusic.set("v.value", val);
        buttonBedroomsMusic.set("v.value", val);
        buttonOutdoorMusic.set("v.value", val);

        if (val == true) {
          component.set("v.enableMusic", true);
          component.set("v.disableWhenBoxMusic", true);
          component.set("v.musicPotentialValue", 0);
          component.set("v.musicNonPotentialValue", 0);
          component.set("v.musicNonPotentialCurrency", 0);
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);    
        } else {
          component.set("v.enableMusic", false);
          component.set("v.enableBoxMusic", false);
          component.set("v.disableWhenBoxMusic", false);
          textBoxMusic.set("v.value", '');
          component.set("v.listMusic", []);
          component.set("v.musicPotentialValue", 0);
          component.set("v.musicNonPotentialValue", 0);
          component.set("v.musicNonPotentialCurrency", 0);
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);    
          $A.util.removeClass(textBoxMusic, 'invalidInput');
          $A.util.removeClass(component.find("fteError3"), "show");
          $A.util.removeClass(textTotalRooms, 'invalidInput');
          $A.util.removeClass(component.find("fteError8"), "show");

        }
    },

    enableAllSecurity : function(component, event) {
        var masterSecurity = component.find("master_checkbox_security");
        var buttonSmartLocks  = component.find("buttonSmartLocks");
        var buttonCameras  = component.find("buttonCameras");
        var buttonDoorbell  = component.find("buttonDoorbell");
        var val = masterSecurity.get("v.value");

        buttonSmartLocks.set("v.value", val);
        buttonCameras.set("v.value", val);
        buttonDoorbell.set("v.value", val);
        if (val == true) {
          component.set("v.enableSecurity", true);
          component.set("v.securityPotentialValue", 0);
          component.set("v.securityNonPotentialValue", 0);  
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);    
        } else {
          component.set("v.enableSecurity", false);
          component.set("v.listSecurity", []);  
          component.set("v.securityPotentialValue", 0);
          component.set("v.securityNonPotentialValue", 0);   
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);                     
        }          
    },
    
    enableClimate : function(component, event) {
        var climate = component.find("checkbox_climate");
        var textBoxClimate =  component.find("textBoxClimate");
        var v = textBoxClimate.get("v.value");
        var val = climate.get("v.value"); 

        if (val == true) {
          component.set("v.enableClimate", true);
          component.set("v.climatePotentialValue", 0);
          component.set("v.climateNonPotentialValue", 0);
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);
        } else {
          component.set("v.enableClimate", false); 
          textBoxClimate.set("v.value", null);
          component.set("v.listClimate", []); 
          component.set("v.climatePotentialValue", 0);
          component.set("v.climateNonPotentialValue", 0);
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);
          $A.util.removeClass(textBoxClimate, 'invalidInput');
          $A.util.removeClass(component.find("fteError4"), "show");
        }
    },

    enableOtherHome : function(component, event) {
       var other_home = component.find("checkbox_other_home");
       var textBoxOtherHome =  component.find("textBoxOtherHome");
       var val = other_home.get("v.value"); 

        if (val == true) {
          component.set("v.enableOtherHome", true); 
        } else {
          component.set("v.enableOtherHome", false); 
          textBoxOtherHome.set("v.value", null);
          component.set("v.listOtherHome", []);  
          $A.util.removeClass(textBoxOtherHome, 'invalidInput');
          $A.util.removeClass(component.find("fteError5"), "show");
        }
    },

    disableKeypad : function(component, event) {
        var elem = event.getSource();
        var noTv  = component.find("selectNumberTv");
        var noTvVal = noTv.get("v.value");
        var tvPotentialValue = component.get("v.tvPotentialValue");
        var sumKeypad = 250;
        
        if ($A.util.hasClass(elem, 'slds-button_success')) {
            $A.util.removeClass(elem, 'slds-button_success');
            if (elem.getLocalId() == 'buttonKeypad') {
              this.removeArrayItem(component, 'listTv', 5);
              component.set("v.tvPotentialValue", tvPotentialValue - sumKeypad);
            } else {
              this.removeArrayItem(component, 'listTv', 4);
            }
            this.setSumPotentialValue(component, event);
            this.setSumNonPotentialValue(component, event);  
        } else {
            $A.util.addClass(elem, 'slds-button_success');
            if (elem.getLocalId() == 'buttonKeypad') {
              this.setArrayItem(component, 'listTv', elem.get('v.label'), 5);
              component.set("v.tvPotentialValue", tvPotentialValue + sumKeypad);
            } else {
              this.setArrayItem(component, 'listTv', elem.get('v.label'), 4);
            }
          this.setSumPotentialValue(component, event);
          this.setSumNonPotentialValue(component, event);  
        }      
    },

    enableBoxTvNumber : function(component, event) {
        var elem = event.getSource();
        var textBoxTv  = component.find("textBoxTv");
        var buttonKeypad = component.find("buttonKeypad");
        var boxTvVal = textBoxTv.get("v.value");

        if ($A.util.hasClass(elem, 'slds-button_success')) {
            $A.util.removeClass(elem, 'slds-button_success');
            $A.util.removeClass(textBoxTv, 'invalidInput');
            $A.util.removeClass(component.find("fteError1"), "show");
            component.set("v.enableBoxTv", false);
            if (boxTvVal>=0 && boxTvVal<100) {
              if ($A.util.hasClass(buttonKeypad, 'slds-button_success')) {
                component.set("v.tvPotentialValue", 250);
              } else {
                component.set("v.tvPotentialValue", 0);
              }  
                this.removeArrayItem(component, 'listTv', 1);
                this.removeArrayItem(component, 'listTv', 2);
                this.removeArrayItem(component, 'listTv', 3);
                this.setSumPotentialValue(component, event);
                this.setSumNonPotentialValue(component, event);
            }
          textBoxTv.set("v.value", '');
        } else {
            $A.util.addClass(elem, 'slds-button_success');
            component.set("v.enableBoxTv", true);
            if (boxTvVal>=0 && boxTvVal<100) {
              var v = textBoxTv.get("v.value") * 200;
              if ($A.util.hasClass(buttonKeypad, 'slds-button_success')) {
                component.set("v.tvPotentialValue", v + 250);
              } else {
                component.set("v.tvPotentialValue", v);
              }  
              this.setArrayItem(component, 'listTv', elem.get('v.label'), 1);
              this.setArrayItem(component, 'listTv', component.get('v.tvPotentialValue'), 3);
              this.setSumPotentialValue(component, event);
              this.setSumNonPotentialValue(component, event);
          }
        }
    },

    validateInputNumbersTv : function(component, event, helper) {
        var field = event.getSource();
        var val = field.get("v.value");
        if(val < 1 || val > 99) {
          $A.util.addClass(component.find("fteError1"),"show");
          return;
        } else {
          $A.util.removeClass(component.find("fteError1"), "show");
        }
    },

    validateInputNumbersTv2 : function(component, event, helper) {
        var field = event.getSource();
        var val = field.get("v.value");
        if(val < 1 || val > 99) {
          $A.util.addClass(component.find("fteError7"),"show");
          return;
        } else {
          $A.util.removeClass(component.find("fteError7"), "show");
        }
    },

    validateInputNumbersSmart : function(component, event, helper) {
        var field = event.getSource();
        var val = field.get("v.value");
        if(val < 1 || val > 99) {
          $A.util.addClass(component.find("fteError2"),"show");
        } else {
          $A.util.removeClass(component.find("fteError2"), "show");
        }
    },

    validateInputNumbersMusic : function(component, event, helper) {
        var field = event.getSource();
        var val = field.get("v.value");

        if(val < 1 || val > 99) {
          $A.util.addClass(component.find("fteError3"),"show");
        } else {
          $A.util.removeClass(component.find("fteError3"), "show");
        }
    },

    validateInputNumbersClimate : function(component, event, helper) {
        var field = event.getSource();
        var val = field.get("v.value");
        if(val < 1 || val > 99) {
          $A.util.addClass(component.find("fteError4"),"show");
        } else {
          $A.util.removeClass(component.find("fteError4"), "show");
        }
    },

    validateBuildingNumberRooms : function(component, event, helper) { // 'selectBuildingNumberRooms'
        var field = event.getSource();
        var val = field.get("v.value");

        if((val < 1 || val > 99) && (val != '')) {
          $A.util.addClass(component.find("fteError8"),"show");
        } else {
          $A.util.removeClass(component.find("fteError8"), "show");
        }
    },

    validateTextOtherHome : function(component, event, helper) {
        var field = event.getSource();
        var val = field.get("v.value").length;
        if(val < 1 || val > 500) {
          $A.util.addClass(component.find("fteError5"),"show");
        } else {
          $A.util.removeClass(component.find("fteError5"), "show");
        }
    },

    validateInputNumberSquareFootage : function(component, event, helper) {
        var field = event.getSource();
        var val = field.get("v.value");
        if(val < 1 || val > 999999999999999999) {
          $A.util.addClass(component.find("fteError6"),"show");
        } else {
          $A.util.removeClass(component.find("fteError6"), "show");
        }
    },

    enableTextBoxSmart : function(component, event) {
        var elem = event.getSource();
        var smartInputField = component.find("textBoxSmart");
        var smartInput = component.find("textBoxSmart").get("v.value");
        var textBoxSmart  = component.find("selectBuildingNumberRooms");
        var smartVal = textBoxSmart.get("v.value");
        var buttonGarage  = component.find("buttonGarage");
        var buttonMainHome = component.find("buttonMainHomeAreasSmart");
        var buttonBedroomsSmart = component.find("buttonBedroomsSmart");
        var garValue = 0;
        var remWholeHome = 0;
        var sum = component.get("v.smartPotentialValue");
        var sumNon = component.get("v.smartNonPotentialValue");

        if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
          garValue = 500;
        }
        if (!$A.util.hasClass(buttonGarage, 'slds-button_success')) {
          garValue = 0;
        }

        if (smartVal == undefined || smartVal == '' ) {
            smartVal = 0;
        }

        if ($A.util.hasClass(elem, 'slds-button_success')) { //OFF
          $A.util.removeClass(elem, 'slds-button_success');
          $A.util.removeClass(textBoxSmart, 'invalidInput');
          $A.util.removeClass(component.find("fteError2"), "show");
          component.set("v.disableWhenBoxSmart", true);
          component.set("v.enableBoxSmart", false);
          if (smartVal>=0 && smartVal<100) {
            var wholeHomeVal = smartVal * 250;
            this.removeArrayItem(component, 'listSmart', 0);
            this.removeArrayItem(component, 'listSmart', 5);
            remWholeHome = 0;          
            smartInputField.set("v.value", smartInput);
            component.set("v.smartPotentialValue", remWholeHome);
            component.set("v.smartNonPotentialValue", 0);
            this.setSumPotentialValue(component, event);
            this.setSumNonPotentialValue(component, event); 
          }  
          smartInputField.set("v.value", 0);
        } else {
          $A.util.addClass(elem, 'slds-button_success'); //ON
          component.set("v.disableWhenBoxSmart", false);
          component.set("v.enableBoxSmart", false);
          if (smartVal>=0 && smartVal<100) {
            var wholeHomeV = smartVal * 250;
            remWholeHome = (6 * 250) + 500 + wholeHomeV;
            //console.log('smartVal +++ ' + smartVal);
            smartInputField.set("v.value", smartInput); //06.08.18
            this.setArrayItem(component, 'listSmart', elem.get('v.label'), 0);
            this.setArrayItem(component, 'listSmart', textBoxSmart.get('v.value'), 5);
            component.set("v.smartPotentialValue", remWholeHome);
            component.set("v.smartNonPotentialValue", 0);
            this.removeArrayItem(component, 'listSmart', 1);
            this.removeArrayItem(component, 'listSmart', 3);
            this.removeArrayItem(component, 'listSmart', 4);
            this.setSumPotentialValue(component, event);
            this.setSumNonPotentialValue(component, event);
            smartInputField.set("v.value", 0);
            
        }
      }
    },

    enableTextBoxSmartBr : function(component, event) {
        var elem = event.getSource();
        var sum = component.get("v.smartPotentialValue");
        var sumNon = component.get("v.smartNonPotentialValue");
        var textBoxSmart  = component.find("textBoxSmart");
        var smartVal = textBoxSmart.get("v.value");
        var buttonGarage  = component.find("buttonGarage");
        var buttonMainHome = component.find("buttonMainHomeAreasSmart");
        var buttonBedroomsSmart = component.find("buttonBedroomsSmart");
        var garValue = 0;
        var mainHomeValue = 0;
        var addWholeHome = 0;

        if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
          garValue = 500;
        }
        if ($A.util.hasClass(buttonMainHome, 'slds-button_success')) {
          mainHomeValue = 1500;
        }

        if ($A.util.hasClass(elem, 'slds-button_success')) {
          $A.util.removeClass(elem, 'slds-button_success');
          $A.util.removeClass(textBoxSmart, 'invalidInput');
          $A.util.removeClass(component.find("fteError2"), "show");
          component.set("v.enableBoxSmart", false);
          //console.log('OFF Smart value ' + smartVal);
          if (smartVal>=0 && smartVal<100) {
            if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
              addWholeHome = garValue;
            }
            if ($A.util.hasClass(buttonMainHome, 'slds-button_success')) {
              addWholeHome = mainHomeValue;
            }
            if (($A.util.hasClass(buttonGarage, 'slds-button_success')) && ($A.util.hasClass(buttonMainHome, 'slds-button_success'))) {
              addWholeHome = mainHomeValue + garValue;
            } 
            if ((!$A.util.hasClass(buttonGarage, 'slds-button_success')) && (!$A.util.hasClass(buttonMainHome, 'slds-button_success'))) {
              addWholeHome = 0;//smartVal * 250;
            } 
            this.removeArrayItem(component, 'listSmart', 4);
            this.removeArrayItem(component, 'listSmart', 5);
            component.set("v.smartPotentialValue", addWholeHome);
            component.set("v.smartNonPotentialValue", 0);
            this.setSumPotentialValue(component, event);
            this.setSumNonPotentialValue(component, event); 
          }              
          textBoxSmart.set("v.value", 0);
        } else {
          $A.util.addClass(elem, 'slds-button_success');
          component.set("v.enableBoxSmart", true);
          //console.log('smartVal ON +++ ' + smartVal);

          if (smartVal>=0 && smartVal<100) {
            if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
              addWholeHome = garValue;
            }
            if ($A.util.hasClass(buttonMainHome, 'slds-button_success')) {
              addWholeHome = mainHomeValue;
            }
            if (($A.util.hasClass(buttonGarage, 'slds-button_success')) && ($A.util.hasClass(buttonMainHome, 'slds-button_success'))) {
              addWholeHome = mainHomeValue + garValue + (smartVal * 250);
            } 
            if ((!$A.util.hasClass(buttonGarage, 'slds-button_success')) && (!$A.util.hasClass(buttonMainHome, 'slds-button_success'))) {
              addWholeHome = smartVal * 250;
            } 

            component.set("v.smartPotentialValue", addWholeHome);
            component.set("v.smartNonPotentialValue", 0);
            this.setArrayItem(component, 'listSmart', elem.get('v.label'), 4);
            this.setSumPotentialValue(component, event);
            this.setSumNonPotentialValue(component, event); 
        }
      }
    },

    enableTextBoxMusic : function(component, event) {
        var elem = event.getSource();

        var sum = component.get("v.musicPotentialValue");
        var musicInputField = component.find("textBoxMusic");
        var musicInput = component.find("textBoxMusic").get("v.value");
        var textBoxMusicInp = component.find("selectBuildingNumberRooms");
        var textBoxMusic  = component.find("selectBuildingNumberRooms").get("v.value");


        var musicVal = component.get("v.valueMusicInput");
        var buttonOutdoorMusic  = component.find("buttonOutdoorMusic");

        component.set("v.musicNonPotentialValue",0);
        component.set("v.musicNonPotentialCurrency", 0);

        var remWholeHome = 0;
        var outdoorValue = 0;
        var numberRooms = 0;

        if ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
          outdoorValue = 2000;
          numberRooms = 1;
        }  

        if (textBoxMusic == undefined || textBoxMusic == '') {
            textBoxMusic = 0;
        }

        if ($A.util.hasClass(elem, 'slds-button_success')) {
          $A.util.removeClass(elem, 'slds-button_success');
          $A.util.removeClass(textBoxMusic, 'invalidInput');
          $A.util.removeClass(component.find("fteError3"), "show");
          component.set("v.disableWhenBoxMusic", true);
          component.set("v.enableBoxMusic", false);
          this.removeArrayItem(component, 'listMusic', 0); //Whole Home
          this.removeArrayItem(component, 'listMusic', 5); //num rooms
          if (textBoxMusic>=0 && textBoxMusic<100) {
            var wholeHomeVal = textBoxMusic * 750;
            if (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
              remWholeHome = 0;          
              musicInputField.set("v.value", 0); //
            } 
            if ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
              remWholeHome = 2000;
              musicInputField.set("v.value", 0); //
            } 
            component.set("v.musicPotentialValue", remWholeHome);
            component.set("v.musicNonPotentialValue", 0);
            this.calculateNonC4ForMusic(component, event);
            this.setSumPotentialValue(component, event);
            this.setSumNonPotentialValue(component, event); 
          }  
        } else {
          $A.util.addClass(elem, 'slds-button_success');
          component.set("v.disableWhenBoxMusic", false);
          component.set("v.enableBoxMusic", false );
          this.setArrayItem(component, 'listMusic', elem.get('v.label'), 0); //Whole Home
          this.setArrayItem(component, 'listMusic', textBoxMusicInp.get('v.value'), 5);
          //console.log('textBoxMusic +++' + textBoxMusic);
          //console.log('textBoxMusic +++' + elem.get('v.label'));
          if (textBoxMusic>=0 && textBoxMusic<100) {
            var wholeHomeVal = textBoxMusic * 750;  
            if ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
              //console.log('buttonOutdoorMusic +++')
              numberRooms = textBoxMusic + 3;
              remWholeHome = wholeHomeVal + 2000 + (2 * 750) ;          
              this.removeArrayItem(component, 'listMusic', 1); 
              musicInputField.set("v.value", 0); 
              component.set("v.musicPotentialValue", remWholeHome);
              component.set("v.musicNonPotentialValue", numberRooms);
              this.calculateNonC4ForMusic(component, event);
              this.setSumPotentialValue(component, event);
              this.setSumNonPotentialValue(component, event); 
            } 
            if (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
              //console.log('buttonOutdoorMusic -------')
              remWholeHome = wholeHomeVal + (2 * 750) + 2000;
              numberRooms = textBoxMusic + 2;

              //console.log('textBoxMusic +++' + textBoxMusic);
              musicInputField.set("v.value", 0); 
              this.removeArrayItem(component, 'listMusic', 3);
  
              component.set("v.musicNonPotentialValue", numberRooms);
              //console.log('buttonOutdoorMusic -------' + component.get("v.musicNonPotentialValue"));
              component.set("v.musicPotentialValue", remWholeHome);
              this.calculateNonC4ForMusic(component, event);
              this.setSumPotentialValue(component, event);
              this.setSumNonPotentialValue(component, event); 
            } 
            this.removeArrayItem(component, 'listMusic', 4);
            //this.removeArrayItem(component, 'listMusic', 5);
        }
      }
    },

    enableTextBoxMusicBr : function(component, event) {
        var elem = event.getSource();
        var textBoxMusic  = component.find("textBoxMusic").get("v.value");
        var musicVal = component.get("v.valueMusicInput");
        var sum = component.get("v.musicPotentialValue");
        component.set("v.musicNonPotentialValue",0);
        component.set("v.musicNonPotentialCurrency", 0);

        var buttonOutdoorMusic  = component.find("buttonOutdoorMusic");
        var buttonMainHomeAreasMusic  = component.find("buttonMainHomeAreasMusic");
        var outdoorValue = 0;
        var mainHomeV = 0;
        var sumRooms = 0;

        if (musicVal == undefined || musicVal == '') {
            musicVal = 0;
        }

        if ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
          outdoorValue = 2000;
          sumRooms = sumRooms + 1;
        }
        if ($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) {
          mainHomeV = 1500;
          sumRooms = sumRooms + 6;
        }

        if ($A.util.hasClass(elem, 'slds-button_success')) {
          $A.util.removeClass(elem, 'slds-button_success');
          $A.util.removeClass(textBoxMusic, 'invalidInput');
          $A.util.removeClass(component.find("fteError3"), "show");
          component.set("v.enableBoxMusic", false);
            this.removeArrayItem(component, 'listMusic', 4); //bedr
            this.removeArrayItem(component, 'listMusic', 5); //num bedr       
            //console.log('textBoxMusic +++ OFF '+ textBoxMusic );
              if (textBoxMusic>=0 && textBoxMusic<100) {
                if ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
                  addWholeHome = 2000;
                }
                if ($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) {
                  addWholeHome = 1500;
                }
                if (($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) && ($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))) {
                  addWholeHome = 3500;
                } 
                if ((!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) && (!$A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))) {
                  addWholeHome = 0;
                } 
              var bedrVal = textBoxMusic * 750
              sumRooms = textBoxMusic + sumRooms;
              var remBedr = sum - bedrVal;
              component.set("v.musicPotentialValue", addWholeHome);
              this.calculateNonC4ForMusic(component,event);       
              this.setSumPotentialValue(component, event);
              this.setSumNonPotentialValue(component, event);
            }   
          component.set("v.valueMusicInput", 0)
        } else {
            $A.util.addClass(elem, 'slds-button_success');
            component.set("v.enableBoxMusic", true );
            this.setArrayItem(component, 'listMusic', elem.get('v.label'), 4); //bedr
            if (textBoxMusic>=0 && textBoxMusic<100) {
              var addWholeHome = outdoorValue + mainHomeV + (textBoxMusic * 750);
              sumRooms = textBoxMusic + sumRooms;
              component.set("v.musicPotentialValue", addWholeHome);
              component.set("v.valueMusicInput", textBoxMusic)
              this.calculateNonC4ForMusic(component,event);       
              this.setSumPotentialValue(component, event);
              this.setSumNonPotentialValue(component, event);
          }  
        } 
    },

    handleSmartButtonClick : function(component, event) {
        var elem = event.getSource();
        var cmpTarget = event.getSource();
        var val = cmpTarget.get("v.value");
        var sum = component.get("v.smartPotentialValue");
        var sumNon = component.get("v.smartNonPotentialValue");
        var textBoxSmart  = component.find("textBoxSmart");

        var buttonGarage  = component.find("buttonGarage");
        var buttonMainHome = component.find("buttonMainHomeAreasSmart");
        var buttonBedroomsSmart = component.find("buttonBedroomsSmart");
        var garValue = 0;
        var mainHomeValue = 0;
        var addWholeHome = 0;
        var newV = 0;

        if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
          garValue = 500;
        }
        if ($A.util.hasClass(buttonMainHome, 'slds-button_success')) {
          mainHomeValue = 1500;
        }

        var smartVal = textBoxSmart.get("v.value");
        var sumRoomVal = 0;

        if (smartVal>=0 && smartVal<100) {
          sumRoomVal = smartVal * 250;
        }

        if ($A.util.hasClass(elem, 'slds-button_success')) {
            if (elem.get('v.name') == '1'){ //Main living areas
              if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
                newV = sumRoomVal + 500;
              } else {
                newV = sumRoomVal;
              }
              component.set("v.smartPotentialValue", newV);
              this.removeArrayItem(component, 'listSmart', 1);
            } else if (elem.get('v.name') == '3') {  //Porch/Garage
              if ($A.util.hasClass(buttonMainHome, 'slds-button_success')) {
                newV = sumRoomVal + 1500;
              } else {
                newV = sumRoomVal;
              }  
              component.set("v.smartPotentialValue", newV);
              this.removeArrayItem(component, 'listSmart', 3);
          }
        } else {
            if (elem.get('v.name') == '1'){
              if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
              //console.log('*********' + elem.get('v.name'));
              newV = sumRoomVal + 1500 + 500;
            } else {
              newV = sumRoomVal + 1500;
            }
              component.set("v.smartPotentialValue", newV);
              //console.log('********* ' + newV);
              this.setArrayItem(component, 'listSmart', elem.get('v.label'), 1); //Main living areas
            } else if (elem.get('v.name') == '3') {
              if ($A.util.hasClass(buttonMainHome, 'slds-button_success')) {
              newV = sumRoomVal + 500 + 1500;
            } else {
              newV = sumRoomVal + 500;
            }
              component.set("v.smartPotentialValue", newV);
              this.setArrayItem(component, 'listSmart', elem.get('v.label'), 3);  //Porch/Garage
            }
          }
        $A.util.toggleClass(event.getSource(), "slds-button_success");
        this.setSumPotentialValue(component, event);
        this.setSumNonPotentialValue(component, event);
    },

    handleMusicButtonClick : function(component, event) {
        var elem = event.getSource();
        var cmpTarget = event.getSource();
        var val = cmpTarget.get("v.value");
        var sum = component.get("v.musicPotentialValue");
        var musicVal = component.get("v.valueMusicInput");

        var sumRoomVal = 0;

        if (musicVal>0 && musicVal<100) {
          sumRoomVal = musicVal * 750;
        }
        var v2000 = 2000;

        if ($A.util.hasClass(elem, 'slds-button_success')) {
          if (elem.get('v.name') == '1'){ //Main home areas
              var newV = sum - 1500;
              component.set("v.musicPotentialValue", newV);
              this.removeArrayItem(component, 'listMusic', 1);
              this.setSumPotentialValue(component, event);
              this.calculateNonC4ForMusic(component,event);       
            } else if (elem.get('v.name') == '3') {  //Outdoor areas
              var newV = sum - v2000;
              component.set("v.musicPotentialValue", newV);
              this.removeArrayItem(component, 'listMusic', 3);
              this.setSumPotentialValue(component, event);
              this.calculateNonC4ForMusic(component,event);       
            }
            this.calculateNonC4ForMusic(component,event);       

        } else {
            if (elem.get('v.name') == '1') { //Main home areas
              var newV = sum + 1500;
              component.set("v.musicPotentialValue", newV);
              this.setArrayItem(component, 'listMusic', elem.get('v.label'), 1);
              this.setSumPotentialValue(component, event);
              this.calculateNonC4ForMusic(component,event);       

            } else if (elem.get('v.name') == '3') { //Outdoor areas
              var newV = sum + v2000;
              component.set("v.musicPotentialValue", newV);
              this.setArrayItem(component, 'listMusic', elem.get('v.label'), 3);
              this.setSumPotentialValue(component, event);
              this.calculateNonC4ForMusic(component,event);       
            }
            this.calculateNonC4ForMusic(component,event);       
        }
        $A.util.toggleClass(event.getSource(), "slds-button_success");
    },

    handleSecurityButtonClick : function(component, event) {
        var elem = event.getSource();
        var cmpTarget = event.getSource();
        var val = cmpTarget.get("v.value");
        var sum = component.get("v.securityPotentialValue");
        var sumNon = component.get("v.securityNonPotentialValue");
        var v300 = 900; //300 locks + dafault 3
        var v400 = 2000; //400 cameras + default 5 //why 700 per Camera????//changed to 400 per camera
        var v1800 = 1800; //1800
        var v2000 = 2000; //2000

        if ($A.util.hasClass(elem, 'slds-button_success')) {
            if (elem.get('v.name') == '0'){
                    this.removeArrayItem(component, 'listSecurity', 0);
                    this.removeArrayItem(component, 'listSecurity', 1);
                    var newV = sum - v300;
                    component.set("v.securityPotentialValue", newV);
                } else if (elem.get('v.name') == '1') {
                    this.removeArrayItem(component, 'listSecurity', 2);
                    this.removeArrayItem(component, 'listSecurity', 3);
                    var newV = sum - v400;
                    component.set("v.securityPotentialValue", newV);
                } else if (elem.get('v.name') == '2') {
                    this.removeArrayItem(component, 'listSecurity', 4);
                    this.removeArrayItem(component, 'listSecurity', 5);
                    var newV = sum - v1800;
                    component.set("v.securityPotentialValue", newV);
                } else if (elem.get('v.name') == '3') {
                    this.removeArrayItem(component, 'listSecurity', 6);
                    this.removeArrayItem(component, 'listSecurity', 7);
                    var newV = sum - v2000;
                    component.set("v.securityPotentialValue", newV);
                }     
            } else {
                if (elem.get('v.name') == '0'){
                    this.setArrayItem(component, 'listSecurity', elem.get('v.label'), 0);
                    this.setArrayItem(component, 'listSecurity',v300 , 1);
                    var newV = sum + v300;
                    component.set("v.securityPotentialValue", newV);
                } else if (elem.get('v.name') == '1') {
                    this.setArrayItem(component, 'listSecurity', elem.get('v.label'), 2);
                    this.setArrayItem(component, 'listSecurity',v400 , 3);
                    var newV = sum + v400;
                    component.set("v.securityPotentialValue", newV);
                } else if (elem.get('v.name') == '2') {
                    this.setArrayItem(component, 'listSecurity', elem.get('v.label'), 4);
                    this.setArrayItem(component, 'listSecurity',v1800 , 5);
                    var newV = sum + v1800;
                    component.set("v.securityPotentialValue", newV);
                } else if (elem.get('v.name') == '3') {
                    this.setArrayItem(component, 'listSecurity', elem.get('v.label'), 6);
                    this.setArrayItem(component, 'listSecurity',v2000 , 7);
                    var newV = sum + v2000;
                    component.set("v.securityPotentialValue", newV);
                }
            }
        this.setSumPotentialValue(component, event);
        this.setSumNonPotentialValue(component, event);
        $A.util.toggleClass(event.getSource(), "slds-button_success");
    },

    applyClassProjectType : function(component, event) {
        var elem = event.getSource();
        var val = elem.get("v.value");
        component.set("v.projectType", val);

        var btnNewHome  = component.find("buttonNewHome");
        var btnRemodeling  = component.find("buttonRemodeling");
        var btnRetrofit  = component.find("buttonRetrofit");

        if (elem == btnNewHome) {
            $A.util.addClass(btnNewHome, 'slds-button_success');
            $A.util.removeClass(btnRemodeling, 'slds-button_success');
            $A.util.removeClass(btnRetrofit, 'slds-button_success');
        } else if (elem == btnRemodeling) {
            $A.util.addClass(btnRemodeling, 'slds-button_success');
            $A.util.removeClass(btnNewHome, 'slds-button_success');
            $A.util.removeClass(btnRetrofit, 'slds-button_success');
        } else if (elem == btnRetrofit) {
            $A.util.addClass(btnRetrofit, 'slds-button_success');
            $A.util.removeClass(btnNewHome, 'slds-button_success');
            $A.util.removeClass(btnRemodeling, 'slds-button_success');
        }
    },

    applyClassBudget : function(component, event) {
        var elem = event.getSource();
        var val = elem.get("v.value");
        component.set("v.projectBudget", val);

        var btnU1  = component.find("buttonUnder1");
        var btn13  = component.find("button13");
        var btn1015  = component.find("button1015");
        var btn35  = component.find("button35");
        var btn510 =  component.find("button510");
        var btn25 =  component.find("button25");
        var btnDidntDiscuss =  component.find("buttonDidntDiscuss");
        var btnWouldntProvide =  component.find("buttonWouldntProvide");

        if (elem == btnU1) {
            $A.util.addClass(btnU1, 'slds-button_success');
            $A.util.removeClass(btn13, 'slds-button_success');
            $A.util.removeClass(btn1015, 'slds-button_success');
            $A.util.removeClass(btn35, 'slds-button_success');
            $A.util.removeClass(btn510, 'slds-button_success');
            $A.util.removeClass(btn25, 'slds-button_success');
            $A.util.removeClass(btnDidntDiscuss, 'slds-button_success');
            $A.util.removeClass(btnWouldntProvide, 'slds-button_success');
        } else if (elem == btn13) {
            $A.util.addClass(btn13, 'slds-button_success');
            $A.util.removeClass(btnU1, 'slds-button_success');
            $A.util.removeClass(btn1015, 'slds-button_success');
            $A.util.removeClass(btn35, 'slds-button_success');
            $A.util.removeClass(btn510, 'slds-button_success');
            $A.util.removeClass(btn25, 'slds-button_success');
            $A.util.removeClass(btnDidntDiscuss, 'slds-button_success');
            $A.util.removeClass(btnWouldntProvide, 'slds-button_success');
        } else if (elem == btn1015) {
            $A.util.addClass(btn1015, 'slds-button_success');
            $A.util.removeClass(btnU1, 'slds-button_success');
            $A.util.removeClass(btn13, 'slds-button_success');
            $A.util.removeClass(btn35, 'slds-button_success');
            $A.util.removeClass(btn510, 'slds-button_success');
            $A.util.removeClass(btn25, 'slds-button_success');
            $A.util.removeClass(btnDidntDiscuss, 'slds-button_success');
            $A.util.removeClass(btnWouldntProvide, 'slds-button_success');
        } else if (elem == btn35) {
            $A.util.addClass(btn35, 'slds-button_success');
            $A.util.removeClass(btnU1, 'slds-button_success');
            $A.util.removeClass(btn13, 'slds-button_success');
            $A.util.removeClass(btn1015, 'slds-button_success');
            $A.util.removeClass(btn510, 'slds-button_success');
            $A.util.removeClass(btn25, 'slds-button_success');
            $A.util.removeClass(btnDidntDiscuss, 'slds-button_success');
            $A.util.removeClass(btnWouldntProvide, 'slds-button_success');
        } else if (elem == btn510) {
            $A.util.addClass(btn510, 'slds-button_success');
            $A.util.removeClass(btnU1, 'slds-button_success');
            $A.util.removeClass(btn13, 'slds-button_success');
            $A.util.removeClass(btn1015, 'slds-button_success');
            $A.util.removeClass(btn35, 'slds-button_success');
            $A.util.removeClass(btn25, 'slds-button_success');
            $A.util.removeClass(btnDidntDiscuss, 'slds-button_success');
            $A.util.removeClass(btnWouldntProvide, 'slds-button_success');
        } else if (elem == btn25) {
            $A.util.addClass(btn25, 'slds-button_success');
            $A.util.removeClass(btnU1, 'slds-button_success');
            $A.util.removeClass(btn13, 'slds-button_success');
            $A.util.removeClass(btn1015, 'slds-button_success');
            $A.util.removeClass(btn35, 'slds-button_success');
            $A.util.removeClass(btn510, 'slds-button_success');
            $A.util.removeClass(btnDidntDiscuss, 'slds-button_success');
            $A.util.removeClass(btnWouldntProvide, 'slds-button_success');
        } else if (elem == btnDidntDiscuss) {
            $A.util.removeClass(btn25, 'slds-button_success');
            $A.util.removeClass(btnU1, 'slds-button_success');
            $A.util.removeClass(btn13, 'slds-button_success');
            $A.util.removeClass(btn1015, 'slds-button_success');
            $A.util.removeClass(btn35, 'slds-button_success');
            $A.util.removeClass(btn510, 'slds-button_success');
            $A.util.addClass(btnDidntDiscuss, 'slds-button_success');
            $A.util.removeClass(btnWouldntProvide, 'slds-button_success');
        } else if (elem == btnWouldntProvide) {
            $A.util.removeClass(btn25, 'slds-button_success');
            $A.util.removeClass(btnU1, 'slds-button_success');
            $A.util.removeClass(btn13, 'slds-button_success');
            $A.util.removeClass(btn1015, 'slds-button_success');
            $A.util.removeClass(btn35, 'slds-button_success');
            $A.util.removeClass(btn510, 'slds-button_success');
            $A.util.removeClass(btnDidntDiscuss, 'slds-button_success');
            $A.util.addClass(btnWouldntProvide, 'slds-button_success');
        }
    },

    calculateNonC4ForMusic : function(component, event) {
        var buttonEveryRoomMusic = component.find("buttonEveryRoomMusic");
        var buttonBedroomsMusic = component.find("buttonBedroomsMusic");
        var buttonMainHomeAreasMusic  = component.find("buttonMainHomeAreasMusic");
        //var boxMusicValue = component.find("textBoxMusic"); 
        var textBoxMusicValue = component.get("v.valueMusicInput");
        var totalRooms = component.find("selectBuildingNumberRooms").get("v.value"); // //textBoxMusic

        if (totalRooms == NaN || totalRooms == undefined){
          totalRooms = 0;
        }
        if (textBoxMusicValue == NaN || textBoxMusicValue == undefined){
          textBoxMusicValue = 0;
        }

        var buttonOutdoorMusic  = component.find("buttonOutdoorMusic");
        var wholeHomeSum = 0;//every room
        var bedroomSum = 0; //bedr
        var mainHomeAreasSum = 0;//main home areas
        var outdoorSum = 0; // outdoor
        var nonC4MusicSum = 0;
        if (($A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success')) 
            && ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
              && (!$A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))
                && (!$A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))) {
                  wholeHomeSum = textBoxMusicValue; 
                  outdoorSum = parseInt(1,10);
                  bedroomSum = 0;
                  mainHomeAreasSum = 0; 
                  nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(outdoorSum,10),10) + parseInt(2,10);
                  component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }
        if (($A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success')) 
            && (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
             && (!$A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
              && (!$A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))) {
              wholeHomeSum = textBoxMusicValue; 
              outdoorSum = 0;
              bedroomSum = 0;
              mainHomeAreasSum = 0;
              nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10),10) + parseInt(2,10);
              component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }
        if (($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) 
          && ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
            && ($A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
               && (!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))) {
              bedroomSum = parseInt(textBoxMusicValue,10); 
              mainHomeAreasSum = parseInt(2,10);
              wholeHomeSum = 0;
              outdoorSum = parseInt(1,10);
              nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(bedroomSum,10) + parseInt(outdoorSum,10) + parseInt(mainHomeAreasSum,10),10);
              component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }
        if (($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) 
          && ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
            && (!$A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
              && (!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))) {
              mainHomeAreasSum = parseInt(2,10);
              wholeHomeSum = 0;
              outdoorSum = parseInt(1,10);
              bedroomSum = 0;
              nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(bedroomSum,10) + parseInt(outdoorSum,10) + parseInt(mainHomeAreasSum,10),10);
              component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }
        if (($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) 
          && (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
            && (!$A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
             && (!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))) {
              mainHomeAreasSum = parseInt(2,10);
              wholeHomeSum = 0;
              outdoorSum = 0;
              bedroomSum = 0;
              nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(bedroomSum,10) + parseInt(outdoorSum,10) + parseInt(mainHomeAreasSum,10),10);
              component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }
        if (($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) 
          && (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
            && ($A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
             &&  (!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))) {
              mainHomeAreasSum = parseInt(2,10);
              wholeHomeSum = 0;
              outdoorSum = 0;
              bedroomSum = parseInt(textBoxMusicValue,10); 
              nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(bedroomSum,10) + parseInt(outdoorSum,10) + parseInt(mainHomeAreasSum,10),10);
              component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }
        if (($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
         && (!$A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))
          &&  (!$A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
           &&   (!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))){
            outdoorSum = parseInt(1,10);
            mainHomeAreasSum = 0;
            wholeHomeSum = 0;
            bedroomSum = 0;
            nonC4MusicSum = parseInt(1,10);
            component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }    
        if (($A.util.hasClass(buttonBedroomsMusic, 'slds-button_success')) 
          && (!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))
           && (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
            && (!$A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))) {
            bedroomSum = parseInt(textBoxMusicValue,10); 
            outdoorSum = parseInt(0,10);
            mainHomeAreasSum = parseInt(0,10);
            wholeHomeSum = parseInt(0,10);
            nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(bedroomSum,10) + parseInt(outdoorSum,10) + parseInt(mainHomeAreasSum,10),10);
            component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }
        if (($A.util.hasClass(buttonBedroomsMusic, 'slds-button_success')) 
           && (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
            && ($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))
            && (!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))) {
            bedroomSum = parseInt(textBoxMusicValue,10); 
            outdoorSum = 0;
            mainHomeAreasSum = parseInt(2,10);
            wholeHomeSum = 0;
            nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(bedroomSum,10) + parseInt(outdoorSum,10) + parseInt(mainHomeAreasSum,10),10);
            component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }

        if (($A.util.hasClass(buttonBedroomsMusic, 'slds-button_success')) 
           && ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
            && (!$A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))
            && (!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))) {
            bedroomSum = parseInt(textBoxMusicValue,10); 
            outdoorSum = parseInt(1,10);
            mainHomeAreasSum = 0;
            wholeHomeSum = 0;
            nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(bedroomSum,10) + parseInt(outdoorSum,10) + parseInt(mainHomeAreasSum,10),10);
            component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10));
        }

        if ((!$A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success')) 
          && (!$A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) 
            && (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
              && (!$A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
                ){
                bedroomSum = 0;
                outdoorSum = 0;
                mainHomeAreasSum = 0;
                wholeHomeSum = 0;
                nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10) + parseInt(bedroomSum,10) + parseInt(outdoorSum,10) + parseInt(mainHomeAreasSum,10),10);
                component.set("v.musicNonPotentialValue", 0);
                component.set("v.musicNonPotentialCurrency", 0);
                this.setSumNonPotentialValue(component, event);
        }   

        if (($A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success')) 
            && (!$A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))
             && (!$A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
              && (!$A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))) {
              if (totalRooms  > 0) {
                wholeHomeSum = totalRooms; 
                outdoorSum = 0;
                bedroomSum = 0;
                mainHomeAreasSum = 0;
                nonC4MusicSum = parseInt(parseInt(wholeHomeSum,10),10) + parseInt(2,10);
                component.set("v.musicNonPotentialValue", parseInt(nonC4MusicSum,10)); 
              }

        }

        if (nonC4MusicSum > 0) {
          this.setArrayItem(component, 'listMusic', nonC4MusicSum.toString(), 6);
        }

        if (totalRooms > 0) {
          this.setArrayItem(component, 'listMusic', nonC4MusicSum.toString(), 6);

        }

        var nonPvMusic = 0;
        var nonPvCurrency = 0;
        var nonPV = component.get("v.musicNonPotentialValue");
        console.log('musicNonPotentialValue +++ '+ nonPV);

        if (nonPV>0) {
          nonPvMusic =  Math.ceil(nonPV/8); 
          console.log('nonPvMusic Math.ceil ++++  '+ nonPvMusic);
          nonPvCurrency = nonPvMusic * 200;
          component.set("v.musicNonPotentialCurrency", nonPvCurrency);
        } else {
          component.set("v.musicNonPotentialCurrency", 0);
        }
        this.setSumNonPotentialValue(component, event);

    },

    setSumPotentialValue : function(component, event) {
        var sumPotentialTv = component.get("v.tvPotentialValue");
        var integerTv = parseInt(sumPotentialTv, 10);
        var smartPotentialValue = component.get("v.smartPotentialValue");
        var integerSmart = parseInt(smartPotentialValue, 10);
        var musicPotentialValue = component.get("v.musicPotentialValue");
        var integerMus = parseInt(musicPotentialValue, 10);
        var securityPotentialValue = component.get("v.securityPotentialValue");
        var integerSec = parseInt(securityPotentialValue, 10);
        var climatePotentialValue = component.get("v.climatePotentialValue");
        var integerCli =  parseInt(climatePotentialValue, 10);
        var squarePotentialValue = component.get("v.squarePotentialValue");
        var v = integerTv+integerSec+integerCli+integerMus+integerSmart;
        component.set("v.sumPotentialValue", v);
    },

    setSumNonPotentialValue : function(component, event) {
        var sumNonPotentialTv = component.get("v.tvNonPotentialValue");
        var smartNonPotentialValue = component.get("v.smartNonPotentialValue");
        var integerSmart = parseInt(smartNonPotentialValue, 10);
        var musicNonPotentialValue = component.get("v.musicNonPotentialCurrency");
        if ((musicNonPotentialValue == undefined) || (musicNonPotentialValue == NaN)) {
          musicNonPotentialValue = 0;
        }
        var integerMus = parseInt(musicNonPotentialValue, 10);
        var securityNonPotentialValue = component.get("v.securityNonPotentialValue");
        var climateNonPotentialValue = component.get("v.climateNonPotentialValue");
        var squareNonPotentialValue = component.get("v.squareNonPotentialValue");
        var v = sumNonPotentialTv+climateNonPotentialValue+securityNonPotentialValue+integerMus+integerSmart;
        component.set("v.sumNonPotentialValue", v);
    },

    validateRequiredTv: function (component) {
        var isValid = true;
        var buttonSingleRemote = component.find("buttonSingleRemote");
        var textBoxTv = component.find("textBoxTv");
        if (textBoxTv.get('v.value') == null 
          || textBoxTv.get('v.value') == '' 
          || textBoxTv.get('v.value') < 1  
          || textBoxTv.get('v.value') >99 
          || textBoxTv.get('v.value') == 0) {
          if ($A.util.hasClass(buttonSingleRemote, 'slds-button_success')) {
            $A.util.addClass(textBoxTv, 'invalidInput');
              isValid = false;
          }
        } else {
            $A.util.removeClass(textBoxTv, 'invalidInput');
        }
        return isValid;     
    },

    validateRequiredNoTv: function (component) {
        var isValid = true;
        var buttonTvRemote = component.find("buttonTvRemote");
        var buttonKeypad = component.find("buttonKeypad");
        var textBoxNoTv = component.find("selectNumberTv");

        if (textBoxNoTv.get('v.value') == null 
          || textBoxNoTv.get('v.value') == '' 
          || textBoxNoTv.get('v.value') < 1  
          || textBoxNoTv.get('v.value') >99 
          || textBoxNoTv.get('v.value') == 0) {
          if ($A.util.hasClass(buttonTvRemote, 'slds-button_success')
          || $A.util.hasClass(buttonKeypad, 'slds-button_success')) {
              $A.util.addClass(textBoxNoTv, 'invalidInput');
              isValid = false;
            }
          } else {
              $A.util.removeClass(textBoxNoTv, 'invalidInput');
          }
          return isValid;     
    },


    validateRequiredClimate: function (component) {
        var isValid = true;
        var textBoxClimate = component.find("textBoxClimate");
        var enableClimate = component.get("v.enableClimate");

        if (textBoxClimate.get('v.value') == null 
          || textBoxClimate.get('v.value') == '' 
          || textBoxClimate.get('v.value') < 1  
          || textBoxClimate.get('v.value') > 99 
          || textBoxClimate.get('v.value') == 0) {
          if (enableClimate == true) {
            $A.util.addClass(textBoxClimate, 'invalidInput');
            isValid = false;
          } 
        } else {
            $A.util.removeClass(textBoxClimate, 'invalidInput');
        }
        return isValid;

    },   

    validateRequiredOtherHome: function (component) {
        var isValid = true;
        var textBoxOtherHome = component.find("textBoxOtherHome");
        var enableOtherHome = component.get("v.enableOtherHome");

        if (textBoxOtherHome.get('v.value') == null 
          || textBoxOtherHome.get('v.value') == '' 
          || textBoxOtherHome.get('v.value').length < 1  
          || textBoxOtherHome.get('v.value').length > 500 
          || textBoxOtherHome.get('v.value') == 0) {
          if (enableOtherHome == true) {
            $A.util.addClass(textBoxOtherHome, 'invalidInput');
            isValid = false;
          } 
        } else {
            $A.util.removeClass(textBoxOtherHome, 'invalidInput');
        }
        return isValid;

    }, 

    validateSquareFootage: function (component) {
        var isValid = true;
        var textSquareFootage = component.find("textSquareFootage");
        var prType = component.get("v.projectType");
        var prBudget = component.get("v.projectBudget");

        if (textSquareFootage.get('v.value') == null
          || textSquareFootage.get('v.value') == '' 
          || textSquareFootage.get('v.value') < 1  
          || textSquareFootage.get('v.value') > 999999999999999999 
          || textSquareFootage.get('v.value') == 0) {
          if (prType != null && prBudget != null) {
            $A.util.addClass(textSquareFootage, 'invalidInput');
            isValid = false;
          } 
        } else {
            $A.util.removeClass(textSquareFootage, 'invalidInput');
        }
        return isValid;

    },   

    validateRequiredTvComponent: function (component) {
        var isValid = true;
        var buttonSingleRemote = component.find("buttonSingleRemote");
        var buttonTvRemote  = component.find("buttonTvRemote");
        var buttonKeypad  = component.find("buttonKeypad");
        var textBoxTv =  component.find("textBoxTv");
        var selectNumberTv = component.find("selectNumberTv");

        if (((textBoxTv.get('v.value') != null) 
          && (textBoxTv.get('v.value') != '0') 
          && (textBoxTv.get('v.value') != '') 
          && ($A.util.hasClass(buttonSingleRemote, 'slds-button_success')))
          || ((selectNumberTv.get('v.value') != null) 
            && (selectNumberTv.get('v.value') != '0') 
            && (selectNumberTv.get('v.value') != '')) 
              || (($A.util.hasClass(buttonTvRemote, 'slds-button_success')) 
                || ($A.util.hasClass(buttonKeypad, 'slds-button_success'))))
           {

        } else {
                  isValid = false;
        }
        //console.log('validateRequiredTvComponent ' + isValid);
        return isValid;     
    },  

    validateRequiredNoTvComponent: function (component) {
        var isValid = true;
        var buttonSingleRemote = component.find("buttonSingleRemote");
        var buttonTvRemote  = component.find("buttonTvRemote");
        var buttonKeypad  = component.find("buttonKeypad");
        var textBoxTv =  component.find("textBoxTv");
        var selectNumberTv = component.find("selectNumberTv");

        if (((selectNumberTv.get('v.value') != null) && (selectNumberTv.get('v.value') != '0'))
          || ($A.util.hasClass(buttonSingleRemote, 'slds-button_success'))
          || ($A.util.hasClass(buttonTvRemote, 'slds-button_success'))
          || ($A.util.hasClass(buttonKeypad, 'slds-button_success'))) {
        } else {
            isValid = false;
        }
      return isValid;     
    },  

    validateRequiredMusic: function (component) {
        var isValid = true;
        var buttonBedroomsMusic = component.find("buttonBedroomsMusic");
        var textBoxMusic = component.find("textBoxMusic");

        if (textBoxMusic.get('v.value') == null 
          || textBoxMusic.get('v.value') == '' 
          || textBoxMusic.get('v.value') < 1  
          || textBoxMusic.get('v.value') > 99 
          || textBoxMusic.get('v.value') == 0) {
          if ($A.util.hasClass(buttonBedroomsMusic, 'slds-button_success')) {
            $A.util.addClass(textBoxMusic, 'invalidInput');
            isValid = false;
          }
        } else {
            $A.util.removeClass(textBoxMusic, 'invalidInput');
        }
        //console.log('music ' + isValid);
        return isValid;   
    },

    validateRequiredTotalRooms: function (component) {
        var isValid = true;
        var buttonEveryRoomMusic = component.find("buttonEveryRoomMusic");
        var buttonEveryRoomSmart = component.find("buttonEveryRoomSmart");

        var textTotalRooms = component.find("selectBuildingNumberRooms");

        if(textTotalRooms.get('v.value') > 99 
          || textTotalRooms.get('v.value') == 0) {
          if (($A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success')) 
            || ($A.util.hasClass(buttonEveryRoomSmart, 'slds-button_success'))) {
            $A.util.addClass(textTotalRooms, 'invalidInput');
            isValid = false;
          }
        } else {
            $A.util.removeClass(textTotalRooms, 'invalidInput');
        }
        //console.log('validateRequiredTotalRooms +++ ' + isValid);
        return isValid;   
    },

    validateRequiredSmart: function (component) {
        var isValid = true;
        var buttonBedroomsSmart = component.find("buttonBedroomsSmart");
        var textBoxSmart = component.find("textBoxSmart");

        if (textBoxSmart.get('v.value') == null 
          || textBoxSmart.get('v.value') == '' 
          || textBoxSmart.get('v.value') < 1  
          || textBoxSmart.get('v.value') > 99 
          || textBoxSmart.get('v.value') == 0) {
          if ($A.util.hasClass(buttonBedroomsSmart, 'slds-button_success')) {
            $A.util.addClass(textBoxSmart, 'invalidInput');
            isValid = false;
          }
        } else {
            $A.util.removeClass(textBoxSmart, 'invalidInput');
        }
        return isValid;     
    },    

    validateRequiredSmartComponent: function (component) {
        var isValid = true;
        var buttonEveryRoomSmart  = component.find("buttonEveryRoomSmart");
        var buttonMainHomeAreasSmart  = component.find("buttonMainHomeAreasSmart");
        var buttonBedroomsSmart  = component.find("buttonBedroomsSmart");
        var buttonGarage  = component.find("buttonGarage");
        var textBoxSmart =  component.find("textBoxSmart");

        if (($A.util.hasClass(buttonEveryRoomSmart, 'slds-button_success'))
          || ($A.util.hasClass(buttonMainHomeAreasSmart, 'slds-button_success'))
          || ($A.util.hasClass(buttonBedroomsSmart, 'slds-button_success'))
          || ($A.util.hasClass(buttonGarage, 'slds-button_success'))) {
            } else {
                isValid = false;
            }
        return isValid;  
    },  

    validateRequiredMusicComponent: function (component) {
        var isValid = true;
        var buttonEveryRoomMusic  = component.find("buttonEveryRoomMusic");
        var buttonMainHomeAreasMusic  = component.find("buttonMainHomeAreasMusic");
        var buttonBedroomsMusic  = component.find("buttonBedroomsMusic");
        var buttonOutdoorMusic  = component.find("buttonOutdoorMusic");
        if (($A.util.hasClass(buttonEveryRoomMusic, 'slds-button_success'))
          || ($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success'))
          || ($A.util.hasClass(buttonBedroomsMusic, 'slds-button_success'))
          || ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success'))) {
        } else {
            isValid = false;
        }
        return isValid;     
    },  

    validateRequiredSecurityComponent: function (component) {
        var isValid = true;
        var buttonSmartLocks  = component.find("buttonSmartLocks");
        var buttonCameras  = component.find("buttonCameras");
        var buttonDoorbell  = component.find("buttonDoorbell");

        if (($A.util.hasClass(buttonSmartLocks, 'slds-button_success'))
          || ($A.util.hasClass(buttonCameras, 'slds-button_success'))
          || ($A.util.hasClass(buttonDoorbell, 'slds-button_success'))) {
        } else {
              isValid = false;
        }
        return isValid;     
    },  

    createSmartRecords : function(component, event) {
        var newS = component.get("v.newSmartHomeBuilder");
        var listTvRecords = component.get("v.listTv");
        var listSmartRecords = component.get("v.listSmart");
        var listMusicRecords = component.get("v.listMusic");
        var listSecurityRecords = component.get("v.listSecurity");
        var listClimateRecords = component.get("v.listClimate");
        var listOtherHomeRecords = component.get("v.listOtherHome");
        var enableTv = component.get("v.enableTv");
        var enableSmart = component.get("v.enableSmart");
        var enableMusic = component.get("v.enableMusic");
        var enableSecurity = component.get("v.enableSecurity");
        var enableClimate = component.get("v.enableClimate");
        var enableOtherHome = component.get("v.enableOtherHome");
        var prType = component.get("v.projectType");

        var musicNumberRooms = component.get("v.musicNumberRooms");
        var prBudget = component.get("v.projectBudget");
        var leadId = component.get("v.leadId"); 
        var sumPotentialValue = component.get("v.sumPotentialValue"); 
        var isValidMusic = this.validateRequiredMusic(component);
        var isValidTv = this.validateRequiredTv(component);
        var isValidNoTv = this.validateRequiredNoTv(component);
        var isValidSmart = this.validateRequiredSmart(component);
        var isValidClimate = this.validateRequiredClimate(component);
        var isValidOtherHome = this.validateRequiredOtherHome(component);
        var isValidSquareFootage = this.validateSquareFootage(component);
        var isValidTotalRooms = this.validateRequiredTotalRooms(component);

        var isValidTvPart = this.validateRequiredTvComponent(component);
        var isValidSmartPart = this.validateRequiredSmartComponent(component);
        var isValidMusicPart = this.validateRequiredMusicComponent(component);
        var isValidSecurityPart = this.validateRequiredSecurityComponent(component);

        var squareFootage = component.find("textSquareFootage"); 
        var totalNumberOfRooms = component.find("selectBuildingNumberRooms"); 
        var valueNumberOfRooms = totalNumberOfRooms.get("v.value");        

        var valueSquareFootage = squareFootage.get("v.value"); 
        var valueLeadMessage = component.get("v.valueLeadMessage");
        var starterController = 10000;
        var premiumController = 25000;

        if (sumPotentialValue<=starterController) {
          newS.Value_category__c = 'Starter';
        }

        if ((sumPotentialValue>starterController) && (sumPotentialValue<=premiumController)) {
          newS.Value_category__c = 'Premium';
        }
        
        if (sumPotentialValue>premiumController) {
          newS.Value_category__c = 'Luxury';
        }

        if (enableMusic) {
            if  (!isValidMusic) {
                this.showToast(false, "Please populate Correct Number of Music Options");
                return;
            }
            if ((isValidMusic && !isValidMusicPart)) {
                this.showToast(false, "Please select Music Options");
                return;
            }
            if (!isValidTotalRooms) {
                this.showToast(false, "Please populate Correct Number of Rooms");
                return;
            }
        }
        if (enableTv) {
            if (!isValidTv) {
                this.showToast(false, "Please populate Correct Number of TV Options");
                return;
            } 
            if (!isValidNoTv) {
                this.showToast(false, "Please populate Correct Number of TV Options");
                return;
            } 
            if (isValidTv && !isValidTvPart) {
                this.showToast(false, "Please select TV Options");
                return;
            }           
        }
        if (enableSmart) {
            if (!isValidSmart) {
                this.showToast(false, "Please populate Correct Number of Smart Lighting Options");
                return;
            } 
            if ((isValidSmart && !isValidSmartPart)) {
                this.showToast(false, "Please Select Smart Lighting Options");
                return;
            }   
            if (!isValidTotalRooms) {
                this.showToast(false, "Please populate Correct Number of Rooms");
                return;
            } 
        }     
        if (enableSecurity) {
            if (!isValidSecurityPart) {
                this.showToast(false, "Please select Security Options");
                return;
            }
        } 
        if (enableClimate) {
            if (!isValidClimate) {
                this.showToast(false, "Please populate Correct Number of Thermostats");
                return;
            }
        } 
        if (enableOtherHome) {
            if (!isValidOtherHome) {
                this.showToast(false, "Please populate correct value Other Description");
                return;
            }
        } 
        if (!isValidSquareFootage) {
            this.showToast(false, "Please populate correct Square Footage");
            return;    
        }        
        if (prType == null) {
            this.showToast(false, "Please select 'New Home' or 'Remodeling' or 'Retrofit' ");
            return;
        }
        if (prBudget == null) {
            this.showToast(false, "Please select your estimated budget");
            return;    
        }

        if ((prType != null) 
            && (prBudget != null) 
                && (!enableMusic) 
                    && (!enableTv)
                        && (!enableSmart)
                            && (!enableSecurity)
                               && (!enableClimate) 
                                   && (!enableOtherHome)
                                        && valueSquareFootage != null) {
            this.showToast(false, "Please select minimum one Component");
            return;
        }

        if ((enableTv && isValidTvPart && isValidTv && isValidNoTv) 
            || (enableSmart && isValidSmartPart && isValidSmart) 
                || (enableMusic && isValidMusicPart && isValidMusic) 
                    || (enableSecurity && isValidSecurityPart) 
                        || (enableClimate && isValidClimate)
                            || (enableOtherHome && isValidOtherHome)) {
                                if (prType != null && prBudget != null && isValidSquareFootage) {
                                    newS.Lead__c = leadId;
                                    newS.Project_type__c = prType;
                                    newS.Budget__c = prBudget;
                                    newS.Square_Footage__c = valueSquareFootage;
                                    newS.Potential_value__c = sumPotentialValue;
                                    if (valueLeadMessage == ''){
                                      newS.Lead_Message__c = '';
                                    } else {
                                      newS.Lead_Message__c = valueLeadMessage;
                                    }

                                    if (valueNumberOfRooms == ''){
                                      newS.NumberOfRooms__c = 0;
                                    } else {
                                      newS.NumberOfRooms__c = valueNumberOfRooms;
                                    }
                                    
                                    var action = component.get("c.saveSmartRecords");
                                    action.setParams({ 
                                        "leadId": leadId,
                                        "smrt": newS,
                                        "listClimate": listClimateRecords,
                                        "listTv": listTvRecords,
                                        "listSmart": listSmartRecords,
                                        "listMusic": listMusicRecords,
                                        "listSecurity": listSecurityRecords,
                                        "listOtherHome": listOtherHomeRecords
                                    });
                                    action.setCallback(this, function(a) {
                                            var state = a.getState();
                                            if (state === "SUCCESS" || a.getReturnValue() !== null) {
                                                window.location = '/' + leadId;
                                            }
                                        });
                                    $A.enqueueAction(action)
                                }
        }
    },

    setArrayItem: function(component, arrName, elem, index) {
        var paramArray = component.get('v.' + arrName);
        paramArray[index] = elem;
        component.set('v.' + arrName, paramArray);
    },

    removeArrayItem: function(component, arrName, index) {
        var paramArray = component.get('v.' + arrName);
        paramArray[index] = null;
        component.set('v.' + arrName, paramArray);
    },

    showToast: function (isSuccess, message) {
        var toast = document.getElementById('toast');
        
        if (toast.classList.contains('slds-hide')) {
        var theme = document.getElementById('theme');

        if (isSuccess) {
          theme.classList.remove('slds-theme_error');
          theme.classList.add('slds-theme_success');
        } else {
          theme.classList.remove('slds-theme_success');
          theme.classList.add('slds-theme_error');
        }

        document.getElementById('toastMessage').innerHTML = message;

        toast.classList.remove('slds-hide');

        setTimeout(function () {
          toast.classList.add('slds-hide');
        }, 3000);
      }
    },

    closeToast: function(component) {
        document.getElementById('toast').classList.add('slds-hide');
    }
  
})