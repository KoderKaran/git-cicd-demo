public class AvatarManager {
    
    // This method is called from User trigger
    public void AvatarManagerInsert(List<User> triggerNew)
    {  
        for(User u: triggerNew)
        {           
             if(String.isNotBlank(u.Avatar_URL__c))
             {                 
				 FutureApexCallout.UploadProfilePhoto(u.Avatar_URL__c, u.id, u.ProfileId);
    		 }
        }
    } 

    public void AvatarManagerUpdate(List<User> triggerNew, Map<Id, User> OldMap )
    {            
        for(User u: triggerNew)
        {
            User oldUser = OldMap.get(u.Id);
            
             if(String.isNotBlank(u.Avatar_URL__c) && u.Avatar_URL__c  != oldUser.Avatar_URL__C)
             {                 
				FutureApexCallout.UploadProfilePhoto(u.Avatar_URL__c, u.id, u.ProfileId);
    		 }
        }
    }
}