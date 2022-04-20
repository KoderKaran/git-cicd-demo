/**
*   This utility class is used to create bar graph data to display on 'dealerVisitClone' VF page
*  
* ===========================================================================================================
*     Version     Date            Comment
* ===========================================================================================================
*     1.0         21-Apr-2017     - create bar graph data of current year for Daily Dealer Sales Log object
*      
**/
public with sharing class UtilityDailyDealerSalesLogThisYear {

  public List < Daily_Dealer_Sales_Log__c > dailyDealerSalesLogList;

  public Map < String, Decimal > mapSubCategToCountAudio;
  public Map < String, Decimal > mapSubCategToCountControllers;
  public Map < String, Decimal > mapSubCategToCountlighting;
  public Map < String, Decimal > mapSubCategToCountVideo;
  public Map < String, Decimal > mapSubCategToCountPakedge;
  public Map < String, Decimal > mapSubCategToCountClimateControl;
  public Map < String, Decimal > mapSubCategToCountCardAccess;
  public Map < String, Decimal > mapSubCategToCountInterfaceComm;
  public Map < String, Decimal > mapSubCategToCountthirdParty;
  public Map < String, Decimal > mapCategoryToCountTriad;
  public Map < String, Decimal > mapSubCategoryToCountDoorLock;
  public Map < String, Decimal > mapSubCategToCountTriad;
  public Map < String, Decimal > mapSubCategToCountNetworking;
  public Map < String, Decimal > mapSubCategToCountPartnerProduct;

  public Map < String, Decimal > mapCategToCountControllers;
  public Map < String, Decimal > mapCategToCountAudio;
  public Map < String, Decimal > mapCategToCountlighting;
  public Map < String, Decimal > mapCategToCountVideo;
  public Map < String, Decimal > mapCategToCountPakedge;
  public Map < String, Decimal > mapCategToCountClimateControl;
  public Map < String, Decimal > mapCategToCountCardAccess;
  public Map < String, Decimal > mapCategToCountInterfaceComm;
  public Map < String, Decimal > mapCategToCountTriad;
  public Map < String, Decimal > mapCategoryToCountDoorLock;
  public Map < String, Decimal > mapCategoryToCountThirdParty;
  public Map < String, Decimal > mapCategoryToCountCardAccess;
  public Map < String, Decimal > mapCategoryToCountNetworking;
  public Map < String, Decimal > mapCategoryToCountPartnerProduct;

  public Account accID;

  public UtilityDailyDealerSalesLogThisYear() {
    accID = new Account();
  }

  public void fetchDailyDealerSalesLog(){
    dailyDealerSalesLogList = [select Sales_Date__c, Dealer_Sales_Category__c, Dealer_Sales_Sub_Category__c, Quantity__c, Total_Cost__c
                               from Daily_Dealer_Sales_Log__c
                               where Dealer__c =: accID.ID
                               AND Sales_Date__c != null AND Sales_Date__c = THIS_YEAR
                               order by Sales_Date__c
    ];
  }

  // Method to map values of 'Audio' and its SubProducts
  public void audioStackedData() {
    mapSubCategToCountAudio = new Map < String, Decimal > ();
    mapCategToCountAudio = new Map < String, Decimal > ();
    Decimal currentTotalCost1 = 0.0;
    Decimal currentQuantity1 = 0.0;

    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Audio') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c) || objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategToCountAudio.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategToCountAudio.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountAudio.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountAudio.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountAudio.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountAudio.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountAudio.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountAudio.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountAudio.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Audio' and its SubProducts from map
  public List < StackedListData > AudioStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountAudio.isEmpty()) {
      for (String key: mapSubCategToCountAudio.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountAudio.get(key)));
      }
    }
    if (!mapCategToCountAudio.isEmpty()) {
      for (String key: mapCategToCountAudio.keySet()) {
        listPieData.add(new StackedListData(key, mapCategToCountAudio.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Controllers' and its SubProducts
  public void controllersStackedData() {
    mapSubCategToCountControllers = new Map < String, Decimal > ();
    mapCategToCountControllers = new Map < String, Decimal > ();
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Controllers') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              Decimal currentTotalCost1 = 0.0;
              currentTotalCost1 = objDealerSalesLog.Total_Cost__c;
              mapCategToCountControllers.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              Decimal currentQuantity1 = 0.0;
              currentQuantity1 = objDealerSalesLog.Quantity__c;
              mapCategToCountControllers.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountControllers.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountControllers.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountControllers.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentQuantity = mapSubCategToCountControllers.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountControllers.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentTotalCost = mapSubCategToCountControllers.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Quantity__c;
                mapSubCategToCountControllers.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Controllers' and its SubProducts from map
  public List < StackedListData > ControllersStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountControllers.isEmpty()) {
      for (String key: mapSubCategToCountControllers.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountControllers.get(key)));
      }
    }
    if (!mapCategToCountControllers.isEmpty()) {
      for (String key: mapCategToCountControllers.keySet()) {
        listPieData.add(new StackedListData(key, mapCategToCountControllers.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Video' and its SubProducts
  public void videoStackedData() {
    mapSubCategToCountVideo = new Map < String, Decimal > ();
    mapCategToCountVideo = new Map < String, Decimal > ();
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Video') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              Decimal currentTotalCost1 = 0.0;
              currentTotalCost1 = objDealerSalesLog.Total_Cost__c;
              mapCategToCountVideo.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              Decimal currentQuantity1 = 0.0;
              currentQuantity1 = objDealerSalesLog.Total_Cost__c;
              mapCategToCountVideo.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountVideo.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountVideo.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountVideo.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountVideo.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountVideo.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountVideo.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountVideo.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Video' and its SubProducts from map
  public List < StackedListData > VideoStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountVideo.isEmpty()) {
      for (String key: mapSubCategToCountVideo.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountVideo.get(key)));
      }
    }
    if (!mapCategToCountVideo.isEmpty()) {
      for (String key: mapCategToCountVideo.keySet()) {
        listPieData.add(new StackedListData(key, mapCategToCountVideo.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'lighting' and its SubProducts
  public void lightingStackedData() {
    mapSubCategToCountlighting = new Map < String, Decimal > ();
    mapCategToCountlighting = new Map < String, Decimal > ();
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Lighting') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              Decimal currentTotalCost1;
              currentTotalCost1 = objDealerSalesLog.Total_Cost__c;
              mapCategToCountlighting.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              Decimal currentQuantity1;
              currentQuantity1 = objDealerSalesLog.Quantity__c;
              mapCategToCountlighting.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountlighting.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountlighting.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountlighting.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountlighting.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountlighting.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountlighting.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountlighting.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'lighting' and its SubProducts from map
  public List < StackedListData > lightingStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountlighting.isEmpty()) {
      for (String key: mapSubCategToCountlighting.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountlighting.get(key)));
      }
    }
    if (!mapCategToCountlighting.isEmpty()) {
      for (String key: mapCategToCountlighting.keySet()) {
        listPieData.add(new StackedListData(key, mapCategToCountlighting.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Climate Control' and its SubProducts
  public void climateControlStackedData() {
    mapSubCategToCountClimateControl = new Map < String, Decimal > ();
    mapCategToCountClimateControl = new Map < String, Decimal > ();
    Decimal currentQuantity1 = 0.0;
    Decimal currentTotalCost1 = 0.0;
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Climate') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategToCountClimateControl.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategToCountClimateControl.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountClimateControl.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountClimateControl.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountClimateControl.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountClimateControl.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountClimateControl.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountClimateControl.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountClimateControl.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Climate Control' and its SubProducts from map
  public List < StackedListData > ClimateControlPieData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountClimateControl.isEmpty()) {
      for (String key: mapSubCategToCountClimateControl.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountClimateControl.get(key)));
      }
    }
    if (!mapCategToCountClimateControl.isEmpty()) {
      for (String key: mapCategToCountClimateControl.keySet()) {
        listPieData.add(new StackedListData(key, mapCategToCountClimateControl.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Pakedge' and its SubProducts
  public void pakedgeStackedData() {
    mapSubCategToCountPakedge = new Map < String, Decimal > ();
    mapCategToCountPakedge = new Map < String, Decimal > ();
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Pakedge') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              Decimal currentTotalCost1;
              currentTotalCost1 = objDealerSalesLog.Total_Cost__c;
              mapCategToCountPakedge.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              Decimal currentQuantity1;
              currentQuantity1 = objDealerSalesLog.Quantity__c;
              mapCategToCountPakedge.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountPakedge.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountPakedge.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountPakedge.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountPakedge.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountPakedge.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountPakedge.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountPakedge.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Pakedge' and its SubProducts from map
  public List < StackedListData > PakedgeStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountPakedge.isEmpty()) {
      for (String key: mapSubCategToCountPakedge.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountPakedge.get(key)));
      }
    }
    if (!mapCategToCountPakedge.isEmpty()) {
      for (String key: mapCategToCountPakedge.keySet()) {
        listPieData.add(new StackedListData(key, mapCategToCountPakedge.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Door Locks' and its SubProducts
  public void DoorLockStackedData() {
    mapCategoryToCountDoorLock = new Map < String, Decimal > ();
    mapSubCategoryToCountDoorLock = new Map < String, Decimal > ();
    Decimal currentTotalCost1 = 0.0;
    Decimal currentQuantity1 = 0.0;
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Door Locks') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategoryToCountDoorLock.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategoryToCountDoorLock.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategoryToCountDoorLock.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategoryToCountDoorLock.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategoryToCountDoorLock.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategoryToCountDoorLock.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategoryToCountDoorLock.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategoryToCountDoorLock.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategoryToCountDoorLock.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Door Locks' and its SubProducts from map
  public List < StackedListData > DoorLockStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategoryToCountDoorLock.isEmpty()) {
      for (String key: mapSubCategoryToCountDoorLock.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategoryToCountDoorLock.get(key)));
      }
    }
    if (!mapCategoryToCountDoorLock.isEmpty()) {
      for (String key: mapCategoryToCountDoorLock.keySet()) {
        listPieData.add(new StackedListData(key, mapCategoryToCountDoorLock.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'triad' and its SubProducts
  public void TriadStackedData() {
    mapSubCategToCountTriad = new Map < String, Decimal > ();
    mapCategoryToCountTriad = new Map < String, Decimal > ();
    Decimal currentTotalCost1 = 0.0;
    Decimal currentQuantity1 = 0.0;
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Triad') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategoryToCountTriad.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategoryToCountTriad.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountTriad.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountTriad.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountTriad.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountTriad.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountTriad.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountTriad.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountTriad.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Triad' and its SubProducts from map
  public List < StackedListData > TriadStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountTriad.isEmpty()) {
      for (String key: mapSubCategToCountTriad.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountTriad.get(key)));
      }
    }
    if (!mapCategoryToCountTriad.isEmpty()) {
      for (String key: mapCategoryToCountTriad.keySet()) {
        listPieData.add(new StackedListData(key, mapCategoryToCountTriad.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of '3rdParty' and its SubProducts
  public void thirdPartyStackedData() {
    mapSubCategToCountthirdParty = new Map < String, Decimal > ();
    mapCategoryToCountThirdParty = new Map < String, Decimal > ();
    Decimal currentTotalCost1 = 0.0;
    Decimal currentQuantity1 = 0.0;
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == '3rd Party') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategoryToCountThirdParty.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategoryToCountThirdParty.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountthirdParty.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountthirdParty.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountthirdParty.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountthirdParty.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountthirdParty.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountthirdParty.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountthirdParty.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of '3rd Party' and its SubProducts from map
  public List < StackedListData > thirdPartyStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountthirdParty.isEmpty()) {
      for (String key: mapSubCategToCountthirdParty.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountthirdParty.get(key)));
      }
    }
    if (!mapCategoryToCountThirdParty.isEmpty()) {
      for (String key: mapCategoryToCountThirdParty.keySet()) {
        listPieData.add(new StackedListData(key, mapCategoryToCountThirdParty.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Interfaces / Communication' and its SubProducts
  public void interfaceComStackedData() {
    mapSubCategToCountinterfaceComm = new Map < String, Decimal > ();
    mapCategToCountinterfaceComm = new Map < String, Decimal > ();
    Decimal currentQuantity1 = 0.0;
    Decimal currentTotalCost1 = 0.0;
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Interface / Communication') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategToCountinterfaceComm.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategToCountinterfaceComm.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountinterfaceComm.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountinterfaceComm.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountinterfaceComm.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountinterfaceComm.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountinterfaceComm.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountinterfaceComm.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountinterfaceComm.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Interfaces / Communication' and its SubProducts from map
  public List < StackedListData > interfaceComStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountinterfaceComm.isEmpty()) {
      for (String key: mapSubCategToCountinterfaceComm.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountinterfaceComm.get(key)));
      }
    }
    if (!mapCategToCountinterfaceComm.isEmpty()) {
      for (String key: mapCategToCountinterfaceComm.keySet()) {
        listPieData.add(new StackedListData(key, mapCategToCountinterfaceComm.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Card Access' and its SubProducts
  public void CardAccessData() {
    mapCategoryToCountCardAccess = new Map < String, Decimal > ();
    mapSubCategToCountCardAccess = new Map < String, Decimal > ();
    Decimal currentTotalCost1 = 0.0;
    Decimal currentQuantity1 = 0.0;
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Card Access') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c) || objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategoryToCountCardAccess.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategoryToCountCardAccess.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountCardAccess.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountCardAccess.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountCardAccess.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountCardAccess.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountCardAccess.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountCardAccess.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountCardAccess.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Card Access' and its SubProducts from map
  public List < StackedListData > CardAccessStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountCardAccess.isEmpty()) {
      for (String key: mapSubCategToCountCardAccess.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountCardAccess.get(key)));
      }
    }
    if (!mapCategoryToCountCardAccess.isEmpty()) {
      for (String key: mapCategoryToCountCardAccess.keySet()) {
        listPieData.add(new StackedListData(key, mapCategoryToCountCardAccess.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Networking' and its SubProducts
  public void NetworkingStackedData() {
    mapSubCategToCountNetworking = new Map < String, Decimal > ();
    mapCategoryToCountNetworking = new Map < String, Decimal > ();
    Decimal currentTotalCost1 = 0.0;
    Decimal currentQuantity1 = 0.0;
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Networking') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategoryToCountNetworking.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategoryToCountNetworking.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountNetworking.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountNetworking.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountNetworking.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentTotalCost = mapSubCategToCountNetworking.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountNetworking.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentQuantity = mapSubCategToCountNetworking.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountNetworking.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Networking' and its SubProducts from map
  public List < StackedListData > NetworkingStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountNetworking.isEmpty()) {
      for (String key: mapSubCategToCountNetworking.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountNetworking.get(key)));
      }
    }
    if (!mapCategoryToCountNetworking.isEmpty()) {
      for (String key: mapCategoryToCountNetworking.keySet()) {
        listPieData.add(new StackedListData(key, mapCategoryToCountNetworking.get(key)));
      }
    }
    return listPieData;
  }

  // Method to map values of 'Partner Product' and its SubProducts
  public void PartnerProductBarDataStackedData() {
    mapSubCategToCountPartnerProduct = new Map < String, Decimal > ();
    mapCategoryToCountPartnerProduct = new Map < String, Decimal > ();
    Decimal currentTotalCost1 = 0.0;
    Decimal currentQuantity1 = 0.0;
    for (Daily_Dealer_Sales_Log__c objDealerSalesLog: dailyDealerSalesLogList) {
      if (objDealerSalesLog.Quantity__c != null || objDealerSalesLog.Total_Cost__c != null) {
        if (objDealerSalesLog.Dealer_Sales_Category__c == 'Partner Products') {
          if (objDealerSalesLog.Dealer_Sales_Sub_Category__c == null || String.isBlank(objDealerSalesLog.Dealer_Sales_Sub_Category__c)|| objDealerSalesLog.Dealer_Sales_Sub_Category__c == 'None') {
            if (objDealerSalesLog.Total_Cost__c != null) {
              currentTotalCost1 = currentTotalCost1 + objDealerSalesLog.Total_Cost__c;
              mapCategoryToCountPartnerProduct.put(objDealerSalesLog.Dealer_Sales_Category__c, currentTotalCost1);
            } else if (objDealerSalesLog.Quantity__c != null) {
              currentQuantity1 = currentQuantity1 + objDealerSalesLog.Quantity__c;
              mapCategoryToCountPartnerProduct.put(objDealerSalesLog.Dealer_Sales_Category__c, currentQuantity1);
            }
          } else {
            if (!mapSubCategToCountPartnerProduct.containsKey(objDealerSalesLog.Dealer_Sales_Sub_Category__c)) {
              if (objDealerSalesLog.Total_Cost__c != null) {
                mapSubCategToCountPartnerProduct.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Total_Cost__c);
              } else if (objDealerSalesLog.Quantity__c != null) {
                mapSubCategToCountPartnerProduct.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, objDealerSalesLog.Quantity__c);
              }
            } else {
              if (objDealerSalesLog.Total_Cost__c != null) {
                Decimal currentTotalCost = mapSubCategToCountPartnerProduct.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentTotalCost = currentTotalCost + objDealerSalesLog.Total_Cost__c;
                mapSubCategToCountPartnerProduct.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentTotalCost);
              } else if (objDealerSalesLog.Quantity__c != null) {
                Decimal currentQuantity = mapSubCategToCountPartnerProduct.get(objDealerSalesLog.Dealer_Sales_Sub_Category__c);
                currentQuantity = currentQuantity + objDealerSalesLog.Quantity__c;
                mapSubCategToCountPartnerProduct.put(objDealerSalesLog.Dealer_Sales_Sub_Category__c, currentQuantity);
              }
            }
          }
        }
      }
    }
  }

  // Method to fill wrapper with values of 'Partner Product' and its SubProducts from map
  public List < StackedListData > PartnerProductBarDataStackedListData() {
    List < StackedListData > listPieData = new List < StackedListData > ();
    if (!mapSubCategToCountPartnerProduct.isEmpty()) {
      for (String key: mapSubCategToCountPartnerProduct.keySet()) {
        listPieData.add(new StackedListData(key, mapSubCategToCountPartnerProduct.get(key)));
      }
    }
    if (!mapCategoryToCountPartnerProduct.isEmpty()) {
      for (String key: mapCategoryToCountPartnerProduct.keySet()) {
        listPieData.add(new StackedListData(key, mapCategoryToCountPartnerProduct.get(key)));
      }
    }
    return listPieData;
  }

  // Wrapper class for Pie Chart
  public class StackedListData {
    public String name ;
    public Decimal data ;
    public StackedListData() {}
      public StackedListData(String name, Decimal data) {
        this.name = name;
        this.data = data;
      }
    }
  }