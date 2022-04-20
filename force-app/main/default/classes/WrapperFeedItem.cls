global without sharing class WrapperFeedItem implements Comparable {

	@AuraEnabled
	public sObject feedItem {get; set;}

	@AuraEnabled
	public Date createdDate {get; set;}

	@AuraEnabled
	public String userPhoto {get; set;}

	@AuraEnabled
	public Long countVote {get; set;}

	@AuraEnabled
	public String myVote {get; set;}

	@AuraEnabled
	public String fileId {get; set;}

	@AuraEnabled
	public sObject user {get; set;}

	@AuraEnabled
	public String userId {get; set;}

	@AuraEnabled
	public Integer views {get; set;}
	
	/*public WrapperFeedItem(sObject feed, Date crtdate, String usrPhoto, Long votes) {
		feedItem = feed;
		createdDate = crtdate;
		userPhoto = usrPhoto;
		countVote = votes;
	}*/

	/*public WrapperFeedItem(
		sObject feed, Date crtdate, String usrPhoto, sObject userRecord, Long votes) {

		feedItem = feed;
		createdDate = crtdate;
		userPhoto = usrPhoto;
		countVote = votes;
		user = userRecord;
	}*/

	/*public WrapperFeedItem(
		sObject feed, Date crtdate, String usrPhoto, String userID, Long votes) {

		feedItem = feed;
		createdDate = crtdate;
		userPhoto = usrPhoto;
		countVote = votes;
		userId = userID;
	}*/

	/*public WrapperFeedItem(sObject feed, Date crtdate, String usrPhoto, Long votes, String vote) {
		feedItem = feed;
		createdDate = crtdate;
		userPhoto = usrPhoto;
		countVote = votes;
		myVote = vote;
	}*/

	public WrapperFeedItem(
		sObject feed, Date crtdate, String usrPhoto, sObject userRecord, Long votes, String vote) {

		feedItem = feed;
		createdDate = crtdate;
		userPhoto = usrPhoto;
		countVote = votes;
		myVote = vote;
		user = userRecord;
	}

	public WrapperFeedItem(sObject feed, Date crtdate, String usrPhoto, sObject userRecord, Long votes, String vote, Integer views) {

		feedItem = feed;
		createdDate = crtdate;
		userPhoto = usrPhoto;
		countVote = votes;
		myVote = vote;
		user = userRecord;
		this.views = views;
	}

	/*public WrapperFeedItem(sObject feed, Date crtdate, String usrPhoto, String userID, Long votes, String vote, Integer views) {

		feedItem = feed;
		createdDate = crtdate;
		userPhoto = usrPhoto;
		countVote = votes;
		myVote = vote;
		userId = userID;
		this.views = views;
	}*/

	global Integer compareTo(Object compareTo) {
        WrapperFeedItem compareToEmp = (WrapperFeedItem)compareTo;
        if (countVote == compareToEmp.countVote) return 0;
        if (countVote > compareToEmp.countVote) return -1;
        return 1;        
    }
}