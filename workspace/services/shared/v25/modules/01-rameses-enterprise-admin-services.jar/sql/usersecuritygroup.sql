[getUsergroups]
SELECT ug.* FROM sys_usergroup ug ORDER BY ug.title 

[getSecuritygroups]
SELECT sg.*, ug.orgclass  
FROM sys_securitygroup sg 
	INNER JOIN sys_usergroup ug ON sg.usergroupid=ug.objid 
WHERE usergroupid=$P{usergroupid} 
ORDER BY sg.name  

[getSecuritygroup]
SELECT * FROM sys_securitygroup 
WHERE objid=$P{objid} AND usergroupid=$P{usergroupid} 

[getOrg]
SELECT o.objid, o.name, o.orgclass FROM sys_org o 
WHERE o.objid=$P{objid} AND o.orgclass=$P{orgclass} 

[getUser]
SELECT u.objid, u.username, u.firstname, u.lastname, u.jobtitle 
FROM sys_user u 
WHERE u.objid=$P{objid}  

[removeMembership]
DELETE FROM sys_usergroup_member WHERE objid=$P{objid} AND user_objid=$P{userid} 