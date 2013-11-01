[getList]
SELECT 
ugm.user_objid as objid, 
ugm.user_username as username, 
ugm.user_lastname as lastname,
ugm.user_firstname as firstname,
ugm.jobtitle as title,
ugm.jobtitle 
FROM sys_usergroup_member ugm 
INNER JOIN sys_usergroup ug ON ugm.usergroupid=ug.objid
WHERE ug.role = 'COLLECTOR'


[getUserTxnCode]
SELECT ugm.usertxncode 
FROM sys_usergroup_member ugm 
INNER JOIN sys_usergroup ug ON ugm.usergroupid=ug.objid
WHERE ugm.user_objid = $P{userid}
AND ug.role = 'COLLECTOR'

[findUserTxnCode]
SELECT ugm.usertxncode 
FROM sys_usergroup_member ugm 
INNER JOIN sys_usergroup ug ON ugm.usergroupid=ug.objid
WHERE ugm.user_objid = $P{userid}
AND ug.role = 'COLLECTOR'

[findCollector]
SELECT 
ugm.user_objid as objid, 
ugm.user_username as username, 
ugm.user_lastname as lastname,
ugm.user_firstname as firstname,
ugm.jobtitle as title
FROM sys_usergroup_member ugm
INNER JOIN sys_usergroup ug ON ugm.usergroupid=ug.objid
WHERE ugm.user_objid = $P{userid}
AND ug.role = 'COLLECTOR'

[findSubCollector]
SELECT 
ugm.user_objid as objid, 
ugm.user_username as username, 
ugm.user_lastname as lastname,
ugm.user_firstname as firstname,
ugm.jobtitle as title
FROM sys_usergroup_member ugm
INNER JOIN sys_usergroup ug ON ugm.usergroupid=ug.objid
WHERE ugm.user_objid = $P{userid}
AND ug.role = 'SUBCOLLECTOR' 
