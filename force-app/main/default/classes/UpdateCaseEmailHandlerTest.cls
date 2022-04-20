@iSTest
public class UpdateCaseEmailHandlerTest{    
   public static testMethod void checkUpdateRMATaskPositive(){
        Case c = new Case();
        c.Subject = 'Om Test';
        c.Status ='New';
        c.Priority = 'Medium';
        c.Origin = 'Email';
        insert c;
        
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = c.Id; 
        insert email;
        
        Case currentCase= [Select Id, Update_RMA_Task__c from Case where Id =: c.Id];
        System.assertEquals(True,currentCase.Update_RMA_Task__c);
   }
   public static testMethod void checkUpdateRMATaskNegative(){
        Case c = new Case();
        c.Subject = 'Om Test';
        c.Status ='New';
        c.Priority = 'Medium';
        c.Origin = 'Email';
        insert c;
        
        Case c1 = new Case();
        c1.Subject = 'Om Test';
        c1.Status ='New';
        c1.Priority = 'Medium';
        c1.Origin = 'Email';
        insert c1;
                
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = c.Id; 
        insert email;
        
        Case currentCase = [Select Id, Update_RMA_Task__c from Case where Id =: c1.Id];
        System.assertEquals(False,currentCase.Update_RMA_Task__c);
    }
    
    public static testMethod void checkFetchAttachmentsPositive(){
        
        Lead l = new Lead(Company = 'JohnMiller', LastName = 'Mike', Status = 'Open', Email = 'test@xyz.org');
        insert l;

		 Case c = new Case();
        c.Subject = 'Om Test';
        c.Status ='New';
        c.Priority = 'Medium';
        c.Origin = 'Email';
        insert c;

        
        test.starttest();          
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress = l.Email;
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = c.id;
        insert email;
        
        
          
        EmailMessageRelation objEMR = new EmailMessageRelation(); 
        objEMR.EmailMessageId = email.Id;
        //objEMR.RelationObjectType = 'Lead'; 
        objEMR.RelationId = l.Id;
        objEMR.RelationType = 'ToAddress';
        insert objEMR; 
        
        Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.Body = b;
        attachment.Name = 'Test1';
        attachment.ParentId = email.Id; 
        insert attachment;
               
        Attachment attachment1 = new Attachment();
        attachment1.Body = b;
        attachment1.Name = 'Test1';
        attachment1.ParentId = email.Id; 
        insert attachment1;
        
        test.stoptest();
        Lead currentLead = [Select Id, (Select Id from Attachments) from Lead where Id =: l.Id];
        System.assertEquals(2,currentLead.Attachments.size());
    }
    
    public static testMethod void checkFetchAttachmentsNegative(){
        
        Lead l = new Lead(Company = 'JohnMiller', LastName = 'Mike', Status = 'Open', Email = 'test@xyz.org');
        insert l;
        
         Case c = new Case();
        c.Subject = 'Om Test';
        c.Status ='New';
        c.Priority = 'Medium';
        c.Origin = 'Email';
        insert c;
        
        test.starttest();          
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress = l.Email;
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId =  c.id;
        insert email;
        
        
          
        EmailMessageRelation objEMR = new EmailMessageRelation(); 
        objEMR.EmailMessageId = email.Id;
        //objEMR.RelationObjectType = 'Lead'; 
        objEMR.RelationId = l.Id;
        objEMR.RelationType = 'ToAddress';
        insert objEMR; 
        
        test.stoptest();
        Lead currentLead = [Select Id, (Select Id from Attachments) from Lead where Id =: l.Id];
        System.assertEquals(0,currentLead.Attachments.size());
    }
    
    
}