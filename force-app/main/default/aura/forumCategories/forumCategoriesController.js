({
    doInit : function(component, event, helper) {
        
        var urlString = window.location.href;
        var url = new URL(urlString);
        var checkUrl  =url.searchParams.get("view");
        
        if($A.util.isUndefinedOrNull(checkUrl)){
            component.set("v.threadFilter","default");
        }else{
            component.set("v.threadFilter",checkUrl);
            component.set("v.threadFilterBoolean",true);
        }
        
        var action2 = component.get("c.fetchUser");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
            
            var profileId = component.get("v.userInfo.ProfileId");
            var DiscussionForumModerator = $A.get("$Label.c.Discussion_Forum_Moderator_Profile_ID");
            var SystemAdmin = $A.get("$Label.c.System_Admin_Profile_Id");
            if (profileId.includes(DiscussionForumModerator) || profileId.includes(SystemAdmin)){
                
                component.set("v.isAdminOnly",true);
            }
        });
        $A.enqueueAction(action2);
        
        
        helper.initiate(component, event, helper);
        
        helper.getFeedItemPerCollab(component, event, helper);
        
        
        
    },
    handleClick : function(cmp, event, helper) {
        cmp.set("v.isOpen", true);
        cmp.set("v.name" , null);
        cmp.set("v.description", null);
        
    },
    newPost : function(cmp, event, helper) {
        cmp.set("v.newPostOpen", true);
        
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
    },
    handleRowAction : function(component, event, helper){
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
            case 'edit':
                var recordId = row.Id;
                component.set("v.colabRecord", recordId );
                helper.editRecord(component, event, helper,recordId);
                component.set("v.isOpenEdit", true);
                break;
            case 'delete':
                var recordId = row.Id;
                component.set("v.colabRecord", recordId );
                component.set("v.isDelete", true);
                break;
            case 'manage':
                if (row.CollaborationType == 'Public') {
                    alert('public groups do not require access');
                }
                else {
                    var recordId = row.Id;
                    component.set("v.recordId1", recordId);
                    component.set("v.colabRecord", recordId );
                    component.set("v.isManageUser", true);  
                }
                break;
            case 'subscribe':
                var recordId = row.Id;
                helper.subscribeToGroup(component,event,helper,recordId);
                break;
                $A.get('e.force:refreshView').fire();
                
            case 'unsubscribe':          
                var recordId = row.Id;
                helper.unsubscribeToGroup(component,event,helper,recordId);
                break;
                $A.get('e.force:refreshView').fire();
            case 'lock':
                var recordId = row.Id;
                helper.lockCategory(component,event,helper,recordId);
                break;
            case 'unlock':
                var recordId = row.Id;
                helper.unlockCategory(component,event,helper,recordId);
                break;
        }
    },
    
    populateUser : function(component, event, helper){
        var recordId = component.get("v.recordId1");
        
        var searchField = component.find('searchField');
        var isValueMissing = searchField.get('v.validity').valueMissing;
        if(isValueMissing) {
            searchField.showHelpMessageIfInvalid();
            searchField.focus();
        }else{ 
            //helper.SearchHelper(component, event);
            helper.getCurrentMember(component, event, helper,recordId);
        }
        
        
        //helper.getCurrentMember(component, event, helper,recordId);
    },
    
    isSendMessage : function(component, event, helper) {
        
    },
    
    addUser : function(component, event, helper) {
        
        helper.UsertoGroup(component, event, helper); 
        component.set("addUserToGroup",false);
    },
    removeUserToGroup : function(component, event, helper) {
        
        helper.removeUsersToGroup(component, event, helper); 
        component.set("addUserToGroup",false);
    },
    editRec :function(component, event, helper) {
        helper.saveEdit(component, event, helper);
        // location.reload();
        
    },
    yesDelete: function(component, event, helper) {
        helper.delRecord(component, event, helper);
    },
    createNewCategory: function(component, event, helper) {
        
        var action = component.get("c.saveRecord"); 
        action.setParams({
            'name' : component.get("v.name"), 
            'colType' : component.get("v.typeSelected"),
            'description' : component.get("v.description"),
            'isAuto' : component.get("v.isAuto"),
            'isLock' : component.get("v.lockCategories")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                location.reload();
            } else {
                console.log(response.getError());
            }
            
        });
        component.set("v.isOpen", false);
        $A.enqueueAction(action);
    },
    saveShadowObject: function (component, event,helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    closeModal: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set("v.newPostOpen", false);
        component.set("v.isDelete", false);
        component.set("v.isOpenEdit", false);
        component.set("v.isGetLink", false);
        component.set('v.isInputFieldActive',false);
        component.set("v.isSendMessage", false);
        component.set("v.isManageUser", false);
        component.set("v.isOpenShadowObject", false);
    },
    
    
    handleChange: function (cmp, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        cmp.set("v.type", selectedOptionValue);
    },
    
    redirect: function(component, event, helper) {
        component.set("v.isShowCategory", false);
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record;
        var action = component.get("c.getListCollaborationFeed"); 
        action.setParams({
            'collabId' : recId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            //if callback is Success then show toast message and close the modal popup
            if(state === "SUCCESS")
            {
                var checkVal = response.getReturnValue();
                component.set("v.collabFeedList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    paginiationRedirect : function(component, event, helper)
    {
        component.set("v.isShowCategory", false);
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record;
        component.set("v.selectedThreadId", recId);
        var childCmp = component.find("cComp")
        childCmp.childAttr(); 
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
        var collabList = component.get("v.collabList");//All Account List
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
    sortType: function(component, event, helper){
        alert('Collaboration Type Sort');
    },
    searchKeyChange: function(component, event, helper){
        var myEvent = $A.get("e.SearchKeyChange");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();
    },
    checkBrowser: function(component) {
        var device = $A.get("$Browser.formFactor");
    },
    
    handleToday: function(component, event, helper){
        window.location = $A.get("$Label.c.filterToday");
    },
    handleLastVisited: function(component, event, helper){
        window.location = $A.get("$Label.c.filterSinceLastVisit");
    },
    handleTrending: function(component, event, helper){
        window.location = $A.get("$Label.c.filterTrending")
    },
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
        component.set("v.currentPageNumber", 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onLast: function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPageDataAsPerPagination(component);
    },
    
    handleChangePage: function(component, event, helper) {
        var newPageNumber = event.getSource().get("v.label");
        component.set("v.currentPageNumber", newPageNumber);
        helper.setFilterAndPageNumberInURL(component, event, helper, newPageNumber);
        helper.setPageDataAsPerPagination(component);
    }
})