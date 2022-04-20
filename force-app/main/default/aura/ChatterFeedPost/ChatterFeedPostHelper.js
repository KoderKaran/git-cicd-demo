({
	getFeedComments : function(component, event) {

        var action = component.get("c.getFeedComments");
        action.setParams({
        	itemId : component.get("v.recordId"),
            networkId : ''
        });
        action.setCallback(this, function(response) {
            var comments = response.getReturnValue();
            for (var i = 0; i < comments.length; i++) {
                console.log(comments[i]);
            }
	        component.set("v.comments", comments);
            //console.log('comments: ' + comments);
        });

        $A.enqueueAction(action);
	},

	getFeedItem : function(component, event) {

        var action = component.get("c.getFeedItem");
        action.setParams({
        	itemId : component.get("v.recordId"),
            networkId : ''
        });
        action.setCallback(this, function(response) {
            var feed = response.getReturnValue();
	        component.set("v.feed", feed);
            console.log('feed: ' + feed);
            var userId = component.get("v.userId");
            if (feed.feedItem.BestCommentId == null){
                component.set("v.editMode", true);
            } else {
                component.set("v.editMode", false);
            }
            if (userId == feed.feedItem.Id){
                document.getElementById(feed.feedItem.Id).classList.add("pointer");
            }
        });

        $A.enqueueAction(action);
	},

    getUserPhoto : function(component, event) {
        
        var usrId = $A.get("$SObjectType.CurrentUser.Id");

        var action = component.get("c.getUserPhoto");
        action.setParams({
            userId : usrId
        });
        action.setCallback(this, function(response) {
            var userPhoto = response.getReturnValue();
            component.set("v.user", userPhoto);
            console.log('userPhoto: ' + userPhoto);
        });

        $A.enqueueAction(action);
    }, 

    /*getTopics : function(component, event) {
        var action = component.get("c.getFeedTopics");
        action.setParams({
            itemId : component.get("v.recordId"),
            networkId : ''
        });
        action.setCallback(this, function(response) {
            var topics = response.getReturnValue();
            component.set("v.topics", topics);
        });

        $A.enqueueAction(action);
    },*/

    getFeedAttach : function(component, event) {
        var action = component.get("c.getFeedAttach");
        action.setParams({
            itemId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var feedAttachment = response.getReturnValue();
            component.set("v.feedAttachment", feedAttachment);
        });

        $A.enqueueAction(action);
    },

    upvoteFeedComment : function(component, feedCommentId, commentVote, helper, event) {
        var action = component.get("c.upvoteThisComment");
        action.setParams({
            'feedCommentId' : feedCommentId,
            'commentVote' : commentVote,
            'networkId' : ''
        });
        action.setCallback(this, function(response) {
            /*var comment = response.getReturnValue();
            var comments = component.get('v.comments');
            for (var i = comments.length - 1; i >= 0; i--) {
                if(comments[i].feedComment.Id === feedItemId) {
                    comments[i] = comment;
                    break;
                }
            }
            component.set("v.comments",comments);*/
            helper.getFeedComments(component, event);
        });

        $A.enqueueAction(action);
    },
    downvoteFeedComment : function(component, feedCommentId, commentVote, helper, event) {
        var action = component.get("c.downvoteThisComment");
        action.setParams({
            'feedCommentId' : feedCommentId,
            'commentVote' : commentVote,
            'networkId' : ''
        });
        action.setCallback(this, function(response) {
            /*var comment = response.getReturnValue();
            var comments = component.get('v.comments');
            for (var i = comments.length - 1; i >= 0; i--) {
                if(comments[i].feedComment.Id === feedItemId) {
                    comments[i] = comment;
                    break;
                }
            }
            component.set("v.comments",comments);*/
            helper.getFeedComments(component, event);
        });

        $A.enqueueAction(action);
    },

    upvoteFeedItem :function(component, feedItemId, feedItemVote) {
        var action = component.get("c.upvoteThisFeedItem");
        action.setParams({
            'feedItemId' : feedItemId,
            'feedItemVote' : feedItemVote,
            'networkId' : ''
        });
        action.setCallback(this, function(response) {
            var item = response.getReturnValue();
            component.set("v.feed", item);
        });

        $A.enqueueAction(action);
    },
    downvoteFeedItem : function(component, feedItemId, feedItemVote) {
        var action = component.get("c.downvoteThisFeedItem");
        action.setParams({
            'feedItemId' : feedItemId,
            'feedItemVote' : feedItemVote,
            'networkId' : ''
        });
        action.setCallback(this, function(response) {
            var item = response.getReturnValue();
            component.set("v.feed", item);
        });

        $A.enqueueAction(action);
    },
    updateViews : function(component, event) {
        var action = component.get("c.updateViewsForFeedItem");
        action.setParams({
            'feedItemId' : component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            console.log('success');
        });

        $A.enqueueAction(action);
    }

})