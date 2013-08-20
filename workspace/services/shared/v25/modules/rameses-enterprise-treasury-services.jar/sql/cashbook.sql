[getList]
SELECT * 
FROM cashbook 
WHERE code LIKE $P{searchtext} OR subacct_name LIKE $P{searchtext}
ORDER BY subacct_name, fund_code

[changeState-approved]
UPDATE cashbook SET state='APPROVED' WHERE objid=$P{objid}

[findBySubAcctFund]
SELECT * FROM cashbook WHERE fund_objid=$P{fundid} AND subacct_objid=$P{subacctid}

[getEntries]
SELECT refdate,refno,reftype,particulars,dr,cr,runbalance,pageno,lineno 
FROM cashbook_entry 
WHERE parentid=$P{objid} AND pageno = $P{page}
order by pageno, lineno 