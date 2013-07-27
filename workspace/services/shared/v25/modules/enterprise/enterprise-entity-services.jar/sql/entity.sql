[getList]
SELECT * FROM entity
WHERE name LIKE $P{searchtext}
ORDER BY name

[checkDuplicateName]
SELECT * FROM entity 
WHERE objid <> $P{objid} 
  AND name = $P{name} AND address = $P{address}