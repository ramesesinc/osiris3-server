[getList]
SELECT * 
FROM remittance 
WHERE txnno = $P{txnno}
  OR collector_name LIKE $P{searchtext} 
ORDER BY collector_name, txnno DESC 

[getUnremittedForCollector]
SELECT af.af as formno, af.stub as stub, 
  MIN(receiptno) as startseries, 
  MAX(receiptno) as endseries,
  SUM(CASE WHEN v.objid IS NULL THEN c.amount ELSE 0 END) AS amount,
  SUM(CASE WHEN v.objid IS NULL THEN c.totalcash-c.cashchange ELSE 0 END) AS totalcash,
  SUM(CASE WHEN v.objid IS NULL THEN c.totalnoncash ELSE 0 END) AS totalnoncash
FROM cashreceipt c 
INNER JOIN afcontrol af ON c.controlid=af.objid
LEFT JOIN remittance_cashreceipt r ON c.objid=r.objid
LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE r.objid IS NULL
AND c.collector_objid = $P{collectorid}
GROUP by af.af, af.stub , c.collector_objid


[collectReceipts]
INSERT INTO remittance_cashreceipt (objid, remittanceid)
SELECT c.objid, $P{remittanceid} 
FROM cashreceipt c 
LEFT JOIN remittance_cashreceipt r ON c.objid=r.objid
WHERE r.objid IS NULL 
AND c.collector_objid = $P{collectorid}

[collectAFControl]
INSERT INTO remittance_af (objid, remittanceid)
SELECT ad.objid, $P{remittanceid} 
FROM afcontrol_activedetail av 
INNER JOIN afcontrol_detail ad ON ad.objid=av.detailid 
WHERE ad.collector_objid = $P{collectorid} 

[getRemittedAFControlIdsForPosting]
SELECT av.controlid 
FROM afcontrol_activedetail av 
INNER JOIN afcontrol_detail ad ON ad.objid=av.detailid 
WHERE ad.collector_objid = $P{collectorid}

[getRemittedFundTotals]
SELECT cb.fund_objid AS fundid, SUM(( cbe.dr - cbe.cr )) AS amount
FROM remittance_cashreceipt c
INNER JOIN cashbook_entry cbe ON cbe.refid = c.objid
INNER JOIN cashbook cb ON cb.objid = cbe.parentid
WHERE remittanceid = $P{remittanceid}
GROUP BY cb.fund_objid


[getSummary]
SELECT af.af, af.stub, min(receiptno), max(receiptno),
  SUM(CASE WHEN v.objid IS NULL THEN c.amount ELSE 0 END) AS summary 
FROM cashreceipt c 
INNER JOIN afcontrol af ON c.controlid=af.objid
LEFT JOIN remittanceitem r ON c.objid=r.receiptid
LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE r.receiptid IS NULL
AND c.collector_objid = $P{collectorid}
GROUP by af.af, af.stub 

[getNonCashPayments]
SELECT cc.*
FROM remittance r
	INNER JOIN remittance_cashreceipt rc ON r.objid = rc.remittanceid
	INNER JOIN cashreceiptpayment_check cc ON rc.objid = cc.receiptid 
WHERE r.objid = $P{remittanceid}
  AND NOT EXISTS(SELECT * FROM cashreceipt_void WHERE receiptid = cc.receiptid)
ORDER BY cc.bank, cc.checkno   
  
