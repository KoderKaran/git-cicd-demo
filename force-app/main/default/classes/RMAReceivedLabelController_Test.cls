@isTest(SeeAllData=true)
public class RMAReceivedLabelController_Test {
    
    static testMethod void RMAReceivedLabelController_DefaultTest()
    {
        RMAReceivedLabelController controller = new RMAReceivedLabelController();        
        controller.caseProductId = 'a0850000003hn7nAAA';
        
       	controller.GetLabelData();
        
    }

}