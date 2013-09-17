[getList]
SELECT * FROM afserial_inventory 
WHERE afid=$P{afid} 
ORDER BY currentseries, currentstub

[getDetails]
SELECT * FROM afserial_inventory_detail 
WHERE controlid=$P{controlid} 
ORDER BY refdate

[findAllAvailable]
SELECT 
   ac.objid AS controlid,  
   ac.afid,
   ac.currentseries as startseries,
   ac.endseries as endseries,
   ac.currentstub as startstub,
   ac.endstub as endstub,
   ac.prefix,
   ac.suffix,
   ac.unit,
   ac.qtybalance
FROM afserial_inventory ac
WHERE ac.afid=$P{afid} 
AND ac.respcenter_objid = 'AFO'
AND ac.qtybalance > 0
ORDER BY ac.currentseries









