[getTxnTypes]
SELECT * FROM cashreceipt_txntype 

[getList]
SELECT c.*, CASE WHEN r.receiptid IS NULL THEN 0 ELSE 1 END AS remitted  
FROM cashreceipt c 
LEFT JOIN remittanceitem r ON c.objid=r.receiptid

[getItems]
SELECT * FROM cashreceiptitem WHERE receiptid=$P{objid}

[getCheckPayments]
SELECT * FROM cashreceiptpayment_check WHERE receiptid=$P{objid}