[getList]
SELECT * 
FROM sys_rule 
WHERE ruleset = $P{ruleset}
${filter}

[getRulesets]
SELECT * FROM sys_ruleset

[getRulegroups]
SELECT * 
FROM sys_rulegroup 
WHERE ruleset=$P{ruleset}
ORDER BY sortorder

[getFacts]
SELECT * 
FROM sys_rule_fact 
WHERE ruleset=$P{ruleset}
ORDER BY sortorder

[getActionDefs]
SELECT * 
FROM sys_rule_actiondef 
WHERE ruleset=$P{ruleset}
ORDER BY sortorder

[getFactFields]
SELECT *
FROM sys_rule_fact_field 
WHERE parentid=$P{objid}
ORDER BY sortorder

[findRule]
SELECT r.* 
FROM sys_rule r 
WHERE r.objid = $P{objid}

[getRuleConditions]
SELECT rc.*,  
	f.title AS fact_title, 
	f.factclass AS fact_factclass
FROM sys_rule_condition rc
INNER JOIN sys_rule_fact f ON f.objid=rc.fact_objid
WHERE rc.parentid=$P{objid} 
ORDER BY rc.pos

[getRuleConditionVars]
SELECT * FROM sys_rule_condition_var WHERE parentid=$P{objid} ORDER BY pos

[getRuleConditionConstraints]
SELECT c.*, 
f.name AS field_name, 
f.title AS field_title, 
f.datatype AS field_datatype, 
f.handler AS field_handler, 
f.lookupkey AS field_lookupkey, 
f.lookupvalue AS field_lookupvalue,
f.lookuphandler AS field_lookuphandler, 
f.lookupdatatype AS field_lookupdatatype, 
f.lovname AS field_lovname, 
f.vardatatype AS field_vardatatype, 
f.required AS field_required, 
f.multivalued AS field_multivalued
FROM sys_rule_condition_constraint c
INNER JOIN sys_rule_fact_field f ON f.objid=c.field_objid
WHERE c.parentid=$P{objid} ORDER BY c.pos

[getRuleActions]
SELECT a.*, ad.title AS actiondef_title 
FROM sys_rule_action a
INNER JOIN sys_rule_actiondef ad ON ad.objid=a.actiondef_objid
WHERE a.parentid=$P{objid} ORDER BY a.pos

[getRuleActionParams]
SELECT p.*, 
ad.name AS actiondefparam_name,
ad.title AS actiondefparam_title,
ad.datatype AS actiondefparam_datatype,
ad.handler AS actiondefparam_handler,
ad.datatype AS actiondefparam_datatype,
ad.lookupkey AS actiondefparam_lookupkey,
ad.lookupvalue AS actiondefparam_lookupvalue,
ad.lookuphandler AS actiondefparam_lookuphandler,
ad.vardatatype AS actiondefparam_vardatatype,
ad.lovname AS actiondefparam_lovname
FROM sys_rule_action_param p
INNER JOIN sys_rule_actiondef_param ad ON ad.objid=p.actiondefparam_objid
WHERE p.parentid=$P{objid} 
ORDER BY ad.sortorder

[findAllVarsByType]
SELECT objid, varname AS name, datatype
FROM sys_rule_condition_var 
WHERE ruleid=$P{ruleid}
${filter}

[getActionDefParams]
SELECT *
FROM sys_rule_actiondef_param
WHERE parentid=$P{objid}
ORDER BY sortorder

[getRulesForDeployment]
SELECT d.ruletext 
FROM sys_rule_deployed d
INNER JOIN sys_rule r ON d.objid = r.objid 
WHERE r.ruleset = $P{ruleset}


[removeAllConditionConstraint]
DELETE 
FROM sys_rule_condition_constraint
WHERE parentid=$P{objid}

[removeAllConditionVar]
DELETE 
FROM sys_rule_condition_var
WHERE parentid=$P{objid}

[removeAllActionParams]
DELETE
FROM sys_rule_action_param
WHERE parentid=$P{objid}

[getRuleVars]
SELECT * 
FROM sys_rule_condition_var 
WHERE ruleid = $P{objid}
ORDER BY pos

[removeAllRuleConstraints]
DELETE FROM sys_rule_condition_constraint WHERE parentid IN ( SELECT objid FROM sys_rule_condition WHERE parentid=$P{objid} ) 

[removeAllRuleConditionVars]
DELETE FROM sys_rule_condition_var WHERE ruleid = $P{objid}

[removeAllRuleConditions]
DELETE FROM sys_rule_condition WHERE parentid =$P{objid} 

[removeAllRuleActionParams]
DELETE FROM sys_rule_action_param WHERE parentid IN  ( SELECT objid FROM sys_rule_action WHERE parentid=$P{objid} ) 

[removeAllRuleActions]
DELETE FROM sys_rule_action WHERE parentid=$P{objid} 
