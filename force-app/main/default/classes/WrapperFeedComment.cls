global without sharing class WrapperFeedComment implements Comparable {
	
	@AuraEnabled
	public sObject feedComment {get; set;}

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
	
	public WrapperFeedComment(sObject feed, Date crtdate, String usrPhoto, sObject userRecord, Long votes, String vote, String attachmentId) {
		feedComment = feed;
		createdDate = crtdate;
		userPhoto = usrPhoto;
		countVote = votes;
		myVote = vote;
		user = userRecord;
		fileId = attachmentId;
	}

	global Integer compareTo(Object compareTo) {
        WrapperFeedComment compareToEmp = (WrapperFeedComment)compareTo;
        if (countVote == compareToEmp.countVote) return 0;
        if (countVote > compareToEmp.countVote) return -1;
        return 1;        
    }
}