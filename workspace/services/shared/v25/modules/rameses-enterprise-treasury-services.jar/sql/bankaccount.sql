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


[getEntries]
SELECT refdate,refno,reftype,particulars,dr,cr,runbalance,pageno,lineno 
FROM bankaccount_entry 
WHERE parentid=$P{objid} AND pageno = $P{page}
order by pageno, lineno 

[getListByFund]
SELECT ba.*
FROM bankaccount ba 
WHERE ba.fund_objid = $P{fundid}
