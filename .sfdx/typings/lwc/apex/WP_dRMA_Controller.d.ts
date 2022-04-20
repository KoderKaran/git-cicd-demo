declare module "@salesforce/apex/WP_dRMA_Controller.search" {
  export default function search(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.searchIssues" {
  export default function searchIssues(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.searchItems" {
  export default function searchItems(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.outboundItems" {
  export default function outboundItems(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.GetIs3rdPartyProduct" {
  export default function GetIs3rdPartyProduct(param: {productSku: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.GetOutcomeList" {
  export default function GetOutcomeList(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.GetShipmentList" {
  export default function GetShipmentList(): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.GetCustomValues" {
  export default function GetCustomValues(param: {caseID: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.GetRMARecords" {
  export default function GetRMARecords(param: {caseID: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.getCaseRecord" {
  export default function getCaseRecord(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.exceptionMetadata" {
  export default function exceptionMetadata(): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.SaveRMA" {
  export default function SaveRMA(param: {rmaId: any, caseId: any, notes: any, supportProd: any, version: any, issue: any, isRMA: any, macSerServ: any, item: any, sku: any, salesNumber: any, SalesNumberViaAutomation: any, nsoReason: any, outcome: any, outboundItem: any, miscPartReason: any, shipping: any, quantity: any, failUpdate: any, damageTransit: any, failBox: any, ovrcIssue: any, noTroubleshoot: any, inWarranty: any, inWarrantyReason: any, inWarrantyException: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.GetRMA" {
  export default function GetRMA(param: {rmaId: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_dRMA_Controller.DeleteRMA" {
  export default function DeleteRMA(param: {rmaId: any}): Promise<any>;
}
