trigger LeadTracking on Lead (before update) {
    List<Lead> leadList = new List<Lead>();
     for (Lead newld : Trigger.new) 
     {
         Lead ldold = Trigger.oldmap.get(newld.id);
         System.Debug('newld.Status: '+newld.Status+' ldold.Status: '+ldold.Status); 
         if(newld.Id == ldold.Id && newld.Status != ldold.Status && newld.RecordTypeId == '012500000005dac')
         {
             System.Debug('newld.Status: '+newld.Status+' ldold.Status: '+ldold.Status); 
             if(ldold.Status == 'Sent To Dealer'){newld.Sent_To_Dealer_End_Date__c = Date.today();}
             if(ldold.Status == 'Opportunity Created'){newld.Opportunity_Created_End_Date__c = Date.today();}
             if(ldold.Status == 'Installed'){newld.Installed_End_Date__c = Date.today();}
             if(ldold.Status == 'Term Lead'){newld.Term_Lead_End_Date__c = Date.today();}
             if(ldold.Status == 'Renewed Interest'){newld.Renewed_Interest_End_Date__c = Date.today();}
             if(ldold.Status == 'New'){newld.New_End_Date__c = Date.today();}
             if(ldold.Status == 'Attempting Contact'){newld.Attempting_Contact_End_Date__c = Date.today();}
             if(newld.Status == 'Attempting Contact')
             {
                 newld.Status_Previous_Value__c = ldold.Status;
                 newld.Attempting_Contact_Start_Date__c  = Date.today();
             }
             if(newld.Status == 'Sent To Dealer')
             {
                 newld.Status_Previous_Value__c = ldold.Status;
                 newld.Sent_To_Dealer_Start_Date__c  = Date.today();
             }
             if(newld.Status == 'Opportunity Created')
             {
                 newld.Status_Previous_Value__c = ldold.Status;
                 newld.Opportunity_Created_Start_Date__c  = Date.today();
             }
             if(newld.Status == 'Installed')
             {
                 newld.Status_Previous_Value__c = ldold.Status;
                 newld.Installed_Start_Date__c  = Date.today();
             }
             if(newld.Status == 'Term Lead')
             {
                 newld.Status_Previous_Value__c = ldold.Status;
                 newld.Term_Lead_Start_Date__c  = Date.today();
             }
             if(newld.Status == 'Renewed Interest')
             {
                 newld.Status_Previous_Value__c = ldold.Status;
                 newld.Renewed_Interest_Start_Date__c  = Date.today();
             }
             
             
         } 
     }
    
}