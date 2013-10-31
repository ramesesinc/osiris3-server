[getRulesets]
SELECT * FROM sys_ruleset WHERE name = $P{ruleset}

[getRulegroups]
SELECT * FROM sys_rulegroup WHERE ruleset = $P{ruleset}

[getRuleFacts]
SELECT * FROM sys_rule_fact WHERE ruleset = $P{ruleset}

[getRuleFactFields]
SELECT * FROM sys_rule_fact_field WHERE parentid = $P{objid}


[getRuleActionDefs]
SELECT * FROM sys_rule_actiondef WHERE ruleset = $P{ruleset}

[getRuleActionDefParams]
SELECT * FROM sys_rule_actiondef_param WHERE parentid = $P{objid}

