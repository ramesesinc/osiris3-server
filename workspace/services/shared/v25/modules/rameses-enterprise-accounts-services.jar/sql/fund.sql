[getRootNodes]
SELECT a.* 
FROM fund a 
WHERE a.parentid IS NULL 

[getChildNodes]
SELECT a.*
FROM fund a 
WHERE a.parentid=$P{objid} and a.type='group'

[getList]
SELECT * FROM fund WHERE parentid=$P{objid} ORDER BY code

[getLookup]
SELECT DISTINCT f.* FROM 
(SELECT * FROM fund WHERE code LIKE $P{searchtext}
UNION 
SELECT * FROM fund WHERE title LIKE $P{searchtext}
) f
ORDER BY f.code

[approve]
UPDATE fund SET state='APPROVED' WHERE objid=$P{objid} 