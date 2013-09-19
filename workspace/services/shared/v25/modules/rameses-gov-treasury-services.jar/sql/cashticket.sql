[findStockReceiptInfo]
SELECT a.objid, 
a.denomination, 
su.qty AS unitqty
FROM cashticket a
INNER JOIN stockitem_unit su ON su.itemid=a.objid
WHERE a.objid= $P{objid}
AND su.unit = $P{unit}
