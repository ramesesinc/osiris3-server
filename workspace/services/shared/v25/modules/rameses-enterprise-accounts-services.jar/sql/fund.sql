[getRootNodes]
SELECT a.* 
FROM fund a 
WHERE a.parentid IS NULL 

[getChildNodes]
SELECT a.*
FROM fund a 
WHERE a.parentid=$P{objid} and a.type='group'

[getList]
SELECT *,'fund' AS filetype 
FROM fund 
# -- WHERE parentid=$P{objid}

[changeState-approved]
UPDATE fund SET state='APPROVED' WHERE objid=$P{objid} 