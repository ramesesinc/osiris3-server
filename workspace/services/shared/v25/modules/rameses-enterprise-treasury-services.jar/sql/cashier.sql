[getList]
SELECT 
user_objid as objid, 
user_username as username, 
user_lastname as lastname,
user_firstname as firstname,
jobtitle as title
FROM sys_usergroup_member WHERE usergroupid = 'CASHIER'