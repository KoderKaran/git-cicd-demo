public without sharing class AskAQuestionController {
	@AuraEnabled
	public static String getUserPhoto(String userId) {
		
		User user = [
			SELECT ContactId
			FROM User
			WHERE Id = :userId
			LIMIT 1
		];
		Contact contact = new Contact();
		if (user.ContactId != NULL) {
			contact = [
				SELECT Avatar_URL__c
	            FROM Contact
	            WHERE Id = :user.ContactId
	            LIMIT 1
			];
			return contact.Avatar_URL__c;
		} else {
			/*String communityId = Network.getNetworkId();
			ConnectApi.Photo userPhoto = ConnectApi.UserProfiles.getPhoto(communityId, userId);
			return userPhoto.largePhotoUrl;*/
			return '';
		}
		
	}

	/*@AuraEnabled
	public static List<ConnectApi.Topic> getTopics() {

		List<Topic> myFeedItemFeedAssignments = [
			SELECT
			    Id,
			    NetworkId,
			    Name
			FROM
			    Topic
			WHERE
			    NetworkId =: Network.getNetworkId()
	    ];
		List<String> recordIds = new List<String>();

		for (Topic topic : myFeedItemFeedAssignments) {
			recordIds.add(topic.Id);
		}

		String communityId = Network.getNetworkId();

		ConnectApi.ManagedTopicType topicType = ConnectApi.ManagedTopicType.Navigational;

		ConnectApi.ManagedTopicCollection topicCollection = ConnectApi.ManagedTopics.getManagedTopics(communityId, topicType, recordIds, 1);

		List<ConnectApi.ManagedTopic> listOfManagedTopics = topicCollection.managedTopics;

		List<ConnectApi.Topic> listOfTopics = new List<ConnectApi.Topic>();

		for (ConnectApi.ManagedTopic managedTopic : listOfManagedTopics) {
			if(!listOfTopics.contains(managedTopic.topic)) {
				listOfTopics.add(managedTopic.topic);
			}
		}

		return listOfTopics;
	}*/

	@AuraEnabled
	public static String saveQuestion(String userId, String questionTitle, String questionDetails, String[] topicIds, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;

		FeedItem feedItem = new FeedItem();
		feedItem.Body = questionDetails;
		feedItem.NetworkScope = communityId;
		feedItem.ParentId = userId;
		feedItem.Title = questionTitle;
		feedItem.Type = 'QuestionPost';
		feedItem.IsRichText = true;

		insert feedItem;

		FeedItemViewsCounter__c counter = new FeedItemViewsCounter__c(
			FeedItemIdValue__c = feedItem.Id,
			NumberOfViews__c = 0
		);
		try {
			insert counter;
		}
		catch (DmlException e) {
			throw new AuraHandledException(e.getMessage());
		}

		/*if(topicIds != null) {
			for (String topicId : topicIds) {
				TopicAssignment topicAssignment = new TopicAssignment();
				topicAssignment.EntityId = feedItem.Id;
				topicAssignment.NetworkId = communityId;
				topicAssignment.TopicId = topicId;
				System.debug('topic for question: ');
				System.debug(topicAssignment);
				insert topicAssignment;
			}
		}*/
		
		return feedItem.Id;
	}

	@AuraEnabled
	public static String saveQuestionWithAttach(String userId, String questionTitle, String questionDetails, String[] topicIds,
		String fileBody, String fileName, String fileFormat, String networkId) {

		if (String.isBlank(networkId)) {
			networkId = Network.getNetworkId();
		}

		String communityId = networkId;

		FeedItem feedItem = new FeedItem();
		feedItem.Body = questionDetails;
		feedItem.NetworkScope = communityId;
		feedItem.ParentId = userId;
		feedItem.Title = questionTitle;
		feedItem.Type = 'QuestionPost';
		feedItem.IsRichText = true;

		insert feedItem;

		FeedItemViewsCounter__c counter = new FeedItemViewsCounter__c(
			FeedItemIdValue__c = feedItem.Id,
			NumberOfViews__c = 0
		);
		try {
			insert counter;
		}
		catch (DmlException e) {
			throw new AuraHandledException(e.getMessage());
		}

		Blob imageData = EncodingUtil.base64Decode(fileBody);
		ID fileId = AskAQuestionController.saveFile(fileName, imageData);

		List<FeedAttachment> feedAttachments = new List<FeedAttachment>();
		    feedAttachments.add( new FeedAttachment(
		    feedEntityId = feedItem.Id,
		    recordId = fileId,
		    type = 'Content'
		));

   		insert feedAttachments;

		/*if(topicIds != null) {
			for (String topicId : topicIds) {
				TopicAssignment topicAssignment = new TopicAssignment();
				topicAssignment.EntityId = feedItem.Id;
				topicAssignment.NetworkId = communityId;
				topicAssignment.TopicId = topicId;
				System.debug('topic for question: ');
				System.debug(topicAssignment);
				insert topicAssignment;
			}
		}*/
		
		return feedItem.Id;
	}

	@AuraEnabled
	public static ID saveFile(String fileNameWithExt, Blob fileData) {

	    ContentVersion file = new ContentVersion(
	        versionData = fileData,
	        title = fileNameWithExt,
	        pathOnClient = '/' + fileNameWithExt
	    );

	    insert file;

	    return file.Id;
  	}
}