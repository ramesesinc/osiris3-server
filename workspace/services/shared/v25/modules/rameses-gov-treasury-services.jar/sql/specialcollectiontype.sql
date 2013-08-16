[create]
INSERT INTO specialaccountsetting 
	(objid, item_objid, amount)
VALUES
	($P{objid}, $P{item_objid}, $P{amount})

[update]	
UPDATE specialaccountsetting SET
	item_objid = $P{item_objid},
	amount = $P{amount}
WHERE objid = $P{objid}

[read]
SELECT 
	ss.*,
	ri.title AS item_title,
	ri.code AS item_code
FROM specialaccountsetting ss 
	INNER JOIN revenueitem ri ON ss.item_objid = ri.objid 
WHERE ss.objid = $P{objid}	

[delete]
DELETE FROM specialaccountsetting WHERE objid = $P{objid}