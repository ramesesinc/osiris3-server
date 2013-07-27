[getById] 
SELECT * FROM itemaccount WHERE objid = $P{objid}

[getList]
SELECT * FROM itemaccount 
WHERE accttitle LIKE $P{accttitle}
ORDER BY accttitle   


[getItemAccountList]
SELECT objid AS acctid, acctcode, accttitle, fundid, defaultvalue, valuetype
FROM itemaccount 
WHERE state = 'APPROVED' 
	AND accttitle LIKE $P{accttitle}
ORDER BY accttitle 


[getFundList]
SELECT * FROM fund WHERE state = 'APPROVED'
ORDER BY fundname

[getFundId]
SELECT objid FROM fund WHERE fundname = $P{fundname}

[getFundById]
SELECT * FROM fund WHERE objid = $P{fundid}

[getItemAcctGroupById]
SELECT * FROM incomeaccountgroup WHERE objid = $P{incomeacctgroupid}

[checkReferencedId]
SELECT COUNT(*) AS count FROM receiptitem WHERE acctid = $P{acctid}


/*** REPORT SQL ***/

[getNGASData]
SELECT 
	CONCAT( COALESCE(p2.acctcode, ''), ' - ' , COALESCE(p2.accttitle,'UNMAPPED') ) as parent2, 
	CONCAT( COALESCE(p1.acctcode, ''), ' - ' , COALESCE(p1.accttitle,'UNMAPPED') ) as parent1, 
	CONCAT( COALESCE(p.acctcode, ''), ' - ' , COALESCE(p.accttitle,'UNMAPPED') ) as parent, 
	CONCAT( COALESCE(ic.acctno, ''), ' - ' , COALESCE(ic.accttitle,'UNMAPPED') ) as account 
FROM incomeaccount ic  
LEFT JOIN account p ON ic.ngasid = p.objid 
LEFT JOIN account p1 ON p.parentid = p1.objid 
LEFT JOIN account p2 ON p1.parentid = p2.objid 
WHERE ic.docstate = 'APPROVED' 
GROUP BY p2.acctcode, p2.accttitle, p1.acctcode, p1.accttitle, p.acctcode, p.accttitle, ic.acctno, ic.accttitle


[getSREData]
SELECT 
	CONCAT( COALESCE(p2.acctcode, ''), '-' , COALESCE(p2.accttitle,'UNMAPPED') ) as parent2, 
	CONCAT( COALESCE(p1.acctcode, ''), '-' , COALESCE(p1.accttitle,'UNMAPPED') ) as parent1, 
	CONCAT( COALESCE(p.acctcode, ''), '-' , COALESCE(p.accttitle,'UNMAPPED') ) as parent, 
	CONCAT( COALESCE(ic.acctno, ''), '-' , COALESCE(ic.accttitle,'UNMAPPED') ) as account 
FROM incomeaccount ic  
LEFT JOIN account p ON ic.sreid = p.objid 
LEFT JOIN account p1 ON p.parentid = p1.objid 
LEFT JOIN account p2 ON p1.parentid = p2.objid 
WHERE ic.docstate = 'APPROVED' 
GROUP BY p2.acctcode, p2.accttitle, p1.acctcode, p1.accttitle, p.acctcode, p.accttitle, ic.acctno, ic.accttitle




[getAccttitleAtRule]
SELECT ruletext  
FROM rule 
WHERE ruletext LIKE $P{acctid} 

