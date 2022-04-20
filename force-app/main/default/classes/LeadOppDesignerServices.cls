public class LeadOppDesignerServices {
    
    Map<Id, Lead> oldMap;
    Map<Id, Lead> newMap;
    
    public LeadOppDesignerServices(
        Map<Id, Lead> oldTrigger, 
        Map<Id, Lead> newTrigger) {
            oldMap = oldTrigger;
            newMap = newTrigger;
        }
    
    public void updateDesignerServices() {  
        Set<ID> leadid = new Set<ID>();
        set<ID> oppId = new Set<ID>();
        system.debug('simplus test here');
        //string recordTypeId = [select Id from RecordType where SObjectType = 'Opportunity' AND DeveloperName = 'Design_Services'].Id;
        string recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Design Services')
            .getRecordTypeId();
        string recordTypeId1 = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services')
            .getRecordTypeId();
        
        system.debug('recordTypeId1' + recordTypeId1);
        system.debug('listofnewmap' +  newMap.values());
        
        if (recordTypeId1 != null) 
        {
            for(Lead l : newMap.values())
                {
                    If(l.RecordTypeId == recordTypeId1){
                    leadid.add(l.Id);
                    oppId.add(l.ConvertedOpportunityId);
                    }
                }
            system.debug('sampleLead' + leadid);
                if(leadid.size() > 0){
                List<Opportunity> opplist = new List<Opportunity>();
                List<String> ismAccountOwner = new List<String>();
                system.debug('sampleopp' + opplist);
                For(Opportunity op : [SELECT Id, AccountID,Associated_Lead__c,StageName,recordtypeid, Account.ISM_Account_Owner__c,OwnerId, Account.OwnerId FROM Opportunity WHERE id IN : oppId])
                {
                    if(op.Account.ISM_Account_Owner__c != null){
                        op.OwnerId = op.Account.ISM_Account_Owner__c; 
                    }else{
                        op.OwnerId = op.Account.OwnerId;
                    }
                    op.recordtypeid = recordTypeId;
                    op.StageName = 'New Design Opportunity';
                    
                    opplist.add(op);
                }

                if(opplist.size() > 0 ) {
                    update opplist;
                }
            }
        }
       
        
    }
    
    
}