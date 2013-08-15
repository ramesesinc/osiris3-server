[getList]
SELECT * FROM collectiontype


[getAvailableFormTypes]
SELECT DISTINCT formno FROM collectiontype

[getListByFormType]
SELECT * FROM collectiontype WHERE formno=$P{formno}

[changeState-approved]
UPDATE collectiontype SET state='APPROVED' WHERE objid=$P{objid}