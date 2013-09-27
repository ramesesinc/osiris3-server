rule "${entity.rulename}"
  agenda-group "${entity.agendagroup}"	
  salience ${entity.salience?entity.salience:0}
  when
	<%entity.conditions?.each{ c->	
		println handler?.condition( c );
	}%>
  then
	<%entity.actions?.each {a->
		println handler?.action( a );	
	}%>
end 
