[getList]
SELECT * FROM cashbook 

[getEntries]
SELECT * FROM cashbook_entry WHERE parent=$P{objid}

[changeState-approved]
UPDATE cashbook SET state='APPROVED' WHERE objid=$P{objid}

[findByCollectorFund]
SELECT * FROM cashbook WHERE fund_objid=$P{fundid} AND subacct_objid=$P{subacctid}
