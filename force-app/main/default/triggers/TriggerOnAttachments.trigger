/*
 *  Description: Trigger that calls handler which contains logic to add Attachment id to a field on Lead
 *  
 *  Sr.No.  Version   Author         Date(mm/dd/yyyy)   Description
 *    1      1.1      Team Simplus     02/28/2018       Initial draft
 */
trigger TriggerOnAttachments on Attachment ( after insert, after update ) {
    
    if( trigger.isAfter ){
        
        if( trigger.isInsert || trigger.isUpdate ){
            
            TriggerOnAttachmentsHandler.updateLead( trigger.new );
        }
        
    }
    
}