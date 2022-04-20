public with sharing class PrivacyAndLanguageCtrl {
	@AuraEnabled
	public static User getUserSettings(String userId) {
		return [
			SELECT UserPreferencesShowEmailToExternalUsers, UserPreferencesShowManagerToExternalUsers,
				UserPreferencesShowMobilePhoneToExternalUsers, UserPreferencesShowTitleToExternalUsers, 
				UserPreferencesShowCityToExternalUsers, UserPreferencesShowCountryToExternalUsers, 
				UserPreferencesShowPostalCodeToExternalUsers, UserPreferencesShowStateToExternalUsers,
				UserPreferencesShowStreetAddressToExternalUsers,LanguageLocaleKey, LocaleSidKey, 
				TimeZoneSidKey, UserPreferencesShowProfilePicToGuestUsers
            FROM User
            WHERE Id = :userId
            LIMIT 1
		];
	}   

	@AuraEnabled
	public static Boolean saveUserSettings(User user) {
		try {
			update user;
			return true;

		}catch(DmlException ex) {
			system.debug(ex.getMessage());
			return false;
		}
	} 

	@AuraEnabled
    public static List<String> getOptions(sObject objObject, String field) {
        List<String> allOpts = new List<String>();

        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
         
        Map<String,Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List<Schema.PicklistEntry> values = fieldMap.get(field).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        system.debug(allOpts);
        return allOpts;
    }


}