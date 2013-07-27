[getListCardType]
SELECT * FROM entityidcardtype 
WHERE objid LIKE $P{objid}

[openCardType]
SELECT * FROM entityidcardtype
WHERE objid = $P{objid}

[insertCardType]
INSERT INTO entityidcardtype ( objid)
VALUES($P{objid})

[deleteCardType]
DELETE FROM entityidcardtype 
WHERE objid = $P{objid}

[insertCard]
INSERT INTO entityidcard
	(objid, entityid, cardtype, cardno, expiry )
VALUES	
	($P{objid}, $P{entityid}, $P{cardtype}, $P{cardno}, $P{expiry} )

[deleteCard]	
DELETE FROM entityidcard WHERE objid = $P{objid}

[deleteCardByEntity]	
DELETE FROM entityidcard WHERE entityid = $P{objid}

[getCardByEntity]
SELECT * FROM entityidcard WHERE entityid=$P{entityid}

[getDuplicateCard]
SELECT e.name
FROM entity e
	INNER JOIN entityidcard c ON e.objid = c.entityid 
WHERE e.objid <> $P{entityid}
  AND c.cardtype = $P{cardtype} 
  AND c.cardno = $P{cardno}