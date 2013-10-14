<% 
	def dt = constraint.dynamicvar?.datatype;
	if( dt.indexOf("_")>0 ) dt = dt.substring(0, dt.indexOf("_"));
	out.print( constraint.varname + ":"  + dt+"value, ");
	out.print( constraint.fieldname  + " == \"" + constraint.dynamicvar.name + "\"");
%>