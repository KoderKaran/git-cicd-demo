public class UpdateCaseEmailHandler {
    /*
      Updates a case to cause a related rule to update related product.
      The business rule is that, each time a case e-mail is sent, we need to 
      create a task for the Tech Support team to be reminded to follow up on 
      a RMA if they have not sent the email 
    */
    public static void updateRMATask(List<EmailMessage> newEmailMessageList){
        List<Case> csList = new List<Case>();
        List<Id> parentIds= new List<Id>();
        for(EmailMessage em : newEmailMessageList){
            parentIds.add(em.ParentID);
        }
        for(Case cs : [SELECT Update_RMA_Task__c, CaseNumber, Id FROM Case WHERE Id IN: parentIds]){
            cs.Update_RMA_Task__c = True;
            csList.add(cs);
        }
        if(!csList.isEmpty()){
            update csList;
        }
    }
    
    @future
    public static void fetchAttachment(Set<Id> lstId){
        List<Attachment> updateAttachmentToLeads = new List<Attachment>();
        List<Attachment> attachmentIds = new List<Attachment>();
        List<EmailMessage> emailMessageNewList =  [Select Id, (Select Id from Attachments), (Select Id, EmailMessageId,RelationId, RelationObjectType from EmailMessageRelations where RelationObjectType = 'lead') from EmailMessage where Id IN: lstId];
        
        Map<EmailMessageRelation, List<Attachment>> listAttachmentsEmailMessageRelation = new Map<EmailMessageRelation, List<Attachment>>();
        for(EmailMessage em : emailMessageNewList){
            attachmentIds.addAll(em.Attachments);
        }
        List<Attachment> lstNewAttachments = [Select Id, Body, Name, ParentId, ContentType, Description, IsPrivate  from Attachment where Id IN: attachmentIds];
        
        for(EmailMessage em : emailMessageNewList){
            for(Attachment att : lstNewAttachments){
                if(att.ParentId == em.Id){
                    List<Attachment> tempListAttachment = new List<Attachment>();
                    tempListAttachment.add(att);
                    if(!tempListAttachment.isEmpty()){
                        if(listAttachmentsEmailMessageRelation.containsKey(em.EmailMessageRelations[0])){
                            List<Attachment> temp = listAttachmentsEmailMessageRelation.get(em.EmailMessageRelations[0]);
                            temp.addAll(tempListAttachment);
                            listAttachmentsEmailMessageRelation.put(em.EmailMessageRelations[0], temp);
                        }
                        else{
                            listAttachmentsEmailMessageRelation.put(em.EmailMessageRelations[0],tempListAttachment);
                        }
                    }
                }
            }
        }
        for(EmailMessageRelation emr : listAttachmentsEmailMessageRelation.keySet()){
            for(Attachment att : listAttachmentsEmailMessageRelation.get(emr)){
              /*Logic to add new attachment*/  
                Attachment attach = new Attachment();
                attach.Body = att.Body;
                attach.Name = String.valueOf(att.Name);
                attach.ParentId = emr.RelationId;
                attach.ContentType = att.ContentType;
                attach.Description = att.Description;
                attach.IsPrivate = att.IsPrivate;
                updateAttachmentToLeads.add(attach);
            }
        }
        if(!updateAttachmentToLeads.isEmpty()){
            insert updateAttachmentToLeads;
        } 
    }
}