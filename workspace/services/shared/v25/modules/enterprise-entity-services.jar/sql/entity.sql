[getList]
SELECT * FROM entity
WHERE name LIKE $P{searchtext}
ORDER BY name
