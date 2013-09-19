[findAvailableForCollector]
SELECT 
   cc.objid AS issuanceid,	
   cc.controlid,	
   ac.afid,
   cc.qtybalance,
   ct.denomination
FROM cashticket_control cc 
INNER JOIN cashticket_inventory ac ON cc.controlid=ac.objid
INNER JOIN cashticket ct ON ct.objid=ac.afid 
WHERE ac.afid =$P{afid} 
AND ac.respcenter_objid=$P{collectorid}
AND cc.qtybalance > 0


[updateControlBalance]
UPDATE cashticket_control
SET qtyissued = qtyissued + $P{qtyissued},
qtybalance = qtybalance - $P{qtyissued}
WHERE objid = $P{issuanceid}