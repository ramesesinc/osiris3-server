[getList]
SELECT * FROM bankaccount 

[changeState-approved]
UPDATE bankaccount SET state=$P{newstate} WHERE objid=$P{objid} AND NOT(state='APPROVED')
