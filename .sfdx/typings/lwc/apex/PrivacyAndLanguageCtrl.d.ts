declare module "@salesforce/apex/PrivacyAndLanguageCtrl.getUserSettings" {
  export default function getUserSettings(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/PrivacyAndLanguageCtrl.saveUserSettings" {
  export default function saveUserSettings(param: {user: any}): Promise<any>;
}
declare module "@salesforce/apex/PrivacyAndLanguageCtrl.getOptions" {
  export default function getOptions(param: {objObject: any, field: any}): Promise<any>;
}
