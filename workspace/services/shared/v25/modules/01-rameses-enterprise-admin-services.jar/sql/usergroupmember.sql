[lookup]
SELECT 
	u.lastname, u.firstname, u.middlename, u.jobtitle, 
	u.objid AS userid, ugm.objid, ugm.usergroupid  
FROM sys_usergroup_member ugm 
	INNER JOIN sys_user u ON ugm.user_objid=u.objid 
WHERE ugm.usergroupid=$P{usergroupid} ${filter} 
ORDER BY ugm.user_lastname 
