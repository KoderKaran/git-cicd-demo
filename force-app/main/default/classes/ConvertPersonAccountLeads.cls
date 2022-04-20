public class ConvertPersonAccountLeads {
    public void convertLeads(List<Lead> leadList, Account account) {
        
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        
        for (Lead lead : leadList)
        {    
            /* Don't convert anything that is already converted */
            if(lead.IsConverted != True && (lead.Status != 'Converted' || lead.Status !='Installed') && (lead.Company == null || lead.Company == ''))
            {
                Database.LeadConvert lc = new Database.LeadConvert();
                
                lc.setLeadId(lead.Id);
                lc.setOverwriteLeadSource(false);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                lc.setAccountId(account.Id);
                lc.setOwnerId(account.Ownerid);
                lc.setDoNotCreateOpportunity(true);
                
                /* Convert lead */
                if(!test.isrunningtest()){  Database.LeadConvertResult lcr = Database.convertLead(lc);}
            }
        }
    }
}