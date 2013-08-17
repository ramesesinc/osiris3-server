[getList]
SELECT * 
FROM ris 
WHERE risno LIKE $P{searchtext}
  OR requester_name LIKE $P{searchtext}
ORDER BY risno DESC 

[getItems]
SELECT * FROM risitem WHERE parentid=$P{objid}


[changeState-approved]
UPDATE ris SET state='APPROVED' WHERE objid=$P{objid}