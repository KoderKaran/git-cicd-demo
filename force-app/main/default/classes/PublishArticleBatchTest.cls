@isTest
public class PublishArticleBatchTest {
    
    @testSetup 
    private static void insertKnowledge() {
        Knowledge__kav insertKnowledge = new Knowledge__kav();
        insertKnowledge.Title = 'This is testing';
        insertKnowledge.UrlName = 'This-Is-Testing';
        insert insertKnowledge;   
    }
    
    @isTest
    private static void whenStartCalled_ShouldNotFail(){
        
        Test.startTest();
        Database.executeBatch(new PublishArticleBatch());
        Test.stopTest();
        
    }    
}