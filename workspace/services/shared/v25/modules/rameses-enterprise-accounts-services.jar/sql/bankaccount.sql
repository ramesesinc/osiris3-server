[getList]
SELECT ba.*, b.branchname, ba.fund_code, ba.fund_title 
FROM bankaccount ba 
INNER JOIN bank b ON ba.bank_objid=b.objid
WHERE ba.code LIKE $P{searchtext}
   OR ba.bank_code LIKE $P{searchtext}
   OR ba.bank_name LIKE $P{searchtext}
ORDER BY ba.code

[changeState-approved]
UPDATE bankaccount SET state=$P{newstate} WHERE objid=$P{objid} 
