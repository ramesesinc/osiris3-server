[getRevenueAccountSRE]
SELECT * FROM sreaccount WHERE acctgroup = 'REVENUE'

[getAccountsByParentIdSRE]
SELECT objid, code, title, type, parentid
FROM sreaccount
WHERE parentid = $P{parentid}
ORDER BY code


[getAmountByAccountId]
SELECT SUM(cri.amount) AS amount
FROM bankdeposit bd 
	INNER JOIN bankdeposit_liquidation bl ON bd.objid = bl.bankdepositid
	INNER JOIN liquidation_cashier_fund lcf ON bl.objid = lcf.objid 
	INNER JOIN liquidation l ON lcf.liquidationid = l.objid 
	INNER JOIN liquidation_remittance lr ON l.objid = lr.liquidationid
	INNER JOIN remittance r ON lr.objid = r.objid 
	INNER JOIN remittance_cashreceipt rc ON r.objid = rc.remittanceid
	INNER JOIN cashreceipt cr ON rc.objid = cr.objid 
	INNER JOIN cashreceiptitem cri ON cr.objid = cri.receiptid 
	INNER JOIN revenueitem ri ON cri.item_objid = ri.objid 
	INNER JOIN revenueitem_sreaccount rsre ON ri.objid = rsre.objid 
	LEFT JOIN cashreceipt_void vr ON cr.objid = vr.objid 
WHERE bd.dtposted BETWEEN $P{fromdate} AND $P{todate}
  AND rsre.acctid = $P{accountid}
  AND vr.objid IS NULL 
  
  