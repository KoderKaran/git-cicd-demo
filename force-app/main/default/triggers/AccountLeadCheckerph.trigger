trigger AccountLeadCheckerph on Account (After Insert, After Update) 
{
    Set<String> acctphones = new Set<String>();
    Set<String> acctemail = new Set<String>();
    List<Account> accounts = new List<Account>();
    List<List<Lead>> ldlist = new List<List<Lead>>();
    Boolean foundMatch = false;
    
    for (Account a : Trigger.new)
    {   
        System.debug(LoggingLevel.INFO, a.RecordTypeId);
        /*Check and make sure that Account is Person Account*/
        if(a.RecordTypeId == '012500000005JxsAAE' || a.RecordTypeId == '012500000005e0fAAA')
        {
            If(a.PersonEmail != Null)
            {
                acctemail.add(a.PersonEmail);
                accounts.add(a);
            }
            if (a.Phone != null)
            {
                acctphones.add(a.Phone);
                accounts.add(a);
            }
        }
    }
    System.debug(acctemail);
    List<Lead> leadList = [SELECT ID,Email,Phone, IsConverted, Status, Company  FROM Lead WHERE IsConverted != True AND Email = :acctemail AND Status != 'Installed' LIMIT 1 ];
    System.debug(leadlist);
    if(leadList.size() > 0)
    {
        If(foundMatch !=True)
        {
            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            
            for(Account account : accounts)
            {
                for (Lead lead : leadList)
                {    
                    /* Don't convert anything that is already converted */
                    if((lead.Status != 'Converted' || lead.Status !='Installed') && lead.IsConverted != True && (lead.Company == null || lead.Company == ''))
                    {
                        Database.LeadConvert lc = new Database.LeadConvert();
                        
                        lc.setLeadId(lead.Id);
                        lc.setOverwriteLeadSource(false);
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        lc.setAccountId(account.Id);
                        lc.setOwnerId(account.Ownerid);
                        lc.setDoNotCreateOpportunity(true);
                        leadConverts.add(lc);
                        /* Convert lead */
                        //Database.LeadConvertResult lcr = Database.convertLead(lc);
                    }
                }
            }
        }
    }
}