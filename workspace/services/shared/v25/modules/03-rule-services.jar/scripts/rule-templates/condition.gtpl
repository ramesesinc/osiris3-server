<%

// Parameters passed from the builder:  condition, index, factDef

def decFormatter = new java.text.DecimalFormat("#####0.00");
def intFormatter = new java.text.DecimalFormat("#####0");
if( !condition.factclass ) {
	throw new Exception("Condition " + factDef.name + " at index " + index + " must have a factclass. Check definition");
};

if( condition.varname ) print condition.varname + ":";
print factDef.factclass + "( ";
condition.constraints.eachWithIndex { con, i->
	if( i > 0 ) print ", ";
	if( con.varname ) print con.varname + ":"
		
	if( con.datatype!="dynamic" ) {
		print con.fieldname;
		if(con.operator?.symbol && con.value) {
			print " " + con.operator?.symbol + " ";
			def dtype = con.datatype.toLowerCase(); 
			
			if( dtype == "string") {
				print "'" + con.value + "'";
			}	
			else if( dtype == "decimal" ) {
				print decFormatter.format(con.value);
			}
			else if( dtype == "integer" ) {
				print intFormatter.format(con.value);
			}
			else {
				print con.value;
			}
		}
	}	
	else {
		def dtype = con.value.datatype;
		if( dtype == "integer" ) dtype = "int";
		def dname = dtype + "Value";
		print dname + ", ";
		print "name == \"" + con.value.name + "\"";
	}
}
print " )";
%>