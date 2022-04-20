({
	doInit:function(component) {
		 component.set("v.spinner", true);
	var action = component.get("c.getUserSettings");
	var userId = component.get("v.recordId");
	console.log(userId);
	action.setParams({"userId" : userId});
	action.setCallback(this, function(response) {           
	    var state = response.getState();
	   if (state === 'ERROR') {
		 
		 alert('error');
	    } else {

			var userSetting = response.getReturnValue();
			var options = ['Restricted', 'Public'];
			var city = userSetting.UserPreferencesShowCityToExternalUsers;
			var country = userSetting.UserPreferencesShowCountryToExternalUsers;
			var zip = userSetting.UserPreferencesShowPostalCodeToExternalUsers;
			var state = userSetting.UserPreferencesShowStateToExternalUsers;
			var street = userSetting.UserPreferencesShowStreetAddressToExternalUsers;
			var photo = userSetting.UserPreferencesShowProfilePicToGuestUsers;
			component.set("v.options", options);
			if(userSetting.UserPreferencesShowProfilePicToGuestUsers == false) {
				component.set("v.photo", 'Restricted');

			}else {
				component.set("v.photo", 'Public');       
			}	
			if(userSetting.UserPreferencesShowTitleToExternalUsers == false) {
				component.set("v.title", 'Restricted');

			}else {
				component.set("v.title", 'Public');       
			}	
			if(userSetting.UserPreferencesShowEmailToExternalUsers == false) {
				component.set("v.email", 'Restricted');

			}else {
				component.set("v.email", 'Public');       
			}
			if(userSetting.UserPreferencesShowManagerToExternalUsers == false) {
				component.set("v.manager", 'Restricted');

			}else {
				component.set("v.manager", 'Public');       
			}
			if(userSetting.UserPreferencesShowMobilePhoneToExternalUsers == false) {
				component.set("v.phone", 'Restricted');

			}else {
				component.set("v.phone", 'Public');       
			}
			if ((city == false) && (country == false) && (zip == false) && (state == false) 
				&& (street == false)) {
				component.set("v.address", 'Restricted');

			}else {
				component.set("v.address", 'Public');       
			}
			component.set("v.userSetting", userSetting);
			 component.set("v.spinner", false);
	    }
	});
       
	$A.enqueueAction(action); 
	},

	saveUserPreferences:function(component) {
	component.set("v.spinner", true);
	// var title = document.getElementById('Title').value;
	// var email = document.getElementById('Email').value;
	// var address = document.getElementById('Address').value;
	// var phone = document.getElementById('Phone').value;
	// var manager = document.getElementById('Manager').value;
	// var photo = document.getElementById('Photo').value;

	var userSetting = {};
	userSetting.Id = component.get("v.recordId");
	// if(photo == 'Restricted') {
	// 	userSetting.UserPreferencesShowProfilePicToGuestUsers = false;
	// }else {
	// 	userSetting.UserPreferencesShowProfilePicToGuestUsers = true;
	// }
	// if(title == 'Restricted') {
	// 	userSetting.UserPreferencesShowTitleToExternalUsers = false;
	// }else {
	// 	userSetting.UserPreferencesShowTitleToExternalUsers = true;
	// }
	// if(email == 'Restricted') {
	// 	userSetting.UserPreferencesShowEmailToExternalUsers = false;
	// }else {
	// 	userSetting.UserPreferencesShowEmailToExternalUsers = true;
	// }
	// if(manager == 'Restricted') {
	// 	userSetting.UserPreferencesShowManagerToExternalUsers = false;
	// }else {
	// 	userSetting.UserPreferencesShowManagerToExternalUsers = true;
	// }
	// if(phone == 'Restricted') {
	// 	userSetting.UserPreferencesShowMobilePhoneToExternalUsers = false;
	// }else {
	// 	userSetting.UserPreferencesShowMobilePhoneToExternalUsers = true;
	// }
	// if(address == 'Restricted') {
	// 	userSetting.UserPreferencesShowCityToExternalUsers = false;
	// 	userSetting.UserPreferencesShowCountryToExternalUsers = false;
	// 	userSetting.UserPreferencesShowPostalCodeToExternalUsers = false;
	// 	userSetting.UserPreferencesShowStateToExternalUsers = false;
	// 	userSetting.UserPreferencesShowStreetAddressToExternalUsers = false;
	// }else {
	// 	userSetting.UserPreferencesShowCityToExternalUsers = true;
	// 	userSetting.UserPreferencesShowCountryToExternalUsers = true;
	// 	userSetting.UserPreferencesShowPostalCodeToExternalUsers = true;
	// 	userSetting.UserPreferencesShowStateToExternalUsers = true;
	// 	userSetting.UserPreferencesShowStreetAddressToExternalUsers = true;
	// }
	userSetting.LanguageLocaleKey = document.getElementById('Language').value;
	userSetting.LocaleSidKey = document.getElementById('Locale').value;
	userSetting.TimeZoneSidKey = document.getElementById('TimeZone').value;
	console.log(userSetting);
	var action = component.get("c.saveUserSettings");
	action.setParams({"user" : userSetting});
	action.setCallback(this, function(response) {           
	    var state = response.getState();
	   if (response.getState() != "SUCCESS") {
	        return;
	    } else {
	        console.log(response.getReturnValue());
	        component.set("v.spinner", false);
	    }
	});
       
	$A.enqueueAction(action); 
	},

	getOptionLang:function(component, lang) {
        
        var action = component.get("c.getOptions");
        action.setParams({ "objObject" : component.get("v.userSetting"), 
                            "field" : lang});
        action.setCallback(this, function(response) {
            if (response.getState() != "SUCCESS") {
                return;
            }
            // console.log(response.getReturnValue());
            component.set("v.languageOption", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getOptionLocale:function(component, locale) {
        
        var action = component.get("c.getOptions");
        action.setParams({ "objObject" : component.get("v.userSetting"), 
                            "field" : locale});
        action.setCallback(this, function(response) {
            if (response.getState() != "SUCCESS") {
                return;
            }
            // console.log(response.getReturnValue());
            component.set("v.localeOption", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getOptionTimeZone:function(component, timeZone) {
        
        var action = component.get("c.getOptions");
        action.setParams({ "objObject" : component.get("v.userSetting"), 
                            "field" : timeZone});
        action.setCallback(this, function(response) {
            if (response.getState() != "SUCCESS") {
                return;
            }
            // console.log(response.getReturnValue());
            component.set("v.timeZoneOption", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})