[getList]
SELECT rg.* FROM sys_rulegroup rg 
WHERE rg.ruleset=$P{ruleset} 
ORDER BY sortorder 

[getLookupList]
SELECT rg.* FROM sys_rulegroup rg 
WHERE rg.ruleset=$P{ruleset} ${filter} 
ORDER BY sortorder 

[getRulesets]
SELECT * FROM sys_ruleset 

[findByName]
SELECT rg.*, rs.title as rulesettitle  
FROM sys_rulegroup rg 
	INNER JOIN sys_ruleset rs on rg.ruleset=rs.name 
WHERE rg.name=$P{name} 
