public class CheckTPSStatus
{/*
    @future(callout=true)
    public static void checkstatus()
    {
        //delete [select Id from TPSStatus__c];
        String orgId = UserInfo.getOrganizationId();
        Httprequest req=new httprequest();
        String domainName='conga-touchpoint.cs28.force.com/';
        List<TPSSiteDomain__c> tpsDomains = [select Id, Domain_Name__c from TPSSiteDomain__c where Domain_Name__c != null limit 1];
        if(tpsDomains.size() > 0)
        {
            domainName = tpsDomains[0].Domain_Name__c;
        }
        String endPointURL='https://'+domainName+'services/apexrest/touchpointapps?Id=' + orgId;
        req.setendpoint(endPointURL);
        //req.setHeader('Content-Type', 'application/xml; charset=utf-8');
        req.setmethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        if(res.getStatusCode() == 200)
        {
            //delete [select Id from TPSStatus__c];
            if(res.getBody() == 'true')
            {               
               //TPSStatus__c tps = new TPSStatus__c(Name = '1', STatus__c = 'Active');
               //insert tps; 
            }
        }
    }*/
    
    // deprecated
    /*public static String checkimmestatus()
    {
        
        String orgId = UserInfo.getOrganizationId();
        Httprequest req=new httprequest();// touchpoint.force.com
        String domainName='touchpoint.secure.force.com/';//services/apexrest/Widgets?Id=a01i0000000Z4jzAAC 
        List<TPSSiteDomain__c> tpsDomains = [select Id, Domain_Name__c from TPSSiteDomain__c where Domain_Name__c != null limit 1];
        if(tpsDomains.size() > 0)
        {
            domainName = tpsDomains[0].Domain_Name__c;
        }
        String endPointURL='https://'+domainName+'services/apexrest/touchpointapps?Id=' + orgId;
        req.setendpoint(endPointURL);
        //req.setHeader('Content-Type', 'application/xml; charset=utf-8');
        req.setmethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());System.debug(res.getStatusCode());
        if(res.getStatusCode() == 200)
        {
            //delete [select Id from TPSStatus__c];
            if(res.getBody() == 'true')
            {                
               //TPSStatus__c tps = new TPSStatus__c(Name = '1', STatus__c = 'Active');
               //insert tps; 
               return 'Active';
            }
        }
        return 'Inactive';
    }*/
    public static String checkimmestatus() {
        return 'Active';
    }
}