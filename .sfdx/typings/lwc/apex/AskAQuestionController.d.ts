declare module "@salesforce/apex/AskAQuestionController.getUserPhoto" {
  export default function getUserPhoto(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/AskAQuestionController.saveQuestion" {
  export default function saveQuestion(param: {userId: any, questionTitle: any, questionDetails: any, topicIds: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/AskAQuestionController.saveQuestionWithAttach" {
  export default function saveQuestionWithAttach(param: {userId: any, questionTitle: any, questionDetails: any, topicIds: any, fileBody: any, fileName: any, fileFormat: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/AskAQuestionController.saveFile" {
  export default function saveFile(param: {fileNameWithExt: any, fileData: any}): Promise<any>;
}
