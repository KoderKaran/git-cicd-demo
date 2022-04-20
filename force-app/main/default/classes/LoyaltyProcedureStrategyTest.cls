@isTest
public class LoyaltyProcedureStrategyTest {
    
    @TestSetup
    static void generateTestAccounts(){
        Account accWithLoyaltyReward = new Account(Name = 'AccountWithLR', SAP_ACCOUNT_ID__c = 'STESTWLR1');
        Account accWithoutLoyaltyReward = new Account(Name = 'AccountWithoutLR', SAP_ACCOUNT_ID__c = 'STESTWOLR1');
        insert new List<Account>{accWithLoyaltyReward,accWithoutLoyaltyReward};
        Loyalty_Rewards__c lr = new Loyalty_Rewards__c(Account__c = accWithLoyaltyReward.Id, Loyalty_Enrolled_Date__c = Date.today(), Loyalty_Enrolled__c = true, Reward_Tier__c = 'Bronze');
        insert lr;
    }

    @isTest
    static void executeDataLoad_givenValidFullCsv_generatesCorrectData(){
        Map<String,CSVParser> loyaltyCsv = generateLoyaltyCsvMap();
        LoyaltyProcedureStrategy lps = new LoyaltyProcedureStrategy();

        DataLoaderResults.DataLoaderAuraResults result;

        Test.startTest();
            result = lps.executeDataLoad(loyaltyCsv);
        Test.stopTest();

        System.debug(result);
    }

    private static Map<String,CSVParser> generateLoyaltyCsvMap(){
        return new Map<String,CSVParser>{
            'Loyalty-Load-Csv' => new CSVParser(
            'ID,Name,Reward Tier,Loyalty Enrolled Date\n'+
            'STESTWLR1,Test1,Gold,1/1/2022\n' +
            'STESTWOLR1,Test2,Gold,1/1/2022\n' +
            'STESTNOACC,Test3,Gold,1/1/2022', 100
        )};
    }

}