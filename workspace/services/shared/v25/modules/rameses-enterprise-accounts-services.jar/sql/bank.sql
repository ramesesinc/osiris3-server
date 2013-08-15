[getList]
SELECT * FROM bank 

[changeState-approved]
UPDATE bank SET state='APPROVED' WHERE objid=$P{objid}