[lookup]
SELECT b.objid, b.state, b.indexno, b.pin, b.name 
FROM municipality b 
WHERE b.name LIKE $P{name}  
ORDER BY b.name 