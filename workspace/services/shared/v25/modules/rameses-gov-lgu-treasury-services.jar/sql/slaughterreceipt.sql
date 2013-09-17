[getLookup]
SELECT 
	ss.amount, 
	ri.objid AS item_objid, 
	ri.title AS item_title, 
	ri.code AS item_code, 
	ri.fund_objid AS item_fund_objid 
FROM specialaccountsetting ss 
INNER JOIN revenueitem ri ON ss.item_objid = ri.objid 
WHERE ss.collectiontypeid = $P{collectiontypeid}	
	AND (ri.title LIKE $P{title}  OR ri.code LIKE $P{code} ) 