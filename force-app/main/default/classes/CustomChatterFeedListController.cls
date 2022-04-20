public without sharing class CustomChatterFeedListController {

	@AuraEnabled
	public static List<WrapperFeedItem> getFeeds(Integer numberOfRecords, String networkId) {
		List<WrapperFeedItem> wrapperFeeds = new List<WrapperFeedItem>();
		List<WrapperFeedItem> returnFeeds = new List<WrapperFeedItem>();

		System.debug('network id: ' + networkId);
		System.debug('user id: ' + userinfo.getuserid());

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}
                                        
		Map<Id, FeedItem> chatterFeeds = new Map<ID, FeedItem>([
			SELECT Id, Title, Body, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate,
				Type, BestCommentId, LikeCount, CommentCount
			FROM FeedItem
			WHERE NetworkScope = :networkId
            	AND Type = 'QuestionPost'
            	//AND CreatedDate > :Date.today().addDays(-7)
            	ORDER BY CreatedDate DESC
            LIMIT :Integer.valueOf(numberOfRecords)
		]);

		System.debug('chatterFeeds: ' + chatterFeeds);

		List<Id> createdByIdList = new List<Id>();
		List<Id> feedItemIds = new List<Id>();
		if (!chatterFeeds.isEmpty()) {
			for (FeedItem feed : chatterFeeds.values()) {
				createdByIdList.add(feed.CreatedById);
				feedItemIds.add(feed.Id);
			}
		}

		List<User> userPhotosList = [
			SELECT Id, FullPhotoUrl, Contact.FirstName, Contact.LastName, Account.Name, Contact.Avatar_URL__c
			FROM User
			WHERE Id IN :createdByIdList
		];

		List<FeedItemViewsCounter__c> feedItemViews = [
			SELECT Id, Name, FeedItemIdValue__c, NumberOfViews__c
			FROM FeedItemViewsCounter__c
			WHERE FeedItemIdValue__c IN :feedItemIds
		];

		Map<String, Integer> feedItemViewsMap = new Map<String, Integer>();

		for (FeedItemViewsCounter__c feedItem : feedItemViews) {
			Integer numOfViews = feedItem.NumberOfViews__c != null ? Integer.valueOf(feedItem.NumberOfViews__c) : 0;
			feedItemViewsMap.put(feedItem.FeedItemIdValue__c, numOfViews);
		}

		String communityId = networkId;

		ConnectApi.BatchResult[] batchResults =  ConnectApi.ChatterFeeds.getFeedElementBatch(communityId, feedItemIds);
		
		for (ConnectApi.BatchResult batchResult : batchResults) {
			ConnectApi.FeedElement feedElement = (ConnectApi.FeedElement) batchResult.getResult();
		
			if (chatterFeeds.containsKey(feedElement.Id)) {
				Long upvoteTotal = 0;
				Long downvoteTotal = 0;
				
				FeedItem feed = chatterFeeds.get(feedElement.Id);
				String feedId = feed.Id;
				String myVote = '';

				Date createdDate = date.newinstance(feed.CreatedDate.year(), feed.CreatedDate.month(), feed.CreatedDate.day());

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
				
				String avatar = '';
				Integer views = 0;
				Long votes = upvoteTotal - downvoteTotal;
				for (User user :userPhotosList) {
					if (user.Id == feed.CreatedById) {
						if (feedItemViewsMap.containsKey(feedid)) {
							views = feedItemViewsMap.get(feedElement.Id);
						}
						if (String.isEmpty(user.Contact.Avatar_URL__c) == false) {
							avatar = user.Contact.Avatar_URL__c;
						}
						WrapperFeedItem feeditem = 
							new WrapperFeedItem(
								feed, createdDate, avatar, user, votes, myVote, views);
						wrapperFeeds.add(feeditem);
						break;
					}
				}
			}
		}
			
		wrapperFeeds.sort();

		Integer i = 0;
		for (WrapperFeedItem wrapperFeed : wrapperFeeds) {
			if (i < Integer.valueOf(numberOfRecords)) {
				returnFeeds.add(wrapperFeed);
			}
			i++;
		}
		System.debug('returnFeeds ' + returnFeeds);
		return returnFeeds;
	}

	@AuraEnabled
	public static List<WrapperFeedItem> getQuestions(String questionsType, Integer numberOfRecords, Integer currentPage, String networkId) {
		List<FeedItem> feeds = new List<FeedItem>();
		List<WrapperFeedItem> wrapperFeeds = new List<WrapperFeedItem>();
		List<WrapperFeedItem> returnFeeds = new List<WrapperFeedItem>();

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		Integer numOfRecords = Integer.valueOf(numberOfRecords);
		Integer offsetValue = Integer.valueOf(numberOfRecords) * (Integer.valueOf(currentPage) - 1);
        
		if (questionsType == 'Latest') {
			feeds = [
				SELECT Id, Title, Body, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate,
					Type, BestCommentId, LikeCount, CommentCount
				FROM FeedItem
				WHERE NetworkScope = :networkId
	            	AND Type = 'QuestionPost'
        		ORDER BY CreatedDate DESC
	            LIMIT :numOfRecords
			];
		}

		if (questionsType == 'Week') {
			feeds = [
				SELECT Id, Title, Body, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate,
					Type, BestCommentId, LikeCount, CommentCount
				FROM FeedItem
				WHERE NetworkScope = :networkId
	            	AND Type = 'QuestionPost'
	            	AND CreatedDate > :Date.today().addDays(-7)
				LIMIT 50000
			];
		}

		if (questionsType == 'All Time') {
			feeds = [
				SELECT Id, Title, Body, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate,
					Type, BestCommentId, LikeCount, CommentCount
				FROM FeedItem
				WHERE NetworkScope = :networkId
	            	AND Type = 'QuestionPost'
	            LIMIT 50000
			];
		}

		if (questionsType == 'Unanswered') {
			feeds = [
				SELECT Id, Title, Body, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate,
					Type, BestCommentId, LikeCount, CommentCount
				FROM FeedItem
				WHERE NetworkScope = :networkId
	            	AND Type = 'QuestionPost'
	            	AND BestCommentId = NULL
	            LIMIT 50000
			];
		}

		Map<Id, FeedItem> chatterFeeds = new Map<ID, FeedItem>(feeds); 

		List<Id> createdByIdList = new List<Id>();
		List<Id> feedItemIds = new List<Id>();
		if (!chatterFeeds.isEmpty()) {
			for (FeedItem feed : chatterFeeds.values()) {
				createdByIdList.add(feed.CreatedById);
				feedItemIds.add(feed.Id);
			}
		}

		Map<Id, User> userPhotosMap = new Map<Id, User>([
			SELECT Id, FullPhotoUrl, Contact.FirstName, Contact.LastName, Account.Name, Contact.Avatar_URL__c
			FROM User
			WHERE Id IN :createdByIdList
		]);
        
        String communityId = networkId;

		ConnectApi.BatchResult[] batchResults =  ConnectApi.ChatterFeeds.getFeedElementBatch(communityId, feedItemIds);

		List<String> feedIds = new List<String>();

		for (ConnectApi.BatchResult batchResult : batchResults) {
			ConnectApi.FeedElement feedElement = (ConnectApi.FeedElement) batchResult.getResult();

			feedIds.add(feedElement.Id);
		}

		List<FeedItemViewsCounter__c> feedItemViews = [
			SELECT Id, Name, FeedItemIdValue__c, NumberOfViews__c
			FROM FeedItemViewsCounter__c
			WHERE FeedItemIdValue__c IN :feedIds
		];

		Map<String, Integer> feedItemViewsMap = new Map<String, Integer>();

		for (FeedItemViewsCounter__c feedItem : feedItemViews) {
			Integer numOfViews = feedItem.NumberOfViews__c != null ? Integer.valueOf(feedItem.NumberOfViews__c) : 0;
			feedItemViewsMap.put(feedItem.FeedItemIdValue__c, numOfViews);
		}
		
		for (ConnectApi.BatchResult batchResult : batchResults) {
			ConnectApi.FeedElement feedElement = (ConnectApi.FeedElement) batchResult.getResult();
		
			if (chatterFeeds.containsKey(feedElement.Id)) {
				Long upvoteTotal = 0;
				Long downvoteTotal = 0;
				
				FeedItem feed = chatterFeeds.get(feedElement.Id);
				String feedId = feed.Id;
				String myVote = '';

				Date createdDate = date.newinstance(feed.CreatedDate.year(), feed.CreatedDate.month(), feed.CreatedDate.day());

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
				
				String avatar = '';
				Integer views = 0;
				Long votes = upvoteTotal - downvoteTotal;
				if (userPhotosMap.containsKey(feed.CreatedById)) {
					if (feedItemViewsMap.containsKey(feedid)) {
						views = feedItemViewsMap.get(feedElement.Id);
					}
					User user = userPhotosMap.get(feed.CreatedById);
					if (String.isEmpty(user.Contact.Avatar_URL__c) == false) {
						avatar = user.Contact.Avatar_URL__c;
					}
					WrapperFeedItem feeditem = new WrapperFeedItem(feed, createdDate, avatar, user, votes, myVote, views);
					wrapperFeeds.add(feeditem);
				}
			}
		}
		
		if (questionsType != 'Latest') {
			wrapperFeeds.sort();
		}

		/*Integer i = 0;
		for (WrapperFeedItem wrapperFeed : wrapperFeeds) {
			if (i < Integer.valueOf(numberOfRecords)) {
				returnFeeds.add(wrapperFeed);
			}
			i++;
		}*/
		for (Integer i = 0; i < Integer.valueOf(numberOfRecords); i++) {
			if (offsetValue < wrapperFeeds.size()) {
				returnFeeds.add(wrapperFeeds[offsetValue]);
				offsetValue++;
			} else {
				break;
			}
		}
		
		return returnFeeds;
	}

	@AuraEnabled
	public static String getUserPhoto(String userId) {
		String communityId = Network.getNetworkId();
		User userPhotosList = [
			SELECT FullPhotoUrl
			FROM User
			WHERE Id = :userId
		];
		return userPhotosList.FullPhotoUrl;
	}

	/*@AuraEnabled
	public static List<ConnectApi.Topic> getFeedTopics(String itemId, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		List<TopicAssignment> myFeedItemFeedAssignments = [
			SELECT
			    Id,
			    NetworkId,
			    TopicId,
			    Topic.Name,
			    EntityId,
			    EntityKeyPrefix
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

		ConnectApi.ManagedTopicCollection topicCollection = ConnectApi.ManagedTopics.getManagedTopics(communityId, topicType, recordIds, 1);

		

		List<ConnectApi.ManagedTopic> listOfManagedTopics = topicCollection.managedTopics;

		List<ConnectApi.Topic> listOfTopics = new List<ConnectApi.Topic>();

		for (ConnectApi.ManagedTopic managedTopic : listOfManagedTopics) {
			listOfTopics.add(managedTopic.topic);
		}
		return listOfTopics;
	}*/

	/*@AuraEnabled
	public static List<WrapperFeedItem> filterByTopicName(List<String> topicNames, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		List<TopicAssignment> listEntityIds = [
			SELECT EntityId 
			FROM TopicAssignment
			WHERE Topic.Name IN :topicNames
			AND NetworkId =: networkId
    	];

    	List<Id> listIds = new List<Id>();
    	if(!listEntityIds.isEmpty()) {
    		for(TopicAssignment topicAssign:listEntityIds) {
    			if((topicAssign.EntityId != NULL) && 
    				(topicAssign.EntityId.getSObjectType().getDescribe().getName() == 'FeedItem')) {
    				listIds.add(topicAssign.EntityId);
    			}
    		}
    	}

    	List<FeedItem> chatterFeeds = [
			SELECT Id, Title, Body, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate, Type
			FROM FeedItem
			WHERE NetworkScope = :networkId 
            AND Id IN :listIds
		];

		List<WrapperFeedItem> wrapperFeeds = new List<WrapperFeedItem>();
		List<WrapperFeedItem> returnFeeds = new List<WrapperFeedItem>();

		List<Id> createdByIdList = new List<Id>();
		if (!chatterFeeds.isEmpty()) {
			for (FeedItem feed : chatterFeeds) {
				createdByIdList.add(feed.CreatedById);
			}
		}

		List<User> userPhotosList = [
			SELECT Id, FullPhotoUrl, Contact.FirstName, Contact.LastName, Account.Name, Contact.Avatar_URL__c
			FROM User
			WHERE Id = :createdByIdList
		];

		for (FeedItem feed : chatterFeeds) {
			Long upvoteTotal = 0;
			Long downvoteTotal = 0;
			String communityId = networkId;
			String feedId = feed.Id;

			Date createdDate = date.newinstance(feed.CreatedDate.year(), feed.CreatedDate.month(), feed.CreatedDate.day());

			ConnectApi.VotePage upvote = 
				ConnectApi.ChatterFeeds.getVotesForFeedElement(communityId, feedId, ConnectApi.UpDownVoteValue.Up);

			if (upvote != NULL) {
				upvoteTotal = upvote.total;
			}

			ConnectApi.VotePage downvote = 
				ConnectApi.ChatterFeeds.getVotesForFeedElement(communityId, feedId, ConnectApi.UpDownVoteValue.Down);
			if (downvote != NULL) {
				downvoteTotal = downvote.total;
			} 
			
			String avatar = '';
			Long votes = upvoteTotal - downvoteTotal;
			for (User user :userPhotosList) {
				if (user.Id == feed.CreatedById) {
					if (String.isEmpty(user.Contact.Avatar_URL__c) == false) {
						avatar = user.Contact.Avatar_URL__c;
					}
					WrapperFeedItem feeditem = 
					new WrapperFeedItem(
						feed, createdDate, avatar, user, votes);
					wrapperFeeds.add(feeditem);
					break;
				}
			}
		}

		for (WrapperFeedItem wrapperFeed : wrapperFeeds) {
				returnFeeds.add(wrapperFeed);
		}
		return returnFeeds;
	}*/

	@AuraEnabled
	public static WrapperFeedItem upvoteThisFeedItem(String feedItemId, String feedItemVote, String networkId) {
		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		return CustomChatterFeedPostController.upvoteThisFeedItem(feedItemId, feedItemVote, networkId);
	}

	@AuraEnabled
	public static WrapperFeedItem downvoteThisFeedItem(String feedItemId, String feedItemVote, String networkId) {
		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}
		return CustomChatterFeedPostController.downvoteThisFeedItem(feedItemId, feedItemVote, networkId);
	}

	@AuraEnabled
	public static Integer getTotalNumberOfPages(String questionsType, Integer numberOfRecords, String networkId) {

		Integer allRecords = 0;
		Integer totalPages = 0;

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		if (questionsType == 'Week') {
			allRecords = [
				SELECT COUNT()
				FROM FeedItem
				WHERE NetworkScope = :networkId
	            	AND Type = 'QuestionPost'
	            	AND CreatedDate > :Date.today().addDays(-7)
	            LIMIT 10000
			];
		}

		if (questionsType == 'All Time') {
			allRecords = [
				SELECT COUNT()
				FROM FeedItem
				WHERE NetworkScope = :networkId
	            	AND Type = 'QuestionPost'
	            LIMIT 10000
			];
		}

		if (questionsType == 'Unanswered') {
			allRecords = [
				SELECT COUNT()
				FROM FeedItem
				WHERE NetworkScope = :networkId
	            	AND Type = 'QuestionPost'
	            	AND BestCommentId = NULL
	            LIMIT 10000
			];
		}

		totalPages = allRecords / Integer.valueOf(numberOfRecords);
		if(Math.mod(allRecords, Integer.valueOf(numberOfRecords)) != 0) {
			totalPages++;
		}

		return totalPages;
	}
}