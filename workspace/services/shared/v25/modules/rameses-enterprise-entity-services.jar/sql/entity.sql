[getList]
SELECT e.objid, e.entityno, e.name, e.address, e.type 
FROM entity e 
WHERE e.entityname LIKE $P{name}  
ORDER BY e.entityname 

[getLookup]
SELECT e.objid, e.entityno, e.name, e.address, e.type 
FROM entity e 
WHERE e.entityname LIKE $P{name} and type IN ('INDIVIDUAL','JURIDICAL') 
ORDER BY e.entityname 

[getLookupIndividual]
SELECT e.objid, e.entityno, e.name, e.address, e.type 
FROM entity e 
INNER JOIN entityindividual ei ON e.objid=ei.objid 
WHERE e.entityname LIKE $P{name} 
ORDER BY e.entityname 

[getLookupJuridical]
SELECT e.objid, e.entityno, e.name, e.address, e.type 
FROM entity e 
INNER JOIN entityjuridical ej ON e.objid=ej.objid 
WHERE e.entityname LIKE $P{name} 
AND ej.orgtype = $P{orgtype}
ORDER BY e.entityname 


[removeContacts]
DELETE FROM entitycontact WHERE entityid=$P{objid}  

[getContacts]
SELECT * FROM entitycontact WHERE entityid=$P{objid} 

[lookup]
SELECT e.objid, e.entityno, e.name, e.address, e.type 
FROM entity e 
WHERE e.entityname LIKE $P{name} and type IN ('INDIVIDUAL','JURIDICAL') 
ORDER BY e.entityname 
