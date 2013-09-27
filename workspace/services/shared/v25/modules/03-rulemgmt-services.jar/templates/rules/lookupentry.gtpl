<%
def dtype = "decimal";
def pattern = (dtype=="decimal") ? "#####0.00" : "#####0";
def fmt = new java.text.DecimalFormat(pattern);
%>

rule "${rulename}_${prefix}_${counter}"
  agenda-group "${agendagroup}"	
  when
	 tbl:  Lookup( name=="${rulename}_${prefix}" ${(entry.from) ? ',' + dtype + 'Value >' + fmt.format(entry.from) : '' } ${(entry.to) ? ',' + dtype + 'Value <=' + fmt.format(entry.to) : '' })
  then
	 tbl.getHandler().handle( "${entry.expr}" ); 
end 
