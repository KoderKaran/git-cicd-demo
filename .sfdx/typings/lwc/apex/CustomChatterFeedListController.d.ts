declare module "@salesforce/apex/CustomChatterFeedListController.getFeeds" {
  export default function getFeeds(param: {numberOfRecords: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedListController.getQuestions" {
  export default function getQuestions(param: {questionsType: any, numberOfRecords: any, currentPage: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedListController.getUserPhoto" {
  export default function getUserPhoto(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedListController.upvoteThisFeedItem" {
  export default function upvoteThisFeedItem(param: {feedItemId: any, feedItemVote: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedListController.downvoteThisFeedItem" {
  export default function downvoteThisFeedItem(param: {feedItemId: any, feedItemVote: any, networkId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomChatterFeedListController.getTotalNumberOfPages" {
  export default function getTotalNumberOfPages(param: {questionsType: any, numberOfRecords: any, networkId: any}): Promise<any>;
}
