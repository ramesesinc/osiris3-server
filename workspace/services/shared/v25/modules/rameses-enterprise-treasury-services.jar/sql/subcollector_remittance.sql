[getList]
SELECT r.*
FROM subcollector_remittance r


[getCollectors]
SELECT 
   DISTINCT 	
   cr.collector_name AS name,
   cr.collector_title AS title,
   cr.collector_objid AS objid
FROM cashreceipt cr
WHERE cr.state = 'DELEGATED'
AND cr.subcollector_objid=$P{subcollectorid}

[getUremittedCollectionSummary]
SELECT 
   cr.stub, 	
   MIN(cr.receiptno) AS startno,
   MAX(cr.receiptno) AS endno,
   SUM( CASE WHEN cv.objid IS NULL THEN cr.amount ELSE 0 END ) AS amount
FROM cashreceipt cr
LEFT JOIN cashreceipt_void cv ON cr.objid=cv.objid
WHERE cr.state = 'DELEGATED'
AND cr.collector_objid = $P{collectorid}
AND cr.subcollector_objid=$P{subcollectorid}
GROUP BY cr.stub

[findSummaryTotals]
SELECT 
   COUNT(*) AS itemcount,
   SUM( CASE WHEN cv.objid IS NULL THEN cr.amount ELSE 0 END ) AS amount
FROM cashreceipt cr
LEFT JOIN cashreceipt_void cv ON cr.objid=cv.objid
WHERE cr.state = 'DELEGATED'
AND cr.collector_objid = $P{collectorid}
AND cr.subcollector_objid=$P{subcollectorid}
  
[collectReceipts]
INSERT INTO subcollector_remittance_cashreceipt (objid, remittanceid)
SELECT cr.objid, $P{remittanceid} 
FROM cashreceipt cr  
WHERE cr.state = 'DELEGATED'
AND cr.collector_objid = $P{collectorid}
AND cr.subcollector_objid=$P{subcollectorid}

[updateCashReceiptState]
UPDATE cashreceipt cr 
SET cr.state = 'POSTED'
WHERE EXISTS (
	SELECT csr.objid 
	FROM subcollector_remittance_cashreceipt csr
	WHERE csr.remittanceid = $P{remittanceid} AND csr.objid=cr.objid
)

