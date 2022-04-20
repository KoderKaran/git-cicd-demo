public class SandboxInit {
    
    public static void updateSystemAdmins()
    {
        List<Id> userList = new List<Id>();
        userList.add('00538000005xU6X'); // CJ Dabb
        userList.add('00538000005afF4'); // Jeremy Clegg
        userList.add('00550000001DDer'); // Eric Quinney
        userList.add('00538000005a9hi'); // Christian Weaver       
        
        List<user> users = [select Id, profileId from user where Id in :userList];
                
        for (user u : users)
        {
            u.profileId = '00e50000000nR4C'; // System administrator Id
        }
        
        update users;    
    }
}