[getRootNodes]
SELECT * FROM account WHERE parentid IS NULL

[getChildNodes]
SELECT * FROM account WHERE parentid=$P{objid}
