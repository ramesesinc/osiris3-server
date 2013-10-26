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

[getLookup]
SELECT a.* FROM 
(SELECT objid,code,title FROM account t WHERE t.code LIKE $P{searchtext} AND type=$P{type}
UNION
SELECT objid,code,title FROM account t WHERE t.title LIKE $P{searchtext} AND type=$P{type}) AS a
ORDER BY a.title

[approve]
UPDATE account SET state='APPROVED' WHERE objid=$P{objid} 


[getSubaccounts]
SELECT a.* FROM account a WHERE a.parentid=$P{objid} AND a.type='subaccount' ORDER BY a.code