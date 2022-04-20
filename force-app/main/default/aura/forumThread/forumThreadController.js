({
    doInit : function(component, event, helper)
    {
        var isThread = component.get("v.threadFilter");
        var CollabId = component.get("v.threadFiltercollabId");
        var urlString = window.location.href;
        var urlSplitted; 
        var commURL;
        var groupSplitted; 
        var idUrl;
        
        if($A.util.isUndefinedOrNull(isThread)){
            urlSplitted = urlString.split("group/");
            commURL = urlSplitted[0];
            groupSplitted = urlSplitted[1].split("/");
            idUrl = groupSplitted[0];
        }else{
            urlSplitted = urlString.split("discussions");
            commURL = urlSplitted[0];
            idUrl = CollabId;
        }
        //helper.initiate(component, event, helper, idUrl,commURL,isThread);
        helper.getUser(component, event, helper);
        helper.getName(component, event, helper,idUrl);
        helper.getSubscriptions(component, event, helper);
        helper.getCollaborationGroupFeedList(component, event, helper, idUrl,commURL,isThread);
    },
    refresh: function(component, event, helper) {
        
        $A.get('e.force:refreshView').fire();  
    },
    
    closeModal: function(component, event, helper) {
        helper.closeAll(component,event, helper);
        
    },
    copyLink :function(component, event, helper) {
        var textForCopy = component.find('inputF').get("v.value");
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
    
    //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    },
    handleTableSort : function(component, event, helper){
        var sortVal = component.find('mobileTableSort').get('v.value');
        if(sortVal == 'Today'){
            window.location = $A.get("$Label.c.filterToday");
        } else if(sortVal == 'SinceLastVisit') {
            window.location = $A.get("$Label.c.filterSinceLastVisit");
        } else if(sortVal == 'Trending'){
            window.location = $A.get("$Label.c.filterTrending");              
        } else{   
            component.set("v.sortDirectionValue ",'asc');
            var sortDirectVal = component.get("v.sortDirectionValue");
            helper.sortData(component,sortVal,sortDirectVal);
        }
        /*var sortVal = component.find('mobileTableSort').get('v.value');
        component.set("v.sortDirectionValue ",'asc');
        var sortDirectVal = component.get("v.sortDirectionValue");
        helper.sortData(component,sortVal,sortDirectVal);*/
    },
    handleRowAction : function(component, event, helper){
        var feedUrl = $A.get("$Label.c.feedItemsUrl");
        var action = {};
        var row = {};
        var device = $A.get("$Browser.formFactor");
        
        if (device == 'DESKTOP') {
        	action = event.getParam('action');
        	row = event.getParam('row');
        } else {
            var filteredData = component.get("v.filteredData");
            var dataId = event.getSource().get("v.name");
            filteredData.forEach(function(data) {
                if (data.Id == dataId) {
                    row = data;
                }
            });
            action = {
                name: event.getParam('value')
            };
        }
        
        switch (action.name) {
            case 'forward':
                var recordId = row.Id;
                component.set("v.feedRecId",recordId);
                component.set("v.isSendMessage", true);
                var getDomain = feedUrl + recordId;
                component.set("v.copyURL",  getDomain);
                helper.getFeedName(component, event, helper,recordId);
                
                break;
            case 'getLink':
                var recordId = row.Id;
                component.set("v.isGetLink", true);
                var getDomain = feedUrl + row.Id;           
                component.set("v.copyURL", getDomain);
                
                
                break;
            case 'pin':
                var recordId = row.Id;
                var isPinId = component.set("v.isPinId", recordId );
                helper.pinPost(component, event, helper);
                break;
            case 'unpin':
                var recordId = row.Id;            
                var isPinId = component.set("v.isPinId", recordId );
                helper.unpinPost(component, event, helper);
                break;        
            case 'delete':
                var recordId = row.Id;
                component.set("v.deleteGroupFeed", recordId );
                component.set("v.isDelete", true);
                break;
            case 'subscribe':
                var recordId = row.Id;
                helper.subscribeToPost(component,event,helper,recordId);
                break;
                $A.get('e.force:refreshView').fire();
                
            case 'unsubscribe':          
                var recordId = row.Id;
                helper.unsubscribeToPost(component,event,helper,recordId);
                break;
                $A.get('e.force:refreshView').fire();
            case 'lock':
                var recordId = row.Id;
                helper.lockThread(component,event,helper,recordId);
                break;
                $A.get('e.force:refreshView').fire();
            case 'unlock':
                var recordId = row.Id;
                helper.unlockThread(component,event,helper,recordId);
                break;
                $A.get('e.force:refreshView').fire();
                
        }
    },
    
    next : function(component, event, helper)
    { /*---Pagination Next Button Click--*/
        var collabList = component.get("v.collabList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var paginationList = collabList.slice(end+1,end+pageSize+1);//Slicing List as page number
        start = start + pageSize;
        end = end + pageSize;
        component.set("v.start",start);
        component.set("v.end",end);        
        component.set('v.collabFeedList', paginationList);
        var currentPageNumber= component.get('v.currentPageNumber')+1;//Current Page Number
        component.set('v.currentPageNumber',currentPageNumber);
        helper.helperMethodPagination(component, event, helper,parseInt(currentPageNumber));
    },
    previous : function(component, event, helper)
    {
        /*---Pagination previous Button Click--*/
        var collabList = component.get("v.collabList");//All CollaborationGroupFeed List
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var paginationList = collabList.slice(start-pageSize,start);//Slicing List as page number
        start = start - pageSize;
        end = end - pageSize;
        component.set("v.start",start);
        component.set("v.end",end);        
        component.set('v.collabFeedList', paginationList);
        var currentPageNumber= component.get('v.currentPageNumber')-1;//Current Page Number
        component.set('v.currentPageNumber',currentPageNumber);
        helper.helperMethodPagination(component, event, helper,parseInt(currentPageNumber));//Reset Pagination
    },
    currentPage: function(component, event, helper) {
        /*---Pagination Number Button Click--*/
        var selectedItem = event.currentTarget;
        var pagenum = selectedItem.dataset.record;//Current Page Number
        var pageSize = component.get("v.pageSize");
        var collabList = component.get("v.collabList");//All Account List
        var start =(pagenum-1)*pageSize;
        var end = ((pagenum-1)*pageSize)+pageSize-1;
        var paginationList = collabList.slice(start,end+1);//Slicing List as page number
        component.set("v.start",start);
        component.set("v.end",end);        
        component.set('v.collabFeedList', paginationList);
        component.set('v.currentPageNumber', parseInt(pagenum));
        helper.helperMethodPagination(component, event, helper,parseInt(pagenum));//Reset Pagination
    },
    
    forwardEmail: function(component, event, helper) {        
        var setBody = component.get("v.copyURL");
        component.set("v.body",setBody);
        var getEmail = component.get("v.email");
        var getSubject = component.get("v.subject");
        var eSubject = component.get("v.userInfo.Name") + " forwarded this post to you: " + component.get("v.subject");
        
        var getbody = component.get("v.body");
        
        if ($A.util.isEmpty(getEmail) || !getEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        } else {          
            helper.sendHelper(component, getEmail, eSubject,getSubject, getbody);
        }
        
        helper.closeAll(component,event, helper);
        
    },
    
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.email", null);
        component.set("v.subject", null);
        component.set("v.body", null);
    },
    yesDelete: function(component, event, helper) {
        helper.delRecord(component, event, helper);
    },
    checkBrowser: function(component) {
        var device = $A.get("$Browser.formFactor");
    } ,
    onNext: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        let newPageNumber = pageNumber + 1;
        component.set("v.currentPageNumber", newPageNumber);
        helper.setFilterAndPageNumberInURL(component, event, helper, newPageNumber);
        helper.setPageDataAsPerPagination(component);
    },
    onPrev: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        let newPageNumber = pageNumber - 1;
        component.set("v.currentPageNumber", newPageNumber);
        helper.setFilterAndPageNumberInURL(component, event, helper, newPageNumber);
        helper.setPageDataAsPerPagination(component);
    },
    onFirst: function(component, event, helper) {   
        let newPageNumber = 1;     
        component.set("v.currentPageNumber", newPageNumber);
        helper.setFilterAndPageNumberInURL(component, event, helper, newPageNumber);
        helper.setPageDataAsPerPagination(component);
    },
    
    onLast: function(component, event, helper) {     
        let newPageNumber = component.get("v.totalPages");        
        component.set("v.currentPageNumber", newPageNumber);
        helper.setFilterAndPageNumberInURL(component, event, helper, newPageNumber);
        helper.setPageDataAsPerPagination(component);
    },
    
    handleChangePage: function(component, event, helper) {
        var newPageNumber = event.getSource().get("v.label");
        component.set("v.currentPageNumber", newPageNumber);
        helper.setFilterAndPageNumberInURL(component, event, helper, newPageNumber);
        helper.setPageDataAsPerPagination(component);
    }
})