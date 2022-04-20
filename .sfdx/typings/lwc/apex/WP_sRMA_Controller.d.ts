declare module "@salesforce/apex/WP_sRMA_Controller.GetReasonCodes" {
  export default function GetReasonCodes(): Promise<any>;
}
declare module "@salesforce/apex/WP_sRMA_Controller.ValidateProductSKU" {
  export default function ValidateProductSKU(param: {productCode: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_sRMA_Controller.CreateCaseProduct" {
  export default function CreateCaseProduct(param: {itemsJSON: any, caseId: any, sendViaTrigger: any, noCreditMemo: any, optOutOfEmail: any, notes: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_sRMA_Controller.GetIs3rdPartyProduct" {
  export default function GetIs3rdPartyProduct(param: {productSku: any}): Promise<any>;
}
declare module "@salesforce/apex/WP_sRMA_Controller.GetSalesOrderInformation" {
  export default function GetSalesOrderInformation(param: {caseID: any, salesNumber: any, beginDate: any, endDate: any}): Promise<any>;
}
