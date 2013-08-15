[getList]
SELECT 
* FROM ris
WHERE state=$P{state}

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