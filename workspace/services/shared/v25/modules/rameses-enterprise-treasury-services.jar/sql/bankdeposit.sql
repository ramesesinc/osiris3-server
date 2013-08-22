[getList]
SELECT * FROM bankdeposit 

[getUndeposited]
SELECT  lcf.objid, 
	l.txnno as liquidationno,
	l.dtposted as liquidationdate,
	lcf.fund_objid,
	lcf.fund_title,
	liquidatingofficer_objid, 
	liquidatingofficer_name, 	
	liquidatingofficer_title, 
	lcf.amount
FROM liquidation_cashier_fund lcf
INNER JOIN liquidation l ON lcf.liquidationid=l.objid
LEFT JOIN bankdeposit_liquidation bdl ON bdl.objid=lcf.objid
WHERE 
lcf.cashier_objid = $P{cashierid}
AND bdl.objid IS NULL

[getUndepositedByFund]
SELECT a.fund_objid,
       a.fund_title,
       SUM(a.amount) AS amount
FROM
( SELECT  
	lcf.fund_objid,
	lcf.fund_title,
	lcf.amount
FROM liquidation_cashier_fund lcf
INNER JOIN liquidation l ON lcf.liquidationid=l.objid
LEFT JOIN bankdeposit_liquidation bdl ON bdl.objid=lcf.objid
WHERE 
lcf.cashier_objid = $P{cashierid}
AND bdl.objid IS NULL) a
GROUP BY a.fund_objid, a.fund_title

[getUndepositedChecks]
SELECT DISTINCT
crp.objid, crp.checkno, crp.particulars, crp.amount  
FROM liquidation_remittance lr
INNER JOIN liquidation_cashier_fund lcf ON lr.liquidationid=lr.liquidationid
INNER JOIN liquidation_checkpayment lc ON lc.liquidationid=lr.liquidationid
INNER JOIN cashreceiptpayment_check crp ON crp.objid=lc.objid
LEFT JOIN cashreceipt_void cv ON crp.receiptid = cv.receiptid 
WHERE lcf.cashier_objid=$P{cashierid}
AND cv.objid IS NULL 

[getDepositSummaries]
SELECT  be.*,
	ba.fund_objid,
	ba.fund_code,
	ba.fund_title
FROM bankdeposit_entry be
	INNER JOIN bankaccount ba ON be.bankaccount_objid = ba.objid
WHERE be.parentid = $P{objid}
ORDER BY ba.fund_title 
