[getList]
SELECT * FROM sys_user su WHERE name LIKE $P{name} 

[changeState-approved]
UPDATE sys_user SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT' 

[getUsergroups]
SELECT 
	ugm.objid, ugm.org_objid, ugm.org_name, ugm.org_orgclass, 
	sg.objid AS securitygroup_objid, sg.name AS securitygroup_name, 
	ug.objid AS usergroup_objid, ug.title AS usergroup_title  
FROM sys_usergroup_member ugm 
	INNER JOIN sys_securitygroup sg ON ugm.securitygroupid=sg.objid AND ugm.usergroupid=sg.usergroupid 
	INNER JOIN sys_usergroup ug ON sg.usergroupid=ug.objid 
WHERE ugm.user_objid=$P{userid}  
