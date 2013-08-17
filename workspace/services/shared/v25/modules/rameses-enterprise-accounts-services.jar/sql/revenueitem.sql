[getList]
SELECT r.* 
FROM revenueitem r 
WHERE r.code LIKE $P{searchtext}
  OR r.title LIKE $P{searchtext}
  OR r.fund_title = $P{fund}
ORDER BY r.title

[changeState-approved]
UPDATE revenueitem SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT'

[getLookup]
SELECT r.* FROM revenueitem r 
WHERE  (r.title LIKE $P{title}  OR r.code LIKE $P{code} )

[getLookupBasicCashReceipt]
SELECT 
   r.objid,r.code,r.title, 
   r.fund_objid,  r.fund_code, r.fund_title, 
   cb.objid as cashbookid   
FROM revenueitem r 
LEFT JOIN cashbook cb ON cb.fund_objid=r.fund_objid AND cb.subacct_objid = $P{collectorid}
WHERE (r.title LIKE $P{title}  OR r.code LIKE $P{code} )

[getLookupExtendedCashReceipt]
SELECT 
   r.objid,r.code,r.title, 
   r.fund_objid,  r.fund_code, r.fund_title, 
   cb.objid as cashbookid   
FROM revenueitem r 
LEFT JOIN cashbook cb ON cb.fund_objid=r.fund_objid AND cb.subacct_objid = $P{collectorid}
WHERE r.objid IN ( ${filter} )
