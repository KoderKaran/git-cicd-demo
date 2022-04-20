declare module "@salesforce/apex/RMAProcessControllerV2.createRMA" {
  export default function createRMA(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/RMAProcessControllerV2.sendMailMethod" {
  export default function sendMailMethod(param: {caseId: any, toEmail: any, ccEmail: any, bccEmail: any, subjectEmail: any}): Promise<any>;
}
