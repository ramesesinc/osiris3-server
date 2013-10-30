[getList]
SELECT a.* FROM 
(SELECT objid,username,lastname,firstname,middlename,jobtitle,state FROM sys_user u WHERE u.lastname LIKE $P{searchtext} 
UNION 
SELECT objid,username,lastname,firstname,middlename,jobtitle,state FROM sys_user u WHERE u.firstname LIKE $P{searchtext} 
UNION 
SELECT objid,username,lastname,firstname,middlename,jobtitle,state FROM sys_user u WHERE u.username LIKE $P{searchtext} 
) AS a 
ORDER BY a.lastname, a.firstname

[approve]
UPDATE sys_user SET state='APPROVED' 
WHERE objid=$P{objid} 

[getUsergroups]
SELECT 
	ugm.objid, ugm.org_objid, ugm.org_name, ugm.org_orgclass, ug.domain, ug.role, 
	sg.objid AS securitygroup_objid, sg.name AS securitygroup_name, 
	ug.objid AS usergroup_objid, ug.title AS usergroup_title  
FROM sys_usergroup_member ugm 
	INNER JOIN sys_usergroup ug ON ugm.usergroupid=ug.objid 
	LEFT JOIN sys_securitygroup sg ON ugm.securitygroupid=sg.objid AND ugm.usergroupid=sg.usergroupid 
WHERE ugm.user_objid=$P{objid}  
 
