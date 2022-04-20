public class WP_dRMA_Warranty_JSON {

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
		public String name;
		public String alias;
		public String type;
		public String key;
	}

	public class Columns {
		public List<Column> column;
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
		public String Warranty_item_code;
		public String serial_code;
		public String product_sku_id;
		public String datasource_code;
		public String partner_id;
		public String partner_name;
		public String salesforce_product_id;
		public String order_id;
		public String local_order_date;
		public String Warranty_order_line_nbr;
		public String Warranty_transaction_line_id;
		public String delivery_id;
		public String rma_id;
		public String return_id;
		public String warranty_name;
		public String mount_type_txt;
		public String veneer_finish_txt;
		public String paint_color_txt;
		public String grill_paint_color_txt;
		public String paint_manufacturer_txt;
	}

	
	public static WP_dRMA_Warranty_JSON parse(String json) {
		return (WP_dRMA_Warranty_JSON) System.JSON.deserialize(json, WP_dRMA_Warranty_JSON.class);
	}
}