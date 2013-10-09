[getList]
SELECT * 
FROM collectiontype
WHERE name LIKE $P{searchtext}
ORDER BY name

[getFormTypes]
SELECT * FROM collectionform 

[findAllByFormNo]
SELECT c.*, cf.formtype 
FROM collectiontype c
INNER JOIN collectionform cf 
ON c.formno=cf.objid 
WHERE c.formno = $P{formno}
ORDER BY c.name

[approve]
UPDATE collectiontype SET state='APPROVED' WHERE objid=$P{objid}

[getFormTypesForBatch]
select distinct  cf.*  
from collectiontype ct
	inner join collectionform cf on ct.formno = cf.objid
where allowbatch=1

[findAllByFormNoForBatch]
SELECT c.*, cf.formtype 
FROM collectiontype c
INNER JOIN collectionform cf 
ON c.formno=cf.objid 
WHERE c.formno = $P{formno} and allowbatch=1
ORDER BY c.name

[getFormTypesSerial]
select * from afserial 
