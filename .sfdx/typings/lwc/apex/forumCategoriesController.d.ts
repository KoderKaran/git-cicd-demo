declare module "@salesforce/apex/forumCategoriesController.saveRecord" {
  export default function saveRecord(param: {name: any, colType: any, description: any, isAuto: any, isLock: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.saveShadowObject" {
  export default function saveShadowObject(param: {feedId: any, pinnedPost: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getCollaborations" {
  export default function getCollaborations(): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getFeedNameData" {
  export default function getFeedNameData(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getCollaborationData" {
  export default function getCollaborationData(param: {collabId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.deleteCollaborationGroup" {
  export default function deleteCollaborationGroup(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.editCollaborationGroup" {
  export default function editCollaborationGroup(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.saveEdit" {
  export default function saveEdit(param: {recordId: any, saveName: any, saveDesc: any, saveType: any, saveAuto: any, saveLock: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getListCollaborationFeed" {
  export default function getListCollaborationFeed(param: {collabId: any, isThread: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.deleteCollaborationGroupFeed" {
  export default function deleteCollaborationGroupFeed(param: {recordId: any, threadFilter: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getFeedComments" {
  export default function getFeedComments(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getFeedItem1" {
  export default function getFeedItem1(param: {collabId: any, currentList: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getNewCollaborationGroupFeeds" {
  export default function getNewCollaborationGroupFeeds(param: {collaborationGroupId: any, existingCollaborationGroupIds: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getCollaborationGroupFeeds" {
  export default function getCollaborationGroupFeeds(param: {collaborationGroupId: any, filter: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getFeedItem" {
  export default function getFeedItem(param: {collabId: any, isThread: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getFeedItemHolder" {
  export default function getFeedItemHolder(): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.listUser" {
  export default function listUser(param: {searchKeyWord: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.findByName" {
  export default function findByName(param: {searchKey: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.addUsertoGroup" {
  export default function addUsertoGroup(param: {userId: any, groupId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.removeUserAccessToGroup" {
  export default function removeUserAccessToGroup(param: {userId: any, groupId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.fetchUser" {
  export default function fetchUser(): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.ManageCollaborationGroupMember" {
  export default function ManageCollaborationGroupMember(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.sendMailMethod" {
  export default function sendMailMethod(param: {mMail: any, mSubject: any, eSubject: any, mBodyLink: any, getUserName: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.saveChunk" {
  export default function saveChunk(param: {collabId: any, fileName: any, base64Data: any, contentType: any, fileId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.updateUserSubscriptionGroup" {
  export default function updateUserSubscriptionGroup(param: {recordId: any, usrId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.removeUserSubscriptionGroup" {
  export default function removeUserSubscriptionGroup(param: {recordId: any, usrId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.updateUserSubscriptionPost" {
  export default function updateUserSubscriptionPost(param: {recordId: any, usrId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.removeUserSubscriptionPost" {
  export default function removeUserSubscriptionPost(param: {recordId: any, usrId: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.getSubscriptions" {
  export default function getSubscriptions(): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.createCustomCollab" {
  export default function createCustomCollab(param: {cgroup: any, isauto: any, isLock: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.lockCustomCollab" {
  export default function lockCustomCollab(param: {recordId: any, lockcat: any}): Promise<any>;
}
declare module "@salesforce/apex/forumCategoriesController.lockFeedItem" {
  export default function lockFeedItem(param: {recordId: any, lockfeed: any}): Promise<any>;
}
