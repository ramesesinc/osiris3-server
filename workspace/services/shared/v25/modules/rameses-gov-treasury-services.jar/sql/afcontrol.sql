[getList]
SELECT * FROM afcontrol WHERE currentseries <= endseries

[getConflictSeries]
SELECT startseries,endseries,cr as qty
FROM afcontrol_detail 
WHERE cr > 0
AND controlid=$P{controlid}
AND
( (startseries >= $P{startseries} AND endseries <= $P{endseries}) 
 OR
 (startseries <= $P{startseries} AND endseries >= $P{endseries}) 
 OR
 (startseries BETWEEN $P{startseries} AND $P{endseries}) 
 OR
 (endseries BETWEEN $P{startseries} AND $P{endseries}) 
 )
 
[getCancelledSeriesInRange]
SELECT * FROM afcontrol_detail 
WHERE controlid=$P{controlid}
AND startseries >= $P{startseries} 
AND endseries <= $P{endseries} 
AND reftype='CANCEL'

[getNextReceiptInfo]
SELECT objid as controlid,prefix,suffix,currentseries as series,
stub,collector_objid,collector_name,collector_jobtitle 
FROM afcontrol WHERE objid=$P{objid} AND currentseries<=endseries
 
[findActiveControlId]
SELECT objid
FROM afcontrol 
WHERE active=1 AND af=$P{af}
AND collector_objid = $P{userid} OR assignee_objid=$P{userid}

[activateControl]
UPDATE afcontrol 
SET active=(  CASE WHEN objid=$P{objid} THEN 1 ELSE 0 END)	
WHERE collector_objid=$P{userid} AND (assignee_objid IS NULL OR assignee_objid=$P{userid}) 
AND currentseries <= endseries

[getOpenControlList]
SELECT objid,currentseries as startseries,endseries,stub 
FROM afcontrol 
WHERE af=$P{af} 
AND currentseries <= endseries 
AND (collector_objid=$P{userid} OR assignee_objid=$P{userid}) 
ORDER BY stub


