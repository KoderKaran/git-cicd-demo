/**
 * @File Name          : LoyaltyRewardsTrigger
 * @Description        : Trigger that calls LoyaltyRewardsTriggerHandler
 * @Author             : Mozart Labao
 * @Last Modified By   : Mozart Labao
 * @Last Modified On   : 11-22-2021
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    11/11/2021  	 		Mozart			       Initial Version
**/
trigger LoyaltyRewardsTrigger on Loyalty_Rewards__c (after update) {
    
    if(Trigger.isafter){
        if( Trigger.isupdate){
            try{
                LoyaltyRewardsTriggerHandler.updateLoyaltyTierAdjustment(Trigger.new,Trigger.oldMap);
            }catch(Exception e){
                ErrorHandler.handleException(new ErrorHandler.ErrorDataContainer(
                    ErrorOriginType.APEX_TRIGGER,
                    'LoyaltyRewardsTrigger',
                    'In line number' + e.getLineNumber() + ', in the after update context',
                    new Map<String,Object>{'Trigger.new'=>Trigger.new,'Trigger.oldMap'=>Trigger.oldMap},
                    e.getTypeName(),
                    e.getMessage(),
                    e.getStackTraceString(),
                    'Loyalty',
                    'Loyalty_Rewards__c'
                ));
            }
            
        }
    }

}