public class RMAReceivedLabelController {
    
	public Id caseProductId {get;set{caseProductId = value;}} /** get set the variable for case Id take value from visual component.**/        
    public string imageURL {get;set;}    
    public string receivedDate	{get; set;}
    public string createdDate 	{get; set;}
    public CaseProduct__c caseProduct {get; set;}
    public Case caseInfo {get; set;}
    
    public RMAReceivedLabelController() {
        
        if(!Test.isRunningTest()) // Cannot get the caseId from the URL while running the test class.
        {
            caseProductId = ApexPages.currentPage().getParameters().get('caseProductId');
            System.debug(caseProductId);
            GetLabelData();
        }
    }
    
    public void GetLabelData()
    {
        System.debug('here ' + caseProductId);
        caseProduct = GetCaseProductData();
        caseInfo = GetCaseData();
        createdDate = caseProduct.CreatedDate.format('MM-dd-yyyy hh:mm a');
        
        if(caseProduct.RMA_Received_Date__c == NULL) {
            receivedDate = '';
        }
        else {
        	receivedDate =  caseProduct.RMA_Received_Date__c.format();
        }        
        imageUrl='https://www.barcodesinc.com/generator/image.php?code='+ caseInfo.CaseNumber +'&style=370&type=C39&width=125&height=50&xres=1&font=1';
    }
    
    private CaseProduct__c GetCaseProductData()
    {
        return  [SELECT 
                 	Item_Code__c  
                 	, Quantity__c
                 	, CreatedDate
                 	, Name
                 	, Case__c
                 	, RMA_Received_Date__c
                 FROM CaseProduct__c 
                 WHERE Id =:caseProductId];   
    }  
    
    private Case GetCaseData() 
    {
        return [Select Id
         		, Account.Name 
                , CaseNumber
                , Status
                From Case 
                where Id =: caseProduct.Case__c]; 
    }
}