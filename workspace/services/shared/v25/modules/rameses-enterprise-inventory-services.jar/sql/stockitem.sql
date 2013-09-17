[getList]
SELECT r.* 
FROM stockitem r 
WHERE r.itemclass = $P{itemclass}

[getItemClasses]
SELECT DISTINCT 
itemclass, itemclass as caption 
FROM stockitem

[getLookup]
SELECT r.* 
FROM stockitem r 
WHERE r.itemclass =  $P{itemclass}
AND r.code LIKE $P{searchtext}

[findUnitQty]
SELECT qty FROM stockitem_unit WHERE itemid=$P{itemid} AND unit=$P{unit}

[findItemType]
SELECT type FROM stockitem WHERE objid=$P{objid}
