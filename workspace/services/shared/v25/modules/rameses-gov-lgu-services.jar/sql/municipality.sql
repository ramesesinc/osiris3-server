[lookup]
SELECT b.objid, b.state, b.indexno, b.pin, b.name 
FROM municipality b 
WHERE b.name LIKE $P{name}  
ORDER BY b.name 

[changeState]
UPDATE municipality SET 
	state=$P{newstate} 
WHERE 
	objid=$P{objid} AND state=$P{oldstate} 


[getById]
SELECT * FROM municipality WHERE objid = $P{objid}