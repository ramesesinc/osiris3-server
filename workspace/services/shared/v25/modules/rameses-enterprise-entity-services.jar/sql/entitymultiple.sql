[getList]
SELECT e.*, emu.fullname 
FROM entitymultiple emu 
	INNER JOIN entity e ON emu.objid=e.objid 
WHERE e.name LIKE $P{name} 
ORDER BY e.name 


[getMembers]
SELECT * FROM entitymember WHERE entityid=$P{objid} ORDER BY itemno 

[removeMembers]
DELETE FROM entitymember WHERE entityid=$P{objid} 
