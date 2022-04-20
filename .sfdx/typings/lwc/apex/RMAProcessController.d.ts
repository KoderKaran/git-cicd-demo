declare module "@salesforce/apex/RMAProcessController.createRMA" {
  export default function createRMA(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/RMAProcessController.sendMailMethod" {
  export default function sendMailMethod(param: {caseId: any, toEmail: any, ccEmail: any, bccEmail: any, subjectEmail: any}): Promise<any>;
}
