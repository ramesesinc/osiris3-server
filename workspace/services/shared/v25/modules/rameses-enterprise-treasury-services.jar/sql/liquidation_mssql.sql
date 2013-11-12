[getList]
SELECT * FROM liquidation

[getUnliquidatedRemittances]
SELECT 
	r.objid, 
	r.txnno AS remittanceno,
	r.dtposted AS remittancedate,
	r.collector_name,
	r.totalcash,
	r.totalnoncash,
	r.amount 
FROM remittance r
LEFT JOIN liquidation_remittance lr ON r.objid=lr.objid
WHERE r.liquidatingofficer_objid  = $P{liquidatingofficerid}
	and r.state = 'OPEN'
 	AND lr.objid IS NULL 

[getUnliquidatedChecks]
SELECT pc.objid, pc.checkno, pc.checkdate, pc.particulars,
CASE WHEN cv.objid IS NULL THEN pc.amount ELSE 0 END AS amount,
CASE WHEN cv.objid IS NULL THEN 0 ELSE 1 END AS voided
FROM remittance_checkpayment rcp 
INNER JOIN cashreceiptpayment_check pc ON rcp.objid=pc.objid
INNER JOIN remittance r ON rcp.remittanceid=r.objid
LEFT JOIN cashreceipt_void cv ON cv.receiptid=pc.receiptid
LEFT JOIN liquidation_remittance lr ON r.objid=lr.objid
WHERE r.liquidatingofficer_objid  = $P{liquidatingofficerid}
	and r.state = 'OPEN'
	AND lr.objid IS NULL


[getUnliquidatedFundSummary]
SELECT a.fund_objid, a.fund_code, a.fund_title, 
SUM(a.amount) AS amount
FROM 
(SELECT 
	cb.fund_objid,	
    cb.fund_code,
    cb.fund_title,
    cbe.cr AS amount
FROM remittance r
LEFT JOIN liquidation_remittance lr ON r.objid=lr.objid
INNER JOIN cashbook_entry cbe ON cbe.refid=r.objid
INNER JOIN cashbook cb ON cb.objid = cbe.parentid 
WHERE r.liquidatingofficer_objid  =  $P{liquidatingofficerid}
	and r.state = 'OPEN'
AND lr.objid IS NULL) a
GROUP BY a.fund_objid, a.fund_code, a.fund_title 

[postLiquidateRemittance]
INSERT INTO liquidation_remittance (objid, liquidationid)
SELECT r.objid, $P{liquidationid}
FROM remittance r WHERE r.objid IN (${ids})

[postLiquidateChecks]
INSERT INTO liquidation_checkpayment (objid, liquidationid  )
SELECT 
crp.objid, $P{liquidationid}
FROM cashreceiptpayment_check crp 
INNER JOIN remittance_cashreceipt rc ON rc.objid=crp.receiptid
WHERE rc.remittanceid IN (${ids})


[getLiquidatedChecks]
SELECT 
   crpc.checkno, crpc.particulars, 
   CASE WHEN cv.objid IS NULL THEN crpc.amount ELSE 0 END AS amount, 
   CASE WHEN cv.objid IS NULL THEN 0 ELSE 1 END AS voided
FROM liquidation_checkpayment rc
INNER JOIN cashreceiptpayment_check crpc ON crpc.objid=rc.objid
LEFT JOIN cashreceipt_void cv ON crpc.receiptid=cv.receiptid
WHERE rc.liquidationid = $P{objid}

[getFundSummaries]
SELECT * FROM liquidation_cashier_fund WHERE liquidationid = $P{liquidationid}