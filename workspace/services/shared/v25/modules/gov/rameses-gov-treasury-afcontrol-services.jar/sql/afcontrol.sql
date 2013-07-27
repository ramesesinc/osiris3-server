[getList]
SELECT *, (endseries-currentseries+1) as qtybalance
FROM afcontrol ${filter} ORDER BY currentseries, stub 

[getOpenListByCollector]
SELECT * FROM afcontrol WHERE currentseries < endseries 
AND collector=$P{collector} ORDER BY currentseries

[getOpenListByAssignee]
SELECT * FROM afcontrol WHERE currentseries < endseries 
AND assignee=$P{assignee} ORDER BY currentseries


[updateCollector]
UPDATE afcontrol SET collector=$P{collector} WHERE objid=$P{objid}

[updateAssignee]
UPDATE afcontrol SET assignee=$P{assignee} WHERE objid=$P{objid}

[updateMode]
UPDATE afcontrol SET mode=$P{mode}
WHERE objid=$P{objid} AND state='OPEN'

[activateCollectorControl]
UPDATE afcontrol 
SET active=(  CASE WHEN objid=$P{objid} THEN 1 ELSE 0 END)	
WHERE collector=$P{collector} AND (assignee IS NULL OR assignee=$P{collector}) AND state='OPEN'

[activateAssigneeControl]
UPDATE afcontrol 
SET active=( CASE WHEN objid=$P{objid} THEN 1 ELSE 0 END)	
WHERE collector=$P{collector} AND assignee=$P{assignee} AND state='OPEN'

[transferCollector]
UPDATE afcontrol SET collector=$P{collector}, beginseries=currentseries WHERE objid=$P{objid} 

#--------------------------------------------------------------------
# called when checking new ensure no conflicts with existing records
# filter is reserved to evaluate prefix and suffix 
#--------------------------------------------------------------------
[checkConflictSeries]
SELECT 1 FROM afcontrol 
WHERE af=$P{af} 
${filter}
AND (
 (startseries >= $P{startseries} AND endseries <= $P{endseries}) 
 OR
 (startseries <= $P{startseries} AND endseries >= $P{endseries}) 
 OR
 (startseries BETWEEN $P{startseries} AND $P{endseries}) 
 OR
 (endseries BETWEEN $P{startseries} AND $P{endseries})
)


#---------------------------------------------------
# the following refers to cancellation of series
#---------------------------------------------------
[checkConflictCancelledSeries]
SELECT 1 FROM afcontrolcancelled 
WHERE controlid=$P{controlid} 
AND (
 (startseries >= $P{startseries} AND endseries <= $P{endseries}) 
 OR
 (startseries <= $P{startseries} AND endseries >= $P{endseries}) 
 OR
 (startseries BETWEEN $P{startseries} AND $P{endseries}) 
 OR
 (endseries BETWEEN $P{startseries} AND $P{endseries})
)

[getCancelledForUpdateSeries]
SELECT startseries,endseries 
FROM afcontrolcancelled 
WHERE controlid=$P{controlid} AND startseries >=$P{currentseries}

[getCancelledSeries]
SELECT  * FROM afcontrolcancelled WHERE controlid=$P{controlid} ORDER BY startseries



#---------------------------------------------------
# updating next series
#---------------------------------------------------
[updateCurrentSeries]
UPDATE afcontrol SET currentseries=$P{currentseries},
state = (CASE WHEN endseries < (currentseries) THEN 'CLOSED' ELSE state END) 
WHERE objid=$P{controlid}  
