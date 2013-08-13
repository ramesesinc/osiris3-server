[getList]
SELECT * FROM entity e
INNER JOIN entityindividual ei
ON e.objid = ei.objid
WHERE e.name LIKE $P{searchtext}
ORDER BY e.name