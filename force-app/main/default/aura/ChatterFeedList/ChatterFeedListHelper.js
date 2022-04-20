({
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
    /*getSelectedFeeds:function(component, event) {
        var filterNames = event.getParam("topicNames");
        if (filterNames.length != 0) {
            var action = component.get("c.filterByTopicName");
            action.setParams({
                topicNames : filterNames,
                networkId : ''
            });
            action.setCallback(this, function(response) {
                var feeds = response.getReturnValue();
                component.set("v.feeds", feeds);
                console.log(feeds);
            });

            $A.enqueueAction(action);
        } else {
            this.getFeeds(component, event);
        }
    },*/
    upvoteFeedItem :function(component, feedItemId, feedItemVote, helper) {
        var action = component.get("c.upvoteThisFeedItem");
        action.setParams({
            'feedItemId' : feedItemId,
            'feedItemVote' : feedItemVote,
            'networkId' : ''
        });
        action.setCallback(this, function(response) {
            var item = response.getReturnValue();
            var feeds = component.get('v.feeds');
            for (var i = feeds.length - 1; i >= 0; i--) {
                if(feeds[i].feedItem.Id === feedItemId) {
                    feeds[i] = item;
                    break;
                }
            }
            component.set("v.feeds",feeds);
            //helper.getFeeds(component,event);
        });

        $A.enqueueAction(action);
    },
    downvoteFeedItem : function(component, feedItemId, feedItemVote, helper) {
        var action = component.get("c.downvoteThisFeedItem");
        action.setParams({
            'feedItemId' : feedItemId,
            'feedItemVote' : feedItemVote,
            'networkId' : ''
        });
        action.setCallback(this, function(response) {
            var item = response.getReturnValue();
            var feeds = component.get('v.feeds');
            for (var i = feeds.length - 1; i >= 0; i--) {
                if(feeds[i].feedItem.Id === feedItemId) {
                    feeds[i] = item;
                    break;
                }
            }
            component.set("v.feeds",feeds);
        });

        $A.enqueueAction(action);
    }, 
    getFeeds : function(component, event) {
        var action = component.get("c.getFeeds");
        action.setParams({
            "numberOfRecords" : component.get("v.numOfRecords"),
            "networkId" : ''
        });
        action.setCallback(this, function(response) {
            var feeds = response.getReturnValue();
            component.set("v.feeds", feeds);
            console.log(feeds);
        });

        $A.enqueueAction(action);
    },

    getFilteredQuestions : function(component, event) {
        var action = component.get("c.getQuestions");
        action.setParams({
            "questionsType" : component.get("v.questionsType"),
            "numberOfRecords" : component.get("v.numOfRecords"),
            "currentPage" : component.get("v.currentPage"),
            "networkId" : ''
        });
        action.setCallback(this, function(response) {
            var feeds = response.getReturnValue();
            component.set("v.feeds", feeds);
            console.log(feeds);
        });

        $A.enqueueAction(action);
    },

    changeQuestionsFilter : function(component, event) {
        var filter = event.target.value;
        component.set("v.questionsType",filter);
        component.set("v.currentPage",1);
        if (filter !== 'Latest') {
            this.getTotalPages(component,event);
        }
        this.getFilteredQuestions(component, event);
    },

    getRecordsFirstPage : function(component, event) {
        component.set("v.currentPage",1);
        var action = component.get("c.getQuestions");
        action.setParams({
            "questionsType" : component.get("v.questionsType"),
            "numberOfRecords" : component.get("v.numOfRecords"),
            "currentPage" : component.get("v.currentPage"),
            "networkId" : ''
        });
        action.setCallback(this, function(response) {
            var feeds = response.getReturnValue();
            component.set("v.feeds", feeds);
        });

        $A.enqueueAction(action);
    },

    getRecordsPrevPage : function(component, event) {
        var curPage = component.get("v.currentPage");
        curPage--;
        component.set("v.currentPage", curPage);

        var action = component.get("c.getQuestions");
        action.setParams({
            "questionsType" : component.get("v.questionsType"),
            "numberOfRecords" : component.get("v.numOfRecords"),
            "currentPage" : component.get("v.currentPage"),
            "networkId" : ''
        });
        action.setCallback(this, function(response) {
            var feeds = response.getReturnValue();
            component.set("v.feeds", feeds);
        });

        $A.enqueueAction(action);
    },

    getRecordsNextPage : function(component, event) {
        var curPage = component.get("v.currentPage");
        curPage++;
        component.set("v.currentPage", curPage);

        var action = component.get("c.getQuestions");
        action.setParams({
            "questionsType" : component.get("v.questionsType"),
            "numberOfRecords" : component.get("v.numOfRecords"),
            "currentPage" : component.get("v.currentPage"),
            "networkId" : ''
        });
        action.setCallback(this, function(response) {
            var feeds = response.getReturnValue();
            component.set("v.feeds", feeds);
        });

        $A.enqueueAction(action);
    },

    getRecordsLastPage : function(component, event) {
        component.set("v.currentPage", component.get("v.totalPages"));
        var action = component.get("c.getQuestions");
        action.setParams({
            "questionsType" : component.get("v.questionsType"),
            "numberOfRecords" : component.get("v.numOfRecords"),
            "currentPage" : component.get("v.currentPage"),
            "networkId" : ''
        });
        action.setCallback(this, function(response) {
            var feeds = response.getReturnValue();
            component.set("v.feeds", feeds);
        });

        $A.enqueueAction(action);
    },

    getTotalPages : function(component, event) {
        var action = component.get("c.getTotalNumberOfPages");
        action.setParams({
            "questionsType" : component.get("v.questionsType"),
            "numberOfRecords" : component.get("v.numOfRecords"),
            "networkId" : ''
        });
        action.setCallback(this, function(response) {
            var pages = response.getReturnValue();
            component.set("v.totalPages", pages);
        });

        $A.enqueueAction(action);
    },

    getRecordsWithPageNumber : function(component, event) {
        var pageNumber = event.currentTarget.value;
        component.set("v.currentPage", pagenumber);
        var action = component.get("c.getQuestions");
        action.setParams({
            "questionsType" : component.get("v.questionsType"),
            "numberOfRecords" : component.get("v.numOfRecords"),
            "currentPage" : component.get("v.currentPage"),
            "networkId" : ''
        });
        action.setCallback(this, function(response) {
            var feeds = response.getReturnValue();
            component.set("v.feeds", feeds);
        });

        $A.enqueueAction(action);
    },
})