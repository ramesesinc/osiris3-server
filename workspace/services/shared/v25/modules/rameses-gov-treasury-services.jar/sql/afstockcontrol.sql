[checkConflictSeries]
SELECT 1 FROM afstockcontrol  
WHERE af=$P{af} 
${filter}
AND (
 (startseries >= $P{startseries} AND endseries <= $P{endseries}) 
 OR
 (startseries <= $P{startseries} AND endseries >= $P{endseries}) 
 OR
 (startseries BETWEEN $P{startseries} AND $P{endseries}) 
 OR
 (endseries BETWEEN $P{startseries} AND $P{endseries})
)

[findAvailable]
SELECT 
   ac.af,
   ac.qtybalance,	 
   af.unitqty,
   ac.currentseries as startseries,
   ac.endseries as endseries,
   ac.currentstub as startstub,
   ac.prefix,
   ac.suffix,
   ac.objid as controlid,
   ac.currentindexno as indexno
FROM afstockcontrol ac
INNER JOIN af ON ac.af = af.objid
WHERE ac.af=$P{af} 
AND ac.endseries > ac.startseries

[getCancelledSeries]
SELECT startseries,endseries,cr as qty FROM afstockcontrol_detail 
WHERE reftype='CANCEL'
AND controlid=$P{controlid}
AND
( (startseries >= $P{startseries} AND endseries <= $P{endseries}) 
 OR
 (startseries <= $P{startseries} AND endseries >= $P{endseries}) 
 OR
 (startseries BETWEEN $P{startseries} AND $P{endseries}) 
 OR
 (endseries BETWEEN $P{startseries} AND $P{endseries}) 
 )


