
[getActiveList]
SELECT * 
FROM afcontrol a
INNER JOIN afcontrol_activedetail av ON av.controlid=a.objid
INNER JOIN afcontrol_detail ad ON av.detailid=ad.objid
WHERE ad.currentseries < ad.endseries 
  AND (ad.startseries = $P{startseries} OR ad.collector_name LIKE $P{searchtext})
ORDER BY ad.currentseries
 
[findActiveControlId]
SELECT a.objid
FROM afcontrol a
INNER JOIN afcontrol_activedetail av ON av.controlid=a.objid
INNER JOIN afcontrol_detail ad ON av.detailid=ad.objid
WHERE a.active=1 AND a.af=$P{af}
AND ad.collector_objid = $P{userid}
AND a.mode = $P{txnmode}

[activateControl]
UPDATE afcontrol SET active=1 WHERE objid=$P{objid}

[deactivateControl]
UPDATE afcontrol SET active=0 WHERE objid=$P{objid}

[getOpenControlList]
SELECT a.objid, currentseries as startseries, endseries, stub, active  
FROM afcontrol a
INNER JOIN afcontrol_activedetail av ON av.controlid=a.objid
INNER JOIN afcontrol_detail ad ON av.detailid=ad.objid
WHERE a.af=$P{af} 
AND currentseries <= endseries 
AND (ad.collector_objid=$P{userid}) 
AND a.mode = $P{txnmode}
AND a.subcollector_objid IS NULL
ORDER BY currentseries

[getListForAssignment]
SELECT a.objid, currentseries as startseries, endseries, stub, active,
subcollector_name, subcollector_title, subcollector_objid
FROM afcontrol a
INNER JOIN afcontrol_activedetail av ON av.controlid=a.objid
INNER JOIN afcontrol_detail ad ON av.detailid=ad.objid
WHERE a.af=$P{af} 
AND currentseries <= endseries 
AND (ad.collector_objid=$P{userid}) 
AND a.mode = $P{txnmode}
AND (a.subcollector_objid IS NOT NULL OR a.active = 0)
ORDER BY currentseries

[assignSubcollector]
UPDATE afcontrol SET subcollector_objid=$P{subcollectorid}, 
subcollector_name=$P{subcollectorname},subcollector_title=$P{subcollectortitle}
WHERE objid=$P{objid} 

[getNextReceiptInfo]
SELECT a.objid as controlid,prefix,suffix,currentseries as series, stub
FROM afcontrol a
INNER JOIN afcontrol_activedetail av ON av.controlid=a.objid
INNER JOIN afcontrol_detail ad ON av.detailid=ad.objid
WHERE a.objid=$P{objid} AND currentseries<=endseries


[findActiveDetail]
SELECT * 
FROM afcontrol a
INNER JOIN afcontrol_activedetail av ON av.controlid=a.objid
INNER JOIN afcontrol_detail ad ON av.detailid=ad.objid
WHERE a.controlid = $P{objid}

[changeMode]
UPDATE afcontrol SET mode=$P{mode}, active=0 WHERE objid=$P{objid}

[findActiveControl]
SELECT * 
FROM afcontrol a
INNER JOIN afcontrol_activedetail av ON av.controlid=a.objid
INNER JOIN afcontrol_detail ad ON av.detailid=ad.objid
WHERE a.objid = $P{objid}

[getDetailsList]
SELECT ad.* FROM afcontrol_detail ad
LEFT JOIN remittance_af rf ON rf.objid=ad.objid 
WHERE controlid=$P{objid} ORDER BY startseries

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

