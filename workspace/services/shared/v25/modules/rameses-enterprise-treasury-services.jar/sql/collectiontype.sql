[getList]
SELECT * FROM collectiontype

[changeState-approved]
UPDATE collectiontype SET state='APPROVED' WHERE objid=$P{objid}