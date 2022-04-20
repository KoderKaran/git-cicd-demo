public class WP_sRMA_JSONtoApex {

    public Response response;
        
	public class Response {
		public String requestType;
		public String uri;
		public String status;
		public Payload payload;
		public String error;
	}

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
		public String columnObjType;
	}

	public class Columns {
		public List<Column> column;
	}

	public class Data {
        public List<Row> row;
        public Row singleRow;
	}

	public class Payload {
		public String schemaDigest;
		public Querydata querydata;
	}

	public class Row {
		public String rowID;
        public String KeyField;
		public String ORDR_DocDate; 
		public String ODLN_DocNum;
		public String ORDR_DocNum;

        // row data
        public String ODLN_DocDate; 
        public String DLN1_ItemCode;
		public String DLN1_Dscription;
        public String RDR1_Quantity;
		public String DLN1_Quantity;
		public String DLN1_Price;
		public String DLN1_LineTotal;    
	}
	
	public static WP_sRMA_JSONtoApex parse(String json) {
		return (WP_sRMA_JSONtoApex) System.JSON.deserialize(json, WP_sRMA_JSONtoApex.class);
	}
}