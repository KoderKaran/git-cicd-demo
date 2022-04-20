trigger createAssetPrimaryController on Account (after insert, after update) {
    List<Account> accountList = trigger.new;
    List<String> accountIdList = new List<String>();

    // Loop through the account objects and add the IDs to
    // a list so that all of the associating assets can be queried
    for(Account acc : accountList){
        accountIdList.add(acc.Id);
    }

    // Get list of related assets
    List<Asset> assetList = [SELECT Id, Name, AccountId FROM Asset WHERE AccountId IN :accountIdList];
    // Stores the account ID and the asset so the correct asset can easily be accessed
    Map<String, Map<String, Asset>> assetMap = new Map<String, Map<String, Asset>>();
    // Stores the assets that need to be upserted
    List<Asset> upsertAsset = new List<Asset>();

    // Loop through the asset list and add the account Id and asset to the map
    for(Asset a : assetList){
        if(assetMap.containsKey(a.AccountId)){
            assetMap.get(a.AccountId).put(a.Name, a);
        } else {
            assetMap.put(a.AccountId, new Map<String, Asset> {a.Name => a});
        }
    }

    // Loop through the list of accounts and check to see if they have an asset attached
    // to them already, and check to see if there is a MacAddress__pc. If there is an asset
    // already attached update it. If there isn't one and the MacAddress__pc != null then
    // create a new asset.
    for(Account acc : accountList){
        if(acc.MacAddress__pc != null){

            // If the acount has an asset check to see if the MacAddress__pc has changed. If it has,
            // add another asset. If it hasn't, update the asset. If th there are no assets on the account
            // add one.
            if(assetMap.containsKey(acc.Id)){
                Map<String, Asset> mapAsset = assetMap.get(acc.Id);
                // If the mac address has changed, add a new asset to the account
                if(!mapAsset.containsKey(acc.MacAddress__pc)){
                    Asset a = new Asset();
                    a.Name = acc.MacAddress__pc;
                    a.AccountId = acc.Id;
                    a.Controller_Software_Major__c = acc.Controller_Software_Major__pc;
                    a.Controller_Software_Minor__c = acc.Controller_Software_Minor__pc;
                    a.Controller_Software_Patch__c = acc.Controller_Software_Patch__pc;
                    a.Controller_Software_Build__c = acc.Controller_Software_Build__pc;
                    a.Active_Controller__c = acc.Active_Controller__pc;
                    a.Primary_Controller__c = acc.Primary_Controller__pc;
                    a.Controller_Install_Date__c = acc.Controller_Install_Date__pc;
                    a.Controller_Last_Check_In__c = acc.Controller_Last_Check_In__pc;
                    a.OS_Last_Update__c = acc.OS_Last_Update__pc;
                    upsertAsset.add(a);
                } else {
                    Asset asset = mapAsset.get(acc.MacAddress__pc);
                    asset.Controller_Software_Major__c = acc.Controller_Software_Major__pc;
                    asset.Controller_Software_Minor__c = acc.Controller_Software_Minor__pc;
                    asset.Controller_Software_Patch__c = acc.Controller_Software_Patch__pc;
                    asset.Controller_Software_Build__c = acc.Controller_Software_Build__pc;
                    asset.Active_Controller__c = acc.Active_Controller__pc;
                    asset.Primary_Controller__c = acc.Primary_Controller__pc;
                    asset.Controller_Install_Date__c = acc.Controller_Install_Date__pc;
                    asset.Controller_Last_Check_In__c = acc.Controller_Last_Check_In__pc;
                    asset.OS_Last_Update__c = acc.OS_Last_Update__pc;
                    upsertAsset.add(asset);
                }
            } else {
                Asset a = new Asset();
                a.Name = acc.MacAddress__pc;
                a.AccountId = acc.Id;
                a.Controller_Software_Major__c = acc.Controller_Software_Major__pc;
                a.Controller_Software_Minor__c = acc.Controller_Software_Minor__pc;
                a.Controller_Software_Patch__c = acc.Controller_Software_Patch__pc;
                a.Controller_Software_Build__c = acc.Controller_Software_Build__pc;
                a.Active_Controller__c = acc.Active_Controller__pc;
                a.Primary_Controller__c = acc.Primary_Controller__pc;
                a.Controller_Install_Date__c = acc.Controller_Install_Date__pc;
                a.Controller_Last_Check_In__c = acc.Controller_Last_Check_In__pc;
                a.OS_Last_Update__c = acc.OS_Last_Update__pc;
                upsertAsset.add(a);
            }
        }
    }

    if(upsertAsset.size() > 0){
        upsert upsertAsset;
    }   
}