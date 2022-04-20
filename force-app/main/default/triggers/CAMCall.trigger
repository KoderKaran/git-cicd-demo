trigger CAMCall on Task (after insert) 
{
    id nid;
    id ownid;
    for(Task nt : Trigger.new)
    {
        ownid = nt.ownerID;
        If(nt.WhatID != Null)
        {
            nid = nt.WhatID;
        }
    }
        List<Case> cslist = [SELECT Id, OwnerID, Status, RecordTypeId, Last_Case_Comment__c FROM Case WHERE Id = :nid 
                             AND RecordTypeID = '012500000005eVdAAI'  AND (Status != 'Waiting for Customer' OR Status != 'Closed')];
    For(Case cs : cslist)
    {
        cs.Status = 'Waiting for Customer';
        cs.Last_Case_Comment__c = System.now();
        Update cs;
    }
}