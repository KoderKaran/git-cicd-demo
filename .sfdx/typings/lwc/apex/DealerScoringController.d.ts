declare module "@salesforce/apex/DealerScoringController.getNewRows" {
  export default function getNewRows(param: {currFieldString: any, fieldCount: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerScoringController.getNewRow" {
  export default function getNewRow(param: {currFieldString: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerScoringController.getAccountFields" {
  export default function getAccountFields(): Promise<any>;
}
declare module "@salesforce/apex/DealerScoringController.updatePointValues" {
  export default function updatePointValues(param: {fieldScoringsString: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerScoringController.saveFieldScoring" {
  export default function saveFieldScoring(param: {fieldScoringsString: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerScoringController.deleteSavedScoringsByName" {
  export default function deleteSavedScoringsByName(param: {recordName: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerScoringController.deleteSavedScoring" {
  export default function deleteSavedScoring(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerScoringController.getSavedScorings" {
  export default function getSavedScorings(): Promise<any>;
}
