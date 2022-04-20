/**
 * Updates a case to cause a related rule to update related product.
 * The business rule is that, each time a case e-mail is sent, we need to 
 * create a task for the Tech Support team to be reminded to follow up on 
 * a RMA if they have not sent the email 
 */
trigger UpdateCaseEmail on EmailMessage (after insert)
{
    set<Id> caseIds= new Set<Id>();
    for(EmailMessage rmaEmail:Trigger.new)
    {
        caseIds.add(rmaEmail.ParentID);
    }

    // Find all cases related to the e-mail that just got sent and that have not
    // had their RMA task set yet.
    List<Case> csList = new List<Case>();
    for(ID thisEmailParentId : caseIds)
    {
        csList.add([SELECT Update_RMA_Task__c, CaseNumber, Id 
                    FROM Case 
                    WHERE id = : thisEmailParentId]);
    }

    // Modify the cases to meet the business rule
    for(Case cs : csList)
        cs.Update_RMA_Task__c = True;
        // Send our updates back to Salesforce
    if(csList.size() > 0 )
    {
        update csList;
    }
}