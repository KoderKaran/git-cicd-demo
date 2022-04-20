trigger LeadDesignTrigger on Lead (after insert, before insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert){
        LeadDesignTriggerHandler.LeadDesign(Trigger.new);
    }
    if(Trigger.isBefore){
        LeadDesignTriggerHandler.CheckLeadFields(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        LeadDesignTriggerHandler.ConvertedUpdField(Trigger.new);
    }
    
}