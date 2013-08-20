[getRootNodes]
SELECT a.* FROM sreaccount a 
WHERE a.parentid IS NULL and a.type='group' 
ORDER BY a.code 

[getChildNodes]
SELECT a.* FROM sreaccount a 
WHERE a.parentid=$P{objid} and a.type='group' 
ORDER BY a.code 

[getList]
SELECT * FROM sreaccount WHERE parentid=$P{objid} ORDER BY code

[search]
SELECT t.* FROM sreaccount t  
WHERE ${filter} t.parentid IS NOT NULL 
ORDER BY t.title 

[lookup]
SELECT t.* FROM sreaccount t WHERE ${filter} ORDER BY t.title 

[changeState-approved]
UPDATE sreaccount SET state='APPROVED' WHERE objid=$P{objid} 