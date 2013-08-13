[getList]
SELECT * FROM afreceipt 

[getItems]
SELECT * FROM afreceiptitem WHERE parentid=$P{objid}


[changeState-approved]
UPDATE afreceipt SET state='APPROVED' WHERE objid=$P{objid}