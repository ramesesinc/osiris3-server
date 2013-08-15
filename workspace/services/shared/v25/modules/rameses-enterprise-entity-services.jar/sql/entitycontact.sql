[getListContactType]
SELECT * FROM entitycontacttype
WHERE objid LIKE $P{objid}

[openContactType]
SELECT * FROM entitycontacttype
WHERE objid = $P{objid}

[insertContactType]
INSERT INTO entitycontacttype ( objid, isunique)
VALUES($P{objid}, $P{isunique})

[deleteContactType]
DELETE FROM entitycontacttype 
WHERE objid = $P{objid}

[insertContact]
INSERT INTO entitycontact
	(objid, entityid, contacttype, contact )
VALUES	
	($P{objid}, $P{entityid}, $P{contacttype}, $P{contact} )

[deleteContact]	
DELETE FROM entitycontact WHERE objid = $P{objid}

[deleteContactByEntity]	
DELETE FROM entitycontact WHERE entityid = $P{objid}


[getContactByEntity]
SELECT * FROM entitycontact WHERE entityid=$P{entityid}

[getDuplicateContact]
SELECT e.ename
FROM entity e
	INNER JOIN entitycontact c ON e.objid = c.entityid 
WHERE e.objid <> $P{entityid}
  AND c.contact = $P{contact} 
  AND c.contacttype = $P{contacttype}