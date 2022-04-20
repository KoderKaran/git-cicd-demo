declare module "@salesforce/apex/CaseCreationControllerV2.search" {
  export default function search(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/CaseCreationControllerV2.GetComponentData" {
  export default function GetComponentData(param: {contactId: any}): Promise<any>;
}
declare module "@salesforce/apex/CaseCreationControllerV2.createCase" {
  export default function createCase(param: {contactId: any, accountId: any, origin: any, rmaType: any}): Promise<any>;
}
