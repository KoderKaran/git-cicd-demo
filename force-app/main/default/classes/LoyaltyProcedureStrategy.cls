public class LoyaltyProcedureStrategy implements DataLoaderProcedureStrategy{

    private final String INSERTED_STRING = 'Inserted Loyalty Rewards';
    private final String UPDATED_STRING = 'Updated Loyalty Rewards';
    private final String ERRORS_STRING = 'Errors';

    private final String LOY_RWD_ID_STRING = 'Loyalty Reward Id';
    private final String TIER_ADJ_ID_STRING = 'Tier Adjustment Id';
    private final String NEW_TIER_STRING = 'New Loyalty Tier';
    private final String REL_ACC_SAP_STRING = 'Related Account SCode';
    private final String REL_ACC_ID_STRING = 'Related Account Id';
    private final String ERROR_FIELDS = 'Fields Causing Error';
    private final String ERROR_MSG_STRING = 'Error Message';

    private List<String> INSERTED_COLUMNS = new List<String>{this.REL_ACC_ID_STRING,this.REL_ACC_SAP_STRING,this.LOY_RWD_ID_STRING, this.TIER_ADJ_ID_STRING, this.NEW_TIER_STRING};
    private List<String> UPDATED_COLUMNS = new List<String>{this.REL_ACC_ID_STRING,this.REL_ACC_SAP_STRING,this.LOY_RWD_ID_STRING, this.TIER_ADJ_ID_STRING, this.NEW_TIER_STRING};
    private List<String> ERRORS_COLUMNS = new List<String>{this.REL_ACC_SAP_STRING, this.ERROR_FIELDS, this.ERROR_MSG_STRING};

    private final DataLoaderResults dataLoaderResults;

    public LoyaltyProcedureStrategy(){
        dataLoaderResults = new DataLoaderResults();
        dataLoaderResults.setTables(new List<String>{this.INSERTED_STRING, this.UPDATED_STRING, this.ERRORS_STRING});
        dataLoaderResults.setTableColumns(this.INSERTED_STRING, this.INSERTED_COLUMNS);
        dataLoaderResults.setTableColumns(this.UPDATED_STRING, this.UPDATED_COLUMNS);
        dataLoaderResults.setTableColumns(this.ERRORS_STRING, this.ERRORS_COLUMNS);
    }

    public DataLoaderResults.DataLoaderAuraResults executeDataLoad(Map<String,CSVParser> files){
        CSVParser loyaltyCsv = files.get('Loyalty-Load-Csv');
        try{
            Map<String,sObject> sCodeToLoyaltyRewardRecords = loyaltyCsv.csvToSObjectsMappedToKeyField(Schema.getGlobalDescribe().get('Loyalty_Rewards__c'), new List<String>{'reward tier', 'loyalty enrolled date'}, 'id');
            Set<String> existingSCodes = sCodeToLoyaltyRewardRecords.keySet();
            List<Loyalty_Rewards__c> existingLoyaltyRewards = [SELECT Id, Reward_Tier__c, Loyalty_Enrolled_Date__c, Account__r.SAP_ACCOUNT_ID__c FROM Loyalty_Rewards__c WHERE Account__r.SAP_ACCOUNT_ID__c IN: existingSCodes];
            List<Loyalty_Tier_Adjustments__c> loyaltyTierAdjustmentsToInsert = new List<Loyalty_Tier_Adjustments__c>();
            Map<Id,Loyalty_Rewards__c> existingLoyaltyRewardsMap = new Map<Id,Loyalty_Rewards__c>(existingLoyaltyRewards);

            List<Loyalty_Rewards__c> loyUpdateIdSuccesses = new List<Loyalty_Rewards__c>();
            List<Loyalty_Rewards__c> loyInsertIdSuccesses = new List<Loyalty_Rewards__c>();

            Map<String,Database.SaveResult> loyUpdateErrorSAPToSaveRes = new Map<String,Database.SaveResult>();
            Map<String,Database.SaveResult> loyInsertErrorSAPToSaveRes = new Map<String,Database.SaveResult>();

            for(Loyalty_Rewards__c lr:existingLoyaltyRewards){
                Loyalty_Rewards__c csvLr = (Loyalty_Rewards__c) sCodeToLoyaltyRewardRecords.get(lr.Account__r.SAP_ACCOUNT_ID__c);
                lr.Reward_Tier__c = csvLr.Reward_Tier__c;
                loyaltyTierAdjustmentsToInsert.add(this.generateLoyaltyTierAdjustment(lr.Reward_Tier__c, lr.Id));
                lr.Loyalty_Enrolled_Date__c = csvLr.Loyalty_Enrolled_Date__c;
                lr.Loyalty_Enrolled__c = true;
                sCodeToLoyaltyRewardRecords.remove(lr.Account__r.SAP_ACCOUNT_ID__c);
            }
            if(existingLoyaltyRewards.size() > 0){
                Database.SaveResult[] updateSaveResults = Database.update(existingLoyaltyRewards, false);  
                for(Database.SaveResult sr:updateSaveResults){
                    Loyalty_Rewards__c currLR = existingLoyaltyRewardsMap.get(sr.id);
                    if(sr.success){
                        loyUpdateIdSuccesses.add(currLR);
                    }else{
                        loyUpdateErrorSAPToSaveRes.put(currLR.Account__r.SAP_ACCOUNT_ID__c, sr);
                    }
                }
            }
            
            Map<String,String> accountSCodeToId = new Map<String,String>();
            for(Account acc: [SELECT Id,SAP_ACCOUNT_ID__c FROM Account WHERE SAP_ACCOUNT_ID__c IN: existingSCodes]){
                accountSCodeToId.put(acc.SAP_ACCOUNT_ID__c.toUpperCase(), acc.Id);
            }
            List<sObject> newLoyaltyRewardRecords = new List<sObject>();
            for(String sCode:sCodeToLoyaltyRewardRecords.keySet()){
                if(sCodeToLoyaltyRewardRecords.get(sCode) == null){  
                    continue;
                }
                if(accountSCodeToId.containsKey(sCode)){
                    sObject loyaltyReward = sCodeToLoyaltyRewardRecords.get(sCode);
                    loyaltyReward?.put('Account__c',accountSCodeToId.get(sCode));
                    loyaltyReward?.put('Loyalty_Enrolled__c',true);
                    newLoyaltyRewardRecords.add(loyaltyReward);
                }else{
                    this.dataLoaderResults.addTableRow(this.ERRORS_STRING, new Map<String,String>{
                        this.ERRORS_COLUMNS.get(0) => sCode,
                        this.ERRORS_COLUMNS.get(1) => 'N/A',
                        this.ERRORS_COLUMNS.get(2) => 'sCode not found'
                    });
                }
            }
            
            if(newLoyaltyRewardRecords.size() > 0){
                Database.SaveResult[] insertLoyaltySaveResults = Database.insert(newLoyaltyRewardRecords,false);
                Integer errorCounter = 0;
                for(Database.SaveResult sr:insertLoyaltySaveResults){
                    Loyalty_Rewards__c currLR = (Loyalty_Rewards__c) getLoyaltyRewardById(sr.id, newLoyaltyRewardRecords);
                    currLR = currLR == null ? new Loyalty_Rewards__c(Id = sr.id) : currLR;
                    if(sr.success){
                        loyInsertIdSuccesses.add(currLR);
                    }else{
                        errorCounter += 1;
                        loyInsertErrorSAPToSaveRes.put('Unknown SAP ' + errorCounter, sr);
                    }
                }
            }
            for(sObject loyaltyReward:newLoyaltyRewardRecords){
                Loyalty_Rewards__c currLr = (Loyalty_Rewards__c) loyaltyReward;
                loyaltyTierAdjustmentsToInsert.add(this.generateLoyaltyTierAdjustment(currLr.Reward_Tier__c, currLr.Id));
            }
            if(loyaltyTierAdjustmentsToInsert.size() > 0){
                Database.SaveResult[] insertTierAdjustmentsSaveResults = Database.insert(loyaltyTierAdjustmentsToInsert, false);
                Map<Id,Loyalty_Tier_Adjustments__c> idToLta = new Map<Id,Loyalty_Tier_Adjustments__c>(loyaltyTierAdjustmentsToInsert);
                Map<Id,Loyalty_Tier_Adjustments__c> successfulLtaInserts = new Map<Id,Loyalty_Tier_Adjustments__c>();
                Map<String,Database.SaveResult> sCodeToFailedLta = new Map<String,Database.SaveResult>();
                for(Database.SaveResult sr:insertTierAdjustmentsSaveResults){
                    Loyalty_Tier_Adjustments__c currLta = idToLta.get(sr.id);
                    if(sr.success){
                        successfulLtaInserts.put(sr.id, currLta);
                    }else{
                        sCodeToFailedLta.put(existingLoyaltyRewardsMap.get(currLta.Loyalty_Rewards__c).Account__r.SAP_ACCOUNT_ID__c, sr);
                    }
                }
                Map<Id,Loyalty_Rewards__c> loyRewUpdateSuccessMap = new Map<Id,Loyalty_Rewards__c>(loyUpdateIdSuccesses);
                Map<Id,Loyalty_Rewards__c> loyRewInsertSuccessMap = new Map<Id,Loyalty_Rewards__c>(loyInsertIdSuccesses);
                Set<Id> allLrIds = new Set<Id>();
                for(Id updateId:loyRewUpdateSuccessMap.keySet()){
                    allLrIds.add(updateId);
                }
                for(Id insertId:loyRewInsertSuccessMap.keySet()){
                    allLrIds.add(insertId);
                }
                //allLrIds.addAll(loyRewInsertSuccessMap.keySet());
                Map<Id,Loyalty_Rewards__c> allSuccessfulLrs = new Map<Id,Loyalty_Rewards__c>([SELECT Id, Account__c, Account__r.SAP_ACCOUNT_ID__c FROM Loyalty_Rewards__c WHERE Id IN: allLrIds]);
                for(Id ltaId:successfulLtaInserts.keySet()){
                    Loyalty_Tier_Adjustments__c lta = successfulLtaInserts.get(ltaId);
                    Loyalty_Rewards__c lr = null;
                    Boolean isUpdate = false;
                    if(loyRewInsertSuccessMap.containsKey(lta.Loyalty_Rewards__c)){
                        lr = loyRewInsertSuccessMap.remove(lta.Loyalty_Rewards__c);
                    }
                    if(loyRewUpdateSuccessMap.containsKey(lta.Loyalty_Rewards__c)){
                        lr = loyRewUpdateSuccessMap.remove(lta.Loyalty_Rewards__c);
                        isUpdate = true;
                    }
                    if(lr == null) continue;
                    String tableToUpdate = isUpdate ? this.UPDATED_STRING:this.INSERTED_STRING;
                    List<String> columns = isUpdate ? this.UPDATED_COLUMNS:this.INSERTED_COLUMNS;
                    Loyalty_Rewards__c fullDataLr = allSuccessfulLrs.get(lr.Id);
                    String changeRewardTierTo = lta.Change_Reward_Tier_To__c.capitalize();
                    this.dataLoaderResults.addTableRow(tableToUpdate, new Map<String,String>{
                        columns.get(0) => fullDataLr.Account__c,
                        columns.get(1) => fullDataLr.Account__r.SAP_ACCOUNT_ID__c,
                        columns.get(2) => fullDataLr.Id,
                        columns.get(3) => lta.Id,
                        columns.get(4) => lta.Change_Reward_Tier_To__c.trim().capitalize()
                    });
                }
                for(Id lrInsertId:loyRewInsertSuccessMap.keySet()){
                    Loyalty_Rewards__c lr = loyRewInsertSuccessMap.remove(lrInsertId);
                    if(lr == null) continue;
                    Loyalty_Rewards__c fullDataLr = allSuccessfulLrs.get(lr.Id);
                    this.dataLoaderResults.addTableRow(this.INSERTED_STRING, new Map<String,String>{
                        this.INSERTED_COLUMNS.get(0) => fullDataLr.Account__c,
                        this.INSERTED_COLUMNS.get(1) => fullDataLr.Account__r.SAP_ACCOUNT_ID__c,
                        this.INSERTED_COLUMNS.get(2) => fullDataLr.Id,
                        this.INSERTED_COLUMNS.get(3) => 'Tier Adjustment did not insert correctly',
                        this.INSERTED_COLUMNS.get(4) => 'Tier Adjustment did not insert correctly'
                    });
                }
                for(Id lrUpdatedId:loyRewUpdateSuccessMap.keySet()){
                    Loyalty_Rewards__c lr = loyRewUpdateSuccessMap.remove(lrUpdatedId);
                    if(lr == null) continue;
                    Loyalty_Rewards__c fullDataLr = allSuccessfulLrs.get(lr.Id);
                    this.dataLoaderResults.addTableRow(this.UPDATED_STRING, new Map<String,String>{
                        this.UPDATED_COLUMNS.get(0) => fullDataLr.Account__c,
                        this.UPDATED_COLUMNS.get(1) => fullDataLr.Account__r.SAP_ACCOUNT_ID__c,
                        this.UPDATED_COLUMNS.get(2) => fullDataLr.Id,
                        this.UPDATED_COLUMNS.get(3) => 'Tier Adjustment did not insert correctly',
                        this.UPDATED_COLUMNS.get(4) => 'Tier Adjustment did not insert correctly'
                    });
                }
                Map<String,Database.SaveResult> allErrors = new Map<String,Database.SaveResult>();
                allErrors.putAll(sCodeToFailedLta);
                allErrors.putAll(loyUpdateErrorSAPToSaveRes);
                allErrors.putAll(loyInsertErrorSAPToSaveRes);
                for(String sCode:allErrors.keySet()){
                    Database.SaveResult sr = allErrors.get(sCode);
                    if(sr == null) continue;
                    this.dataLoaderResults.addTableRow(this.ERRORS_STRING, new Map<String,String>{
                        this.ERRORS_COLUMNS.get(0) => sCode,
                        this.ERRORS_COLUMNS.get(1) => String.join(sr.getErrors().get(0).getFields(),','),
                        this.ERRORS_COLUMNS.get(2) => sr.getErrors().get(0).getMessage()
                    });
                }
                String allErrorsString = String.join(this.dataLoaderResults.getSetOfValuesInColumn(this.ERRORS_STRING, this.ERROR_MSG_STRING), '; ');
                if(String.isNotBlank(allErrorsString)){
                    ErrorHandler.handleException(new ErrorHandler.ErrorDataContainer(
                        ErrorOriginType.APEX_CLASS,
                        'LoyaltyProcedureStrategy',
                        'executeDataLoad',
                        new Map<String,Object>{
                            'sCodes of Failures' => this.dataLoaderResults.getSetOfValuesInColumn(this.ERRORS_STRING,'')
                        },
                        'Error when data loading for Loyalty data loader procedure.',
                        allErrorsString,
                        '',
                        'Internal Data Loader',
                        'Loyalty Tier Adjustments'
                    ));
                }
            }
            return this.dataLoaderResults.getAuraResults();
        }catch(CSVParser.InvalidHeaderException invalidHeaderError){
            throw new AuraHandledException('INVALID CSV HEADERS: Please make sure your csv headers are as follows: "ID", "Name", "Reward Tier", and "Loyalty Enrolled Date" and try again.');
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage() + ' TRACE: ' + e.getStackTraceString());
        }
    }

    private Loyalty_Tier_Adjustments__c generateLoyaltyTierAdjustment(String newRewardTier, String loyaltyRewardsId){
        return new Loyalty_Tier_Adjustments__c(
            Loyalty_Rewards__c = loyaltyRewardsId,
            Change_Reward_Tier_To__c = newRewardTier,
            Date__c = Date.today(),
            Reason__c = 'Data loaded via Loyalty Data loader procedure.'
        );
    }

    private sObject getLoyaltyRewardById(Id id, List<sObject> loyaltyRewards){
        for(sObject lr:loyaltyRewards){
            if(lr.get('Id') == id){
                return lr;
            }
        }
        return null;
    }

    private void handleTablePopulation(Database.SaveResult[] saveResults, Boolean isUpdate){

    }
}