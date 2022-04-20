global class BuildScorecard implements Schedulable {
    public Date startD;
    public Date endD;
    global void execute(SchedulableContext ctx) {
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :ctx.getTriggerId()];
        
        System.debug(ct.CronExpression);
        System.debug(ct.TimesTriggered);
        
        updateScorecards();
    }
    
    // All dates are built from this period record, governs all selection timeline
    public static Period getYesterdayQuarterPeriod(){
        // Pull quarter boundaries from Period table using Yesterday's date to ensure calculations are wrapped up correctly
        Period p = [SELECT EndDate,StartDate FROM Period 
                    where Type = 'Quarter' AND StartDate <= YESTERDAY AND EndDate >= YESTERDAY];
        return p;
    }
    
    // Master method pulls together all the pieces
    public static void updateScorecards(){
        // Get Yesterday's quarter start and end
        Period p = getYesterdayQuarterPeriod();
        // Build scorecards using the selected period
        Map<Id, Scorecard__c> sc = buildScorecardForPeriod(p);
        Upsert sc.values();
    }
    
    // Receives Period object with Start and End dates set. Can be run separately to rebuild historical scorecards
    public static Map<Id, Scorecard__c> buildScorecardForPeriod(Period p){
        // Get existing scorecard records for target period
        // populate in map by owner id
        Map<Id, Scorecard__c> sc = getScorecards(p);
        // Populate scorecard field values with various data collected across the system
        sc = populatePurchaseHistory(p, sc);
        sc = populateNewDealer(p, sc);
        sc = populateDealerVisit(p, sc);
        sc = populateDealerCall(p, sc);
        
        // Normalize all null values to 0 if they didn't get assigned in processing
        // accounting for records that had value on previous run and may not anymore (deletions, ownership changes, unknown ect...)
        for(Id i : sc.keySet()){
            Scorecard__c s = sc.get(i);
            try{
                if(s.Dealer_Calls__c == null)
                    s.Dealer_Calls__c = 0;
            } catch (Exception e){
                s.Dealer_Calls__c = 0;
            }
                
            try{
                if(s.Dealer_Visits__c == null)
                    s.Dealer_Visits__c = 0;
            } catch (Exception e){
                s.Dealer_Visits__c = 0;
            }
            
            try{
                if(s.New_Dealers__c == null)
                    s.New_Dealers__c = 0;
            } catch (Exception e){
                s.New_Dealers__c = 0;
            }
                
            try{
                if(s.Revenue__c == null)
                    s.Revenue__c = 0;
            } catch (Exception e){
                s.Revenue__c = 0;
            }
            sc.put(i, s);
        }
        
        return sc;
    }
    
    // Pull Scorecards from the database for the given period intentionally not pulling back field values as they will be reset
    public static Map<Id,Scorecard__c> getScorecards(Period p){
        List<Scorecard__c> scl = [select Id, OwnerId from Scorecard__c where Start_Date__c = :p.StartDate AND End_Date__c = :p.EndDate];
        Map<Id,Scorecard__c> sc = new Map<Id,Scorecard__c>();
        for(Scorecard__c scrd: scl)
            sc.put(scrd.OwnerId, scrd);
        
        return sc;
    }

	// Get Purchase History records (imported from ERP) for the given period    
    public static Map<Id,Decimal> getPurchaseHistoryMap(Period p){
        List<AggregateResult> ar = [SELECT Account__r.OwnerId ownid, SUM(Amount__c) tot FROM Customer_Purchase_History__c 
                                    WHERE Start_Date__c >= :p.StartDate AND End_Date__c <= :p.EndDate
                                    GROUP BY Account__r.OwnerId];
        Map<Id, Decimal> rMap = new Map<Id, Decimal>();
        
        for(AggregateResult c: ar){
            rMap.put((Id)c.get('ownid'), (Decimal)c.get('tot'));
        }
        return rMap;
    }
    
    // Update Scorecard with purchase records pulled from the database
    public static Map<Id,Scorecard__c> populatePurchaseHistory(Period p, Map<Id,Scorecard__c> sc){
        Map<Id, Decimal> purchHist = getPurchaseHistoryMap(p);
        Scorecard__c s;
        for(Id i : purchHist.keySet()){
            if(sc.containsKey(i))
                s = sc.get(i);
            else
                s = new Scorecard__c(OwnerId = i, Start_Date__c = p.StartDate, End_Date__c = p.EndDate);
            s.Revenue__c = purchHist.get(i);
            sc.put(i, s);
        }
        
        return sc;
    }
    
    // Pull new dealer records by account owner
    public static Map<Id,Decimal> getNewDealerMap(Period p){
        List<AggregateResult> ar = [SELECT OwnerId ownid, count(Id) tot FROM Account 
                                    WHERE First_Order_Date__c >= :p.StartDate AND First_Order_Date__c <= :p.EndDate
                                    GROUP BY OwnerId];
        Map<Id, Decimal> rMap = new Map<Id, Decimal>();
        
        for(AggregateResult c: ar){
            rMap.put((Id)c.get('ownid'), (Decimal)c.get('tot'));
        }
        return rMap;
    }
    
    // Populate New Dealers on scorecard with data from database
    public static Map<Id,Scorecard__c> populateNewDealer(Period p, Map<Id,Scorecard__c> sc){
        Map<Id, Decimal> dealerCount = getNewDealerMap(p);
        Scorecard__c s;
        for(Id i : dealerCount.keySet()){
            if(sc.containsKey(i))
                s = sc.get(i);
            else
                s = new Scorecard__c(OwnerId = i, Start_Date__c = p.StartDate, End_Date__c = p.EndDate);
            s.New_Dealers__c = dealerCount.get(i);
            sc.put(i, s);
        }
        
        return sc;
    }
    
    // Pull Dealer Visits from database
    // TODO: verify if should be by unique account, once per dealer
    public static Map<Id,Decimal> getDealerVisitMap(Period p){
        List<AggregateResult> ar = [SELECT OwnerId ownid, COUNT_DISTINCT(Account__c) tot FROM Sales_Notes__c 
                                    WHERE CreatedDate >= :p.StartDate AND CreatedDate <= :p.EndDate
                                    AND Name = 'Dealer Visit'
                                    GROUP BY OwnerId];
        Map<Id, Decimal> rMap = new Map<Id, Decimal>();
        
        for(AggregateResult c: ar){
            rMap.put((Id)c.get('ownid'), (Decimal)c.get('tot'));
        }
        return rMap;
    }
    
    // Popular Dealer Visits on Scorecard
    public static Map<Id,Scorecard__c> populateDealerVisit(Period p, Map<Id,Scorecard__c> sc){
        // populate scorecards with values from map, creating record if needed
        Map<Id, Decimal> visitCount = getDealerVisitMap(p);
        Scorecard__c s;
        for(Id i : visitCount.keySet()){
            if(sc.containsKey(i))
                s = sc.get(i);
            else
                s = new Scorecard__c(OwnerId = i, Start_Date__c = p.StartDate, End_Date__c = p.EndDate);
            s.Dealer_Visits__c = visitCount.get(i);
            sc.put(i, s);
        }
        
        return sc;
    }

	// Get Call history from database
    public static Map<Id,Decimal> getDealerCallMap(Period p){
        // TODO: May need some consideration for archived activities
        List<AggregateResult> ar = [SELECT OwnerId ownid, COUNT_DISTINCT(WhatId) tot FROM Task 
                                    WHERE ActivityDate >= :p.StartDate AND ActivityDate <= :p.EndDate
                                    AND ActivityDate != null
                                    AND WhatId != null
                                    AND Subject = 'Call'
                                    GROUP BY OwnerId];
        Map<Id, Decimal> rMap = new Map<Id, Decimal>();
        
        for(AggregateResult c: ar){
            rMap.put((Id)c.get('ownid'), (Decimal)c.get('tot'));
        }
        return rMap;
    }
    
    // Populate Dealer Calls on scorecard
    public static Map<Id,Scorecard__c> populateDealerCall(Period p, Map<Id,Scorecard__c> sc){
        // populate scorecards with values from map, creating record if needed
        Map<Id, Decimal> callCount = getDealerCallMap(p);
        Scorecard__c s;
        for(Id i : callCount.keySet()){
            if(sc.containsKey(i))
                s = sc.get(i);
            else
                s = new Scorecard__c(OwnerId = i, Start_Date__c = p.StartDate, End_Date__c = p.EndDate);
            s.Dealer_Calls__c = callCount.get(i);
            sc.put(i, s);
        }
        return sc;
    }
}