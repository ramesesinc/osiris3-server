[lookup]
SELECT
  objid,
  name,
  indexno,
  pin
FROM lgu_city
WHERE state = 'APPROVED' 
  AND name LIKE $P{name} 
ORDER BY name