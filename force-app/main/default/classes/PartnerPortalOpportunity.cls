public with sharing class PartnerPortalOpportunity {
	// Return a list of the ten most recently modified contacts
	public List <Opportunity> getOpportunities() {
		Id id = System.currentPageReference().getParameters().get('id');
		
		return [select ID,NAME,stagename,isclosed, leadsource FROM OPPORTUNITY WHERE AccountId = :System.currentPageReference().getParameters().get('id')];
	}
}