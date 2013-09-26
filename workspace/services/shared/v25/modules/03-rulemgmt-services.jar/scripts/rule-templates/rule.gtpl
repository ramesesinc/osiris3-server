${header()}

rule "${rule.rulename}"
  agenda-group "${rule.agendagroup}"	
  salience ${rule.salience?rule.salience:0}
  when
	<%
	rule.conditions?.eachWithIndex{ c,x->	
	println conditionHandler(c,x);
	}
	%>
  then
	Map binding = new HashMap();
	<%vars.each { o->%>
	binding.put( "${o.name}", ${o.name} );	
	<%}%>
	<%
	rule.actions?.eachWithIndex{a,x->
	println actionHandler(a,x);
	}
	%>
end 
