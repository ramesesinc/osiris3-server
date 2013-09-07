[getList]
SELECT * FROM sys_ruleset 

[getRulegroups]
SELECT * FROM sys_rulegroup WHERE ruleset=$P{ruleset} ORDER BY sortorder 

[getRulefacts]
SELECT * FROM sys_fact WHERE ruleset=$P{ruleset} ORDER BY description 
