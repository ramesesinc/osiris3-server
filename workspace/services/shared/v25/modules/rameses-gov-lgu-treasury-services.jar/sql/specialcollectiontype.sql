[create]
INSERT INTO specialaccountsetting 
	(objid, collectiontypeid, item_objid, amount)
VALUES
	($P{objid}, $P{collectiontypeid}, $P{item_objid}, $P{amount})

[update]	
UPDATE specialaccountsetting SET
	item_objid = $P{item_objid},
	amount = $P{amount}
WHERE objid = $P{objid}

[read]
SELECT 
	ss.*,
	ri.title AS item_title,
	ri.code AS item_code,
	ri.fund_objid AS item_fund_objid
FROM specialaccountsetting ss 
	INNER JOIN revenueitem ri ON ss.item_objid = ri.objid 
WHERE ss.collectiontypeid = $P{collectiontypeid}	

[delete]
DELETE FROM specialaccountsetting WHERE objid = $P{objid}