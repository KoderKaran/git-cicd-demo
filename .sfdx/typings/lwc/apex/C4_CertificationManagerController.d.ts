declare module "@salesforce/apex/C4_CertificationManagerController.search" {
  export default function search(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/C4_CertificationManagerController.getCertifications" {
  export default function getCertifications(param: {contactId: any}): Promise<any>;
}
declare module "@salesforce/apex/C4_CertificationManagerController.moveCertifications" {
  export default function moveCertifications(param: {toContactId: any, fromContactId: any, certIdList: any}): Promise<any>;
}
declare module "@salesforce/apex/C4_CertificationManagerController.copyCertifications" {
  export default function copyCertifications(param: {toContactId: any, fromContactId: any, certIdList: any}): Promise<any>;
}
