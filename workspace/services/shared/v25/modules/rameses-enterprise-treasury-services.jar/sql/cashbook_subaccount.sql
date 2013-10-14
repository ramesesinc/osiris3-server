[getList]
SELECT 
user_objid as objid, 
user_username as username, 
user_lastname as lastname,
user_firstname as firstname,
usergroupid as subaccttype,
org_name,
jobtitle as title
FROM sys_usergroup_member 
WHERE user_lastname LIKE $P{searchtext}
  AND usergroupid IN ('COLLECTOR', 'LIQUIDATING_OFFICER', 'CASHIER')