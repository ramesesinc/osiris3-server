[lookup]
SELECT b.objid, b.state, b.indexno, b.pin, b.name 
FROM province b 
WHERE b.name LIKE $P{name}  
ORDER BY b.name 

[changeState]
UPDATE province SET 
	state=$P{newstate} 
WHERE 
	objid=$P{objid} AND state=$P{oldstate} 

[getById]
SELECT * FROM province WHERE objid = $P{objid}