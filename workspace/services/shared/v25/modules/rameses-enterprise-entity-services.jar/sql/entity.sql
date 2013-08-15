[getList]
SELECT e.objid, e.entityno, e.name, e.address, e.type 
FROM entity e 
WHERE e.name LIKE $P{name}  
ORDER BY e.name 


[lookup]
SELECT e.objid, e.entityno, e.name, e.address, e.type 
FROM entity e 
WHERE e.name LIKE $P{name} and type IN ('INDIVIDUAL','JURIDICAL') 
ORDER BY e.name 

[removeContacts]
DELETE FROM entitycontact WHERE entityid=$P{objid}  

[getContacts]
SELECT * FROM entitycontact WHERE entityid=$P{objid} 
