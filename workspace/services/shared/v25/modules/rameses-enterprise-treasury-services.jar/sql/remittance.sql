[getList]
SELECT r.*,
CASE WHEN lr.objid IS NULL THEN 0 ELSE 1 END AS liquidated 
FROM remittance r
LEFT JOIN liquidation_remittance lr ON r.objid=lr.objid
WHERE r.txnno = $P{txnno}
  OR r.collector_name LIKE $P{searchtext} 
ORDER BY r.collector_name, r.txnno DESC 

[getUnremittedForCollector]
SELECT c.formno, c.collector_objid, c.controlid, 
  MIN(series) as startseries, 
  MAX(series) as endseries,
  SUM(CASE WHEN v.objid IS NULL THEN c.amount ELSE 0 END) AS amount,
  SUM(CASE WHEN v.objid IS NULL THEN c.totalcash-c.cashchange ELSE 0 END) AS totalcash,
  SUM(CASE WHEN v.objid IS NULL THEN c.totalnoncash ELSE 0 END) AS totalnoncash
FROM cashreceipt c 
LEFT JOIN remittance_cashreceipt r ON c.objid=r.objid
LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE r.objid IS NULL
AND c.collector_objid = $P{collectorid}
GROUP by c.collector_objid, c.formno, c.controlid, c.collector_objid

[getUnremittedReceipts]
SELECT c.formno, c.receiptno, c.paidby, c.receiptdate,
CASE WHEN v.objid IS NULL THEN c.amount ELSE 0 END AS amount,
CASE WHEN v.objid IS NULL THEN 0 ELSE 1 END AS voided,
c.subcollector_name
FROM cashreceipt c 
LEFT JOIN remittance_cashreceipt r ON c.objid=r.objid
LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE r.objid IS NULL
AND c.collector_objid = $P{collectorid}
ORDER BY c.receiptno

[getUnremittedChecks]
SELECT 
crp.objid, crp.checkno, crp.particulars, 
CASE WHEN cv.objid IS NULL THEN crp.amount ELSE 0 END AS amount,
CASE WHEN cv.objid IS NULL THEN 0 ELSE 1 END AS voided,
cash.subcollector_name
FROM cashreceipt cash 
INNER JOIN cashreceiptpayment_check crp ON crp.receiptid=cash.objid
LEFT JOIN cashreceipt_void cv ON crp.receiptid = cv.receiptid
LEFT JOIN remittance_cashreceipt rc ON rc.objid=cash.objid
WHERE rc.objid IS NULL 
AND cash.collector_objid = $P{collectorid}

[collectReceipts]
INSERT INTO remittance_cashreceipt (objid, remittanceid)
SELECT c.objid, $P{remittanceid} 
FROM cashreceipt c 
LEFT JOIN remittance_cashreceipt r ON c.objid=r.objid
WHERE r.objid IS NULL 
AND c.collector_objid = $P{collectorid}

[collectChecks]
INSERT INTO remittance_checkpayment (objid, remittanceid, amount, voided )
SELECT 
crp.objid, $P{remittanceid}, crp.amount,   
CASE WHEN cv.objid IS NULL THEN 0 ELSE 1 END AS voided
FROM cashreceipt cash 
INNER JOIN cashreceiptpayment_check crp ON crp.receiptid=cash.objid
LEFT JOIN remittance_cashreceipt rc ON rc.objid=cash.objid
LEFT JOIN cashreceipt_void cv ON crp.receiptid = cv.receiptid
WHERE rc.remittanceid = $P{remittanceid}

[getRemittedFundTotals]
SELECT cb.fund_objid, cb.fund_title, SUM(( cbe.dr - cbe.cr )) AS amount
FROM remittance_cashreceipt c
LEFT JOIN cashreceipt_void cv ON c.objid = cv.receiptid 
INNER JOIN cashbook_entry cbe ON cbe.refid = c.objid
INNER JOIN cashbook cb ON cb.objid = cbe.parentid
WHERE remittanceid = $P{remittanceid}
AND cv.objid IS NULL
GROUP BY cb.fund_objid, cb.fund_title




[getRemittedChecks]
SELECT 
   crpc.checkno, crpc.particulars, 
   CASE WHEN rc.voided = 1 THEN 0 ELSE rc.amount END AS amount, 
   rc.voided
FROM remittance_checkpayment rc
INNER JOIN cashreceiptpayment_check crpc ON crpc.objid=rc.objid
WHERE rc.remittanceid  = $P{objid}

[getRemittedReceipts]
SELECT c.formno, c.receiptno, c.paidby, c.receiptdate,
CASE WHEN v.objid IS NULL THEN c.amount ELSE 0 END AS amount,
CASE WHEN v.objid IS NULL THEN 0 ELSE 1 END AS voided
FROM cashreceipt c 
LEFT JOIN remittance_cashreceipt r ON c.objid=r.objid
LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE r.remittanceid = $P{objid}
ORDER BY c.receiptno
