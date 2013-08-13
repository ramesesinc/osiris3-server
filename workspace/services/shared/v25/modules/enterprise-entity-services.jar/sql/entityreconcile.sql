[getListForReconcile] 
SELECT * FROM entity 
WHERE name LIKE $P{name} 
  AND objid <> $P{entityid} 
ORDER BY name 

[deleteEntityMember]
DELETE FROM entitymember WHERE entityid = $P{entityid}

[deleteEntity]
DELETE FROM entity WHERE objid = $P{objid} 

[insertReconciledEntity]
INSERT INTO reconciledentity
	(entityid, reconciledentityid, entity )
VALUES
	($P{entityid}, $P{reconciledentityid}, $P{entity})



#----------------------------------
# BPAPPLICATION
#----------------------------------
[getBPApplicationByTaxpayer]
SELECT objid, info, businessid 
FROM bpapplication 
WHERE taxpayerid = $P{taxpayerid}

[updateBPApplicationTaxpayerInfo]
UPDATE bpapplication SET
	taxpayerid = $P{taxpayerid},
	info = $P{info}
WHERE objid = $P{objid}	

[updateBPApplicationListing]
UPDATE bpapplicationlisting SET
	taxpayerid = $P{taxpayerid},
	taxpayername = $P{taxpayername},
	taxpayeraddress = $P{taxpayeraddress}
WHERE objid  = $P{appid}	

[updateBusinessInfo]
UPDATE business SET
	taxpayerid = $P{taxpayerid},
	taxpayername = $P{taxpayername},
	taxpayeraddress = $P{taxpayeraddress}
WHERE objid  = $P{businessid}	

[updateBPPermitInfo]
UPDATE bppermit SET
	taxpayerid = $P{taxpayerid},
	taxpayername = $P{taxpayername},
	taxpayeraddress = $P{taxpayeraddress}
WHERE objid  = $P{appid}	


#----------------------------------
# FAAS 
#----------------------------------
[getFaasListByTaxpayer]
SELECT objid 
FROM faaslist 
WHERE taxpayerid = $P{taxpayerid}

[updateFaasListTaxpayerInfo]
UPDATE faaslist SET
	taxpayerid = $P{taxpayerid},
	taxpayername = $P{taxpayername},
	taxpayeraddress = $P{taxpayeraddress},
	taxpayerno = $P{taxpayerno}
WHERE objid = $P{faasid}	

[updateRPTLedgerTaxpayerInfo]
UPDATE rptledger SET
	taxpayerid = $P{taxpayerid},
	taxpayername = $P{taxpayername},
	taxpayeraddress = $P{taxpayeraddress},
	taxpayerno = $P{taxpayerno}
WHERE faasid = $P{faasid}	


[getFaasById]
SELECT info 
FROM faas 
WHERE objid = $P{faasid} 

[updateFaasInfo]
UPDATE faas SET 
	info = $P{info}
WHERE objid = $P{faasid}	



#----------------------------------
# RECEIPT
#----------------------------------
[getReceiptByTaxpayer]
SELECT objid 
FROM receiptlist 
WHERE payorid = $P{taxpayerid}

[updateReceiptPayorInfo]
UPDATE bpapplication SET
	taxpayerid = $P{taxpayerid},
	info = $P{info}
WHERE objid = $P{objid}	
