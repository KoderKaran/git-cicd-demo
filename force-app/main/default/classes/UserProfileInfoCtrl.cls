public without sharing class UserProfileInfoCtrl {
    
    @AuraEnabled
    public static TechnicianUserInfo getUserProfileInfo(String userId) {
        User user = [
            SELECT Name, ContactId, Associated_Contact__c, Avatar_URL__c
            FROM User
            WHERE Id = :userId
            LIMIT 1
        ];
        
        Contact contact = new Contact(
            Firstname = '',
            Lastname = '',
            Email = '',
            MobilePhone = '',
            Description = ''
        );
        
        TechnicianUserInfo userInfo = new TechnicianUserInfo();
        
        if (user.ContactId != NULL) 
        {
            contact = [SELECT Name, Title, MailingCity, MailingState, MailingCountry, Account.Name 
                       FROM Contact
                       WHERE Id = :user.ContactId
                       LIMIT 1];
            
            populateUserInfo(userInfo, contact);           
        } 
        else if (user.Associated_Contact__c != NULL)
        {           
            contact = [SELECT Name, Title, MailingCity, MailingState, MailingCountry, Account.Name 
                       FROM Contact
                       WHERE Id = :user.Associated_Contact__c
                       LIMIT 1];
            
            populateUserInfo(userInfo, contact);
            userInfo.AccountName = 'Control4';
            
        }
        else
        {
            userInfo.Name = user.Name;
            userInfo.AccountName = '';
            userInfo.Title = ''; 
            userInfo.MailingState = ''; 
            userInfo.MailingCountry = '';            
        }
    
        system.debug('userInfo: ' + userInfo);
        return userInfo;
    }     
        
        @AuraEnabled
        public static User getUserImageURL(String userId) {
            User user = [SELECT Avatar_URL__c
                         FROM User
                         WHERE Id = :userId
                         LIMIT 1];
            
            return user;  
        }
        
        
        @AuraEnabled
        public static Boolean updateUserProfileInfo(Contact contact, Account account) {
            
            try {
                update contact;
                update account;
                return true;
            } catch (DmlException ex){
                system.debug('error ->' + ex.getMessage());
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
        
        private static void populateUserInfo(TechnicianUserInfo userInfo, Contact contact)
        {
            userInfo.Name = contact.Name; 
            userInfo.Title = contact.Title; 
            //userInfo.MailingCity = contact.MailingCity; 
            userInfo.MailingState = contact.MailingState; 
            
            // this would be best to do with the code for every country as a global meta data table. 
            
            switch on contact.MailingCountry
            {
                when 'US'{
                    userInfo.MailingCountry = 'United States'; 
                }
                when 'USA'{
                    userInfo.MailingCountry = 'United States'; 
                }
                when 'GB'{
                    userInfo.MailingCountry = 'Great Britain'; 
                }
                when 'CA'{
                    userInfo.MailingCountry = 'Canada'; 
                }
                when 'CN'{
                    userInfo.MailingCountry = 'China'; 
                }
                when 'AU'{
                    userInfo.MailingCountry = 'Australia'; 
                }
                when 'IN'{
                    userInfo.MailingCountry = 'India'; 
                }
                when 'NZ'{
                    userInfo.MailingCountry = 'New Zealand'; 
                }
                when 'DE'{
                    userInfo.MailingCountry = 'Germany'; 
                }
                when else { 
                    userInfo.MailingCountry = contact.MailingCountry;
                }
            }   
        }
        
        public class TechnicianUserInfo {
            
            @AuraEnabled
            public string Name;
            
            @AuraEnabled
            public string Title;
            
            @AuraEnabled
            public string AccountName;
            
            //@AuraEnabled
            //public string MailingCity;
            
            @AuraEnabled
            public string MailingState;
            
            @AuraEnabled
            public string MailingCountry;
        }
    }