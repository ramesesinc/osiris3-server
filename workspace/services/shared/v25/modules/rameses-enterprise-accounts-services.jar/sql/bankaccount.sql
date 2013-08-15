[getList]
SELECT ba.*, b.branchname 
FROM bankaccount ba 
INNER JOIN bank b ON ba.bank_objid=b.objid

[changeState-approved]
UPDATE bankaccount SET state=$P{newstate} WHERE objid=$P{objid} AND NOT(state='APPROVED')
