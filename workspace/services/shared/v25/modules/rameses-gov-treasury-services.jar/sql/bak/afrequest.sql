[getList]
SELECT 
CASE WHEN ar.objid IS NULL THEN af.objid ELSE ar.objid END AS objid,
af.state, af.txndate, af.txntype, 
af.requester_firstname, af.requester_lastname,
CASE WHEN ar.objid IS NULL THEN 'afrequest' ELSE 'afreceipt' END AS filetype
FROM afrequest af
LEFT JOIN afreceipt ar ON af.objid=ar.request_objid
WHERE af.state=$P{state}

[getItems]
SELECT ar.*, (ar.qty - ar.qtyreceived) as qtybalance,
af.aftype, af.unit, af.unitqty, af.description, 
af.serieslength, af.denomination
FROM afrequestitem ar
INNER JOIN af af ON af.objid=ar.af 
WHERE ar.reqid = $P{objid}

[changeState-approved]
UPDATE afrequest SET state='APPROVED' WHERE objid=$P{objid}

[changeState-closed]
UPDATE afrequest SET state='CLOSED' WHERE objid=$P{objid}