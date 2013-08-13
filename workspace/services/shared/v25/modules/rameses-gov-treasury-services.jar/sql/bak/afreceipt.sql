[getItems]
SELECT ar.*,
af.aftype, af.unit, af.unitqty, af.description,
af.serieslength, af.denomination
FROM afreceiptitem ar
INNER JOIN af af ON af.objid=ar.af 
WHERE ar.receiptid = $P{objid}