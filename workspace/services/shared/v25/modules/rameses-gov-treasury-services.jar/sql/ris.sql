[getList]
SELECT * FROM ris 

[getItems]
SELECT * FROM risitem WHERE parentid=$P{objid}


[changeState-approved]
UPDATE ris SET state='APPROVED' WHERE objid=$P{objid}