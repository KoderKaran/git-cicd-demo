public class RMA_Type {
    
    @AuraEnabled
    Public Static string GetRMA_Type (String recId){
        String myIdPrefix = recId.substring(0,3);
        String rmaType;
        
        Schema.DescribeSObjectResult caseProdDesc = CaseProduct__c.sObjectType.getDescribe();
        String caseProdPrefix = caseProdDesc.getKeyPrefix();
        System.debug('Case Product Prefix is ' + caseProdPrefix);
        
        Schema.DescribeSObjectResult caseDesc = Case.sObjectType.getDescribe();
        String casePrefix = caseDesc.getKeyPrefix();
        System.debug('Case Prefix is ' + casePrefix);
        
        List<CaseProduct__c> casePRRMA = New List<CaseProduct__c>();
        List<Case> caseRMA = New List<Case>();
        
        if(caseProdPrefix!=null && caseProdPrefix.equals(myIdPrefix)){
            casePRRMA = [Select Id,RMA_Type__c from CaseProduct__c where Id = :recId];
            if(casePRRMA != null && !casePRRMA.isEmpty()){
                if(casePRRMA[0].RMA_Type__c != null)
					rmaType = casePRRMA[0].RMA_Type__c + ' RMA';
            }
        }
        
       
        if(casePrefix!=null && casePrefix.equals(myIdPrefix)){
            //caseRMA =[Select Id,SRMA_Layout__c from Case where Id = :recId];
            CaseRMA = [SELECT Id,(Select Id,Case__c,RMA_Type__c from CaseProduct__r where RMA_Type__c != Null  Limit 1) from Case where Id = :recId];
            if(caseRMA != null && !caseRMA.isEmpty()){
                if(caseRMA[0].CaseProduct__r[0].RMA_Type__c!= null)
					rmaType = caseRMA[0].CaseProduct__r[0].RMA_Type__c + ' RMA';
            }
        }
        return rmaType; 
      
    }

}