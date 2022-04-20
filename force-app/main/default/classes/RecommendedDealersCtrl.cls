public class RecommendedDealersCtrl {

    public Id leadId { get; set; }
    public List<Opportunity> oppos { get; set; }
    public Lead lead { 
        get {
            if (this.leadId == null) {
                this.lead = new Lead();
                return this.lead;
            }
        
            this.lead = [
                SELECT FirstName, Owner.Phone, Owner.Name 
                FROM Lead 
                WHERE Id = :this.leadId
            ];
            
            Datetime fiveMinutesAgo = Datetime.now().addMinutes(-5);
            
            this.oppos = [
                SELECT Account.Name, Account.Dealer_Phone_for_Leads__c
                FROM Opportunity
                WHERE Associated_Lead__c = :leadId
                    AND CreatedDate >= :fiveMinutesAgo
            ];
            
            return this.lead;
        }
        set; 
    }
    
    public RecommendedDealersCtrl() {
        
    }

}