[getDomains]
SELECT DISTINCT t.domain as category, t.domain as caption 
FROM sys_ruleset t ORDER BY domain 

[getRulesets]
SELECT t.*, t.title as caption FROM sys_ruleset t 
WHERE t.domain=$P{domain} ORDER BY t.title   

[getList]
SELECT r.*, 'rule' as filetype 
FROM sys_rule r 
WHERE r.rulesetid=$P{rulesetid} 

[getRulegroups]
SELECT * FROM sys_rulegroup 
WHERE rulesetid=$P{rulesetid} 
ORDER BY indexno   

[getRulefacts]
SELECT * FROM sys_rulefact_schema 
WHERE rulesetid=$P{rulesetid} AND (rulegroupid IS NULL OR rulegroupid=$P{rulegroupid})  
ORDER BY description 
