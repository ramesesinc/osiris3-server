[lookup]
SELECT
  objid,
  name,
  indexno,
  pin
FROM lgu_district
WHERE state = 'APPROVED' 
  AND name LIKE $P{name} and parentid like $P{parentid}
ORDER BY name