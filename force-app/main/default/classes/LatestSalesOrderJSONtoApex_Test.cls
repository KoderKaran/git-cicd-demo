@isTest
public class LatestSalesOrderJSONtoApex_Test {

    static testMethod void testParse() 
    {
		String json = '{\"response\":{\"@requestType\":\"schema\",\"uri\":\"/C4Test/query/GetWarrantyLatestSObySKU.aspx?cardcode=RIC906&sku=OVRC-300-PRO\",\"status\":\"OK\",'+
		'\"payload\":{\"@schemaDigest\":\"219D7D1E41BFDDBB4A5AEB681E5FFFD8\",\"querydata\":{\"@queryName\":\"/query//GetWarrantyLatestSObySKU.aspx?cardcode=RIC906&sku=OVRC-300-PRO\",\"columns\":{\"column\":{\"@name\":\"Warranty_order_id\",\"@alias\":\"order_id\",\"@type\":\"String\",\"@key\":\"false\"}},\"data\":{\"row\":{\"@id\":\"1\",\"Warranty_order_id\":\"624259\"}}}},\"error\":\"\"}}';
		
        string fixJSON1 = json.replace('@id','rowID').replace('@name','columnName').replace('@alias','columnAlias').replace('@type','columnType').replace('@key','columnKey');       
        string fixJSON2 = fixJSON1.replace('@','');   
        
        LatestSalesOrderJSONtoApex obj = LatestSalesOrderJSONtoApex.parse(fixJSON2);
        
        System.assertEquals(obj.response.payload.querydata.data.row.Warranty_order_id, '624259');        
	}
    
}