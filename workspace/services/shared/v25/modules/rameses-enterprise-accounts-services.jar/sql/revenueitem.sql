[getList]
SELECT r.* 
FROM revenueitem r 
WHERE r.title LIKE $P{searchtext} 
ORDER BY r.title

[getListByCode]
SELECT r.* 
FROM revenueitem r 
WHERE r.code LIKE $P{searchtext} 
ORDER BY r.code
 
[changeState-approved]
UPDATE revenueitem SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT'

[approve]
UPDATE revenueitem SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT'

[getLookup]
SELECT r.* FROM revenueitem r 
WHERE  (r.title LIKE $P{title}  OR r.code LIKE $P{code} ) 
and r.state = 'APPROVED'
ORDER BY r.title

[findSingleEntry]
SELECT r.objid, r.code, r.title, r.fund_objid, r.fund_code, r.fund_title 
FROM revenueitem r WHERE objid=$P{objid}