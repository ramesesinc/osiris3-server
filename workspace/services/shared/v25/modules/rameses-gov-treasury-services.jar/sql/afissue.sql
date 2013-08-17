[getList]
SELECT * FROM afissue

[getItems]
SELECT * FROM afissueitem WHERE parentid=$P{objid}


[changeState-approved]
UPDATE afissue SET state='APPROVED' WHERE objid=$P{objid}