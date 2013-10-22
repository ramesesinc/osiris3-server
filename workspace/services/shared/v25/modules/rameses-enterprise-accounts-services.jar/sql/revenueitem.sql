[getList]
SELECT r.* 
FROM revenueitem r 
WHERE r.code LIKE $P{searchtext}
  OR r.title LIKE $P{searchtext}
  OR r.fund_title = $P{fund}
ORDER BY r.title

[changeState-approved]
UPDATE revenueitem SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT'

[approve]
UPDATE revenueitem SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT'

[getLookup]
SELECT r.* FROM revenueitem r 
WHERE  (r.title LIKE $P{title}  OR r.code LIKE $P{code} ) 
and r.state = 'APPROVED'

[findSingleEntry]
SELECT r.objid, r.code, r.title, r.fund_objid, r.fund_code, r.fund_title 
FROM revenueitem r WHERE objid=$P{objid}

[getAccountColumns]
SELECT name, title, source from account_segment 
WHERE objectname = 'revenueitem' 
ORDER BY sortorder 

[getAccountList]
SELECT r.objid, r.code, r.title 
${columns}
FROM revenueitem r
${sources}
ORDER BY r.title
