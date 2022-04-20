({
	doInit : function(component, event, helper) {
        var usrId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", usrId);

        if (!component.get("v.isThisQuestionListPage")) {
            helper.getFeeds(component,event);
        } else {
            helper.getTotalPages(component,event);
            helper.getFilteredQuestions(component,event);
        }

        //helper.getTopics(component,event);
    },

    upvoteFeedItem : function(component, event, helper) {
        var feedItemId = event.currentTarget.id;
        var feedItemVote = event.currentTarget.name;
        helper.upvoteFeedItem(component, feedItemId, feedItemVote, helper);        
    },

    downvoteFeedItem : function(component, event, helper) {
        var feedItemId = event.currentTarget.id;
        var feedItemVote = event.currentTarget.name;
        helper.downvoteFeedItem(component, feedItemId, feedItemVote, helper);
    },

    /*filterData:function(component, event, helper) {
        helper.getSelectedFeeds(component, event);
    },*/

    filterQuestions:function(component, event, helper) {
        helper.changeQuestionsFilter(component, event);
    },

    firstPage:function(component, event, helper) {
        helper.getRecordsFirstPage(component,event);
    },

    prevPage:function(component, event, helper) {
        helper.getRecordsPrevPage(component,event);
    },

    nextPage:function(component, event, helper) {
        helper.getRecordsNextPage(component,event);
    },

    lastPage:function(component, event, helper) {
        helper.getRecordsLastPage(component,event);
    },
    getPageNumber : function(component,event,helper) {
        if (event.which === 13 || event.keyCode === 13) {
            helper.getRecordsWithPageNumber(component,event);
        }
    }
})