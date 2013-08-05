[getList]
SELECT * 
FROM sys_securitygroup sg
WHERE sg.usergroupid = $P{usergroupid}

[getUserGroupPermissions]
SELECT * FROM sys_usergroup_permission WHERE usergroupid=$P{usergroupid} 
 
 
 