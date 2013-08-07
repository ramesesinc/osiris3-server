[getRootNodesForAdmin]
SELECT DISTINCT ug.domain as caption, ug.domain as domain, '' as usergroupid, 'domain' as filetype
FROM sys_usergroup ug
LEFT JOIN sys_usergroup_admin uga ON ug.objid=uga.usergroupid
WHERE (uga.user_objid =  $P{userid} OR 'root' = $P{userid} OR 'sa' = $P{userid})

[getChildNodesForAdmin]
SELECT ug.title as caption, ug.domain as domain, ug.objid as usergroupid, 'usergroup-folder' as filetype, ug.orgclass
FROM sys_usergroup ug
LEFT JOIN sys_usergroup_admin uga ON ug.objid=uga.usergroupid
WHERE ( uga.user_objid = $P{userid} OR 'root' = $P{userid} OR 'sa' = $P{userid} )
AND ug.domain=$P{domain}


[getList]
SELECT ugm.objid, ugm.user_username, ugm.user_lastname, ugm.user_firstname, sg.name AS securitygroup, ugm.org_name
FROM sys_usergroup_member ugm
INNER JOIN sys_securitygroup sg ON ugm.securitygroupid=sg.objid 
LEFT JOIN sys_usergroup_admin uga ON ugm.usergroupid=uga.usergroupid
WHERE ugm.usergroupid=$P{usergroupid}
AND ( uga.user_objid = $P{userid} OR 'root' = $P{userid} OR 'sa' = $P{userid} )


[getAdminList]
SELECT uga.* FROM sys_usergroup_admin uga
WHERE uga.usergroupid=$P{usergroupid}

[search]
SELECT ugm.objid, su.username, su.name, sg.name AS securitygroup, so.name as org
FROM sys_usergroup_member ugm
INNER JOIN sys_user su ON su.objid=ugm.user_objid
INNER JOIN sys_securitygroup sg ON ugm.securitygroupid=sg.objid 
LEFT JOIN sys_org so ON ugm.orgid=so.objid
WHERE su.name like $P{name}  

 