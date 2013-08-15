[getList]
SELECT e.*, ej.* 
FROM entity e 
	INNER JOIN entityjuridical ej ON e.objid=ej.objid 
WHERE e.name LIKE $P{name} 
ORDER BY e.name 