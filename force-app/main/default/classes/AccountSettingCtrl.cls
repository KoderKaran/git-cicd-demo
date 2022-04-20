public with sharing class AccountSettingCtrl {

	@AuraEnabled
	public static User getContact(String userId) {
		return [
			SELECT UserName, Contact.Email 
			FROM User 
			WHERE Id = :userId
		];
	}
}