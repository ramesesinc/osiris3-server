[getList]
SELECT * FROM liquidation 
where o.liquidatingofficer_objid = $P{liquidationofficerid}
	and txnno like $P{txnno}

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
	rf.fund_objid,	
    f.code as fund_code,
    rf.fund_title,
    rf.amount AS amount
FROM remittance r
inner join remittance_fund rf on rf.remittanceid = r.objid 
inner join fund f on f.objid = rf.fund_objid 
LEFT JOIN liquidation_remittance lr ON r.objid=lr.objid
WHERE r.liquidatingofficer_objid = $P{liquidatingofficerid}
	and r.state = 'OPEN'
AND lr.objid IS NULL ORDER BY f.code) a
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