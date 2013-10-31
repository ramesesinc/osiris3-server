[getList]
SELECT 
ugm.user_objid as objid, 
ugm.user_username as username, 
ugm.user_lastname as lastname,
ugm.user_firstname as firstname,
ugm.jobtitle as title
FROM sys_usergroup_member ugm
INNER JOIN sys_usergroup ug ON ug.objid=ugm.usergroupid
WHERE ug.role = 'LIQUIDATING_OFFICER'


[getUserTxnCode]
SELECT ugm.usertxncode 
FROM sys_usergroup_member ugm 
INNER JOIN sys_usergroup ug ON ug.objid=ugm.usergroupid
WHERE ugm.user_objid = $P{userid}
AND ug.role = 'LIQUIDATING_OFFICER'

[findUserTxnCode]
SELECT ugm.usertxncode 
FROM sys_usergroup_member ugm 
WHERE ugm.user_objid = $P{userid}
INNER JOIN sys_usergroup ug ON ug.objid=ugm.usergroupid
AND ug.role = 'LIQUIDATING_OFFICER'