declare module "@salesforce/apex/CustomChatterFeedPostController.getUserPhoto" {
  export default function getUserPhoto(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.getFeedComments" {
  export default function getFeedComments(param: {itemId: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.getFeedItem" {
  export default function getFeedItem(param: {itemId: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.getFeedAttach" {
  export default function getFeedAttach(param: {itemId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.upvoteThisComment" {
  export default function upvoteThisComment(param: {feedCommentId: any, commentVote: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.downvoteThisComment" {
  export default function downvoteThisComment(param: {feedCommentId: any, commentVote: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.upvoteThisFeedItem" {
  export default function upvoteThisFeedItem(param: {feedItemId: any, feedItemVote: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.downvoteThisFeedItem" {
  export default function downvoteThisFeedItem(param: {feedItemId: any, feedItemVote: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.submitThisCommentWithoutAttachment" {
  export default function submitThisCommentWithoutAttachment(param: {feedElementId: any, commentText: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.submitThisCommentWithAttachment" {
  export default function submitThisCommentWithAttachment(param: {feedElementId: any, commentText: any, fileBody: any, fileName: any, fileFormat: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.updateBestComment" {
  export default function updateBestComment(param: {feedItemId: any, feedCommentId: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedPostController.updateViewsForFeedItem" {
  export default function updateViewsForFeedItem(param: {feedItemId: any}): Promise<any>;
}
