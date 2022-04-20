public class RMAProcessController {
    
//    @AuraEnabled 
//    public static Boolean hasRMA(string caseId)
//    { 
//        Boolean hasRMA = false;        
//        List<Case> records = [SELECT Id, (SELECT Id, Item__c FROM CaseProduct__r Where Item__c != null and RMA__c = 'Yes' ) FROM Case WHERE Id = :caseId];        
//        List<CaseProduct__c> caseProducts = records[0].CaseProduct__r;        
//        hasRMA = caseProducts.size() > 0 ? true : false;        
//        return hasRMA;      
//    }    
    
    @AuraEnabled 
    public static RMAInformation createRMA(string caseId)
    { 
        EmailInfo templateInfo = RMAProcessController.getEmailTemplateInfo(caseId);
        EmailTemplate et = [SELECT Id, Name, Subject, Markup, HTMLValue FROM EmailTemplate WHERE id = :templateInfo.templateId];
        User u = [Select name from user where id = :UserInfo.getUserId()];       
        
        RMAInformation info = new RMAInformation();
        for (string to : templateInfo.toList){
            info.ToEmail = info.ToEmail == null ? to : info.ToEmail + ';' + to;  
        }        
        
        for (string cc : templateInfo.ccList){
            info.CcEmail = info.CcEmail == null ? cc : info.CcEmail + ';' + cc;  
        } 
        
        for (string bcc : templateInfo.bccList){
            info.BccEmail = info.BccEmail == null ? bcc : info.BccEmail + ';' + bcc;  
        } 
        
        info.EmailTemplateName = et.Name;
        info.SubjectEmail = et.subject + ' ' + templateInfo.caseNumber; 
        info.BodyEmail = et.HTMLValue.replace('{{{Sender.Name}}}', u.name).replace('{{{Recipient.Name}}}', templateInfo.recipientName).replace('{{{CaseNumber}}}', templateInfo.caseNumber);
        
        return info;      
    }    
    
    
    @AuraEnabled 
    public static string sendMailMethod(string caseId, string toEmail, string ccEmail, string bccEmail, string subjectEmail)
    {        
        string returnValue = '';        
        EmailInfo templateInfo = RMAProcessController.getEmailTemplateInfo(caseId);
        EmailTemplate et = [SELECT Id, Subject, Markup, HTMLValue FROM EmailTemplate WHERE id = :templateInfo.templateId];
        User u = [Select name from user where id = :UserInfo.getUserId()];       
        
        // BUILD THE EMAIL
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Step 2: Set list of people who should get the email
        //List<String> sendTo = new List<String>();
        //sendTo.add(mMail);
        //mail.setToAddresses(templateInfo.toList);
        mail.setToAddresses(toEmail.split(';'));
        
        if (ccEmail != '')
        {
       		mail.setCcAddresses(ccEmail.split(';'));
        }
        
        if (bccEmail != '')
        {
       		mail.setBccAddresses(bccEmail.split(';'));
        }  
        
        // Step 3: Set who the email is sent from
        //mail.setReplyTo('noreply@salesforce.com'); // This works without setting it
        //mail.setSenderDisplayName('salesforce User'); 
        
        // Step 4. Set email contents - you can use variables!
       	//mail.setSubject('THIS IS A TEST EMAIL (NOT A VALID RMA):  ' + subjectEmail);
        mail.setSubject(subjectEmail);        
        mail.setHtmlBody(et.HTMLValue.replace('{{{Sender.Name}}}', u.name).replace('{{{Recipient.Name}}}', templateInfo.recipientName).replace('{{{CaseNumber}}}', templateInfo.caseNumber));
        
        // Add to attachment file list
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        Messaging.Emailfileattachment att = new Messaging.Emailfileattachment();
        att.setFileName(templateInfo.caseNumber + '.pdf');
        PageReference rmaForm = new PageReference('/apexcomponent/RMAForm');
        rmaForm.getParameters().put('caseId',caseId);
        //rmaForm.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        
        if(!Test.isRunningTest())
        {
            Blob myBlob = rmaForm.getContentAsPDF();       
            att.setBody(myBlob);
            fileAttachments.add(att);
            mail.setFileAttachments(fileAttachments);
        }
        
        // Step 5. Add your email to the master list
        mails.add(mail);
        
        System.debug('MyCaseId' + caseId);
        System.debug(mail);
        
        System.debug('EmailSendNow');
        
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
    
    // This method is legacy code from an old javascript button in saleforce classic. This is a poor way to do this. This should be rewritten.
    public static EmailInfo getEmailTemplateInfo(Id caseId){
        
        EmailInfo eInfo = new EmailInfo();
        // FOR TESTING
        //string salesrma_Address =  'alongaker@control4.com' ; // salesrma@control4.com
        //string emeasalesrma_Address = 'alongaker@control4.com' ; // emeasalesrma@control4.com
        //string traffic_Address = 'cdabb@control4.com'; // traffic@control4.com
        //string dderry_Address = 'cdabb@control4.com'; // dderry@control4.com

        string salesrma_Address =  'salesrma@control4.com';
        string emeasalesrma_Address = 'emeasalesrma@control4.com';
        string traffic_Address = 'traffic@control4.com';
        string dderry_Address = 'dderry@control4.com';
        
        List<Case> records = [SELECT Id, CaseNumber, of_RMA_s__c, Account.SAP_Instance__c,Account.DealerType__c, Account.Account_Region__c, Account.BillingCountry, Account.RMA_CC_Email__c, Contact.Name, CaseProducts__c, (SELECT Id, Scrap__c,Item__c,Item__r.RMA_Location__c,RMA__c, RMA_Type__c FROM CaseProduct__r Where Item__c != null) FROM Case WHERE Id = :caseId]; 
        
        eInfo.recipientName = records[0].Contact.Name;
        eInfo.caseNumber = records[0].CaseNumber;
        
        string location = null; 
        boolean scrapOnly = true; 
        boolean hasScrap = false; 
        boolean salesRMA = false; 
        string germanCountry = records[0].Account.BillingCountry; 
        string upperString; 
        string region; 
        if(germanCountry != null){ 
            upperString = germanCountry.toUpperCase(); 
            if( upperString == 'GERMANY' || upperString == 'DE' ){ 
                region = 'Germany'; 
            }else{ 
                region = records[0].Account.SAP_Instance__c; 
            } 
        } 
        else{ 
            region = records[0].Account.SAP_Instance__c; 
        }
                
        string acctRegion = records[0].Account.Account_Region__c; 
        string dealerType = records[0].Account.DealerType__c; 
        string rma_cc_email = records[0].Account.RMA_CC_Email__c;
                
        boolean isNotNull = false; 
        if(records[0].CaseProduct__r != null){ 
            
            List<CaseProduct__c> caseProducts = records[0].CaseProduct__r;
            
            //system.debug('Here I am: ' + caseProducts.size());            
            
            for(integer i = 0; i < caseProducts.size(); i++)
            { 
                //if(caseProducts.size() > 0)
                //{ 
                    if(caseProducts[i].Item__c != null){ 
                        if(caseProducts[i].RMA__c == 'Yes'){ 
                            isNotNull = true; 
                        } 
                        if(caseProducts[i].Item__r.RMA_Location__c != null){ 
                            location = caseProducts[i].Item__r.RMA_Location__c; 
                        } 
                    }
                    
                    if(caseProducts[i].Scrap__c == true){ 
                        hasScrap = true; 
                    } 
                    if(caseProducts[i].RMA_Type__c == 'Sales'){ 
                        salesRMA = true; 
                    } else { 
                        scrapOnly = false; 
                    }    
                //}                
            } 
        } 
        
        if(isNotNull == true)
        { 
            // This is never true. Line 171 sets scrapOnly to false if RMA_Type__c != 'Sales'. Yet this if statement requires that the salesRMA be false. 
            if(scrapOnly && hasScrap && region == 'Germany' &&!salesRMA ) 
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.templateId = '00X38000001c7E6'; //&template_id=00X38000001kfPW&new_template=1") //Old Dev 00X0U000000Du8e done
            }
            //else 
            if(dealerType == 'Control4' && location == 'SLC' )
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.ccList.Add(traffic_Address); //+traffic@control4.com
                eInfo.ccList.Add('dderry_Address'); //+dderry@control4@control4.com
                eInfo.templateId = '00X38000001c7Dw'; //&template_id=00X38000001QwiN&new_template=1") //Old Dev 00X0U000000Du98 done
            } 
            else if(dealerType == 'Control4' && location == 'York')
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.ccList.Add(traffic_Address); //+traffic@control4.com
                eInfo.templateId = '00X38000001c7Dw'; //&template_id=00X38000001QwiN&new_template=1") //Old Dev 00X0U000000Du98 done
            } 
            // This is never true. Line 171 sets scrapOnly to false if RMA_Type__c != 'Sales'. Yet this if statement requires that the salesRMA be false. 
            else if(scrapOnly && hasScrap && region == 'US' &&!salesRMA)
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.templateId = '00X38000001c7E1'; //&template_id=00X38000001bviI&new_template=1") //Old Dev 00X0U000000Du93 done
            } 
            // This is never true. Line 171 sets scrapOnly to false if RMA_Type__c != 'Sales'. Yet this if statement requires that the salesRMA be false. 
            else if(scrapOnly && hasScrap && region != 'US' &&!salesRMA )
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.templateId = '00X38000001c7E1'; //&template_id=00X38000001bviI&new_template=1") //Old Dev 00X0U000000Du93 done
            }           
            else if(dealerType == 'Control4' && region == 'US' )
            { 
                if(salesRMA)
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7EV'; //&template_id=00X38000001khbg&new_template=1") //Old Dev 00X0U000000Du8U done
                } 
                else if(acctRegion != null && acctRegion != 'International' )
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}                   
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7Dr'; //&template_id=00X500000011i8A&new_template=1")  //Old Dev 00X0U000000Du6x done                     
                } 
                else
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.bccList.Add(dderry_Address); //&p5=dderry@control4.com
                    eInfo.templateId = '00X38000001c7Dr'; //&template_id=00X500000011i8A&new_template=1")  //Old Dev 00X0U000000Du6x done           
                } 
            } 
            else if(dealerType == 'Pakedge' && region == 'US')
            { 
                if(salesRMA)
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7Ef'; //&template_id=00X38000001khbi&new_template=1") //Old Dev 00X0U000000Du8K done
                } 
                else if(acctRegion != null && acctRegion != 'International' )
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7DX'; //&template_id=00X38000001g1hR&new_template=1") //Old Dev 00X0U000000Du8y done
                } 
                else
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.bccList.Add(dderry_Address); //&p5=dderry@control4.com
                    eInfo.templateId = '00X38000001c7DX'; //&template_id=00X38000001g1hR&new_template=1") //Old Dev 00X0U000000Du8y done
                } 
            } 
            else if(dealerType == 'Triad' && region == 'US')
            { 
                if(salesRMA)
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7Ek'; //&template_id=00X38000001khbk&new_template=1") //Old Dev 00X0U000000Du8A done
                } 
                else if(acctRegion != null && acctRegion != 'International' )
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7E7'; //&template_id=00X38000001zNeK&new_template=1") //Old Dev 00X0U000000Du7v done
                } 
                else
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(salesrma_Address); //&p24=salesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.bccList.Add(dderry_Address); //&p5=dderry@control4.com
                    eInfo.templateId = '00X38000001c7E7'; //&template_id=00X38000001zNeK&new_template=1") //Old Dev 00X0U000000Du7v done
                } 
            } 
            else if(dealerType == 'Control4' && region == 'Germany')
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.templateId = '00X38000001c7Dc'; //&template_id=00X38000001kdbF&new_template=1") //Old Dev 00X0U000000Du8o done
            } 
            else if(dealerType == 'Control4' && region == 'UK')
            { 
                if(salesRMA)
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7EV'; //&template_id=00X38000001khbg&new_template=1") //Old Dev 00X0U000000Du8U done
                } 
                else
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7Dm'; //&template_id=00X50000001WpWX&new_template=1") //Old Dev 00X0U000000Du7M done
                } 
            } 
            else if(dealerType == 'Pakedge' && region == 'UK')
            { 
                if(salesRMA)
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7Ea'; //&template_id=00X38000001khbh&new_template=1") //Old Dev 00X0U000000Du8P done
                } 
                else 
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7DN'; //&template_id=00X38000001g4oB&new_template=1") //Old Dev 00X0U000000Du8t done
                } 
            } 
            else if(dealerType == 'Pakedge' && region == 'Germany')
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.templateId = '00X38000001c7DS'; //&template_id=00X38000001kfPV&new_template=1") //Old Dev 00X0U000000Du8j done
            } 
            else if(dealerType == 'Triad' && region == 'UK')
            { 
                if(salesRMA)
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7E8'; //&template_id=00X38000001khbj&new_template=1") //Old Dev 00X0U000000Du8F done
                } 
                else 
                {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                    eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                    eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                    eInfo.templateId = '00X38000001c7EL'; //&template_id=00X38000001o6QY&new_template=1") //Old Dev 00X0U000000Du85 done
                } 
            } 
            else if(dealerType == 'Triad' && region == 'Germany')
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add(emeasalesrma_Address); //&p24=emeasalesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.templateId = '00X38000001c7EB'; //&template_id=00X38000001kfPX&new_template=1") //Old Dev 00X0U000000Du8Z done
            } 
            else if(dealerType == 'Control4' && region == 'AUS')
            {   //window.open("/_ui/core/email/author/EmailAuthor?p2_lkid={!Case.ContactId}&rtype=003&p3_lkid={!Case.Id}&retURL=%2F{!Case.Id}
                eInfo.toList.Add('ausalesrma@control4.com'); //&p24=ausalesrma@control4.com
                eInfo.ccList.Add(rma_cc_email); //&p4={!Account.RMA_CC_Email__c}
                eInfo.templateId = '00X38000001c7Dh'; //&template_id=00X38000001vTYA&new_template=1") //Old Dev 00X0U000000Du80 done
            } 
            else if(dealerType == null)
            { 
                ////////alert ("Dealer Type of Account is null") 
            } 
        }else
        { 
            ////////alert("The case doesn't have an RMA Product"); 
        }      
        
        return eInfo;
    }
    
    public class RMAInformation {
        
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
        public string bodyEmail;
    }
    
    public class EmailInfo {        
        
        public string templateId;
        
        public list<string> toList = new list<string>();
        
        public list<string> ccList = new list<string>();
        
        public list<string> bccList = new list<string>();    
        
        public string recipientName;
        
        public string caseNumber;
    }      
}

//NOTES
//p4 = CC address
//p5 =  BCC address
//p6 = Email subject
//p7 = Email body
//p24 = Additional To
//p26 = From address