public without sharing class CustomChatterFeedPostController {

	@AuraEnabled
	public static User getUserPhoto(String userId) {
		String communityId = Network.getNetworkId();

		User userPhoto = new User();

		List<User> userPhotoList = [
			SELECT Id, FullPhotoUrl, Contact.FirstName, Contact.LastName, Account.Name, Contact.Avatar_URL__c
			FROM User
			WHERE Id = :userId
		];

		if(!userPhotoList.isEmpty()) {
			userPhoto = userPhotoList.get(0);
		}
		if (String.isBlank(userPhoto.Contact.Avatar_URL__c)) {
			userPhoto.Contact.Avatar_URL__c = '';
		}

		return userPhoto;
	}

	@AuraEnabled
	public static List<WrapperFeedComment> getFeedComments(String itemId, String networkId) {
		List<WrapperFeedComment> wrapperComments = new List<WrapperFeedComment>();

		Map<ID, FeedComment> feedComments =  new Map<ID, FeedComment>([
			SELECT FeedItemId, CommentBody, CreatedBy.FirstName, CreatedBy.LastName,
				LastEditDate, CreatedDate, LastEditById, CreatedById
			FROM FeedComment
			WHERE FeedItemId =: itemId
		]);


		List<Id> createdByIdList = new List<Id>();
		List<Id> feedCommentIds = new List<Id>();
		if (!feedComments.isEmpty()) {
			for (FeedComment feedComment : feedComments.values()) {
				createdByIdList.add(feedComment.CreatedById);
				feedCommentIds.add(feedComment.Id);
			}
		}

		List<User> userPhotosList = [
			SELECT Id, FullPhotoUrl, Contact.FirstName, Contact.LastName, Account.Name, Contact.Avatar_URL__c
			FROM User
			WHERE Id = :createdByIdList
		];

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;

		ConnectApi.CommentPage commentPages = ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityId, itemId);
		List<ConnectApi.Comment> comments = commentPages.items;
		for (ConnectApi.Comment comment : comments) {
			
		
				Long upvoteTotal = 0;
				Long downvoteTotal = 0;
				FeedComment feedcomment = feedComments.get(comment.Id);
				String commentId = feedcomment.Id;
				String myVote = 'None';
				String fileId = '';

				ConnectApi.CommentCapabilities commentCapabilities = comment.capabilities;
            
            	if (commentCapabilities.content != NULL) {
					ConnectApi.ContentCapability contentCapability = commentCapabilities.content;
                    if (contentCapability.Id != NULL) {
                        fileId = contentCapability.Id;
                    }
				}

				ConnectApi.UpDownVoteCapability upDownVoteCapability = commentCapabilities.upDownVote;

				ConnectApi.UpDownVoteValue upDownVoteValue = upDownVoteCapability.myVote;

				if (upDownVoteValue == ConnectApi.UpDownVoteValue.Up) {
					myVote = 'Up';
				}

				if (upDownVoteValue == ConnectApi.UpDownVoteValue.Down) {
					myVote = 'Down';
				}

				Date createdDate = date.newinstance(feedcomment.CreatedDate.year(), feedcomment.CreatedDate.month(), feedcomment.CreatedDate.day());
				/*if (feedcomment.LastEditDate != NULL) {
					createdDate = date.newinstance(feedcomment.LastEditDate.year(), feedcomment.LastEditDate.month(), feedcomment.LastEditDate.day());
				}*/

				upvoteTotal = upDownVoteCapability.upVoteCount;
				downvoteTotal = upDownVoteCapability.downVoteCount;
				
				String avatar = '';
				Long votes = upvoteTotal - downvoteTotal;
				for (User user :userPhotosList) {
					if (user.Id == feedcomment.CreatedById) {
						if (!String.isBlank(user.Contact.Avatar_URL__c)) {
							avatar = user.Contact.Avatar_URL__c;
						}
						WrapperFeedComment wrapperComment = 
						new WrapperFeedComment(feedcomment, createdDate, avatar, user, votes, myVote, fileId);
						wrapperComments.add(wrapperComment);
						break;
					}
				}
		}
		wrapperComments.sort();
		return wrapperComments;
	}

	@AuraEnabled
	public static WrapperFeedItem getFeedItem(String itemId, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		List<String> feedTypes = new List<String> {'AdvancedTextPost', 'AnnouncementPost', 'ApprovalPost', 'CanvasPost', 
									'ContentPost', 'LinkPost', 'PollPost', 'ProfileSkillPost', 
									'QuestionPost', 'ReplyPost', 'RypplePost', 'TextPost'};

		FeedItem chatterFeed = new FeedItem();

		List<FeedItem> chatterFeedList = [
			SELECT Id, Title, Body, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate, BestCommentId
			FROM FeedItem
			WHERE NetworkScope = :networkId 
			AND Type IN :feedTypes 
			AND Id =: itemId
			LIMIT 1
		];

		if(!chatterFeedList.isEmpty()) {
			chatterFeed = chatterFeedList.get(0);
		}

		/*List<FeedItemViewsCounter__c> listOfFeedItemViews = [
			SELECT Id, Name, FeedItemIdValue__c, NumberOfViews__c
			FROM FeedItemViewsCounter__c
			WHERE FeedItemIdValue__c =: itemId
			LIMIT 1
		];
		
		if (!listOfFeedItemViews.isEmpty()) {
			FeedItemViewsCounter__c feedItemView = listOfFeedItemViews.get(0);
			feedItemView.NumberOfViews__c = feedItemView.NumberOfViews__c + 1;
			update feedItemView;
		}*/
		

		Long upvoteTotal = 0;
		Long downvoteTotal = 0;
		String communityId = networkId;
		String myVote = '';
		String feedId = chatterFeed.Id;

		User user = new User();

		List<User> userList = [
			SELECT Id, FullPhotoUrl, Contact.FirstName, Contact.LastName, Account.Name, Contact.Avatar_URL__c
			FROM User
			WHERE Id = :chatterFeed.CreatedById
			LIMIT 1
		];

		if (!userList.isEmpty()) {
			user = userList.get(0);
		}

		Date createdDate = date.newinstance(chatterFeed.CreatedDate.year(), chatterFeed.CreatedDate.month(), chatterFeed.CreatedDate.day());

		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.getFeedElement(communityId, feedId);

		ConnectApi.FeedElementCapabilities feedCapabilities = feedElement.capabilities;

		ConnectApi.UpDownVoteCapability upDownVoteCapability = feedCapabilities.upDownVote;

		ConnectApi.UpDownVoteValue upDownVoteValue = upDownVoteCapability.myVote;

		if (upDownVoteValue == ConnectApi.UpDownVoteValue.Up) {
			myVote = 'Up';
		}

		if (upDownVoteValue == ConnectApi.UpDownVoteValue.Down) {
			myVote = 'Down';
		}

		upvoteTotal = upDownVoteCapability.upVoteCount;

		downvoteTotal = upDownVoteCapability.downVoteCount;
		
		Long votes = upvoteTotal - downvoteTotal;
		String avatar = '';
		if (!String.isBlank(user.Contact.Avatar_URL__c)) {
			avatar = user.Contact.Avatar_URL__c;
		}
		WrapperFeedItem feeditem = 
			new WrapperFeedItem(chatterFeed, createdDate, avatar, user, votes, myVote);
		return feeditem;
	}

	@AuraEnabled
	public static Id getFeedAttach(String itemId) {

		List<FeedAttachment> feedAttachment = [
			SELECT recordId
			FROM FeedAttachment
			WHERE feedEntityId = :itemId
		];
		if (feedAttachment.isEmpty()) {
			return null;
		}
		Id contentVersionId = feedAttachment.get(0).recordId;

		ContentVersion contentVersion = new ContentVersion();

		List<ContentVersion> contentVersionList = [
			SELECT VersionData, Title, PathOnClient, ContentDocumentId 
			FROM ContentVersion
			WHERE Id = :contentVersionId
			LIMIT 1
		];

		if (!contentVersionList.isEmpty()) {
			contentVersion = contentVersionList.get(0);
		}
		
		return contentVersion.ContentDocumentId;
	}

	@AuraEnabled
	public static void upvoteThisComment(String feedCommentId, String commentVote, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;
		ConnectApi.UpDownVoteCapabilityInput voteUp = new ConnectApi.UpDownVoteCapabilityInput();
		if (commentVote == 'Up') {
			voteUp.vote = ConnectApi.UpDownVoteValue.None;
		} else {
			voteUp.vote = ConnectApi.UpDownVoteValue.Up;
		}
		ConnectApi.UpDownVoteCapability vote = ConnectApi.ChatterFeeds.setCommentVote(communityId, feedCommentId, voteUp);
	}

	@AuraEnabled
	public static void downvoteThisComment(String feedCommentId, String commentVote, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;
		ConnectApi.UpDownVoteCapabilityInput voteDown = new ConnectApi.UpDownVoteCapabilityInput();
		if (commentVote == 'Down') {
			voteDown.vote = ConnectApi.UpDownVoteValue.None;
		} else {
			voteDown.vote = ConnectApi.UpDownVoteValue.Down;
		}
		ConnectApi.UpDownVoteCapability vote = ConnectApi.ChatterFeeds.setCommentVote(communityId, feedCommentId, voteDown);
	}
	
	@AuraEnabled
	public static WrapperFeedItem upvoteThisFeedItem(String feedItemId, String feedItemVote, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;
		ConnectApi.UpDownVoteCapabilityInput voteUp = new ConnectApi.UpDownVoteCapabilityInput();
		if (feedItemVote == 'Up') {
			voteUp.vote = ConnectApi.UpDownVoteValue.None;
		} else {
			voteUp.vote = ConnectApi.UpDownVoteValue.Up;
		}
		ConnectApi.UpDownVoteCapability vote = 
			ConnectApi.ChatterFeeds.setFeedElementVote(communityId, feedItemId, voteUp);

		WrapperFeedItem feedItem = CustomChatterFeedPostController.getFeedItem(feedItemId, networkId);

		return feedItem;
	}

	@AuraEnabled
	public static WrapperFeedItem downvoteThisFeedItem(String feedItemId, String feedItemVote, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;
		ConnectApi.UpDownVoteCapabilityInput voteDown = new ConnectApi.UpDownVoteCapabilityInput();
		if (feedItemVote == 'Down') {
			voteDown.vote = ConnectApi.UpDownVoteValue.None;
		} else {
			voteDown.vote = ConnectApi.UpDownVoteValue.Down;
		}
		ConnectApi.UpDownVoteCapability vote = 
			ConnectApi.ChatterFeeds.setFeedElementVote(communityId, feedItemId, voteDown);

		WrapperFeedItem feedItem = CustomChatterFeedPostController.getFeedItem(feedItemId, networkId);

		return feedItem;
	}

	@AuraEnabled
	public static void submitThisCommentWithoutAttachment(String feedElementId, String commentText, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;
		ConnectApi.Comment comment = 
			ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, commentText);
	}

	@AuraEnabled
	public static void submitThisCommentWithAttachment(String feedElementId, String commentText, 
			String fileBody, String fileName, String fileFormat, String networkId) {

		Blob convertedFile = EncodingUtil.base64Decode(fileBody);

		ConnectApi.BinaryInput file = new ConnectApi.BinaryInput(convertedFile, fileFormat, fileName);

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = commentText;

		ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		
		messageInput.messageSegments.add(textSegmentInput);

		ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
		commentInput.body = messageInput;

		ConnectApi.CommentCapabilitiesInput commentCapabilitiesInput = new ConnectApi.CommentCapabilitiesInput();
		ConnectApi.ContentCapabilityInput contentCapabilityInput = new ConnectApi.ContentCapabilityInput();

		commentCapabilitiesInput.content = contentCapabilityInput;
		contentCapabilityInput.title = fileName;

		commentInput.capabilities = commentCapabilitiesInput;

		system.debug(file);

		ConnectApi.Comment comment = 
			ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, commentInput, file);
	}

	/*@AuraEnabled
	public static List<ConnectApi.Topic> getFeedTopics(String itemId, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		List<TopicAssignment> myFeedItemFeedAssignments = [
			SELECT Id, NetworkId,TopicId,Topic.Name, EntityId, EntityKeyPrefix
			FROM
			    TopicAssignment
			WHERE
			    EntityId =: itemId And
			    NetworkId =: networkId
	    ];

		List<String> recordIds = new List<String>();

		for (TopicAssignment topicAssignment : myFeedItemFeedAssignments) {
			recordIds.add(topicAssignment.TopicId);
		}

		String communityId = networkId;
		ConnectApi.ManagedTopicType topicType = ConnectApi.ManagedTopicType.Navigational;

		ConnectApi.ManagedTopicCollection topicCollection = 
			ConnectApi.ManagedTopics.getManagedTopics(communityId, topicType, recordIds, 1);

		List<ConnectApi.ManagedTopic> listOfManagedTopics = topicCollection.managedTopics;

		List<ConnectApi.Topic> listOfTopics = new List<ConnectApi.Topic>();

		for (ConnectApi.ManagedTopic managedTopic : listOfManagedTopics) {
			listOfTopics.add(managedTopic.topic);
		}
		return listOfTopics;

	}*/

	@AuraEnabled
	public static void updateBestComment(String feedItemId, String feedCommentId, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;
		ConnectApi.QuestionAndAnswersCapabilityInput questionAndAnswersCapabilityInput = 
			new ConnectApi.QuestionAndAnswersCapabilityInput();
		questionAndAnswersCapabilityInput.bestAnswerId = feedCommentId;
		ConnectApi.QuestionAndAnswersCapability questionAndAnswersCapability = 
			ConnectApi.QuestionAndAnswers.updateQuestionAndAnswers(communityId, feedItemId, 
				questionAndAnswersCapabilityInput);
	}

	@AuraEnabled
	public static void updateViewsForFeedItem(String feedItemId) {

		List<FeedItemViewsCounter__c> listOfFeedItemViews = [
			SELECT Id, Name, FeedItemIdValue__c, NumberOfViews__c
			FROM FeedItemViewsCounter__c
			WHERE FeedItemIdValue__c =: feedItemId
			LIMIT 1
		];
		
		if (!listOfFeedItemViews.isEmpty()) {
			FeedItemViewsCounter__c feedItemView = listOfFeedItemViews.get(0);
			feedItemView.NumberOfViews__c = feedItemView.NumberOfViews__c + 1;
			update feedItemView;
		}
	}
}