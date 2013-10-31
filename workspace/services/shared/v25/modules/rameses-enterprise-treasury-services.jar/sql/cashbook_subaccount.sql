[getList]
SELECT 
ugm.user_objid as objid, 
ugm.user_username as username, 
ugm.user_lastname as lastname,
ugm.user_firstname as firstname,
ug.role as subaccttype,
ugm.org_name,
ugm.jobtitle as title
FROM sys_usergroup_member ugm
INNER JOIN sys_usergroup ug ON ug.objid=ugm.usergroupid
WHERE ugm.user_lastname LIKE $P{searchtext}
AND ug.role IN ('COLLECTOR', 'LIQUIDATING_OFFICER', 'CASHIER')