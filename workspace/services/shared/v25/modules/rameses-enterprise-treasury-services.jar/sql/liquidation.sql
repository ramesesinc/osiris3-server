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
LEFT JOIN liquidation l ON l.objid = lr.liquidationid
WHERE r.liquidatingofficer_objid  = $P{liquidatingofficerid}
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
LEFT JOIN liquidation l ON l.objid = lr.liquidationid
INNER JOIN cashbook_entry cbe ON cbe.refid=r.objid
INNER JOIN cashbook cb ON cb.objid = cbe.parentid 
WHERE r.liquidatingofficer_objid  =  $P{liquidatingofficerid}
AND lr.objid IS NULL ORDER BY cb.fund_code) a
GROUP BY a.fund_objid, a.fund_code, a.fund_title 

[addLiquidateRemittance]
INSERT INTO liquidation_remittance (objid, liquidationid)
SELECT $P{liquidationid}, r.objid
FROM remittance r WHERE r.objid IN (${ids})


[getFundSummaries]
SELECT * FROM liquidation_cashier_fund WHERE liquidationid = $P{liquidationid}