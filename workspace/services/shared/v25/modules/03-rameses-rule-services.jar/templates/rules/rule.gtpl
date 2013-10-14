<% 
	
	def prn_cond = { c->
		c.constraints.eachWithIndex { ct,i->
			if(i>0) out.print(",");
			def h = ct.field.handler;
			if( ct.operator?.symbol?.contains("null")) h = "null";
			out.print( templateSvc.get( "rules/rule_constraint_"+h, [constraint:ct] ));
		}
	} 

	def prn_action_param = { o->
		def r;
		def handler = 	o.actiondefparam.handler
		if( o.exprtype == "range") handler+="-range";
		if( o.exprtype == "expression") handler+="-expression";

		switch( handler ) {
			case "lookup":
				r = "new KeyValue(\"${o.obj.key}\", \"${o.obj.value}\")".toString();
				break;
			case "var":
				r = o.var.name;
				break;
			case "lov":
				r = "\""+o.lov+"\"";
				break;
			case "message":	
				r = "\"" + o.stringvalue + "\"";
				break;
			case "expression-expression":
				r = "(new ActionExpression(\"${o.expr}\", bindings)).getDecimalValue()" ;
				break;
			case "expression-range":
				r = "0.0";
				break;
		}
		return r ;
	}

	
%>
package ${rule.ruleset}.${rule.name};
import ${rule.ruleset}.*;
import java.util.*;
import com.rameses.rules.common.*;

global RuleAction action;

rule "${rule.name}"
	agenda-group "${rule.rulegroup}"
	salience ${rule.salience}
	no-loop
	when
		<%rule.conditions.each { cond-> %>
		${ (cond.varname)?cond.varname + ':': '' } ${cond.fact.factclass} ( <%prn_cond(cond)%> )
		<%}%>
	then
		Map bindings = new HashMap();
		<%rule.vars.each {%>
		bindings.put("${it.varname}", ${it.varname} );
		<%}%>
	<%rule.actions.eachWithIndex { action,i->
		def rangeEntries = action.params.findAll{ it.exprtype == 'range' };
		if( rangeEntries ) { 
			rangeEntries.eachWithIndex { param, j-> 
				def rname = "re${i}";
				def dtype = rule.vars.find{ it.objid == param.var.objid}.datatype ;
				def method = (dtype=='decimal')? "Decimalvalue" : "intvalue";
				out.println( "RangeEntry ${rname} = new RangeEntry(\"${rule.name}\");");
				out.println( "${rname}.setBindings(bindings);");
				out.println( "${rname}.set${method}(${param.var.name});");
				action.params.eachWithIndex{ parm,k->
					out.println( "${rname}.getParams().put( \"${parm.actiondefparam.name}\", ${prn_action_param(parm)} );" );	
				}
				out.println( "insert(${rname});")
			}
		}
		else {	
			out.println( "Map _p${i} = new HashMap();" );
			action.params.eachWithIndex{ parm,j->
				out.println( "_p${i}.put( \"${parm.actiondefparam.name}\", ${prn_action_param(parm)} );" );
			}
			out.println( "action.execute( \"${action.actiondef.name}\",_p${i},drools);");
		}	
	}%>
end

<%rule.actions.each { action->
	action.params.findAll{ it.exprtype == 'range' }.eachWithIndex { param, i-> 
		def dtype = rule.vars.find{ it.objid == param.var.objid}.datatype ;
		if(dtype=="integer") dtype = "int";
		param.listvalue.eachWithIndex{ entry, j-> %>
	
rule "${action.actiondef.name}_${i}_${j}"
	when
		rv: RangeEntry( id=="${rule.name}", ${dtype}value > ${entry.from} <%if(entry.to){%>, ${dtype}value <= ${entry.to} <%}%>)
	then
		Map bindings = rv.getBindings();
		Map params = rv.getParams();
		params.put( "amount", (new ActionExpression("${entry.value}", bindings)).getDecimalValue() );	
		action.execute( "${action.actiondef.name}",params, drools);
end

<% }}} %>
	