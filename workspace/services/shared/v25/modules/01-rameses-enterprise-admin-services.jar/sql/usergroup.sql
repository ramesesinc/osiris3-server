[getRootNodesForAdmin]
SELECT DISTINCT ug.domain as caption, ug.domain as domain, '' as usergroupid, 'domain' as filetype
FROM sys_usergroup ug
INNER JOIN sys_usergroup_admin uga ON ug.objid=uga.usergroupid
WHERE uga.user_objid =  $P{userid}

[getChildNodesForAdmin]
SELECT ug.title as caption, ug.domain as domain, ug.objid as usergroupid, 'usergroup-folder' as filetype, ug.orgclass
FROM sys_usergroup ug
INNER JOIN sys_usergroup_admin uga ON ug.objid=uga.usergroupid
WHERE uga.user_objid = $P{userid} 
AND ug.domain=$P{domain}


[getList]
SELECT ugm.objid, su.username, ugm.user_lastname, ugm.user_firstname, sg.name AS securitygroup, ugm.org_name
FROM sys_usergroup_member ugm
INNER JOIN sys_user su ON su.objid=ugm.user_objid
INNER JOIN sys_securitygroup sg ON ugm.securitygroupid=sg.objid 
WHERE ugm.usergroupid=$P{usergroupid}

 
[getUserGroupPermissions]
SELECT * FROM sys_usergroup_permission WHERE usergroupid=$P{usergroupid} 

[search]
SELECT ugm.objid, su.username, su.name, sg.name AS securitygroup, so.name as org
FROM sys_usergroup_member ugm
INNER JOIN sys_user su ON su.objid=ugm.user_objid
INNER JOIN sys_securitygroup sg ON ugm.securitygroupid=sg.objid 
LEFT JOIN sys_org so ON ugm.orgid=so.objid
WHERE su.name like $P{name}  

 