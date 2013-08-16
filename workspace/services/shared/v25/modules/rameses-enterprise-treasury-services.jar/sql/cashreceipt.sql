[getTxnTypes]
SELECT * FROM cashreceipt_txntype 

[getList]
SELECT c.*, 
CASE WHEN v.receiptid IS NULL THEN 0 ELSE 1 END AS voided,  
CASE WHEN r.receiptid IS NULL THEN 0 ELSE 1 END AS remitted  
FROM cashreceipt c 
LEFT JOIN remittanceitem r ON c.objid=r.receiptid
LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid

[getItems]
SELECT ci.*, r.fund_objid AS item_fund_objid, r.fund_title AS item_fund_title
FROM cashreceiptitem ci
INNER JOIN revenueitem r ON r.objid = ci.item_objid
WHERE ci.receiptid=$P{objid}

[getCheckPayments]
SELECT * FROM cashreceiptpayment_check WHERE receiptid=$P{objid}