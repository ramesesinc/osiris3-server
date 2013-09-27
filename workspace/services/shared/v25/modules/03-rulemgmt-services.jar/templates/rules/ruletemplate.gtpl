import java.util.*;
import java.math.*;
import com.rameses.rules.common.*;

global RuleAction action;

rule "${entity.rulename}"
  agenda-group "${entity.agendagroup}"	
  no-loop
  salience ${entity.salience?entity.salience:0}
  when
	<%
	   entity.conditions?.eachWithIndex{ c,x->	
		   println conditionHandler(c,x);
	   }
	%>
  then
	<%
	   entity.actions?.findAll{it.name}.eachWithIndex{ a,x->	
		   println actionHandler(a,x);
	   }
	%>
end 
