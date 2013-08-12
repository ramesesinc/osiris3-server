[getRootNodes]
SELECT so.name as caption, so.*, oc.childnodes 
FROM sys_org so
INNER JOIN sys_orgclass oc ON so.orgclass=oc.name 
WHERE so.parentid IS NULL 

[getChildNodes]
SELECT so.name as caption, so.*, oc.childnodes 
FROM sys_org so
INNER JOIN sys_orgclass oc ON so.orgclass=oc.name 
WHERE so.parentid =$P{parentid} AND so.orgclass=$P{orgclass} 

[getChildClasses]
SELECT * FROM sys_orgclass WHERE name IN ( ${filter} )


[getOrgClasses]
SELECT * FROM sys_orgclass

[getList]
SELECT * FROM sys_org WHERE orgclass IN (${orgclasses}) AND parentid=$P{parentid} order by name 

[getLookup]
SELECT * FROM sys_org WHERE orgclass=$P{orgclass} 

[getRoot]
SELECT * FROM sys_org WHERE parentid IS NULL 

[getInfo]
SELECT * FROM sys_org WHERE name=$P{name} 
