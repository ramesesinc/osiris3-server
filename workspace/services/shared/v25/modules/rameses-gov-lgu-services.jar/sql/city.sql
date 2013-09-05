[lookup]
SELECT b.objid, b.state, b.indexno, b.pin, b.name 
FROM city b 
WHERE b.name LIKE $P{name}  
ORDER BY b.name 

[changeState]
UPDATE city SET 
	state=$P{newstate} 
WHERE 
	objid=$P{objid} AND state=$P{oldstate} 

[getById]
SELECT * FROM city WHERE objid = $P{objid}