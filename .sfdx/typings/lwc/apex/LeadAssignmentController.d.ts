declare module "@salesforce/apex/LeadAssignmentController.getSettingURL" {
  export default function getSettingURL(param: {leadId: any}): Promise<any>;
}
declare module "@salesforce/apex/LeadAssignmentController.getDealers" {
  export default function getDealers(param: {leadId: any}): Promise<any>;
}
declare module "@salesforce/apex/LeadAssignmentController.validateLead" {
  export default function validateLead(param: {leadId: any}): Promise<any>;
}
declare module "@salesforce/apex/LeadAssignmentController.sendLeadsToDealers" {
  export default function sendLeadsToDealers(param: {leadId: any, sendImmediatelyJson: any, interval: any, sendLaterJson: any}): Promise<any>;
}
