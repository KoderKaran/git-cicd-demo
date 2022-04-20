@isTest
private class AccountSettingCtrlTest {
	
	@isTest static void testGetContact() {
		UserRole r = new UserRole(name = 'TEST ROLE 1');
		Database.insert(r);

		Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User userWithRole = new User(
			alias = 'role1', 
			email='userwithrole@roletest11.com', 
			userroleid = r.id,
			emailencodingkey='UTF-8', 
			lastname='Testing111', 
			languagelocalekey='en_US', 
			localesidkey='en_US', 
			profileid = pf.Id, 
			timezonesidkey='America/Los_Angeles', 
			username='userwithrole11@testorg.com'

		);

		system.debug('userWithRole : ' + userWithRole);

		System.runAs(userWithRole) {

			Account account = new Account(
				Name = 'account',
				BillingStreet = '',
				BillingPostalCode = '',
				BillingCity = '',
				BillingCountry = '',
				BillingState = '',
				OwnerId = userWithRole.Id
			);
			insert account;
			
			Contact contact = new Contact(
				Firstname = 'Firstname',
				Lastname = 'Lastname',
				Avatar_URL__c = 'test',
				Email = '',
				MobilePhone = '',
				AccountId = account.Id,
				Description = '',
				OwnerId = userWithRole.Id
			);
			insert contact;

			Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
	        User user = new User(
	        	Alias = 'standt',
	        	Email='standarduser@testorg.com', 
	            EmailEncodingKey='UTF-8',
	            LastName='Testing',
	            LanguageLocaleKey='en_US', 
	            LocaleSidKey='en_US',
	            ProfileId = p.Id,
	            /*UserRoleId = userWithRole.UserRoleId,*/
	            TimeZoneSidKey='America/Los_Angeles',
	            UserName='standarduser@testorg.com',
	            ContactId = contact.Id
	        );
	        insert user;

	        system.debug('test user : ' + user);

			NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        System.debug('member : ' + membership);

	        system.runas(user){ 

				test.StartTest();
					User result = AccountSettingCtrl.getContact(user.Id);
				test.StopTest();
				System.assertEquals(user.Id, result.Id);
			}

		}
	}
	
}