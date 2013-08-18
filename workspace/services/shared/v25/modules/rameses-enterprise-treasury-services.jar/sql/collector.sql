[getList]
SELECT 
user_objid as objid, 
user_username as username, 
user_lastname as lastname,
user_firstname as firstname,
jobtitle
FROM sys_usergroup_member WHERE usergroupid = 'COLLECTOR'


[getUserTxnCode]
SELECT ug.usertxncode 
FROM sys_usergroup_member ug 
WHERE ug.user_objid = $P{userid}
