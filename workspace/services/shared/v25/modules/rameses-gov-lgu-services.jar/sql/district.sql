[lookup]
SELECT b.objid, b.state, b.indexno, b.pin, b.name 
FROM district b 
WHERE b.name LIKE $P{name}  
ORDER BY b.name 

[changeState]
UPDATE district SET 
	state=$P{newstate} 
WHERE 
	objid=$P{objid} AND state=$P{oldstate} 

