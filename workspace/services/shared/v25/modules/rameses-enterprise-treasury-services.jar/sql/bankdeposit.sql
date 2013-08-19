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
INNER JOIN remittance_cashreceipt rc ON rc.remittanceid=lr.objid
INNER JOIN cashreceiptpayment_check crp ON crp.receiptid=rc.objid
WHERE lcf.cashier_objid=$P{cashierid}
