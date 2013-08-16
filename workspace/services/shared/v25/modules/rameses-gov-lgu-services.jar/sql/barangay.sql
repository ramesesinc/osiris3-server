[lookup]
SELECT b.objid, b.state, b.indexno, b.pin, b.name 
FROM barangay b 
WHERE b.name LIKE $P{name}  
ORDER BY b.name 

[changeState]
UPDATE barangay SET 
	state=$P{newstate} 
WHERE 
	objid=$P{objid} AND state=$P{oldstate} 

[getById]
SELECT * FROM barangay WHERE objid = $P{objid}

[search]
SELECT * FROM barangay
