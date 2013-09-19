[getList]
SELECT r.* 
FROM stockissue r WHERE state =$P{state}

[getItems]
SELECT * FROM stockissueitem WHERE parentid=$P{objid}

[closeRequest]
UPDATE stockrequest SET state='CLOSED' WHERE objid=$P{objid}

