[getInfo]
SELECT * FROM sys_user where username=$P{username}  

[getInfoByPrimaryKey]
SELECT * FROM sys_user where objid=$P{objid}  

[incrementLoginCount]
update sys_user set 
	pwdlogincount=$P{pwdlogincount}+1 
where 
	username=$P{username} and pwdlogincount=$P{pwdlogincount} 

[updateLock]
update sys_user set lockid=$P{lockid} where username=$P{username} 

[getPermissions]
SELECT  
	ug.domain, um.usergroupid AS role, 
	sg.exclude AS security_exclude, um.exclude AS custom_exclude  
FROM sys_usergroup_member um 
	INNER JOIN sys_usergroup ug ON um.usergroupid = ug.objid 
	INNER JOIN sys_user u ON um.user_objid = u.objid 
	INNER JOIN sys_securitygroup sg ON um.securitygroupid=sg.objid 
WHERE u.objid = $P{userid} AND um.org_objid IS NULL 	

[getPermissionsByOrg]
SELECT  
	ug.domain, um.usergroupid AS role, 
	sg.exclude AS security_exclude, um.exclude AS custom_exclude  
FROM sys_usergroup_member um  
	INNER JOIN sys_usergroup ug ON um.usergroupid = ug.objid 
	INNER JOIN sys_user u ON um.user_objid = u.objid 
	INNER JOIN sys_securitygroup sg ON um.securitygroupid=sg.objid 
	INNER JOIN sys_org o ON um.org_objid=o.objid 
WHERE u.objid = $P{userid} AND o.name = $P{orgname} 
