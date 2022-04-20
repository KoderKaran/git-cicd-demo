declare module "@salesforce/apex/CaseCreationController.search" {
  export default function search(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/CaseCreationController.getContactName" {
  export default function getContactName(param: {contactId: any}): Promise<any>;
}
declare module "@salesforce/apex/CaseCreationController.createCase" {
  export default function createCase(param: {contactId: any, accountId: any, origin: any, customer: any, mycontrol4name: any, controller: any, softwareVersion: any, subject: any, description: any}): Promise<any>;
}
