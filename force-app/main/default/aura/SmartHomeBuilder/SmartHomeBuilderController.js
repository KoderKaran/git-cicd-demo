({
	/**	
	 * @description Initial method
	 */ 
	doInit: function(component, event, helper) {
		helper.doInit(component, event);
	},

	enableAllTv: function(component, event, helper) {
		helper.enableAllTv(component, event);
    },

    enableAllSmart: function(component, event, helper) {
		helper.enableAllSmart(component, event);
    },

    enableAllMusic: function(component, event, helper) {
		helper.enableAllMusic(component, event);
    },

    enableAllSecurity: function(component, event, helper) {
		helper.enableAllSecurity(component, event);
    },

    disableKeypad: function(component, event, helper) {
		helper.disableKeypad(component, event);
    },    

    enableBoxTvNumber: function(component, event, helper) {
		helper.enableBoxTvNumber(component, event);
    },  

    enableTextBoxSmart: function(component, event, helper) {
		helper.enableTextBoxSmart(component, event);
    },  

    enableTextBoxSmartBr: function(component, event, helper) {
		helper.enableTextBoxSmartBr(component, event);
    },  

    enableTextBoxMusic: function(component, event, helper) {
		helper.enableTextBoxMusic(component, event);
	    helper.calculateNonC4ForMusic(component,event);       
    },  

    enableTextBoxMusicBr: function(component, event, helper) {
		helper.enableTextBoxMusicBr(component, event);
	    helper.calculateNonC4ForMusic(component,event);       
    },  
  
    createSmartRecords: function(component, event, helper) {
		helper.createSmartRecords(component, event);
	},

    handleSmartButtonClick: function(component, event, helper) {
		helper.handleSmartButtonClick(component, event);
	},

    handleMusicButtonClick: function(component, event, helper) {
		helper.handleMusicButtonClick(component, event);
		helper.calculateNonC4ForMusic(component,event);       
	},

    handleSecurityButtonClick: function(component, event, helper) {
		helper.handleSecurityButtonClick(component, event);
	},	

	applyClassProjectType: function(component, event, helper) {
		helper.applyClassProjectType(component, event);
	},	

	applyClassBudget: function(component, event, helper) {
		helper.applyClassBudget(component, event);
	},

	handleNoOfTvChange: function(component, event, helper) {
		var noTv  = event.getSource().get('v.value');
		var buttonKey = component.find("buttonKeypad");
		var buttonRem = component.find("buttonTvRemote");

		helper.validateInputNumbersTv2(component, event, helper);

		if (noTv>0 && noTv<100) {
			//if ($A.util.hasClass(buttonKey, 'slds-button_success') || $A.util.hasClass(buttonRem, 'slds-button_success') ) {
				var v = noTv * 1000;
				component.set("v.tvNonPotentialValue", v);
				helper.setArrayItem(component, 'listTv', component.get('v.tvNonPotentialValue'), 6);
				helper.setArrayItem(component, 'listTv', noTv, 0); 	
				helper.setSumNonPotentialValue(component, event);
		}
	},

	handleTextBoxBlur: function(component, event, helper) {
        var boxTvVal = event.getSource().get('v.value');
        var buttonKeypad = component.find("buttonKeypad");


 		helper.validateInputNumbersTv(component, event, helper);

        if (boxTvVal>0 && boxTvVal<100) {
			var v = boxTvVal * 200;
			if ($A.util.hasClass(buttonKeypad, 'slds-button_success')) {
	        	component.set("v.tvPotentialValue", v + 250);
			} else {
		        component.set("v.tvPotentialValue", v);
			}
			helper.setArrayItem(component, 'listTv', event.getSource().get('v.value'), 2);
			helper.setArrayItem(component, 'listTv', component.get('v.tvPotentialValue'), 3);
			helper.setSumPotentialValue(component, event);
		}
	},

	handleTextSmartBoxBlur: function(component, event, helper) {
		var smartVal = event.getSource().get("v.value");
		var buttonGarage  = component.find("buttonGarage");
		var buttonMainHome = component.find("buttonMainHomeAreasSmart");
		var buttonWholeHome = component.find("buttonEveryRoomSmart");
		var buttonBedroomsSmart = component.find("buttonBedroomsSmart");

		var wholeHomeValue = 0;
		var garValue = 0;
        var mainHomeValue = 0;
        var addWholeHome = 0;
        var bedroomsSmartVal = 0;
        var wholeHomeVal = 0;


	    if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
            garValue = 500;
        }
        if ($A.util.hasClass(buttonMainHome, 'slds-button_success')) {
            mainHomeValue = 1500;
        }
        if ($A.util.hasClass(buttonWholeHome, 'slds-button_success')) {
            wholeHomeValue = (6 * 250) + 500; // Garage value
        }
        if ($A.util.hasClass(buttonBedroomsSmart, 'slds-button_success')) {
            bedroomsSmartVal = smartVal * 250; // Garage value
        }

       	helper.validateInputNumbersSmart(component, event, helper);

     	if (smartVal>=0 && smartVal<100) {
        	wholeHomeVal = smartVal * 250;
        	var addWholeHome = wholeHomeVal + garValue + mainHomeValue + wholeHomeValue;
			helper.setArrayItem(component, 'listSmart', event.getSource().get('v.value'), 5);
			component.set("v.smartPotentialValue", addWholeHome);
          	component.set("v.smartNonPotentialValue", 0);
          	helper.setSumPotentialValue(component, event);
          	helper.setSumNonPotentialValue(component, event); 
        }
	},

	handleTextMusicBoxBlur: function(component, event, helper) {
		var musicVal = event.getSource().get("v.value");
		var buttonOutdoorMusic  = component.find("buttonOutdoorMusic");
        var buttonMainHomeAreasMusic  = component.find("buttonMainHomeAreasMusic");
        var buttonWholeHome = component.find("buttonEveryRoomMusic");
        var outdoorValue = 0;
        var mainHomeV = 0;
        var wholeHomeValue = 0;
        var getNon4music = component.get("v.musicNonPotentialValue");

        if ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
          outdoorValue = 2000;
        }
        if ($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) {
          mainHomeV = 1500;
        }
        if ($A.util.hasClass(buttonWholeHome, 'slds-button_success')) {
           wholeHomeValue = (2 * 750) + 2000;
        }

 		helper.validateInputNumbersMusic(component, event, helper);

        if (musicVal>=0 && musicVal<100) {
        	var bedrVal = musicVal * 750;
        	var addWholeHome = bedrVal + outdoorValue + mainHomeV + wholeHomeValue;
			helper.setArrayItem(component, 'listMusic', event.getSource().get('v.value'), 5);
			component.set("v.musicPotentialValue", addWholeHome);
        	helper.calculateNonC4ForMusic(component,event);       
            helper.setSumPotentialValue(component, event);
            helper.setSumNonPotentialValue(component, event); 
		}
	},

	handleTextClimateBoxBlur: function(component, event, helper) {
	    var climateVal = event.getSource().get("v.value");
	    
 		helper.validateInputNumbersClimate(component, event, helper);

 		if (climateVal>0 && climateVal<100) {
			var v = climateVal * 350;
	        component.set("v.climatePotentialValue", v);
			helper.setArrayItem(component, 'listClimate', event.getSource().get('v.value'), 0);
			helper.setArrayItem(component, 'listClimate', component.get('v.climatePotentialValue'), 1);
			helper.setSumPotentialValue(component, event);
		}
	},

	handleTextOtherHomeBoxBlur: function(component, event, helper) {
		helper.setArrayItem(component, 'listOtherHome', event.getSource().get('v.value'), 0);
 		helper.validateTextOtherHome(component, event, helper);
	},

	handleSquareFootageBlur: function(component, event, helper) {
 		helper.validateInputNumberSquareFootage(component, event, helper);
	},

	handleBuildingNumberRoomsBlur: function(component, event, helper) {

		var roomsVal = event.getSource().get("v.value");
		var buttonGarage  = component.find("buttonGarage");
		var buttonMainHome = component.find("buttonMainHomeAreasSmart");
		var buttonWholeHome = component.find("buttonEveryRoomSmart");
		var buttonBedroomsSmart = component.find("buttonBedroomsSmart");

		var wholeHomeValue = 0;
		var garValue = 0;
        var mainHomeValue = 0;
        var addWholeHome = 0;
        var bedroomsSmartVal = 0;
        var wholeHomeVal = 0;

	    if ($A.util.hasClass(buttonGarage, 'slds-button_success')) {
            garValue = 500;
        }
        if ($A.util.hasClass(buttonMainHome, 'slds-button_success')) {
            mainHomeValue = 1500;
        }
        if ($A.util.hasClass(buttonWholeHome, 'slds-button_success')) {
            wholeHomeValue = (6 * 250) + 500;
        }
        if ($A.util.hasClass(buttonBedroomsSmart, 'slds-button_success')) {
            bedroomsSmartVal = roomsVal * 250; 
        }

     	if (roomsVal>=0 && roomsVal<100) {
     		if ($A.util.hasClass(buttonWholeHome, 'slds-button_success')) {
	        	wholeHomeVal = roomsVal * 250;
	        	var addWholeHome = wholeHomeVal + garValue + mainHomeValue + wholeHomeValue;
				helper.setArrayItem(component, 'listSmart', event.getSource().get('v.value'), 5);
				component.set("v.smartPotentialValue", addWholeHome);
	          	component.set("v.smartNonPotentialValue", 0);
	          	helper.setSumPotentialValue(component, event);
	          	helper.setSumNonPotentialValue(component, event); 
          	}
        }

		var buttonOutdoorMusic  = component.find("buttonOutdoorMusic");
        var buttonMainHomeAreasMusic  = component.find("buttonMainHomeAreasMusic");
        var buttonWholeHomeMusic = component.find("buttonEveryRoomMusic");
        var outdoorValue = 0;
        var mainHomeV = 0;
        var wholeHomeValue = 0;
        var totalRooms = 0;
        var getNon4music = component.get("v.musicNonPotentialValue");
        console.log('roomsVal +++ ' + roomsVal);


        if ($A.util.hasClass(buttonOutdoorMusic, 'slds-button_success')) {
          outdoorValue = 2000;
        }
        if ($A.util.hasClass(buttonMainHomeAreasMusic, 'slds-button_success')) {
          mainHomeV = 1500;
        }
        if ($A.util.hasClass(buttonWholeHomeMusic, 'slds-button_success')) {
           wholeHomeValue = (2 * 750) + 2000;
        }

        if (roomsVal>=0 && roomsVal<100) {
        	if ($A.util.hasClass(buttonWholeHomeMusic, 'slds-button_success')) {
	        	var bedrVal = roomsVal * 750;
	        	var addWholeHome = bedrVal + outdoorValue + mainHomeV + wholeHomeValue;
	        	totalRooms = parseInt(roomsVal,1) + 3;
				helper.setArrayItem(component, 'listMusic', event.getSource().get('v.value'), 5);
				component.set("v.musicPotentialValue", addWholeHome);
				component.set("v.musicNonPotentialValue", parseInt(totalRooms,10));
	        	helper.calculateNonC4ForMusic(component,event);       
	            helper.setSumPotentialValue(component, event);
	            helper.setSumNonPotentialValue(component, event); 
        	}
		}

  		helper.validateBuildingNumberRooms(component, event, helper);
	},
    
    enableClimate: function(component, event, helper) {
		helper.enableClimate(component, event);
	},
    
    enableOtherHome: function(component, event, helper) {
		helper.enableOtherHome(component, event);
	},

    goPage: function(component, event, helper) {
        helper.goToPage();
    },

	checkFieldValid: function (component, event, helper) {
		helper.checkFieldValid(component,event);
	},

	checkAttr: function(component, event, helper) {
		var elem = component.get('v.listSmart');
		console.log(elem.length);
		console.log('******** ' + elem);
	},

	limitCharacterTo: function(component, event, helper) {
		helper.limitCharacterTo(component, event, helper);
	},

})