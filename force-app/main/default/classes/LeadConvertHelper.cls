/*
*    Description: Handler class for trigger on Lead to Update Opportinity Name by Lead's Subject after 
*                 Lead gets converted. Also adds attachment to converted Opportunity from Lead.
*                 Handler to update 'Contact Name' on Opportunity with ConvertedContactId's value when a Lead is 
*                 converted.
*    Sr.No. Version     Author            Date(mm/dd/yy)    Description
*  
*       1     1.0       Team Simplus      12/07/2017        Initial Draft 
*       2     1.1       Team Simplus      02/28/2018        Updated to add logic for attachments 
*                                                           for a Lead to Opportunity Conversion
*/
public with sharing class LeadConvertHelper {
    
    // This method update Opportinity Name by Lead's Subject if Lead is converted and adds attachment to converted Opportunity.
    public void updateOpportunity(list<Lead> newLeadList) {        
        
        List<Lead> leadList = new List<Lead>();
        
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id,Lead> convertedConIdLeadObjMap = new Map<Id,Lead>();
        List<Attachment> insertAttachmentList = new List<Attachment>();
        
        // Method with trigger.new as parameter value to update Opportunities field 'Contact Name' with 
        // 'Lead Name' on Lead conversion
        // List to hold Opportunities to carry out update
        List<Opportunity> updateOppList = new List<Opportunity>();
        
        // Map of Opportunity Id and Lead Id
        Map<Id,Id> mapOppId_LeadId = new Map<Id,Id>();
        
        // Map of Lead id and index of list where Lead id is present in the list acquired as parameter
        Map<Id, Integer> mapLeadId_LeadIndex = new Map<Id, Integer>();
        
        // Added in version 1.1
        // Set of Attachments Id's from AttachmentIds__c field on Lead to be used by a query on Attachments
        Set<Id> attachmentIdSet = new Set<Id>();
        
        // Iterate on list of leads acquired in parameter add Lead Id and its index to map
        for(Integer index = 0; index < newLeadList.size(); index++){
            mapLeadId_LeadIndex.put(newLeadList[index].Id, index);
        }
        
        
        // Get record type Id for Lead for record type label 'Design Services'
        Id leadRecordTypeId 
            = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(Label.Lead_Design_Services).getRecordTypeId();
        
        // Added field AttachmentIds__c to Query in version 1.1
        // Check if the Lead is converted and is in the list obtained above    
        for(Lead leadObj : [Select 
                            Id,
                            LastName,
                            Name,
                            Status,
                            ConvertedOpportunityId,
                            ConvertedAccountId,
                            ConvertedContactId,
                            ConvertedOpportunity.Name,
                            Lead_Subject__c,
                            RecordTypeId,
                            Dealer_Name__r.OwnerId,
                            AttachmentIds__c
                            From Lead 
                            Where isConverted = true                                
                            And Id IN : newLeadList]) {
                                
                                // Add obtained Leads to a list
                                leadList.add(leadObj);
                                
                                // Check if ConvertedOpportunityId is not empty or null
                                if( leadObj.ConvertedOpportunityId != null &&
                                   String.isNotBlank(leadObj.ConvertedOpportunityId)) {                                        
                                       
                                       // Check if ConvertedContactId not null if true then add it to a set and fill a map
                                       if(leadObj.ConvertedContactId != null){
                                           contactIdSet.add(leadObj.ConvertedContactId);
                                           convertedConIdLeadObjMap.put(leadObj.ConvertedContactId,leadObj);
                                           // Set 'Contact Name' field with ConvertedContactId
                                           leadObj.ConvertedOpportunity.Contact_Name__c = leadObj.ConvertedContactId;
                                           
                                           // If block added in version 1.1
                                           // Check if AttachmentIds__c is not blank and add Attachment Id's to a set
                                           // which will be used by a query later
                                           if( 
                                               leadObj.AttachmentIds__c != null 
                                               && 
                                               String.isNotEmpty( leadObj.AttachmentIds__c ) 
                                           ){
                                               
                                               attachmentIdSet.addAll( (List<Id>)leadObj.AttachmentIds__c.split(',') );
                                               
                                           }
                                           
                                       }                                       
                                       
                                       
                                       
                                       // To test exception handling while updating Opportunities
                                       if(Test.isRunningTest()){
                                           
                                           // Check for Last Name as 'Test Lead Test Running' and set 
                                           // Opportunities Name to null
                                           // so that we can receive an error
                                           if(leadObj.LastName.contains('Test Lead Test Running')){
                                               leadObj.ConvertedOpportunity.Name = null;
                                           }
                                           
                                       }
                                       
                                       //updateOppList.add(leadObj.ConvertedOpportunity);
                                       
                                       mapOppId_LeadId.put(leadObj.ConvertedOpportunityId, leadObj.Id);
                                       
                                       
                                       // Check if record type id queried is not null
                                       if(leadRecordTypeId != null){
                                           
                                           // If record type id for the record equals design services record type id
                                           // then update converted Opportunities name with Leas Subject if Lead Subject is 
                                           // not null or blank. Also update Opportunities Owner with Dealer's Owner Id
                                           if(leadObj.RecordTypeId == leadRecordTypeId){
                                               /* Commented as no approval received for the code's functionality
                                                if(leadObj.Lead_Subject__c != null 
                                                && String.isNotBlank(leadObj.Lead_Subject__c)){
                                                leadObj.ConvertedOpportunity.Name = leadObj.Lead_Subject__c;
                                                }
                                                */
                                               if(leadObj.Dealer_Name__c != null){
                                                   leadObj.ConvertedOpportunity.OwnerId = leadObj.Dealer_Name__r.OwnerId;
                                               }                                               
                                           }
                                           
                                       }
                                       
                                       // Add the Opportunities to a list when criterias are met
                                       if((leadObj.Dealer_Name__c != null) 
                                          || (leadObj.ConvertedOpportunity.Contact_Name__c != null)){
                                              updateOppList.add(leadObj.ConvertedOpportunity);
                                          }
                                       
                                   }
                            }
        
        
        // Check if list of Opportunities to update is not null
        if(updateOppList != null && !updateOppList.isEmpty()){
            try{
                // Update Opportunities for 'Contact Name' field
                update updateOppList;
            }catch(System.DMLException objExcep){
                
                // Get count of DML exceptions and add error to corresponding Lead 
                for(Integer index = 0; index < objExcep.getNumDml(); index++ ){
                    
                    // Check exception for index is not null
                    if(objExcep.getDmlId(index) != null){   
                        
                        // Check Id obtained is of Opportunity and map has this Opportunity Id
                        if( mapOppId_LeadId.containsKey(objExcep.getDmlId(index))){                               
                            // Add error to the Lead at a particular index of the acquired Lead's list
                            newLeadList[mapLeadId_LeadIndex.get(mapOppId_LeadId.get(objExcep.getDmlId(index)))].addError(objExcep.getDmlMessage(index));
                        }
                    }
                }
                
            }
        }      
        
        // Replaced contactIdSet with attachmentIdSet in version 1.1
        // Get all the Attachments under id refrenced by ConvertedContactId
        for(Attachment attachmentObj : [SELECT Body,BodyLength,ContentType,
                                        Description,Id,IsDeleted,IsPrivate,Name,ParentId,Parent.Name
                                        FROM Attachment 
                                        Where Id IN : attachmentIdSet And IsDeleted = false
                                       ]){ 
                                           
                                           Attachment attachment = new Attachment();
                                           
                                           // Check if map contains parent id if true than clone the attachment record
                                           if(convertedConIdLeadObjMap.get(attachmentObj.ParentId) != null){
                                               attachment.Body = attachmentObj.Body;
                                               attachment.Name = String.valueOf(attachmentObj.Name);
                                               attachment.ParentId = 
                                                   convertedConIdLeadObjMap.get(attachmentObj.ParentId).ConvertedOpportunityId;
                                               attachment.ContentType = attachmentObj.ContentType;
                                               attachment.Description = attachmentObj.Description;
                                               attachment.IsPrivate = attachmentObj.IsPrivate;
                                               
                                               // Add new attachment to list of all attachments to insert
                                               insertAttachmentList.add(attachment);
                                           }
                                           
                                       }
        
        // Create new Attachments for Opportunities
        if(!insertAttachmentList.isEmpty()) {
            try{
                insert insertAttachmentList;
            }catch(System.DMLException objExcep)
            {
                // Get count of DML exceptions and add error to corresponding Lead 
                for(Integer index = 0; index < objExcep.getNumDml(); index++ ){
                    
                    // Check exception for index is not null
                    if(objExcep.getDmlId(index) != null){
                        
                        // Get Id from exception
                        Id objExcepAttchId = objExcep.getDmlId(index);
                        
                        // Check Id obtained is of Opportunity and map has this Opportunity Id
                        if( objExcepAttchId.getSObjectType() == Attachment.getSObjectType() 
                           && mapOppId_LeadId.containsKey(objExcepAttchId)){
                               
                           }
                        
                    } 
                }
                
            }
        }
    }
}