[getList]
SELECT 
user_objid as objid, 
user_username as username, 
user_lastname as lastname,
user_firstname as firstname,
usergroupid as subaccttype,
jobtitle as title
FROM sys_usergroup_member 
WHERE usergroupid IN ('COLLECTOR', 'LIQUIDATING_OFFICER', 'CASHIER')