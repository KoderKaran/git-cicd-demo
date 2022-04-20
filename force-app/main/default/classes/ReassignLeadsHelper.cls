public class ReassignLeadsHelper {

    public static Lead assignLeadTerr(Lead thisLead) {
        Map<String, String> fieldLabelToNameMap = GlobalVariables.fieldLabelToNameMap;
        List<Lead_Territory__c> allLeadTerritories = [
            SELECT Id, Name, Type__c, 
                LastLeadAssignment__c, Assigned_To__c,
                Assigned_To_ID__c, Assigned_To_Type__c, Order__c, 
            (SELECT Lead_Territory__c, Country__c,
                State__c, Zip_End__c, Zip_Start__c
                FROM Lead_Territory_Geographies__r ORDER BY Country__c, State__c),
            (SELECT Lead_Territory__c, Lead_Field__c, Operator__c, Value__c FROM Lead_Territory_Field_Criteria__r ORDER BY Lead_Field__c)
            FROM Lead_Territory__c
            ORDER BY Order__c
        ];

        for(Lead_Territory__c leadTerritory : allLeadTerritories) {
            if( leadTerritory.Lead_Territory_Geographies__r.size() > 0 || leadTerritory.Lead_Territory_Field_Criteria__r.size() > 0 ) {
                Boolean isMatchTerField = false;
                Boolean isFindTerritory = false;
                if(leadTerritory.Lead_Territory_Geographies__r.size() == 0) {
                    isFindTerritory = true;
                } else {
                    String country = thisLead.Country != null ? thisLead.Country.toLowerCase() : '';
                    String state = thisLead.State != null ? thisLead.State.toLowerCase() : '';
                    String postalCode = thisLead.PostalCode != null ? thisLead.PostalCode.toLowerCase() : '';
                    String countryState = country + '/' + state;
                    String justCountry = country + '/';
                    map<String, List<Lead_Territory_Geography__c>> countryStateToGeosMap = new map<String, List<Lead_Territory_Geography__c>>();
                    Boolean justCountryGeo = false;
                    
                    for(Lead_Territory_Geography__c leadgeo : leadTerritory.Lead_Territory_Geographies__r) {
                        String theCountryState = (leadgeo.Country__c != null ? leadgeo.Country__c.toLowerCase() : '') + '/' + (leadgeo.State__c != null?leadgeo.State__c.toLowerCase():'');
                        if(countryStateToGeosMap.containsKey(theCountryState)) {
                            countryStateToGeosMap.get(theCountryState).add(leadgeo);
                        } else {
                            countryStateToGeosMap.put(theCountryState, new List<Lead_Territory_Geography__c> {leadgeo});
                        }
                    }
                    
                    String theMapKey = countryState;

                    if(countryStateToGeosMap.containsKey(justCountry)) {
                        theMapKey = justCountry;
                    }
                    List<Lead_Territory_Geography__c> theCountryStateGeos = countryStateToGeosMap.get(theMapKey);
                    system.debug('###' + theCountryStateGeos);

                    if(theCountryStateGeos != null && !theCountryStateGeos.isEmpty()) {
                        for(Lead_Territory_Geography__c theCountryStateGeo : theCountryStateGeos) {
                            if(isInPostalRange(thisLead.PostalCode, theCountryStateGeo.Zip_Start__c, theCountryStateGeo.Zip_End__c)) {
                                isFindTerritory = true;
                                break;
                            }
                        }
                    }
                }

                system.debug('###' + isFindTerritory);
                if(isFindTerritory) {
                    if(leadTerritory.Lead_Territory_Field_Criteria__r.size() == 0) {
                        isMatchTerField = true;
                    } else {
                        Boolean isPassTheFieldCriteria = true;
                        for(Lead_Territory_Field_Criteria__c criteria: leadTerritory.Lead_Territory_Field_Criteria__r) {
                            String thisFieldName = criteria.Lead_Field__c; //fieldLabelToNameMap.get(criteria.Lead_Field__c);
                            //STring thisFieldValue = thisLead.get(thisFieldName);
                            Schema.DisplayType type = GlobalVariables.FieldTypeMap.get(thisFieldName);
                            if(type == Schema.DisplayType.Boolean) {
                                Boolean criteriaValue = criteria.Value__c == null || criteria.Value__c.toLowerCase() == 'false' ? false : true;
                                Boolean fieldValue = Boolean.valueOf(thisLead.get(thisFieldName));
                                if(criteria.Operator__c.toLowerCase() == 'equals' && fieldValue != criteriaValue) {
                                    isPassTheFieldCriteria = false;
                                } else if(criteria.Operator__c.toLowerCase() == 'not equal to' && fieldValue == criteriaValue) {
                                    isPassTheFieldCriteria = false;
                                }
                            } else if(type == Schema.DisplayType.Currency || type == Schema.DisplayType.Integer || type == Schema.DisplayType.Percent || type == Schema.DisplayType.Double) {
                                try {
                                    Decimal criteriaValue = criteria.Value__c == null ? null : Decimal.valueOf(criteria.Value__c);
                                    Decimal fieldValue = thisLead.get(thisFieldName) == null ? null : Decimal.valueOf(Double.valueOf(thisLead.get(thisFieldName)));
                                    if(criteria.Operator__c.toLowerCase() == 'equals' && fieldValue != criteriaValue) {
                                        isPassTheFieldCriteria = false;
                                    } else if(criteria.Operator__c.toLowerCase() == 'not equal to' && fieldValue == criteriaValue) {
                                        isPassTheFieldCriteria = false;
                                    }
                                } catch(Exception ex) {
                                    isPassTheFieldCriteria = false;
                                }
                            } else if(type == Schema.DisplayType.DateTime) {
                                DateTime criteriaValue = null;
                                if(criteria.Value__c != null) {
                                    String[] dates = criteria.Value__c.split('/');
                                    criteriaValue = DateTime.newInstance(Integer.valueOf(dates[2]), Integer.valueOf(dates[0]), Integer.valueOf(dates[1]));
                                }

                                DateTime fieldValue = thisLead.get(thisFieldName) == null ? null : DateTime.valueOf(thisLead.get(thisFieldName));
                                if(criteria.Operator__c.toLowerCase() == 'equals' && fieldValue != criteriaValue) {
                                    isPassTheFieldCriteria = false;
                                } else if(criteria.Operator__c.toLowerCase() == 'not equal to' && fieldValue == criteriaValue) {
                                    isPassTheFieldCriteria = false;
                                }                                
                            }
                            else if(type == Schema.DisplayType.Date) {
                                Date criteriaValue = null;
                                if(criteria.Value__c != null) {
                                    String[] dates = criteria.Value__c.split('/');
                                    criteriaValue = Date.newInstance(Integer.valueOf(dates[2]), Integer.valueOf(dates[0]), Integer.valueOf(dates[1]));
                                }

                                Date fieldValue = thisLead.get(thisFieldName) == null ? null : Date.valueOf(thisLead.get(thisFieldName));
                                if(criteria.Operator__c.toLowerCase() == 'equals' && fieldValue != criteriaValue) {
                                    isPassTheFieldCriteria = false;
                                } else if(criteria.Operator__c.toLowerCase() == 'not equal to' && fieldValue == criteriaValue) {
                                    isPassTheFieldCriteria = false;
                                }
                            } else {
                                String criteriaValue = criteria.Value__c == null ? '' : criteria.Value__c.trim().toLowerCase();
                                String fieldValue = thisLead.get(thisFieldName) == null ? '' : String.valueOf(thisLead.get(thisFieldName)).trim().toLowerCase();
                                Set<String> values = new Set<String>();
                                
                                for(String value : criteriaValue.split(',')) {
                                    values.add(value.trim().toLowerCase());
                                }

                                system.debug('###1' + fieldValue);
                                system.debug('###2' + values);

                                if(criteria.Operator__c.toLowerCase() == 'equals' && !values.contains(fieldValue)) {
                                    isPassTheFieldCriteria = false;
                                } else if(criteria.Operator__c.toLowerCase() == 'not equal to' && values.contains(fieldValue)) {
                                    isPassTheFieldCriteria = false;
                                }
                            }

                            if(!isPassTheFieldCriteria) {
                                break;
                            }
                        }
                        isMatchTerField = isPassTheFieldCriteria;
                    }
                }

                if(isMatchTerField && isFindTerritory ) {
                    if(leadTerritory.Type__c == 'Round Robin') {
                        leadTerritory = [SELECT Id, Assigned_To_ID__c, LastLeadAssignment__c FROM Lead_Territory__c where Name =:leadTerritory.Name  ORDER BY LastLeadAssignment__c asc limit 1];                        
                    }

                    thisLead.Lead_Territory__c = leadTerritory.Id;
                    Id leadNewOwnerId = leadTerritory.Assigned_To_ID__c;                    
                    thisLead.OwnerId = leadNewOwnerId;  
                    leadTerritory.LastLeadAssignment__c = datetime.now(); 
                    update leadTerritory;                                                       
                    break;
                }
            }            
        }
        thisLead.Run_Lead_Assignment__c = false;
        
        return thisLead;
    }
    
    @TestVisible
     private static Boolean isInPostalRange(String postalCode, String postalStart, String postalEnd) {
        if(postalStart == null && postalEnd == null) {
            return true;
        }
        
        if(postalCode == null) {
            return false;
        }            
        
        if(postalStart != null && postalEnd != null) {
            return (postalCode.compareTo(postalStart) >= 0 && postalCode.compareTo(postalEnd) <= 0); 
        }

        return false;        
    }
}