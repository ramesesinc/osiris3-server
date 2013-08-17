[getList]
SELECT * 
FROM collectiontype
WHERE name LIKE $P{searchtext}
ORDER BY name

[changeState-approved]
UPDATE collectiontype SET state='APPROVED' WHERE objid=$P{objid}