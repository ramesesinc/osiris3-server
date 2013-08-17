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
