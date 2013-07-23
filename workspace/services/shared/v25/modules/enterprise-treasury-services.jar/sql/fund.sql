[getList]
SELECT * FROM fund 
WHERE fund LIKE $P{fund}
	OR fundname LIKE $P{fundname}
ORDER BY fundname

[getById]
SELECT * FROM fund WHERE objid = $P{objid}

[getFund]
SELECT fund FROM fund

[checkDuplicateFund]
SELECT COUNT(*) AS count 
FROM fund 
WHERE objid <> $P{objid}
  AND fund = $P{fund}

[checkReferencedId]
SELECT * FROM incomeaccount WHERE fundid = $P{fundid}

[getFundsWithBankAccount]
SELECT * FROM fund WHERE bankacctrequired = 1