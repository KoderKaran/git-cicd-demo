public class ContactRecursionCheck 
{
	private static boolean runOnce = true;
    
    public static boolean RunOnceCheck()
    {        
        if(runOnce)
        {
         runOnce = false;
         return true;  
        }
        else
        {
            return runOnce;
        }
	}
}