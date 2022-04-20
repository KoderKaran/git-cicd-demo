@isTest
private class Technician_setCertificateImagesTest {
	
	@isTest static void test_Technician_setCertificateImages() {
		Map <String, Certificate_Default_Badge__mdt> typesMap = new Map<String, Certificate_Default_Badge__mdt>();
	    Certificate_Default_Badge__mdt[] certificateBadges = [SELECT Certificate_Type__c, Certificate_Default_Badge_URL__c, Certificate_Color_Badge_URL__c FROM Certificate_Default_Badge__mdt];

	    for (Certificate_Default_Badge__mdt certificateBadge : certificateBadges) {
	        typesMap.put(certificateBadge.Certificate_Type__c, certificateBadge);
	    }

		Account account = new Account(
			Name = 'account',
			BillingStreet = '',
			BillingPostalCode = '',
			BillingCity = '',
			BillingCountry = '',
			BillingState = ''
		);
		insert account;
		
		Contact contact = new Contact(
			Firstname = 'Firstname',
			Lastname = 'Lastname',
			Email = '',
			MobilePhone = '',
			AccountId = account.Id,
			Description = ''
		);
		insert contact;

		/*Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User']; 
        User user = new User(
        	Alias = 'standt',
        	Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='standarduser@testorg.com',
            ContactId = contact.Id
        );
        insert user;*/

	    C4_Training_Certification__c certificate = new C4_Training_Certification__c (
            Grade__c = 'A',
        	Type__c = 'Automation Programmer',
        	CreatedDate = System.today(),
        	Contact__c = contact.Id, 
        	Training_Date__c = System.today()
        );

        Test.startTest();
        insert certificate;
        Test.stopTest();

	}
	
}