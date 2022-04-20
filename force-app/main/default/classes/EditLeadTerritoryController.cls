public class EditLeadTerritoryController{
    
    private String leadTerritoryID = ApexPages.currentPage().getParameters().get('id');
    public Boolean isActive { get; set; }
    
    public EditLeadTerritoryController(){
        errorMessages = new List<String>();
        setLeadTerritory();
        newLeadTerritoryGeos = new List<Lead_Territory_Geography__c>();
        for(Integer i = 0; i < 5; i++)
        {
            newLeadTerritoryGeos.add(new Lead_Territory_Geography__c(Lead_Territory__c = leadTerritoryID));
        }  
        users = new List<User>();
        initLeadFieldsAndOperators();
        searchType = leadTerritory.Assigned_To_Type__c;
        isActive = false;
        String customerSTatus = CheckTPSStatus.checkimmestatus();
         if(customerSTatus == 'Active')
         {
             isActive = true;
         }
         else
         {
             errorMessages.add('Your accout status with Touchpoint Solutions is shown as Inactive. The Lead Routing app will be disabled until your account is made Active. Please contact Touchpoint Solutions to have your status reactivated.');
         }
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
    }
    
    public List<User> users { get; set; }
    public String userinfo { get; set; }
    public String searchType { get; set; }
    public List<Group> LeadQueues { get; set; }
      
    public Lead_Territory__c leadTerritory { get; set; }
    public List<String> errorMessages { get; set; }
    public String jsonCriteria { get; set; }
    public String removedId { get; set; }
    public String removedType { get; set; }
    public List<Lead_Territory_Geography__c> newLeadTerritoryGeos { get; set; }
    public String AssignmentsCSV { get; set; }
    public Lead leadObject { get; set; }
    
    public List<SelectOption> LeadFieldOptions { get; set; }
    
    public PageReference checkCustomerTpsStatus()
    {
        CheckTPSStatus.checkimmestatus();
        STring currentUrl = ApexPages.currentPage().getUrl();
        pageReference retPage = new PageReference(currentUrl);
        retPage.setRedirect(true);
        return retPage;
    }
    
    public pageReference searchUser(){
        if(userinfo.length() > 1){
          String searchValue = '%' + userinfo + '%';
          users = [select Name, Title, Email, Phone, UserRole.Name from User 
              where Name like :searchValue
              or Phone = :userinfo
              or Email = :userinfo limit 15];
              
              LeadQueues = [select Id, Name from Group where Type = 'Queue' and Name like :searchValue limit 15];
        }
        return null;
    }
  
    public void addMoreLeadTerritoryGeos()
    {
        for(Integer i = 0; i < 5; i++)
        {
            newLeadTerritoryGeos.add(new Lead_Territory_Geography__c(Lead_Territory__c = leadTerritoryID));
        }    
    }
    
    public void insertNewLeadTerritoryGeos()
    {
        List<Lead_Territory_Geography__c> needToInsertTerritoryGeos = new List<Lead_Territory_Geography__c>();
         for(Lead_Territory_Geography__c newLeadTerritoryGeo : newLeadTerritoryGeos)
        {    
            if(!(String.isBlank(newLeadTerritoryGeo.Country__c) && String.isBlank(newLeadTerritoryGeo.State__c) && String.isBlank(newLeadTerritoryGeo.Zip_Start__c) && String.isBlank(newLeadTerritoryGeo.Zip_End__c)))
            {
                needToInsertTerritoryGeos.add(newLeadTerritoryGeo);
            }
        }
        if(needToInsertTerritoryGeos.size() > 0)
        {
            insert needToInsertTerritoryGeos;
            setLeadTerritory();
        }
        newLeadTerritoryGeos = new List<Lead_Territory_Geography__c>();
        for(Integer i = 0; i < 5; i++)
        {
            newLeadTerritoryGeos.add(new Lead_Territory_Geography__c(Lead_Territory__c = leadTerritoryID));
        }     
    }
    
    public void insertNewLeadTerritoryGeosByCSV()
    {
        List<Lead_Territory_Geography__c> csvAssignments = analyseCSVString(AssignmentsCSV);
        List<Lead_Territory_Geography__c> needToInsertTerritoryGeos = new List<Lead_Territory_Geography__c>();
         for(Lead_Territory_Geography__c newLeadTerritoryGeo : csvAssignments)
        {    
            if(!(String.isBlank(newLeadTerritoryGeo.Country__c) && String.isBlank(newLeadTerritoryGeo.State__c) && String.isBlank(newLeadTerritoryGeo.Zip_Start__c) && String.isBlank(newLeadTerritoryGeo.Zip_End__c)))
            {
                needToInsertTerritoryGeos.add(newLeadTerritoryGeo);
            }
        }
        if(needToInsertTerritoryGeos.size() > 0)
        {
            insert needToInsertTerritoryGeos;
            setLeadTerritory();
        }
    }
    
    public List<SelectOption> getLeadFields()
    {
        List<SelectOption> result = new List<SelectOption>();
        result.add(new SelectOption('', '--None--'));
        
        Map<String, Schema.SObjectField> fieldMap = Lead.SObjectType.getDescribe().Fields.getMap();
        
        List<String> fieldLabels = new List<String>();
        Map<String, String> fieldNames = new Map<String, String>();
        for (Schema.SObjectField field: fieldMap.values())
        {
            Schema.DescribeFieldResult fieldDes = field.getDescribe();
            fieldLabels.add(fieldDes.getLabel());
            fieldNames.put(fieldDes.getLabel(), fieldDes.getName());
        }
        fieldLabels.sort();
        
        for (String label: fieldLabels) 
        {
            result.add(new SelectOption(fieldNames.get(label), label));
        }
        
        return result;
    }
    
    public pageReference saveLeadTerritory(){
        if(!validLeadTerritory(leadTerritory)){
            return null;
        }
        try{
            update leadTerritory;
            setLeadTerritory();
        }
        catch(Exception ex){
            errorMessages.add(ex.getMessage());
        }
        return null;
    }
    
    public pageReference createGeographicCriteria(){
        Lead_Territory_Geography__c criteria = (Lead_Territory_Geography__c)JSON.deserializeStrict(jsonCriteria, Lead_Territory_Geography__c.class);
        
        if(!validGeographicCriteria(criteria)){
            return null;
        }
        
        try{
            upsert criteria;
            setLeadTerritory();
        }
        catch(Exception ex){
            errorMessages.add(ex.getMessage());
        }
        return null;
    }
    
    public pageReference createLeadFieldCriteria(){
        Lead_Territory_Field_Criteria__c criteria = (Lead_Territory_Field_Criteria__c)JSON.deserializeStrict(
            jsonCriteria, Lead_Territory_Field_Criteria__c.class);
        if(!validLeadFieldCriteria(criteria)){
            return null;
        }
        
        try{
            upsert criteria;
            setLeadTerritory();
        }
        catch(Exception ex){
            errorMessages.add(ex.getMessage());
        }
        return null;
    }
    
    public pageReference remove(){
        if(removedType == 'territory'){
            delete new Lead_Territory__c(Id = removedId);
        }
        else if(removedType == 'geography'){
            delete new Lead_Territory_Geography__c(Id = removedId);
        }
        else if(removedType == 'leadField'){
            delete new Lead_Territory_Field_Criteria__c(Id = removedId);
        }
        setLeadTerritory();
        return null;
    }
    
    
    /**
     * Private methods ------->
     */
    private Boolean validLeadTerritory(Lead_Territory__c leadTerritory){
        errorMessages = new List<String>();
        if(String.isBlank(leadTerritory.Name)){
            errorMessages.add('Lead Territory Name is required');
        }
        if(leadTerritory.Type__c == null){
            errorMessages.add('Type is required');
        }/*
        if(String.isBlank(leadTerritory.Assigned_To_User__c)){
            errorMessages.add('Assign To is required');
        }*/
        if(errorMessages.isEmpty()){
            return true;
        }
        return false;
    }
    
    private Boolean validGeographicCriteria(Lead_Territory_Geography__c geographicCriteria){
        errorMessages = new List<String>();
        if(String.isBlank(geographicCriteria.Country__c)){
            errorMessages.add('Geographic Criteria: Country is required');
        }
        if(String.isBlank(geographicCriteria.State__c)){
            errorMessages.add('Geographic Criteria: State is required');
        }
        if(String.isBlank(geographicCriteria.Zip_Start__c)){
            errorMessages.add('Geographic Criteria: Postal Start is required');
        }
        if(String.isBlank(geographicCriteria.Zip_End__c)){
            errorMessages.add('Geographic Criteria: Postal End is required');
        }
        if(errorMessages.isEmpty()){
            return true;
        }
        return false;
    }
    
    private Boolean validLeadFieldCriteria(Lead_Territory_Field_Criteria__c leadFieldCriteria){
        errorMessages = new List<String>();
        if(String.isBlank(leadFieldCriteria.Lead_Field__c)){
            errorMessages.add('Geographic Criteria: Field is required');
        }
        if(String.isBlank(leadFieldCriteria.Operator__c)){
            errorMessages.add('Geographic Criteria: Operator is required');
        }
        if(String.isBlank(leadFieldCriteria.Value__c)){
            errorMessages.add('Geographic Criteria: Value is required');
        }
        if(errorMessages.isEmpty()){
            return true;
        }
        return false;
    }
    
    private void setLeadTerritory(){//Assigned_To_User__c, Assigned_To_User__r.Name,
        leadTerritory = [select Id, Name, Type__c,  Assigned_To__c, Assigned_To_ID__c, Assigned_To_Type__c, Order__c, 
            (select Lead_Territory__c, Country__c, State__c, Zip_End__c, Zip_Start__c from Lead_Territory_Geographies__r order by Country__c, State__c),
            (select Lead_Territory__c, Lead_Field__c, Operator__c, Value__c from Lead_Territory_Field_Criteria__r order by Lead_Field__c)
            from Lead_Territory__c where Id = :leadTerritoryID];
    }
    
    // This method will analyse the  csv line.
    private List<String> analyseCsvLine(String cvsLine)
    {
        List<String> analyseResults = new List<String>();
        if(cvsLine != null)
        {
            cvsLine = cvsLine.trim() + ',';
            Pattern cvsPattern = Pattern.compile('("[^"]*("{2})*[^"]*")*[^,]*,'); 
            Matcher cvsMatcher = cvsPattern.matcher(cvsLine);
            String tempCell ;
            while(cvsMatcher.find())
            {
                tempCell = cvsMatcher.group();
                tempCell = replaceDoubleQuotationMarks(tempCell);
                analyseResults.add(tempCell);
            }
        }
        return analyseResults;
    }

    private String replaceDoubleQuotationMarks(String input)
    {
        if(input != null && input != '')
        {
            input = input.trim();
            if(input.startsWith('"'))
            {   // The string is contained  double quotation marks.
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
    
    private void initLeadFieldsAndOperators()
    {
        LeadFieldOptions = new List<SelectOption>();
        List<String> fieldLabels = new List<String>();
        for(String key : GlobalVariables.descirbeFieldResultMap.keySet())
        {
            fieldLabels.add(key);
        }
        fieldLabels.sort();
        for(String fieldLabel : fieldLabels)
        {
            Schema.DescribeFieldResult result = GlobalVariables.descirbeFieldResultMap.get(fieldLabel);
            LeadFieldOptions.add(new SelectOption(result.getName(), fieldLabel));
        }
    }
    
    private List<Lead_Territory_Geography__c> analyseCSVString(String assignmentCsv)
    {
        List<Lead_Territory_Geography__c> assignmentDetails = new List<Lead_Territory_Geography__c>();
        if(assignmentCsv != null && assignmentCsv != '')
        {              
            String[] csvLines = assignmentCsv.split('\n');
            for(String csvLine : csvLines)
            {
                List<String> fieldValues = analyseCsvLine(csvLine);
                Lead_Territory_Geography__c detail = new Lead_Territory_Geography__c(Lead_Territory__c = leadTerritoryID);
                detail.Country__c = fieldValues[0];
                detail.State__c = fieldValues[1];
                detail.zip_Start__c = fieldValues[2];
                detail.zip_End__c = fieldValues[3];
                assignmentDetails.add(detail);
            }
        }
        return assignmentDetails;
    }
}