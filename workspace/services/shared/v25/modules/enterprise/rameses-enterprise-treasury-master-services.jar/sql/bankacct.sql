[getBankAccounts]
SELECT * FROM bankaccount

[getById]
SELECT * FROM bankaccount WHERE objid = $P{objid}

[getFund]
SELECT f.objid AS objid, f.fundname AS fundname 
FROM fund f 
LEFT JOIN bankaccount b ON b.fundid != f.objid 
WHERE f.docstate = 'APPROVED'

[getFundByFundName]
SELECT objid FROM fund WHERE fundname = $P{fundname}

[checkDuplicateBankAccount]
SELECT COUNT(*) AS count 
FROM bankaccount 
WHERE acctno = $P{acctno} 
AND fundid = $P{fundid}

[getList]
SELECT ba.*, f.fundname AS fund, b.code AS bank_code, b.name AS bank_name, b.branchname 
FROM bankaccount ba INNER JOIN fund f ON ba.fundid = f.objid
INNER JOIN bank b ON ba.bankid = b.objid
WHERE acctno LIKE $P{acctno}
	OR b.name LIKE $P{bank_name}
	OR b.code LIKE $P{bank_code}
ORDER BY b.name, acctno 
