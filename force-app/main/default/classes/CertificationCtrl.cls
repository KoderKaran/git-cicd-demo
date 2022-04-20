public without sharing class CertificationCtrl {

	@AuraEnabled
 	public static List<Certificate> getCertification(String userId) {

        List<Certificate> certList = new List<Certificate>();
        List<string> rejectList = new List<string>();
        Map <String, C4_Training_Certification__c> usersCertMap = new Map<String, C4_Training_Certification__c>(); 
        
	 	User user = [SELECT PortalContact__c
                    FROM User
                    WHERE Id = :userId];        
        
	    List<C4_Training_Certification__c> certificates = [SELECT Type__c, Training_Date__c
                                                           FROM C4_Training_Certification__c
                                                           WHERE Contact__r.Id =:user.PortalContact__c
                                                               AND Grade__c != 'F'
                                                               AND Grade__c != 'Fail'
                                                               AND Training_Date__c != null                                                           	  
                                                           ORDER BY CreatedDate DESC];
        
        for (C4_Training_Certification__c c : certificates) {
            usersCertMap.put(c.Type__c, c);
        }     

        // Apply custom business logic to the list
        // 1.	If the user has neither 2012 or 2019, then ONLY show the greyed out version of the 2019
		// 2.	If the user has the 2012 cert, then show the greyed out version of the 2019, and the colored version of the 2012.
		// 3.	If the user has the 2019 cert, then don’t show the 2012 version, and only show the colored version of the 2019.  (even if they have the 2012 version)
        if ((usersCertMap.get('Centralized Lighting') == null && usersCertMap.get('Centralized Lighting 2019') == null) || usersCertMap.get('Centralized Lighting 2019') != null)
        {
            rejectList.Add('Centralized Lighting');
        }

        
		// Get the full list of certifications
        Certificate_Default_Badge__mdt[] badges = [SELECT Certificate_Type__c, Certificate_Default_Badge_URL__c, Certificate_Color_Badge_URL__c, orderby__c 
                                                   FROM Certificate_Default_Badge__mdt 
                                                   WHERE Certificate_Type__c NOT IN :rejectList
                                                   ORDER BY orderby__c];
        
        // Populate certList
        for (Certificate_Default_Badge__mdt badge : badges) {
            
            C4_Training_Certification__c userCert = usersCertMap.get(badge.Certificate_Type__c);
            
            Certificate cert = new Certificate();
            
            cert.CertTitle = badge.Certificate_Type__c == 'Centralized Lighting' ? 'Centralized Lighting 2012' : badge.Certificate_Type__c; // Assign CertTitle plus rename centralized lighting to correct an old naming convention
            
            if (userCert == null)
            {
                cert.CertURL = badge.Certificate_Default_Badge_URL__c;
                cert.CertSubTitle = 'Not yet completed'; 
            } 
            else 
            {
                cert.CertURL = badge.Certificate_Color_Badge_URL__c;
                DateTime trainingDate = userCert.Training_Date__c; // Cast to DateTime so that format() works
                cert.CertSubTitle = 'Completed: ' +  trainingDate.format('MMMMM') + ' ' +  trainingDate.Day() + ', ' + trainingDate.year();
            }          
            
            certList.add(cert);          
        }    
    
       	return certList;
  	}

  	public class Certificate {

        @AuraEnabled
        public string CertURL;

        @AuraEnabled
        public string CertTitle;

        @AuraEnabled
        public string CertSubTitle;
    }
}