[getList]
SELECT * FROM bank 
WHERE code = $P{code}
	OR name LIKE $P{name}
ORDER BY name 

[getById]
SELECT * FROM bank WHERE objid = $P{objid} 

[checkDuplicateBank]
SELECT COUNT(*) AS count FROM bank WHERE bankname = $P{bankname} AND branchname = $P{branchname}

[checkIfReferenced]
SELECT COUNT(*) AS count FROM bankaccount WHERE bankid = $P{bankid}
