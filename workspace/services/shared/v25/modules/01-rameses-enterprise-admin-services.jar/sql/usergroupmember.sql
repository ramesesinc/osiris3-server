[lookup]
SELECT 
	u.objid, u.lastname, u.firstname, u.middlename, u.jobtitle, 
	ugm.objid as usergroupmemberid, ugm.usergroupid  
FROM sys_usergroup_member ugm 
	INNER JOIN sys_user u ON ugm.user_objid=u.objid 
WHERE ugm.usergroupid=$P{usergroupid} ${filter} 
ORDER BY ugm.user_lastname 

[find]
SELECT * FROM sys_usergroup_member 
WHERE usergroupid=$P{usergroupid} and user_objid=$P{userid}  
