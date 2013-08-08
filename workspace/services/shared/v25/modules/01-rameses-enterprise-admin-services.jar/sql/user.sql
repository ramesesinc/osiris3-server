[getList]
SELECT *   
FROM sys_user su
 
[changeState-approved]
UPDATE sys_user SET state='APPROVED' WHERE objid=$P{objid} AND state = 'DRAFT' 
 