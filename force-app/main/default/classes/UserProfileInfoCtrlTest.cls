@isTest
private class UserProfileInfoCtrlTest {

	@testSetup static void setup() {
		UserRole r = new UserRole(name = 'TEST ROLE 28');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role28', 
            email='userwithrole28@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing28', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole28@testorg.com'

        );

        system.debug('userWithRole : ' + userWithRole);

        System.runAs(userWithRole) {

			Account account = new Account(
				Name = 'account1',
				BillingStreet = '',
				BillingPostalCode = '',
				BillingCity = '',
				BillingCountry = '',
				BillingState = ''
			);
			insert account;
			
			Contact contact = new Contact(
				Firstname = 'Firstname1',
				Lastname = 'Lastname1',
				Email = '',
				MobilePhone = '',
				AccountId = account.Id,
				Description = ''
			);
			insert contact;

			Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
	        User user = new User(
	        	EmailEncodingKey = 'ISO-8859-1',
	            LanguageLocaleKey = 'en_US',
	            TimeZoneSidKey = 'America/New_York',
	            LocaleSidKey = 'en_US',
	            FirstName = 'first',
	            LastName = 'last',
	            Username = 'test@appirio.com', 
	            CommunityNickname = 'testUser123',
	            Alias = 't1',
	            Email = 'no@email.com',
	            IsActive = true,
	            ProfileId = p.Id,
	            ContactId = contact.Id
	        );
	        insert user;
            
            User user2 = new User(
	        	EmailEncodingKey = 'ISO-8859-1',
	            LanguageLocaleKey = 'en_US',
	            TimeZoneSidKey = 'America/New_York',
	            LocaleSidKey = 'en_US',
	            FirstName = 'first2',
	            LastName = 'last2',
	            Username = 'test2@appirio.com', 
	            CommunityNickname = 'testUser1232',
	            Alias = 't12',
	            Email = 'no@email.com',
	            IsActive = true,
	            ProfileId = pf.Id,
	            Associated_Contact__c = contact.Id
	        );
	        insert user2;

            User user3 = new User(
	        	EmailEncodingKey = 'ISO-8859-1',
	            LanguageLocaleKey = 'en_US',
	            TimeZoneSidKey = 'America/New_York',
	            LocaleSidKey = 'en_US',
	            FirstName = 'first3',
	            LastName = 'last3',
	            Username = 'test3@appirio.com', 
	            CommunityNickname = 'testUser1233',
	            Alias = 't12',
	            Email = 'no@email.com',
	            IsActive = true,
	            ProfileId = pf.Id
	        );
	        insert user3;
        }
	}

	@isTest 
	static void getUserProfileInfoTest() {

		User user = [
			SELECT Id, Name, Username 
			FROM User 
			WHERE Username = 'test@appirio.com'
			LIMIT 1
		];

        system.runas(user){ 

        	NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        Test.startTest();
	        	UserProfileInfoCtrl.TechnicianUserInfo  contactTest = UserProfileInfoCtrl.getUserProfileInfo(user.Id);
	        Test.stopTest();
	        System.assertEquals(contactTest.Name, 'Firstname1 Lastname1');

	    }
	}

        @isTest     
        static void getUserProfileInfoTest_ForInternalEmployeesWithNoAssociatedContact() {

		User user = [
			SELECT Id, Name, Username 
			FROM User 
			WHERE Username = 'test3@appirio.com'
			LIMIT 1
		];

	        Test.startTest();
	        	UserProfileInfoCtrl.TechnicianUserInfo  contactTest = UserProfileInfoCtrl.getUserProfileInfo(user.Id);
	        Test.stopTest();
	        System.assertEquals(contactTest.Name, 'first3 last3');
	}
    
    
    @isTest 
    static void getUserProfileInfoTest_ForInternalEmployees() {

		User user = [
			SELECT Id, Name, Username 
			FROM User 
			WHERE Username = 'test2@appirio.com'
			LIMIT 1
		];



	        Test.startTest();
	        	UserProfileInfoCtrl.TechnicianUserInfo  contactTest = UserProfileInfoCtrl.getUserProfileInfo(user.Id);
	        Test.stopTest();
	        System.assertEquals(contactTest.Name, 'Firstname1 Lastname1');

	}

	@isTest 
	static void updateUserProfileInfoTest() {
		Account account = new Account(
			Name = 'account2',
			BillingStreet = '',
			BillingPostalCode = '',
			BillingCity = '',
			BillingCountry = '',
			BillingState = ''
		);
		insert account;
		
		Contact contact = new Contact(
			Firstname = 'Firstname2',
			Lastname = 'Lastname2',
			Email = '',
			MobilePhone = '',
			AccountId = account.Id,
			Description = ''
		);
		insert contact;

		contact.Firstname = 'Test';
		account.BillingStreet = 'BillingStreet';
		Test.startTest();
        	Boolean result = UserProfileInfoCtrl.updateUserProfileInfo(contact, account);
        	List<String> options = UserProfileInfoCtrl.getOptions(Account, 'State__c');
        Test.stopTest();
        System.assertEquals(result, true);
		System.assertNotEquals(options.size(), null);
	}
	
}