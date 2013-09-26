<%
handler?.imports()?.each {
print "import " + it + ";"	
}
%>
import java.util.*;
import java.math.*;
import com.rameses.rules.common.*;

global RuleAction action;

rule "${entity.rulename}"
  agenda-group "${entity.agendagroup}"	
  salience ${entity.salience?entity.salience:0}
  when
	<%
	   entity.conditions?.eachWithIndex{ c,x->	
		println handler?.condition( c,x );
	  }
	%>
  then
	<%
	  entity.actions?.eachWithIndex{a,x->
		println handler?.action( a,x );	
	  }
	%>
end 
