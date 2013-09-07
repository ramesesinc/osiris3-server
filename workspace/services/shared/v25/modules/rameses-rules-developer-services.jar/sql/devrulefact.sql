[getList]
SELECT rf.* FROM sys_fact rf  
WHERE rf.ruleset=$P{ruleset} 
ORDER BY description  

[findByName]
SELECT rf.*, rs.title as rulesettitle, rg.title AS rulegrouptitle   
FROM sys_fact rf 
	INNER JOIN sys_ruleset rs on rf.ruleset=rs.name 
	LEFT JOIN sys_rulegroup rg ON rf.rulegroup=rg.name 
WHERE rf.name=$P{name} 
