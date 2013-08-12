[getList]
SELECT * 
FROM sys_securitygroup sg
WHERE sg.usergroupid = $P{usergroupid}

[getUserGroupPermissions]
SELECT * FROM sys_usergroup_permission WHERE usergroupid=$P{usergroupid} 
 
 
[getSecurityGroupPermissions]
SELECT p.*,sg.exclude FROM sys_securitygroup sg
INNER JOIN sys_usergroup_permission p ON sg.usergroupid=p.usergroupid
WHERE sg.objid = $P{objid}  
