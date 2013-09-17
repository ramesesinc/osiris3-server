[findStockReceiptInfo]
SELECT a.objid, 
a.serieslength, 
su.qty AS unitqty
FROM afserial a
INNER JOIN stockitem_unit su ON su.itemid=a.objid
WHERE a.objid= $P{objid}
AND su.unit = $P{unit}

[getAFInfo]
SELECT unitqty, unit,serieslength  FROM af WHERE objid=$P{objid}

[getTypes]
SELECT af.objid as af, af.* FROM af ORDER BY af.objid

[getList]
SELECT af.objid as objid, af.objid as code, af.description, af.unit 
FROM af WHERE af.objid LIKE $P{searchtext}
