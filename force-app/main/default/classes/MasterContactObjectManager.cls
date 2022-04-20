public class MasterContactObjectManager {
    // This method is called from ContactTrigger.apxt
    public void CreateMasterContact(List<Contact> triggerNew)
    {
        // Creates new Master Contact object update new the Contact look field ot the Master Contact object
        List<Contact> conList = new List<Contact>();    
        for(Contact con: triggerNew)
        {
            string conName = '';
            if (String.isBlank(con.firstName))
            {
               conName = con.LastName; 
            } 
            else
            {
               conName = con.FirstName + ' ' + con.LastName; 
            }            
            
	        Master_Contact__c masterContact = new Master_Contact__c(Name = conName);
            Insert masterContact;
            Contact contact = new Contact(id = con.id);
            contact.Master_Contact__c = masterContact.id; 
            conList.add(contact);
        }
        Update conList;
    } 
}