[getOpenIssuanceList]
SELECT a.* FROM 
(SELECT 
ai.objid AS objid,	
ai.startstub AS stub,
ai.currentseries AS startseries,
ai.endseries AS endseries,
NULL AS txnmode,
0 AS active,
0 AS open
FROM afserial_inventory ai
WHERE  ai.afid = $P{af}
AND ai.respcenter_objid = $P{userid}
AND NOT EXISTS (SELECT ac.controlid FROM afserial_control ac WHERE ac.controlid=ai.objid)
UNION ALL
	SELECT 
	ai.objid AS objid,	
	ai.startstub AS stub,
	ac.currentseries AS startseries,
	ai.endseries AS endseries,
	ac.txnmode,
	ac.active AS active,
	CASE WHEN ac.currentseries = ai.currentseries
	THEN 0 ELSE 1 END AS open
	FROM afserial_inventory ai
	INNER JOIN afserial_control ac ON ai.objid=ac.controlid
	WHERE  ai.afid = $P{af} 
	AND ac.assignee_objid IS NULL 
	AND ai.respcenter_objid = $P{userid}
) a
WHERE a.startseries <= a.endseries
ORDER BY a.startseries

[getAssigneeIssuanceList]
SELECT 
ai.objid AS objid,	
ac.assignee_name,
ai.startstub AS stub,
ac.currentseries AS startseries,
ai.endseries AS endseries,
ac.txnmode,
ac.active AS active,
CASE WHEN ac.currentseries = ai.currentseries
THEN 0 ELSE 1 END AS open
FROM afserial_inventory ai
INNER JOIN afserial_control ac ON ai.objid=ac.controlid
WHERE  ai.afid = $P{af} 
AND NOT(ac.assignee_objid IS NULL) 
AND ai.respcenter_objid = $P{userid}

[findActiveControlForCashReceipt]
SELECT ac.currentseries, ai.currentstub, ai.objid AS controlid, ai.prefix, ai.suffix 
FROM afserial_control ac
INNER JOIN afserial_inventory ai ON ai.objid=ac.controlid
WHERE ai.afid = $P{afid}
AND ai.respcenter_objid = $P{userid}
AND ac.txnmode = $P{txnmode}
AND ac.currentseries <= ai.endseries

[findActiveControlForActivation]
SELECT ac.controlid 
FROM afserial_control ac
INNER JOIN afserial_inventory ai ON ai.objid=ac.controlid
WHERE ai.respcenter_objid=$P{userid}
AND ac.txnmode = $P{txnmode}
AND ac.active=1

[activateControl]
INSERT INTO afserial_control (controlid, txnmode,assignee_objid, assignee_name, currentseries,qtyissued,active)
SELECT objid, $P{txnmode}, NULL, NULL, currentseries, 0,1
FROM afserial_inventory WHERE objid=$P{objid}

[reactivateControl]
UPDATE afserial_control 
SET active=1, txnmode=$P{txnmode} 
WHERE controlid=$P{objid}

[deactivateControl]
UPDATE afserial_control 
SET active = false, txnmode = NULL 
WHERE controlid=$P{objid}

[reactivateAssignSubcollector]
UPDATE afserial_control 
SET assignee_objid=$P{assigneeid},
   assignee_name=$P{assigneename}
WHERE controlid=$P{objid}   

[changeMode]
UPDATE afserial_control 
SET txnmode = $P{txnmode}
WHERE controlid=$P{objid}

[activateAssignSubcollector]
INSERT INTO afserial_control (controlid, txnmode,assignee_objid, assignee_name, currentseries,qtyissued,active)
SELECT objid, NULL, $P{assigneeid}, $P{assigneename}, currentseries, 0,1
FROM afserial_inventory WHERE objid=$P{objid}

[updateNextSeries]
UPDATE afserial_control 
SET currentseries = currentseries + 1,
qtyissued = qtyissued + 1
WHERE controlid = $P{controlid}

[findControlForBatch]
SELECT 
ac.controlid, 
ac.currentseries AS startseries,
ai.endseries AS endseries,
ai.startstub AS stub, 
ai.prefix,
ai.suffix, 
a.serieslength
FROM afserial_control ac
INNER JOIN afserial_inventory ai ON ai.objid=ac.controlid
INNER JOIN afserial a ON ai.afid=a.objid
WHERE ac.controlid = $P{controlid}
