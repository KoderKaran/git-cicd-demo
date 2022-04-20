({
	doInit : function(component, event, helper) {
		helper.getOptionLang(component, 'LanguageLocaleKey');
		helper.getOptionLocale(component, 'LocaleSidKey');
		helper.getOptionTimeZone(component, 'TimeZoneSidKey');
		helper.doInit(component);
		
	},

	saveUserPreferences:function(component, event, helper) {
		console.log("nene");
		helper.saveUserPreferences(component);
		// if (component.get("v.validate") == true) {
		// 	helper.saveUserProfileInfo(component);
		// }
	}
})