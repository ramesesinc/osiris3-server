[getList]
SELECT * FROM bank 

[approve]
UPDATE bank SET state='APPROVED' WHERE objid=$P{objid}