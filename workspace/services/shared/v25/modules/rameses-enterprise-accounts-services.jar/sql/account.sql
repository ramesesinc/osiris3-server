[getRootNodes]
SELECT a.*
FROM account a 
WHERE a.parentid IS NULL and a.type='group' 
ORDER BY a.code

[getChildNodes]
SELECT a.*
FROM account a 
WHERE a.parentid=$P{objid} and a.type='group'
ORDER BY a.code

[getList]
SELECT * FROM account WHERE parentid=$P{objid} ORDER BY code

[lookupAccount]
SELECT * FROM account WHERE type=$P{type} ORDER BY code

[changeState-approved]
UPDATE account SET state='APPROVED' WHERE objid=$P{objid} 