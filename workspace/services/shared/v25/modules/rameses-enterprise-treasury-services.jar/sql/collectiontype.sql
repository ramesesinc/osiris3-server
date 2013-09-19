[getList]
SELECT * 
FROM collectiontype
WHERE name LIKE $P{searchtext}
ORDER BY name

[getFormTypes]
SELECT * FROM collectionform 

[findAllByFormNo]
SELECT * 
FROM collectiontype
WHERE formno = $P{formno}
ORDER BY name

[approve]
UPDATE collectiontype SET state='APPROVED' WHERE objid=$P{objid}