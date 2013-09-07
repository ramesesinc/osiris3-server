[getList]
SELECT * FROM sys_operator 

[getAll]
SELECT * FROM sys_operator 

[getSymbols]
SELECT * FROM sys_operator_item 
WHERE operator=$P{operator} 
ORDER BY sortorder 
