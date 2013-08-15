[getList]
SELECT r.*, a.code as ngasacct, f.code as fundacct 
FROM revenueitem r 
LEFT JOIN revenueitem_account ra ON ra.objid=r.objid
LEFT JOIN account a ON a.objid=ra.acctid
LEFT JOIN revenueitem_fund rf ON rf.objid=r.objid
LEFT JOIN fund f ON f.objid=rf.acctid

[changeState-approved]
UPDATE revenueitem SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT'

[getLookup]
SELECT r.* FROM revenueitem r  
WHERE r.state='APPROVED' 
AND 
(r.title LIKE $P{title} 
OR r.code LIKE $P{code} )
