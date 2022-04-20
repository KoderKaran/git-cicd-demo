public class AccountStylingClass {
	private final Account acct;	

    public AccountStylingClass(ApexPages.StandardController stdController){
		this.acct = (Account)stdController.getRecord();
    }
    
    public String getRollingTwelveMonths() {
        if(this.acct.Rolling_12_Months__c <= this.acct.Previous_12_Months__c){
            return 'red';
        }
        return 'green';
    }
    
    public String getYtdRevenue() {
        if(this.acct.YTD_Revenue__c <= this.acct.YTD_Revenue_Comparison__c){
            return 'red';
        }
        return 'green';
    }
    
    public String getQtdRevenue() {
        if(this.acct.QTD_Revenue__c <= this.acct.QTD_Revenue_Comparison__c){
            return 'red';
        }
        return 'green';
    }
        
}