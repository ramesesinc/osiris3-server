[getList]
SELECT * FROM itemaccountgroup 

[getReference]
SELECT accttitle FROM incomeaccount 
WHERE objid = $P{groupid} 
