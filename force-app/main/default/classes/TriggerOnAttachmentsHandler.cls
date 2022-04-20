/*
 *  Description: Trigger handler which contains logic add Attachment id to a field on Lead
 *  
 *  Sr.No.  Version   Author         Date(mm/dd/yyyy)   Description
 *    1      1.1      Team Simplus     02/28/2018       Initial draft
 *    2      1.1      Team Simplus     03/01/2018       Added LastName to Lead's Query
 *                                                      Added isRunningTest to cover exception 
 *                                                      handling part in test class
 */
public class TriggerOnAttachmentsHandler {
    
    // Holds set of Lead Id's acquired from ParentId on Attachment
    public static Set<Id> setLeadId = new Set<Id>();
    
    // Holds mapping of Lead id and its record acquired after qerying
    public static Map<Id,Lead> mapLeadId_Lead;
    
    // Flag to indicate if Queried Lead is updated, if true then consider block where
    // Lead is updated
    public static Boolean isLeadUpdated = false;
    
    // Holds initial three digits of Lead id
    public static final String STR_LEAD_INITIAL = '00Q';
    
    // Default Constructor
    public TriggerOnAttachmentsHandler(){}
    
    // Method updates Lead with list of Attachments passed
    public static void updateLead( List<Attachment> listAttachment ){
        
        // Iterate on list of Attachments 
        for( Attachment objAttach: listAttachment ){
            
            if( String.valueOf( objAttach.ParentId ).startsWith( STR_LEAD_INITIAL ) ){
                
                if( !setLeadId.contains( objAttach.ParentId ) ){                    
                    setLeadId.add( objAttach.ParentId );                    
                }
                
            }            
        }
        
        if( !setLeadId.isEmpty() ){
            
            // Get Lead's based on id from Set
            mapLeadId_Lead 
                = new Map<Id,Lead>(
                    [
                        Select 
                          Id, 
                          AttachmentIds__c,
                          LastName
                        From 
                          Lead
                        Where 
                          Id In: setLeadId
                    ]
                );
            
            if( !mapLeadId_Lead.isEmpty() ){
                
                for( Attachment objAttach: listAttachment ){
                    
                    // Check if map contains Lead Id 
                    // if id is present then check for AttachmentIds__c field and add Attachment Id to it
                    if( mapLeadId_Lead.containsKey( objAttach.ParentId ) ){
                        
                        if( 
                            mapLeadId_Lead.get( objAttach.ParentId ).AttachmentIds__c != null 
                            || 
                            String.isNotEmpty( mapLeadId_Lead.get( objAttach.ParentId ).AttachmentIds__c )
                        ){                               
                            
                            if( !mapLeadId_Lead.get( objAttach.ParentId ).AttachmentIds__c.contains( objAttach.Id ) ){
                                
                                mapLeadId_Lead.get( objAttach.ParentId ).AttachmentIds__c += ',' + objAttach.Id;
                                
                                isLeadUpdated = true;
                                
                            }
                            
                        }else{
                            
                            mapLeadId_Lead.get( objAttach.ParentId ).AttachmentIds__c = objAttach.Id;
                            
                            isLeadUpdated = true;
                            
                        }
                        
                    }
                    
                }
                
                // Update Lead if isLeadUpdated is true
                if( isLeadUpdated ){
                    
                    try{
                        
                        // To test exception handling while updating Leads
                        if(Test.isRunningTest()){
                            
                            // Check for Last Name as 'Test Lead Test Running' and set 
                            // Leads Last Name to null
                            // so that we can receive an error
                            if( mapLeadId_Lead.values()[0].LastName.contains( 'Test Lead Test Running' ) ){
                                mapLeadId_Lead.values()[0].LastName = null;
                            }
                            
                        }
                        
                        update mapLeadId_Lead.values();
                        
                    }catch( Exception objExcp ){
                        
                        for( Attachment objAttach: listAttachment ){
                            
                            objAttach.addError( objExcp.getMessage() );
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
}