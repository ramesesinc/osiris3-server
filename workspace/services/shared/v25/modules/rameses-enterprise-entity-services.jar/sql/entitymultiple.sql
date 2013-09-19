[getList]
SELECT e.*, emu.fullname 
FROM entitymember em 
	INNER JOIN entitymultiple emu ON em.entityid=emu.objid 
	INNER JOIN entity e ON emu.objid=e.objid 
WHERE em.taxpayer_name LIKE $P{name} 
ORDER BY em.taxpayer_name 


[getMembers]
SELECT * FROM entitymember WHERE entityid=$P{objid} ORDER BY itemno 

[removeMembers]
DELETE FROM entitymember WHERE entityid=$P{objid} 
