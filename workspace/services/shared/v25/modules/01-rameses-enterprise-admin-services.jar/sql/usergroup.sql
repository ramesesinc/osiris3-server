[getRootNodes]
SELECT DISTINCT 
	ug.domain as caption, ug.domain as domain, '' as usergroupid, 'domain' as filetype 
FROM sys_usergroup ug 
	LEFT JOIN sys_usergroup_admin uga ON ug.objid=uga.usergroupid 
WHERE 
	(uga.user_objid=$P{userid} OR 'root'=$P{userid} OR 'sa'=$P{userid}) 


[getChildNodes]
SELECT DISTINCT 
	ug.title as caption, ug.domain as domain, ug.objid as usergroupid, 
	'usergroup-folder' as filetype, ug.orgclass 
FROM sys_usergroup ug 
	LEFT JOIN sys_usergroup_admin uga ON ug.objid=uga.usergroupid 
WHERE 
	ug.domain=$P{domain} AND 
	(uga.user_objid=$P{userid} OR 'root'=$P{userid} OR 'sa'=$P{userid}) 

[getList]
SELECT DISTINCT 
	ugm.objid, ugm.user_username, ugm.user_lastname, ugm.user_firstname, 
	ugm.org_name, sg.name AS securitygroup 
FROM sys_usergroup ug 
	INNER JOIN sys_usergroup_member ugm ON ug.objid=ugm.usergroupid ${usergroupfilter} 
	INNER JOIN sys_securitygroup sg ON ugm.securitygroupid=sg.objid 
	LEFT JOIN sys_usergroup_admin uga ON ugm.usergroupid=uga.usergroupid 
WHERE 
	ug.domain=$P{domain} AND 
	(uga.user_objid=$P{userid} OR 'root'=$P{userid} OR 'sa'=$P{userid}) 	
ORDER BY 
	ugm.user_lastname, ugm.user_firstname 

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

[changeState-approved]
UPDATE sys_usergroup_member SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT' 