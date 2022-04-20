public class DispatcherCaseProductNewController {
    private final ApexPages.StandardController controller;
	
    public DispatcherCaseProductNewController(ApexPages.StandardController stdcontroller) {
        this.controller = stdcontroller;
    }

    public PageReference redirect() {
        PageReference pr;
        String rtId = ApexPages.currentPage().getParameters().get('RecordType');
        if(rtId == null){
            // If a record type wasn't passed in, we need to determine the user's default
            List<Schema.RecordTypeInfo> infos = Schema.SObjectType.CaseProduct__c.RecordTypeInfos;
            //check each one
            for (Schema.RecordTypeInfo rti : infos){
                if (rti.isDefaultRecordTypeMapping()){
                    rtId = rti.getRecordTypeId();
                }
            }
        }
        RecordType recordType = [SELECT ID FROM RecordType WHERE Id = :rtId];
        if (recordType.Id == '0125000000059WR'){
            //sent the user to VF page
            pr=Page.RMA_Tech_Detail;
        }else{
            Schema.DescribeSObjectResult r = CaseProduct__c.SObjectType.getDescribe();
            	pr = new PageReference('/' + r.getKeyPrefix() + '/e');
        }
        pr.getParameters().putAll(ApexPages.currentPage().getParameters());
        //add the nooverride parameter to keep us out of an endless loop
        pr.getParameters().put('nooverride', '1');
        //For some reason the save_new parameter is sent which tries to autosave the page
        pr.getParameters().remove('save_new');
        return pr.setRedirect(true);
    }
}