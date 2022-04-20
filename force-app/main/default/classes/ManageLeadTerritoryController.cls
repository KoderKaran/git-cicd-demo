public class ManageLeadTerritoryController {
    /*Initializing private variables with NULL value. This variables has ID type, it means
      that the should contains ID of some records. In our case it's a record type ID
      See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_access_modifiers.htm
                  https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_primitives.htm

    */
    /*Constructor of our class
      See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_constructors.htm?search_text=constructor*/
    public ManageLeadTerritoryController(){
        IsCreatedTerr = false;
        SystemHasLeadTerrSetup = false;
        List<Territory_Setup__c> LeadTerrSetups = [select Id, Next_Mass_Update_Date_Lead__c, Status__c from Territory_Setup__c 
                                        order by lastmodifieddate desc limit 1];
        if(!LeadTerrSetups.isEmpty()) {
            SystemHasLeadTerrSetup = true;
            LeadTerrSetup = LeadTerrSetups.get(0);
        } else {
            LeadTerrSetup = new Territory_Setup__c(Status__c = 'On');
        }                           
        /*Call "setRecordTypeIds" method*/
        /*Initializing List of Strings
          See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_list.htm
        */
        errorMessages = new List<String>();
        /*Creating instance of "Lead_Territory__c" object and assigning to "RecordTypeId" value of variable "leadTerritoryRecordTypeId"
          See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_SObjects.htm?search_text=sobject
         */
        leadTerritory = new Lead_Territory__c( );
        /*Initializing List of User objects*/
        users = new List<User>();
        /*Initializing List of Lead_Territory_Geography__c objects*/
        newLeadTerritoryGeos = new List<Lead_Territory_Geography__c>();
        /*In this loop we add to "newLeadTerritoryGeos" instances of "Lead_Territory_Geography__c" object and specify value of a 
           "RecordTypeId" field
         */
        for(Integer i = 0; i < 5; i++){
            newLeadTerritoryGeos.add(new Lead_Territory_Geography__c());
        }  
        /*Call "setLeadTerritories" method*/
        setLeadTerritories();
        isActive = true;
        // isActive = false;
        // String customerSTatus = CheckTPSStatus.checkimmestatus();
        // if(customerSTatus == 'Active')
        // {
        // isActive = true;
        // }
        // else
        // {
        // errorMessages.add('Your accout status with Touchpoint Solutions is shown as Inactive. The Lead Routing app will be disabled until your account is made Active. Please contact Touchpoint Solutions to have your status reactivated.');
        // }
         /*
        List<TPSStatus__c> tpsSTatuss = [select Id from TPSStatus__c where Status__c = 'Active'];//TPSStatus__c tps = new TPSStatus__c(Name = '1', STatus__c = 'Active')
        if(tpsSTatuss.size() > 0)
        {
            isActive = true;
        }
        else
        {
            errorMessages.add('Your accout status with Touchpoint Solutions is shown as Inactive. The Lead Routing app will be disabled until your account is made Active. Please contact Touchpoint Solutions to have your status reactivated.');
        }*/
        defautusers = [select Name, Title, Email, Phone, UserRole.Name from User where isactive = true and User.Profile.UserLicense.Name != 'Chatter Free' limit 50];
        defaultLeadQueues = [select Id, Name from Group where Type = 'Queue' limit 50];
    }
   
public String rerenderId { get; set; }

    /*This block it's a block of variables, lists and object's instaces with getters and setters.
      See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_properties.htm 
     */
     public String tmp { get; set; }
      public Boolean isActive { get; set; }
    public List<User> users { get; set; }
    public List<Group> LeadQueues { get; set; }
    public List<User> defautusers { get; set; }
    public List<Group> defaultLeadQueues { get; set; }
    public String userinfo { get; set; }
    public String searchType { get; set; }
    public List<Lead_Territory_Geography__c> newLeadTerritoryGeos { get; set; }
    public String AssignmentsCSV { get; set; }
    public Boolean SystemHasLeadTerrSetup { get; set; }
    public List<String> errorMessages { get; set; }
    public Lead_Territory__c leadTerritory { get; set; }
    public String jsonCriteria { get; set; }
    public String removedId { get; set; }
    public String removedType { get; set; }
    public String territoryOrder { get; set; }
    public String CurrentTerritoryId { get; set; }
    public Lead leadObject { get; set; }
    //public Integer CurrentIndex { get; set; }
    public Boolean IsCreatedTerr { get; set; }
    
    public Territory_Setup__c LeadTerrSetup { get; set; }
    
    public List<Lead_Territory__c> leadTerritories { get; set; }
    
    public List<Lead_Territory_Geography__c> DisplayGeos { get; set; }
    public List<Lead_Territory_Field_Criteria__c> DisplayFcs { get; set; }
    
    
    public PageReference checkCustomerTpsStatus()
    {
        CheckTPSStatus.checkimmestatus();
        STring currentUrl = ApexPages.currentPage().getUrl();
        pageReference retPage = new PageReference(currentUrl);
        retPage.setRedirect(true);
        return retPage;
    }
    
    public void refreshDIsplayRecords()
    {
        List<Lead_Territory__c> thisleadTerritories = [select Id, Name, Type__c,  Effective_Date__c, Assigned_To_Type__c, Assigned_To_ID__c, Assigned_To__c, Order__c, of_Field_Criteria__c, of_Geographic_Criteria__c,
            (select lead_Territory__c, Country__c, State__c, Zip_End__c, Zip_Start__c from Lead_Territory_Geographies__r order by CreatedDate desc),
            (select Lead_Territory__c, Lead_Field__c, Operator__c, Value__c from Lead_territory_Field_Criteria__r order by CreatedDate desc)
            from Lead_Territory__c where Id = : CurrentTerritoryId];
        DisplayGeos = thisleadTerritories[0].Lead_Territory_Geographies__r;
        DisplayFcs = thisleadTerritories[0].Lead_territory_Field_Criteria__r;
    }
    
      /**
     * Public methods ------->
     */
    @RemoteAction
    public static void setupStatus(String status) {
        Boolean hasLeadTerrtorySetup = false;
        for(Territory_Setup__c item : [
                SELECT Next_Mass_Update_Date_Lead__c, Status__c
                FROM Territory_Setup__c
                ORDER BY LastModifiedDate
                DESC LIMIT 1
            ]) {

            hasLeadTerrtorySetup = true;
            item.Status__c = status;
            update item;

            List<CronJobDetail> jobDetails = [SELECT Id FROM CronJobDetail WHERE Name = 'Mass Update Leads'];
            List<CronTrigger> conTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetailId in :jobDetails];
            database.delete([SELECT Job_ID__c FROM MassUpdateLeadJOBID__c WHERE Job_ID__c != null LIMIT 1]);
            
            for(CronTrigger conTrigger : conTriggers) {
                System.abortJob(conTrigger.Id); 
            }
            
            if(status == 'On') {
                if(item.Next_Mass_Update_Date_Lead__c != null) {
                    Date massUpdateDate = item.Next_Mass_Update_Date_Lead__c;
                    String year = string.valueOf(massUpdateDate.year());
                    String month = string.valueOf(massUpdateDate.month());
                    String day = string.valueOf(massUpdateDate.day());
                    
                    assignLeadToTerritoriesScheudle m = new assignLeadToTerritoriesScheudle();
                    String sch = '0 0 1 ' + day + ' ' + month + ' ? ' + year;
                    String jobID = system.schedule('Mass Update Leads', sch, m);
                    if(jobID != null) {
                        MassUpdateLeadJOBID__c newJob = new MassUpdateLeadJOBID__c(Name = 'Lead JOB', Job_ID__c = jobID);
                        insert newJob;
                    }
                }
            }
        }

        if(!hasLeadTerrtorySetup) {
            Territory_Setup__c theLeadTerr = new Territory_Setup__c(Status__c = status);
            insert theLeadTerr;
        }
    }
    
    public PageReference massupdateTerritoriesImmed() {
        List<Territory_Setup__c> LeadTerrSetups = [
            SELECT Next_Mass_Update_Date_Lead__c, Status__c
            FROM Territory_Setup__c 
            ORDER BY LastModifiedDate
            DESC LIMIT 1
        ];

        if(!LeadTerrSetups.isEmpty() && LeadTerrSetups[0].STatus__c == 'on') {        
            String strFields = '';

            for(String strField : Schema.SObjectType.Lead.fields.getMap().keySet()) {
                strFields += strField + ', ';
            }

            String m_strAllLeadFields = strFields.substring(0, strFields.length()-2);
            String strFilterInQuery = 'where No_Mass_Update__c != true';
            String strQuery = 'select ' + m_strAllLeadFields + ' from Lead ' + strFilterInQuery;
            Map<Id, lead> leadmap = new Map<Id, Lead>();
            ReassignLeadsBatch reassignLeadBatchJob = new ReassignLeadsBatch(strQuery, leadmap);
            Database.executeBatch(reassignLeadBatchJob, 1);
        }

        pageReference retPage = new PageReference('/apex/ManageLeadTerritory');
        /*Method "setRedirect" used to redirect. In our case it sets to true and redirect is performed through a client side redirect.
          See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_System_PageReference_setRedirect.htm
        */
        retPage.setRedirect(true);
        return retPage;
    }
    
    public PageReference saveMassUpdatedDate() {
        List<Territory_Setup__c> LeadTerrSetups = [
            SELECT Next_Mass_Update_Date_Lead__c, Status__c
            FROM Territory_Setup__c 
            ORDER BY LastModifiedDate
            DESC LIMIT 1
        ];

        errorMessages = new List<String>();

        if(!LeadTerrSetups.isEmpty() && LeadTerrSetups[0].STatus__c == 'on') {
            if(LeadTerrSetup.Next_Mass_Update_Date_Lead__c == null) {
                errorMessages.add('Please entry the updated date');
                return null;
            }
            /*This row used to create your own transaction control. For this reason we create "savepoint"
              with method "Database.savepoint()" which is used to define a point which can be roll back to. 
              If any error occurs during a transaction, that contains many statements, the application will 
              roll back to the most recent savepoint and the entire transaction will not be aborted"
              See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm#apex_System_Database_setSavepoint
            */
            System.savePoint savepoint = Database.setSavePoint();
            try{
                upsert LeadTerrSetup;
                
                List<MassUpdateLeadJOBID__c> jobs = [SELECT Job_ID__c FROM MassUpdateLeadJOBID__c];
                for(MassUpdateLeadJOBID__c job : jobs) {
                    if(job.Job_ID__c != null) {
                        System.abortJob(jobs[0].Job_ID__c); 
                    }
                }
                if(!jobs.isEmpty()) {                
                    delete jobs;
                }

                Date massUpdateDate = [
                    SELECT Next_Mass_Update_Date_Lead__c
                    FROM Territory_Setup__c
                    WHERE Id = :LeadTerrSetup.Id
                ].Next_Mass_Update_Date_Lead__c;

                String year = String.valueOf(massUpdateDate.year());
                String month = String.valueOf(massUpdateDate.month());
                String day = String.valueOf(massUpdateDate.day());

                assignLeadToTerritoriesScheudle m = new assignLeadToTerritoriesScheudle();

                String sch = '0 0 1 ' + day + ' ' + month + ' ? ' + year;
                String jobID = system.schedule('Mass Update Leads', sch, m);
                MassUpdateLeadJOBID__c newJob = new MassUpdateLeadJOBID__c(Name = 'Lead JOB', Job_ID__c = jobID);
                insert newJob;
            } catch(Exception ex) {
                errorMessages.add(ex.getMessage());
                /* "Database.rollback" will  restore the database to that point( our "savepoint")
                    See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm#apex_System_Database_rollback
                */
                Database.rollBack(savepoint);
            }
        }

        return null;
    }
     
    /**
     * Public methods ------->
     */
    public void addMoreLeadTerritoryGeos()
    {
         /*In this loop we add  instances of "Lead_Territory_Geography__c" object to "newLeadTerritoryGeos" and specify value of a 
           "RecordTypeId" field
         */
        for(Integer i = 0; i < 5; i++)
        {
            newLeadTerritoryGeos.add(new Lead_Territory_Geography__c());
        }    
    }
    
    public void insertNewLeadTerritoryGeos()
    {
        List<Lead_Territory_Geography__c> needToInsertTerritoryGeos = new List<Lead_Territory_Geography__c>();
        /*At this loop we iterate over "newLeadTerritoryGeos" List. Accsess to each element of the list occurs by
            "newLeadTerritoryGeo" variable. Our List is the List of Objects and we can accsess to fields of "Lead_Territory_Geography__c"
            via "newLeadTerritoryGeo.[fieldName]" like "newLeadTerritoryGeo.Territory__c" in our case.
            See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_loops_for_lists.htm

        */
        for(Lead_Territory_Geography__c newLeadTerritoryGeo : newLeadTerritoryGeos)
        {     /*Call "validGeographicCriteria" method with "newLeadTerritoryGeo" parameter. This method returns a Boolean
               value to "IF condition"
            */
            if(validGeographicCriteria(newLeadTerritoryGeo))
            {
                if(CurrentTerritoryId != null && CurrentTerritoryId != '')
                {   /*Assigning to field "Territory__c" value of "CurrentTerritoryId" variable */
                    newLeadTerritoryGeo.Lead_Territory__c = CurrentTerritoryId;
                    /*Add our "Lead_Territory_Geography__c" with changed "Territory__c" field to List "needToInsertTerritoryGeos" */
                    needToInsertTerritoryGeos.add(newLeadTerritoryGeo);
                }
            }
        }
        /*Checking, if our List "needToInsertTerritoryGeos" size >0 (it means, that we have some records)*/
        if(needToInsertTerritoryGeos.size() > 0)
        {   /*Insert List of "Lead_Territory_Geography__c" objects
            See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dml_section.htm
            */
            insert needToInsertTerritoryGeos;
            /*Call "setLeadTerritories" method*/
            setLeadTerritories();
        }
        newLeadTerritoryGeos = new List<Lead_Territory_Geography__c>();
        for(Integer i = 0; i < 5; i++)
        {
            newLeadTerritoryGeos.add(new Lead_Territory_Geography__c());
        }
        errorMessages.clear();
    }
    
    public void insertNewLeadTerritoryGeosByCSV() {
        /* We call analyseCSVString where we convert AssignmentsCSV String to List of Lead_Territory_Geography__c objects.
        Use search by method name 'analyseCSVString' to learn how it is implemented.*/
        List<Lead_Territory_Geography__c> csvAssignments = analyseCSVString(AssignmentsCSV);

        //system.debug('AssignmentsCSV -->'+AssignmentsCSV);
        //system.debug('csvAssignments -->'+csvAssignments);
        List<Lead_Territory_Geography__c> needToInsertTerritoryGeos = new List<Lead_Territory_Geography__c>();
        for(Lead_Territory_Geography__c newLeadTerritoryGeo : csvAssignments)
        {  /*Call "validGeographicCriteria" method with "newLeadTerritoryGeo" parameter. This method returns a Boolean
               value
         */
            if(validGeographicCriteria(newLeadTerritoryGeo))
            {
                if(CurrentTerritoryId != null && CurrentTerritoryId != '')
                {
                    newLeadTerritoryGeo.Lead_Territory__c = CurrentTerritoryId;
                    needToInsertTerritoryGeos.add(newLeadTerritoryGeo);
                }
            }
        }
        if(!needToInsertTerritoryGeos.isEmpty()) {
            insert needToInsertTerritoryGeos;
            setLeadTerritories();
            AssignmentsCSV = '';
        }
        /*Clearing the "errorMessages" list
          See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_list.htm#apex_System_List_methods
        */
        errorMessages.clear();
    }
    /*Method which returns "List<SelectOption>". Used on ManageLeadTerritoryPage page*/
    public List<SelectOption> getLeadFields()
    {   /*Initialize "List<Selectoptions>"
          See more at https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/apex_pages_selectoption.htm  
        */
        List<SelectOption> result = new List<SelectOption>();
        /*Add value to our list(methods are the same with typical Lists)*/
        result.add(new SelectOption('', '--None--'));
        /*Initialize Map
          https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_map.htm
        */
        /*At this row we use Schema.sObjectField object to get all fields of "Lead" object
          See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_Schema_SObjectField.htm#apex_Schema_SObjectField_getDescribe
                      https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dynamic_describe_objects_understanding.htm
                      https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dynamic_field_tokens.htm
        */
        Map<String, Schema.SObjectField> fieldMap = Lead.SObjectType.getDescribe().Fields.getMap();
        
        List<String> fieldLabels = new List<String>();
        Map<String, String> fieldNames = new Map<String, String>();
        /*In this loop we fill our "fieldNames" Map and "fieldLabels" List. We iterate over "fieldMap" values (method ".values()") 
          To "fieldLabels" we add label of Lead object field and to "fieldNames" we put pair of key(field label, using ".getLabel()") 
          and value(field name, using ".getName()"). Keep in mind, that field Name and Label can be different.
          More about Map methods at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_map.htm#apex_System_Map_methods
        */
        for (Schema.SObjectField field: fieldMap.values())
        {
            Schema.DescribeFieldResult fieldDes = field.getDescribe();
            fieldLabels.add(fieldDes.getLabel());
            fieldNames.put(fieldDes.getLabel(), fieldDes.getName());
        }
        /*Sorting "fieldLabels" list. See "sort()" method in List methods*/
        fieldLabels.sort();
        for (String label: fieldLabels) 
        {
            result.add(new SelectOption(fieldNames.get(label), label));
        }
        /*Return of List <Selectoption>*/
        return result;
    }
    /*This metod invokes from ManageLeadTerritoryPage. Use search by method name on the page. 
      See more about pageReference type at https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_quick_start_controller_navigation_methods.htm
    */
    public pageReference createLeadTerritory(){
        if(!validLeadTerritory(leadTerritory)){
            return null;
        }

        errorMessages = new List<String>();
        /*Creating new instance of "Lead_Territory__c" object by cloning "leadTerritory" object(it's instance
            of "Lead_Territory__c" object too)
        See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_sobject.htm#apex_System_SObject_clone
         */
        Lead_Territory__c newTerritory = leadTerritory.clone();
        if(leadTerritories.isEmpty()){
            newTerritory.Order__c = 1;
        }
        else{
            /*Assigning value to "Order__c" field. Accsess to element of "leadTerritories" by index which consist of the difference between size of 
            "leadTerritories" (we remember, that is the Integer value) and "1". */
            newTerritory.Order__c = leadTerritories[leadTerritories.size() - 1].Order__c + 1;
        }
        /*Try-catch block used to handle exceptions. In "try" we put a block of code, which will be executed and exception
        can occur. "catch" identifies a block of code that handles a particular type of exception. In a brackets you can see a 
        type of exception that will be handled.
        See more https://developer.salesforce.com/docs/atlas.en-us.apex_workbook.meta/apex_workbook/apex7_2.htm
        */
        try{
            insert newTerritory;
            leadTerritories.add(newTerritory);
            leadTerritory = new Lead_Territory__c();
            setLeadTerritories();
            IsCreatedTerr = true;
            PageReference retpage = new PageReference('/apex/ManageLeadTerritory');
            retPage.setRedirect(true);
            return retpage;
        }
        catch(Exception ex){
            errorMessages.add(ex.getMessage());
        }
        
        return null;
    }
    
    public pageReference editLeadTerritory(){
        /*At this row we set value to "territoryId" variable. For this reason we use "ApexPages" class and
         methods "currentPage() (returns the current page's PageReference)", "getParameters() (map of parameters that are 
         included in the page URL)" and "get('id') (get the value of parameter with name "id")" For example:
         https://example.com/test/somePage?id=2&name=test&surname=test. If in "get('id')" we change "id" to "name" our
         "territoryId" variable will has value 'test'
         See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_System_PageReference_getParameters.htm
                     https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/apex_System_ApexPages_methods.htm
        */
        errorMessages = new List<String>();
        String territoryId = ApexPages.currentPage().getParameters().get('id');
        for(Lead_Territory__c territory : leadTerritories){
            if(territory.Id == territoryId){
                if(validLeadTerritory(territory)) {
                    try {
                        update territory;
                    } catch(Exception ex){
                        errorMessages.add(ex.getMessage());
                    }
                }
                setLeadTerritories();
                return null;
            }
        }
        return null;
    }
    
    public pageReference createGeographicCriteria(){
        /*At this row we create an instance of "Lead_Territory_Geography__c" object using casting result of "JSON.deserializeStrict" 
        to "Lead_Territory_Geography__c"
        See more about casting https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_casting.htm
        Method "JSON.deserializeStrict" deserializes the specified JSON string into an Apex object of the specified type
        (Lead_Territory_Geography__c.class in our case). Parameter "jsonCriteria" taken from ManageLeadTerritoryPage (variable "jsonCriteria" with
        geter and seter) and contains JSON.
        See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Json.htm#apex_System_Json_deserializeStrict
                    http://www.w3schools.com/js/js_json.asp
        */
        Lead_Territory_Geography__c criteria = (Lead_Territory_Geography__c)JSON.deserializeStrict(jsonCriteria, Lead_Territory_Geography__c.class);
        
        if(validGeographicCriteria(criteria)) {
            errorMessages = new List<String>();
            
            try {
                upsert criteria;
            } catch(Exception ex) {
                errorMessages.add(ex.getMessage());
            }
        }

        setLeadTerritories();
        
        return null;
    }
    /*You can see, that the logic of this method is similar with previous "createGeographicCriteria" */
    public pageReference createLeadFieldCriteria() {
        Lead_Territory_Field_Criteria__c criteria = (Lead_Territory_Field_Criteria__c)JSON.deserializeStrict(
            jsonCriteria, Lead_Territory_Field_Criteria__c.class);
        
        if(validLeadFieldCriteria(criteria)) {
            errorMessages = new List<String>();
            
            try {
                upsert criteria;
            } catch(Exception ex){
                errorMessages.add(ex.getMessage());
            }
        }

        setLeadTerritories();

        return null;
    }
    /*At this method that is invoked from ManageLeadTerritoryPage we specify, which object's record should be
      deleted. For this, we assigning to "ID" field value of variable "removedId" and use DML operation "delete"
      */
    public pageReference remove() {
        if(removedType == 'territory'){
            delete new Lead_Territory__c(Id = removedId);
        } else if(removedType == 'geography'){
            delete new Lead_Territory_Geography__c(Id = removedId);
        }
        else if(removedType == 'leadField'){
            delete new Lead_Territory_Field_Criteria__c(Id = removedId);
        }

        setLeadTerritories();

        return null;
    }
    /*At this method we assigning new values to "Order__c" field of "Lead_Territory__c" object and
    then update him*/
    public pageReference saveOrder(){
        Integer index = 1;
        /*At this loop we iterate over collection of Strings. But variable it's a simple string "territoryOrder".
          How it works? "territoryOrder" is a String with mask [String1_orderString2_orderString3_order]. Method "split()"
          returns a list that contains each substring of the String that is terminated by either the end of the String or '_order' substring.
          Result of this method is an array [String1, String2, String3].
          See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_string.htm#apex_System_String_split
        */
        for(String orderId : territoryOrder.split('_order')){
            for(Lead_Territory__c territory : leadTerritories){
                if(territory.Id == orderId){
                    territory.Order__c = index;
                    break;
                }
            }
            index++;
        }
        update leadTerritories;
        //currentindex = null;
        setLeadTerritories();
        return null;
    }
    /*This method used to find Users with criteria*/
    public pageReference searchUser() {
    
        if(String.isNotBlank(userinfo)) {
            /*We assign a value to "searchValue" variable with wildcards "%" for using "LIKE" operator
              See more at https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_select_comparisonoperators.htm
            */
            String searchValue = '%' + userinfo + '%';
            users = [
                SELECT Name, Title, Email,
                    Phone, UserRole.Name
                FROM User 
                WHERE isActive = true
                    AND ( Name LIKE :searchValue
                    OR Phone = :userinfo
                    OR Email = :userinfo)
                LIMIT 15
            ];

            LeadQueues = [
                SELECT Name
                FROM Group
                WHERE Type = 'Queue'
                    AND Name LIKE :searchValue
                LIMIT 15
            ];

            system.debug('users -->'+users);
            system.debug('LeadQueues -->'+LeadQueues);
        }

        return null;
    }
    
    
    /**
     * Private methods ------->
     */
     /*Method which returns Boolean value*/
    private Boolean validLeadTerritory(Lead_Territory__c leadTerritory){
        system.debug('leadTerritory -->'+leadTerritory);
        errorMessages = new List<String>();
        /*At this if condition we check "leadTerritory.Name" with method ".isBlank()", this method
          returns true if the specified String is white space, empty (''), or null; otherwise, returns false.
          See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_string.htm
         */
        if(String.isBlank(leadTerritory.Name)) {
            errorMessages.add('Lead Territory Name is required');
        }
        if(String.isBlank(leadTerritory.Type__c)) {
            errorMessages.add('Type is required');
        }
        if(String.isBlank(leadTerritory.Assigned_To__c)) {
            errorMessages.add('Assign To is required');
        }
        system.debug('errorMessages -->'+errorMessages);
        if(errorMessages.isEmpty()){
            return true;
        }
        return false;
    }
     /*Method which returns Boolean value. Similar with previous "validLeadTerritory"*/
    private Boolean validGeographicCriteria(Lead_Territory_Geography__c geographicCriteria){
        errorMessages = new List<String>();
        if(String.isBlank(geographicCriteria.Country__c)){
            errorMessages.add('Geographic Criteria: Country is required');
        }
        /*At this "IF condition" we use logical operator && (AND) If are both true then the expression evaluates to true. 
        Otherwise the expression evaluates to false.Pay attention to logical complement "!" ("!String.isBlank(geographicCriteria.Zip_Start__c").
        This operator inverts the value of a Boolean, so that true becomes false, and false becomes true.
        See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_expressions_operators_understanding.htm
        */
        if(!String.isBlank(geographicCriteria.Zip_Start__c) && String.isBlank(geographicCriteria.Zip_End__c)){
            errorMessages.add('Geographic Criteria: Postal End is required');
        }
        if(!String.isBlank(geographicCriteria.Zip_End__c) && String.isBlank(geographicCriteria.Zip_Start__c)){
            errorMessages.add('Geographic Criteria: Postal Start is required');
        }
        if(errorMessages.isEmpty()){
            return true;
        }
        return false;
    }
    /*Method which returns Boolean value. Similar with previous "validLeadTerritory" method*/
    private Boolean validLeadFieldCriteria(Lead_Territory_Field_Criteria__c leadFieldCriteria){
        errorMessages = new List<String>();
        if(String.isBlank(leadFieldCriteria.Lead_Field__c)){
            errorMessages.add('Lead Field Criteria: Field is required');
        }
        /*At this "IF condition" we use logical operator || (OR). If are both false ("leadFieldCriteria.Operator__c" not equal to "--None--") and
        "leadFieldCriteria.Operator__c" is not blank then the expression evaluates to false.Otherwise the expression evaluates to true
          See more at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_expressions_operators_understanding.htm
        */
        if(leadFieldCriteria.Operator__c == '--None--' || String.isBlank(leadFieldCriteria.Operator__c)){
            errorMessages.add('Lead Field Criteria: Operator is required');
        }
        if(leadFieldCriteria.Value__c == '--None--'){
            leadFieldCriteria.Value__c = null;
        }
        if(errorMessages.isEmpty()){
            return true;
        }
        return false;
    }
    /*This method used to fill List of "Lead_Territory__c" objects */
    private void setLeadTerritories(){//Assigned_To_User__c, Assigned_To_User__r.Name, 
        /*Pay attention to SOQL query. We have two subquerys to related objects "Territory_Geographies__r" 
          and "Territory_Field_Criteria__r". Keep in mind, tha we use "__r" when creating subquery to related object. 
          About this and other joins you can read at 
          https://developer.salesforce.com/page/A_Deeper_look_at_SOQL_and_Relationship_Queries_on_Force.com
        */
        leadTerritories = [
            SELECT Name, Type__c, Effective_Date__c,
                Assigned_To_Type__c, Assigned_To_ID__c,
                Assigned_To__c, Order__c, of_Field_Criteria__c,
                of_Geographic_Criteria__c,
            (
                SELECT lead_Territory__c, Country__c,
                    State__c, Zip_End__c,
                    Zip_Start__c
                FROM Lead_Territory_Geographies__r
                ORDER BY CreatedDate DESC
            ),
            (
                SELECT Lead_Territory__c, Lead_Field__c,
                    Operator__c, Value__c
                FROM Lead_territory_Field_Criteria__r
                ORDER BY CreatedDate DESC
            )
            FROM Lead_Territory__c
            ORDER BY Order__c
        ];

        List<Territory_Setup__c> LeadTerrSetups = [
            SELECT Next_Mass_Update_Date_Lead__c, Status__c
            FROM Territory_Setup__c 
            ORDER BY lastmodifieddate
            DESC LIMIT 1
        ];

        if(!LeadTerrSetups.isEmpty()) {
            SystemHasLeadTerrSetup = true;
            LeadTerrSetup = LeadTerrSetups[0];
        } else {
            LeadTerrSetup = new Territory_Setup__c(Status__c = 'On');
        }

        IsCreatedTerr = false; 
    }
    /*This method returns List of "Lead_Territory_Geography__c" objects*/
    private List<Lead_Territory_Geography__c> analyseCSVString(String assignmentCsv)
    {
        List<Lead_Territory_Geography__c> assignmentDetails = new List<Lead_Territory_Geography__c>();
        if(assignmentCsv != null && assignmentCsv != '')
        {    
            /*Creating list of Strings from "assignmentCsv" String with method "split()" */          
            String[] csvLines = assignmentCsv.split('\n');
            /*In this loop we creating new instance of "Lead_Territory_Geography__c" object
              and specifying fields of this object with values, which geting from "fieldValues"
              list. We access to each element by his index(For example "fieldValues[0]" - first value from List)
            */
            for(String csvLine : csvLines)
            {
                List<String> fieldValues = analyseCsvLine(csvLine);
                Lead_Territory_Geography__c detail = new Lead_Territory_Geography__c();

                for(Integer i = 0; i < fieldValues.size(); i++) {
                    if(i == 0) {
                        detail.Country__c = fieldValues.get(i);
                    } else if(i == 1) {
                        detail.State__c = fieldValues.get(i);
                    } else if(i == 2) {
                        detail.zip_Start__c = fieldValues.get(i);
                    } else if(i == 3) {
                        detail.zip_End__c = fieldValues.get(i);
                    }
                }
                
                assignmentDetails.add(detail);
            }
        }
        return assignmentDetails;
    }
    
    // This method will analyse the  csv line.
    private List<String> analyseCsvLine(String cvsLine)
    {
        List<String> analyseResults = new List<String>();
        if(cvsLine != null)
        {
            cvsLine = cvsLine.trim() + ',';
            /*Creating instance of "Pattern" object wit method "compile()", that compiles the regular expression into a 
            Pattern object.
            More about pattern at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_pattern_and_matcher_pattern_methods.htm
            See more about RegExp  at https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
            You can try to write some regular expressions at this site https://regex101.com/
            */
            Pattern cvsPattern = Pattern.compile('("[^"]*("{2})*[^"]*")*[^,]*,'); 
             /*Creating instance of "Matcher" object with method "matcher()"(it's method relates to "Pattern" object!) with parameter "cvsLine" (it's our String,
             where we want to find matches), that creates a Matcher object that matches the input string regExp against this Pattern object.
             See more about Matcher https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_pattern_and_matcher_matcher_methods.htm 
            Pattern object.*/
            Matcher cvsMatcher = cvsPattern.matcher(cvsLine);
            String tempCell ;
            /*Loop with "find()" method. This method attempts to find the next subsequence of the input sequence that matches the pattern. 
              This method returns true if a subsequence of the input sequence matches this Matcher object's pattern.*/
            while(cvsMatcher.find())
            {   /*Method "group()" returns the input subsequence returned by the previous match*/
                tempCell = cvsMatcher.group();
                /*Call to "replaceDoubleQuotationMarks" method */
                tempCell = replaceDoubleQuotationMarks(tempCell);
                analyseResults.add(tempCell);
            }
        }
        return analyseResults;
    }
    /*This method return incoming String in a modified form */
    private String replaceDoubleQuotationMarks(String input)
    {
        if(input != null && input != '')
        {
            input = input.trim();
            /*We using "startsWith()" method to check, our input String begins with the specified prefix or not*/
            if(input.startsWith('"'))
            {   // The string is contained  double quotation marks.
                /*Method "replaceAll()" replaces each substring of a string that matches the regular expression regExp(or simple String) 
                with the replacement sequence replacement. In our case("input = input.replaceAll('""', '"');") for example, we replace
                all "" symbols to " .
                */
                input = input.replaceAll('^"', '');
                input = input.replaceAll('",$', '');    
                input = input.replaceAll('""', '"');
            }
            else
            {
                input = input.replaceAll(',$','' );
            }
                return input;
        }
        return '';
    }
}