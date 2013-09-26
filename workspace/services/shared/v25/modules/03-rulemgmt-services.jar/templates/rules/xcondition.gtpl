<%
def decFormatter = new java.text.DecimalFormat("#####0.00");
def intFormatter = new java.text.DecimalFormat("#####0");
if( !condition.factname ) return '';

if( condition.factvarname ) print condition.factvarname + ":";
print condition.factname + "(";
if(condition.constraints) {
	print " ";
	condition.constraints.findAll{it.fieldname}.eachWithIndex { con, i->
		if( i > 0 ) print ", ";
		if(con.varname) print con.varname + ": ";
		def fieldname = con.fieldname;
		def value = con.value;
		
		//we do special handling of value field
		if( fieldname == "value" ) {
			fieldname = con.datatype + "Value";
		}
		
		//wrap around strings
		if(value && !con.usevar==true && con.datatype == "string")  {
			value = "\""+value+"\"";
		}
		
		print fieldname;
		if(con.operator) print " " + con.operator + " ";	
		if(value) print value;
	}
	print " ";
}
print ")";
%>