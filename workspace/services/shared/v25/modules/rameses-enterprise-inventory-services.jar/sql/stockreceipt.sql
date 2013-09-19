[getList]
SELECT r.* 
FROM stockreceipt r WHERE state =$P{state}

[getItems]
SELECT * FROM stockreceiptitem WHERE parentid=$P{objid}

[closeRequest]
UPDATE stockrequest SET state='CLOSED' WHERE objid=$P{objid}


