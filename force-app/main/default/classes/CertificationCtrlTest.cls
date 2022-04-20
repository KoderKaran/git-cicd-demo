@isTest
private class CertificationCtrlTest {
	
	@isTest static void test_method_one() {

        UserRole r = new UserRole(name = 'TEST ROLE 4');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role4', 
            email='userwithrole4@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing4', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole4@testorg.com'

        );

        system.debug('userWithRole : ' + userWithRole);

        System.runAs(userWithRole) {

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

    		Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
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
            insert user;

            List<C4_Training_Certification__c> certificationList = new List<C4_Training_Certification__c>();

            C4_Training_Certification__c certificationOne = new C4_Training_Certification__c (
            	Grade__c = 'A',
            	Type__c = 'Automation Programmer',
            	//TBD__c = 'https://www.pixelslogodesign.com/blog/wp-content/uploads/2018/01/csm_Meng_Meng_Baby_1_88cad0f74f-320x240.jpg',
            	CreatedDate = System.today(),
            	Contact__c = contact.Id, 
            	Training_Date__c = System.today()
            );
            certificationList.add(certificationOne);

            C4_Training_Certification__c certificationTwo = new C4_Training_Certification__c (
            	Grade__c = 'B',
            	Type__c = 'Automation Programmer',
            	//TBD__c = '',
            	CreatedDate = System.today(),
            	Contact__c = contact.Id,
            	Training_Date__c = System.today()
            );
            certificationList.add(certificationTwo);

            insert certificationList;

            List<CertificationCtrl.Certificate> certificates = new List<CertificationCtrl.Certificate>();

            Test.startTest();
            	certificates = CertificationCtrl.getCertification(user.Id);
            Test.stopTest();
            System.assertNotEquals(certificates.size(), 0);

        }

	}
	
}