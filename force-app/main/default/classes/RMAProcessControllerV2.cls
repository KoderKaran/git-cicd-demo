public without sharing class RMAProcessControllerV2 {
    
    public static string exceptionDetails = '';
    
    @AuraEnabled 
    public static RMAInformation createRMA(string caseId)
    { 
        User u = [Select name from user where id = :UserInfo.getUserId()];
        EmailInfo emailInfo = RMAProcessControllerV2.GetEmailDetails(caseId);        
        RMAInformation rmaInfo = new RMAInformation(); 
        
        // To Address
        if(!String.isBlank(emailInfo.EmailRule.To_Email__c) && !String.isBlank(emailInfo.contactEmail)) {
			rmaInfo.ToEmail = emailInfo.EmailRule.To_Email__c + ';' + emailInfo.contactEmail;       
        }
        else if (!String.isBlank(emailInfo.EmailRule.To_Email__c)){
            rmaInfo.ToEmail = emailInfo.EmailRule.To_Email__c; 
        }
        else if (!String.isBlank(emailInfo.contactEmail)){
            rmaInfo.ToEmail = emailInfo.contactEmail; 
        }
        
        // CC Address        
        if(!String.isBlank(emailInfo.EmailRule.CC_Email__c) && !String.isBlank(emailInfo.rmaCCemail)) {
			rmaInfo.CcEmail = emailInfo.EmailRule.CC_Email__c + ';' + emailInfo.rmaCCemail;       
        }
        else if (!String.isBlank(emailInfo.EmailRule.CC_Email__c)){
            rmaInfo.CcEmail = emailInfo.EmailRule.CC_Email__c; 
        }
        else if (!String.isBlank(emailInfo.rmaCCemail)){
            rmaInfo.CcEmail = emailInfo.rmaCCemail; 
        }
        
        // BCC Address
        if (!String.isBlank(emailInfo.EmailRule.BCC_Email__c)){
            rmaInfo.BccEmail = emailInfo.EmailRule.BCC_Email__c; 
        }

        rmaInfo.SubjectEmail = emailInfo.EmailContent.Email_Subject__c + ' ' + emailInfo.caseNumber;
        rmaInfo.ExceptionDetails = exceptionDetails;
        
        if (emailInfo.EmailContent.Content__c != null)
        {
            rmaInfo.BodyEmail = emailInfo.EmailContent.Content__c.replace('{{{Sender.Name}}}', u.name).replace('{{{Recipient.Name}}}', emailInfo.contactName).replace('{{{CaseNumber}}}', emailInfo.caseNumber);    
        }
        
        return rmaInfo;
    }
    
    
    // sendMailMethod is used by the RMA Lightning component. RMA sent via triggers uses SendSalesRMAFromApex 
    @AuraEnabled 
    public static string sendMailMethod(string caseId, string toEmail, string ccEmail, string bccEmail, string subjectEmail)
    {        
        string returnValue = '';        
        User u = [Select name from user where id = :UserInfo.getUserId()];       
        
        // Step 1: Create a new Email
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setWhatId(caseId);
        mail.setSaveAsActivity(true);
        
        // Step 2: Set list of people who should get the email
        if (toEmail != ''){
            mail.setToAddresses(toEmail.split(';'));
        }
        if (ccEmail != ''){
            mail.setCcAddresses(ccEmail.split(';'));
        }
        if (bccEmail != ''){
            mail.setBccAddresses(bccEmail.split(';'));
        }
        
        // Step 3: Set who the email is sent from
        //mail.setReplyTo('noreply@salesforce.com'); // This works without setting it
        //mail.setSenderDisplayName('salesforce User'); 
        
        // Step 4. Set email contents - you can use variables!
        mail.setSubject(subjectEmail);
        
        // It might be faster to select the template again rather than transfer the data through the javascript component.
        EmailInfo emailInfo = RMAProcessControllerV2.GetEmailDetails(caseId);
        if (emailInfo.EmailContent.Content__c != null)
        {
            emailInfo.EmailContent.Content__c = emailInfo.EmailContent.Content__c.replace('<p','<div').replace('</p','</div'); // this is a workaround becaue RichTextFields save line breaks as '<p><br></p>' which result in double spacing
            mail.setHtmlBody(emailInfo.EmailContent.Content__c.replace('{{{Sender.Name}}}', u.name).replace('{{{Recipient.Name}}}', emailInfo.contactName).replace('{{{CaseNumber}}}', emailInfo.caseNumber));
        }
        
        // Add to attachment file list
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        Messaging.Emailfileattachment att = new Messaging.Emailfileattachment();
        att.setFileName(emailInfo.caseNumber + '.pdf');
        PageReference rmaForm = new PageReference('/apex/RMAFormV2');
        rmaForm.getParameters().put('caseId',caseId);
        rmaForm.getParameters().put('errorStyle','1'); // will tell the visualforce page to return an exception if there is an error. We don't want the pdf to be emailed if it fails. 
        
        if(!Test.isRunningTest())
        {
            Blob myBlob = rmaForm.getContentAsPDF();  // this throws an exception if there is an error in the PDF because errorStyle = 1. You can't recatch errors in Apex. Let this role up to the client   
            att.setBody(myBlob);
            fileAttachments.add(att);
            mail.setFileAttachments(fileAttachments);
        }
        
        // Step 5. Add your email to the master list
        mails.add(mail);
        
        System.debug('MyCaseId' + caseId);
        System.debug(mail); 
        
        try
        {
            // Step 6: Send all emails in the master list
            Messaging.sendEmail(mails);    
            
            // Update RMA_sent__c on the case to show that the RMA has been sent
            Case c = [SELECT Id, RMA_sent__c FROM Case WHERE id = :caseId];  
            c.RMA_sent__c = true;
            update c;           
            
            returnValue = 'Success';
        }
        catch(Exception e)
        {
            returnValue = 'Error Message: ' + e.getMessage();
        }
        
        return returnValue;
    }
    
    
    // eMailRMAFromApex gets called from CaseTrigger.apxt
    public void eMailRMAFromApex(List<Case> CaseList)
    { 
        for (Case c : CaseList)
        {           
            if (c.RMA_SendviaTrigger__c && !c.RMA_sent__c)
            {
                try
                {
                    SendRMAEmail(c.Id);
                }
                catch(Exception ex)
                {                    
                    new ApexDebugLog().createLog(new ApexDebugLog.Error('RMAProcessControllerV2', 'eMailRMAFromApex', c.Id, ex));
                }               
            }          
        }
    }
    
    public void eMailRMA_DoNotSendEmail(List<Case> CaseList)
    { 
        for (Case c : CaseList)
        {           
            if (c.RMA_SendviaTrigger__c && !c.RMA_sent__c)
            {
	            c.RMA_SendviaTriggerResult__c = 'Email NOT Sent: Automation has been disabled in metadata table';           
            }
        }
    }
    
    
    @future(callout=true)
    public static void SendRMAEmail(string caseId)
    {        
        try
        {                 
            User u = [Select name from user where id = :UserInfo.getUserId()]; 
            //string fromUser = if snap user then perhaps use this 'Control4 + SnapAV'
            EmailInfo emailInfo = RMAProcessControllerV2.GetEmailDetails(caseId);     
            
            // Step 1: Create a new Email
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setWhatId(caseId);
            mail.setSaveAsActivity(true);
            
            // To Address
            if(!String.isBlank(emailInfo.EmailRule.To_Email__c) && !String.isBlank(emailInfo.contactEmail)) {
                mail.setToAddresses((emailInfo.EmailRule.To_Email__c + ';' + emailInfo.contactEmail).split(';'));       
            }
            else if (!String.isBlank(emailInfo.EmailRule.To_Email__c)){
                mail.setToAddresses(emailInfo.EmailRule.To_Email__c.split(';')); 
            }
            else if (!String.isBlank(emailInfo.contactEmail)){
                mail.setToAddresses(emailInfo.contactEmail.split(';')); 
            }
            
            // CC Address        
            if(!String.isBlank(emailInfo.EmailRule.CC_Email__c) && !String.isBlank(emailInfo.rmaCCemail)) {
                mail.setCcAddresses((emailInfo.EmailRule.CC_Email__c + ';' + emailInfo.rmaCCemail).split(';'));       
            }
            else if (!String.isBlank(emailInfo.EmailRule.CC_Email__c)){
                mail.setCcAddresses(emailInfo.EmailRule.CC_Email__c.split(';')); 
            }
            else if (!String.isBlank(emailInfo.rmaCCemail)){
                mail.setCcAddresses(emailInfo.rmaCCemail.split(';'));
            }
            
            // BCC Address
            if (!String.isBlank(emailInfo.EmailRule.BCC_Email__c)){
                mail.setBccAddresses((emailInfo.EmailRule.BCC_Email__c).split(';'));
            }           
            
            	// Set who the email is sent from
                // mail.setReplyTo('noreply@salesforce.com');    // Not Needed???
                // mail.setSenderDisplayName('salesforce User'); // Not Needed???            
            mail.setSubject(emailInfo.EmailContent.Email_Subject__c + ' ' + emailInfo.caseNumber);            
            if (emailInfo.EmailContent.Content__c != null){
                emailInfo.EmailContent.Content__c = emailInfo.EmailContent.Content__c.replace('<p','<div').replace('</p','</div'); // this is a workaround becaue RichTextFields save line breaks as '<p><br></p>' which result in double spacing
                mail.setHtmlBody(emailInfo.EmailContent.Content__c.replace('{{{Sender.Name}}}', u.name).replace('{{{Recipient.Name}}}', emailInfo.contactName).replace('{{{CaseNumber}}}', emailInfo.caseNumber));
            }
            
            // Add to attachment file list
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment att = new Messaging.Emailfileattachment();
            att.setFileName(emailInfo.caseNumber + '.pdf');
            PageReference rmaForm = new PageReference('/apex/RMAFormV2');
            rmaForm.getParameters().put('caseId',caseId);
            rmaForm.getParameters().put('errorStyle','1'); // will tell the visualforce page to return an exception if there is an error. We don't want the pdf to be emailed if it fails. 
            
            if(!Test.isRunningTest())
            {
                Blob myBlob = rmaForm.getContentAsPDF();  // this throws an exception if there is an error in the PDF because errorStyle = 1. You can't recatch errors in Apex. Let this role up to the client   
                att.setBody(myBlob);
                fileAttachments.add(att);
                mail.setFileAttachments(fileAttachments);
            }

            // Send the email
            mails.add(mail);
            Messaging.sendEmail(mails);    
            
            // Update RMA_sent__c on the case to show that the RMA has been sent
            Case c = [SELECT Id, RMA_sent__c, RMA_SendviaTriggerResult__c FROM Case WHERE id = :caseId];  
            c.RMA_sent__c = true;
            c.RMA_SendviaTriggerResult__c = 'Success';            
            update c;           
        }
        catch(Exception ex)
        {
            // Update case with the error
            Case c = [SELECT Id, RMA_sent__c, RMA_SendviaTriggerResult__c FROM Case WHERE id = :caseId];  
            c.RMA_SendviaTriggerResult__c = ex.getMessage().length() > 500 ? ex.getMessage().substring(0, 500) : ex.getMessage(); // Limit error to 500 characters long
            update c;  
            
            // Insert error into the Apex Debug Log
            new ApexDebugLog().createLog(new ApexDebugLog.Error('RMAProcessControllerV2', 'sendSalesRMAFromApex', caseId, ex));
        }
    }
    
    public static EmailInfo GetEmailDetails(Id caseId)
    {   
        EmailInfo emailInfo = new EmailInfo();
        boolean hasSalesRMA = false;
        string oneProductTypeCheck = '';
        string rmaLocation = '';
        
        try
        {       
            Case caseData = [SELECT Id, CaseNumber, Account.SAP_Instance__c,Account.Dealer_Type2__c, Account.Account_Region__c, Account.BillingCountry, Account.RMA_CC_Email__c, Contact.Name, Contact.Email, CaseProducts__c, (SELECT Id, Scrap__c,Item__c,Item__r.RMA_Location__c,RMA__c, RMA_Type__c FROM CaseProduct__r Where Item__c != null and RMA__c = 'Yes') FROM Case WHERE Id = :caseId]; 
            
            if(caseData.CaseProduct__r != null)
            {    
                if (caseData.CaseProduct__r.size() > 0)
                {
                    for(integer i = 0; i < caseData.CaseProduct__r.size(); i++)
                    {
                        if (!string.isEmpty(caseData.CaseProduct__r[i].Item__r.RMA_Location__c))
                        {
                            hasSalesRMA = caseData.CaseProduct__r[i].RMA_Type__c == 'Sales' ? true : hasSalesRMA;
                            
                            if (oneProductTypeCheck == '')
                            {
                                oneProductTypeCheck = caseData.CaseProduct__r[i].Item__r.RMA_Location__c;
                                rmaLocation = caseData.CaseProduct__r[i].Item__r.RMA_Location__c;                                
                            }
                            else if ((oneProductTypeCheck == 'CLT' || caseData.CaseProduct__r[i].Item__r.RMA_Location__c == 'CLT') // this logic should be removed after the merger because of limitation in SAP
                                     && oneProductTypeCheck != caseData.CaseProduct__r[i].Item__r.RMA_Location__c) // this logic should be removed after the merger because of limitation in SAP
                            {
                                oneProductTypeCheck = 'TWO TYPES OF CASEPRODUCTS';
                            }
                        }
                    }                  
                }
                else 
                {
                    exceptionDetails = exceptionDetails + 'ERROR_MESSAGE - This case does not have an RMA';     
                }            
            }            
            
            if (oneProductTypeCheck != 'TWO TYPES OF CASEPRODUCTS')
            {
                emailInfo.contactName = caseData.Contact.Name;
                emailInfo.contactEmail = caseData.Contact.Email; 
                emailInfo.caseNumber = caseData.CaseNumber;        
                emailInfo.rmaCCemail = caseData.Account.RMA_CC_Email__c; 
                emailInfo.EmailRule = GetEmailRule(hasSalesRMA, rmaLocation, caseData);
                emailInfo.EmailContent = GetEmailContent(emailInfo.EmailRule);
            }
            else
            {
                emailInfo.contactEmail = '* ERROR: CANNOT COMBINE SNAP & C4 PRODUCTS *'; // this should prevent the user from being able to send RMA's with multiple product types.
            }
        }
        catch (Exception e)
        {
            exceptionDetails = exceptionDetails + 'ERROR_MESSAGE: ' +  e.getMessage() + e.getStackTraceString();
        }   
        
        return emailInfo;
    }    
    
    private static RMA_Communication_Rules__c GetEmailRule(boolean hasSalesRMA, string rmaLocation, Case caseData)
    {   
        RMA_Communication_Rules__c result;   
        
        try
        {       
            result = [select Id, To_Email__c, CC_Email__c, BCC_Email__c, RMA_Communication_Content__c 
                      from RMA_Communication_Rules__c 
                      where Recordtype.name = 'Email'
                      and isSalesRMA__c = :hasSalesRMA
                      and DealerType__c = :caseData.Account.Dealer_Type2__c
                      and RMA_Location__c INCLUDES (:rmaLocation)
                      and SAP_Instance__c INCLUDES (:caseData.Account.SAP_Instance__c)
                      and Billing_Country__c INCLUDES (:caseData.Account.BillingCountry)];     
        }
        catch (Exception e) // this does not catch if result == null
        {
            exceptionDetails = exceptionDetails + 'ERROR_MESSAGE: ' +  e.getMessage() + e.getStackTraceString() +
                ' **VALUES**' + 
                ' hasSalesRMA: ' + hasSalesRMA +
                ' RMA_Location__c: ' + rmaLocation +                
                ' DealerType__c: ' + caseData.Account.Dealer_Type2__c +
                ' SAP_Instance__c: ' + caseData.Account.SAP_Instance__c + 
                ' Billing_Country__c: ' + caseData.Account.BillingCountry;   
        }
        
        return result;     
    }
    
    private static RMA_Communication_Content__c GetEmailContent(RMA_Communication_Rules__c rule)
    {   
        RMA_Communication_Content__c result;
        
        try
        {       
            result = [SELECT Id, Email_Subject__c, Content__c FROM RMA_Communication_Content__c where Id = :rule.RMA_Communication_Content__c];    
        }
        catch (Exception e)
        {
            exceptionDetails = exceptionDetails + ' ERROR_MESSAGE ' +  e.getMessage() + e.getStackTraceString() + 'VALUE: RMA_Communication_Rules__c: ' + rule;   
        }
        
        return result;     
    }
    
    public class RMAInformation 
    {        
        @AuraEnabled
        public string ToEmail;        
        @AuraEnabled
        public string CcEmail;        
        @AuraEnabled
        public string BccEmail;        
        @AuraEnabled
        public string EmailTemplateName;        
        @AuraEnabled
        public string SubjectEmail;        
        @AuraEnabled
        public string BodyEmail;        
        @AuraEnabled
        public string ExceptionDetails; // This might not be actually used (I DON'T BELIEVE THE PDF CAN SEE THIS), but its here if you choose to handle errors this way.
    }
    
    public class EmailInfo 
    {              
        public string templateId;       
        public list<string> toList = new list<string>();        
        public list<string> ccList = new list<string>();        
        public list<string> bccList = new list<string>();        
        public string contactName;  
        public string contactEmail;  
        public string caseNumber;
        public string rmaCCemail;        
        public RMA_Communication_Rules__c EmailRule;        
        public RMA_Communication_Content__c EmailContent;       
    }      
}