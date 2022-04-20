trigger LiveChatTranscipt on LiveChat_transcript__c ( After update) 
{
    //Setting a string to capture ID and Transcript from LiveChat
    Set<String> lccaseid = new Set<String>();
    Set<String> lctranscript = new Set<String>();
    for(LiveChat_transcript__c lc : system.trigger.new)
    {
        If(lc.Transcript__c != Null)
        {
            lccaseid.add(lc.Case__c);
            lctranscript.add(lc.Transcript__c);
        }
    }
    //List all of the RMA associated with the case that the Transcript is associated with.
    List<CaseProduct__c> rmalist =[SELECT ID, Case__c, Detail__c FROM CaseProduct__c WHERE Case__c = :lccaseid];
    If(rmalist.size() > 0)
    {
        //Update the RMA detail with the transcript information
        For(CaseProduct__c rma :rmalist)
        {
            rma.Detail__c = rma.Detail__c + '\n'+'Transcript'+ '\n' + lctranscript;
            update rma;
        }
    }
}