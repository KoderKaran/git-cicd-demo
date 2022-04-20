public class mySecondController {
	// Return a list of the ten most recently modified contacts
	public List<Contact> getContacts() {
		Id id = System.currentPageReference().getParameters().get('id');
		return [SELECT Id, Name, Account.Name, Phone, Email FROM Contact WHERE Id = :id ORDER BY LastModifiedDate DESC LIMIT 10];
	}

	// Get the 'id' query parameter from the URL of the page.
	// If it's not specified, return an empty contact.
	// Otherwise, issue a SOQL query to return the contact from the
	// database.
	public Contact getContact() {
		Id id = System.currentPageReference().getParameters().get('id');
		return id == null ? new Contact() : [SELECT Id, Name FROM Contact WHERE Id = :id];
	}
}