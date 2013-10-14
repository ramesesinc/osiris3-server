[getList]
SELECT e.*, ei.gender, ei.birthdate 
FROM entity e 
	INNER JOIN entityindividual ei ON e.objid=ei.objid 
WHERE e.entityname LIKE $P{name}  
ORDER BY e.entityname 