<%
def fmt = {type->
	if(type=="string")return "String";
	else if(type=="integer")return "int";
	else if(type=="decimal")return "java.math.BigDecimal";
	else if(type=="date")return "java.util.Date";
	else if(type=="list")return "java.util.List";
	else return type;
}
%>

declare ${fact.name}
  <%fact.fields?.each{ k,v-> %>	
	${k} 	:	${ fmt(v.type) }		
  <%}%>
end