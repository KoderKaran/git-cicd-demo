public with sharing class CustomProfileMenuController {

	/*@AuraEnabled
	public static String getUserPhoto(String userId) {
		//String communityId = Network.getNetworkId();
		//ConnectApi.Photo userPhoto = ConnectApi.UserProfiles.getPhoto(communityId, userId);
		//return userPhoto.largePhotoUrl;
		User user = [
			SELECT ContactId
			FROM User
			WHERE Id = :userId
			LIMIT 1
		];

		Contact contact = [
			SELECT Avatar_URL__c
            FROM Contact
            WHERE Id = :user.ContactId
            LIMIT 1
		];
		
		return contact.Avatar_URL__c;
	}*/

	@AuraEnabled 
    public static Contact fetchUser(){
      	User user = [SELECT Id,Name,ContactId FROM User 
      		WHERE Id =: userInfo.getUserId()];

  		Contact contact = new Contact(
  			Firstname = '',
  			Lastname = '',
  			Avatar_URL__c = ''
		);

      	if (user.ContactId != NULL) {
      		contact = [
				SELECT Firstname, Lastname, Avatar_URL__c
	            FROM Contact
	            WHERE Id = :user.ContactId
	            LIMIT 1
			];
			if (String.isBlank(contact.Avatar_URL__c)) {
				contact.Avatar_URL__c = '';
			}
      	}

		return contact;
    }
}