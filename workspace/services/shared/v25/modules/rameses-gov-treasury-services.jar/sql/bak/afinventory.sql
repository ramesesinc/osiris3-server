[getList]
SELECT *, (qtyreceived-qtyissued) as qtybalance FROM afinventorycontrol ${filter}

[getAvailableAF]
SELECT 
   ac.af,
   (ac.qtyreceived-ac.qtyissued) as qtybalance,	 
   af.unitqty,
   ac.currentseries as startseries,
   ac.currentstub as startstub,
   ac.prefix,
   ac.suffix,
   ac.objid as controlid 
FROM afinventorycontrol ac
INNER JOIN af ON ac.af = af.objid
WHERE ac.af=$P{af} 
AND ac.endseries > ac.startseries

[checkSeriesPriorUpdate]
SELECT currentseries FROM afinventorycontrol WHERE objid=$P{controlid}

[updateInventory]
UPDATE afinventorycontrol 
SET 
  currentseries = $P{nextseries},
  currentstub = $P{nextstub},
  qtyissued = qtyissued + $P{qty}
WHERE objid=$P{controlid}

[getJournalEntriesByAF]
SELECT ar.txndate, ar.objid, afr.af, ar.txntype, ar.issueto, 
CASE WHEN  ar.txntype = 'PURCHASE' THEN afr.qty ELSE 0 END as dr,
CASE WHEN  NOT(ar.txntype = 'PURCHASE') THEN afr.qty ELSE 0 END as cr
FROM afreceiptitem afr 
INNER JOIN afreceipt ar ON ar.objid=afr.receiptid 
WHERE afr.af = $P{af}
ORDER by ar.txndate 


#--------------------------------------------------------------------
# filter is reserved to evaluate prefix and suffix 
#--------------------------------------------------------------------
[checkConflictSeries]
SELECT 1 FROM afinventorycontrol  
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


