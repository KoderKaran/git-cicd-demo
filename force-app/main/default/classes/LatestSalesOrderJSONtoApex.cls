public class LatestSalesOrderJSONtoApex {

		public class Response {
		public String requestType;
		public String uri;
		public String status;
		public Payload payload;
		public String error;       
	}

	public Response response;

	public class Querydata {
		public String queryName;
		public Columns columns;
        public Data data;
	}

	public class Column {
		public String columnName;
		public String columnAlias;
		public String columnType;
		public String columnKey;
	}

	public class Columns {
		public Column column;
		
	}

	public class Data {
		public Row row;
	}

	public class Payload {
		public String schemaDigest;
		public Querydata querydata;
    }

	public class Row {
		public String rowID;
		public String fm_finops_serial_number_transaction_order_id;
        public String Warranty_order_id;
	}

	
	public static LatestSalesOrderJSONtoApex parse(String json) {
		return (LatestSalesOrderJSONtoApex) System.JSON.deserialize(json, LatestSalesOrderJSONtoApex.class);
	}
}