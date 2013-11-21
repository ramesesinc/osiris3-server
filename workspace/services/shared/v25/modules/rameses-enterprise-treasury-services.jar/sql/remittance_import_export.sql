[findRemittanceByid]
SELECT * FROM remittance WHERE objid = $P{remittanceid}

[findRemittanceAfSerial]
SELECT objid FROM remittance_afserial WHERE objid = $P{objid}

[getRemittanceAfSerials]
SELECT * FROM remittance_afserial WHERE remittanceid = $P{remittanceid}

[getRemittanceCashReceipts]
SELECT * FROM remittance_cashreceipt WHERE remittanceid = $P{remittanceid}

[getRemittanceCashTickets]
SELECT * FROM remittance_cashticket WHERE remittanceid =  $P{remittanceid}

[getRemittanceCheckPayments]
SELECT * FROM remittance_checkpayment WHERE remittanceid = $P{remittanceid}

[getRemittanceFunds]
SELECT * FROM remittance_fund WHERE remittanceid = $P{remittanceid}



[getUniqueAfSerialControls]
SELECT DISTINCT aid.controlid, raf.remittanceid
FROM remittance_afserial raf 
  INNER JOIN afserial_inventory_detail aid ON raf.objid = aid.objid 
WHERE raf.remittanceid = $P{remittanceid} 


[getUniqueCashTicketControls]
SELECT DISTINCT cid.controlid, rct.remittanceid 
FROM remittance_cashticket rct
  INNER JOIN cashticket_inventory_detail cid ON rct.objid = cid.objid 
WHERE rct.remittanceid = $P{remittanceid} 


[findAfSerialControl]
SELECT * FROM afserial_control WHERE controlid = $P{controlid}

[findAFSerialInventory]
SELECT * FROM afserial_inventory WHERE objid = $P{controlid}

[getAFSerialInventoryDetails]
SELECT * FROM afserial_inventory_detail WHERE objid = $P{objid}



[getCashReceipts]
SELECT cr.* 
FROM remittance_cashreceipt remcr  
	INNER JOIN cashreceipt cr ON cr.objid = remcr.objid 
WHERE remcr.remittanceid = $P{remittanceid}	

[getCashReceiptItems]
SELECT cri.* 
FROM remittance_cashreceipt remcr  
	INNER JOIN cashreceipt cr ON cr.objid = remcr.objid 
	INNER JOIN cashreceiptitem cri ON cr.objid = cri.receiptid
WHERE remcr.remittanceid = $P{remittanceid}	


[getCashReceiptCheckPayments]
SELECT cp.* 
FROM remittance_cashreceipt remcr  
	INNER JOIN cashreceipt cr ON cr.objid = remcr.objid
	INNER JOIN cashreceiptpayment_check cp ON cr.objid = cp.receiptid 
WHERE remcr.remittanceid = $P{remittanceid}	


[getVoidedReceipts]
SELECT cv.* 
FROM remittance_cashreceipt remcr  
	INNER JOIN cashreceipt_void cv ON remcr.objid = cv.receiptid
WHERE remcr.remittanceid = $P{remittanceid}	


[findCashTicketInventory]
SELECT * FROM cashticket_inventory WHERE objid = $P{controlid}

[findCashTicketControl]
SELECT * FROM cashticket_control WHERE controlid = $P{controlid}

[getCashTicketInventoryDetails]
SELECT * FROM cashticket_inventory_detail WHERE objid = $P{objid} 






#===============================================================
#
# IMPORT SUPPORT 
#
#===============================================================
[insertRemittance]
INSERT INTO remittance(
  objid
  ,state
  ,txnno
  ,dtposted
  ,collector_objid
  ,collector_name
  ,collector_title
  ,liquidatingofficer_objid
  ,liquidatingofficer_name
  ,liquidatingofficer_title
  ,amount
  ,totalcash
  ,totalnoncash
  ,cashbreakdown
)  
VALUES (
  $P{objid}
  ,$P{state}
  ,$P{txnno}
  ,$P{dtposted}
  ,$P{collector_objid}
  ,$P{collector_name}
  ,$P{collector_title}
  ,$P{liquidatingofficer_objid}
  ,$P{liquidatingofficer_name}
  ,$P{liquidatingofficer_title}
  ,$P{amount}
  ,$P{totalcash}
  ,$P{totalnoncash}
  ,$P{cashbreakdown}
)


[insertRemittanceAfSerial]
INSERT INTO remittance_afserial(
  objid
  ,remittanceid
)
VALUES(
  $P{objid}
  ,$P{remittanceid}
)


[insertRemittanceCashReceipt]
INSERT INTO remittance_cashreceipt(
  objid
  ,remittanceid
)
VALUES(
  $P{objid}
  ,$P{remittanceid}
)


[insertRemittanceCashTicket]
INSERT INTO remittance_cashticket(
  objid
  ,remittanceid
)
VALUES(
  $P{objid}
  ,$P{remittanceid}
)


[insertRemittanceCheck]
INSERT INTO remittance_checkpayment(
  objid
  ,remittanceid
  ,amount
  ,voided
)
VALUES (
  $P{objid}
  ,$P{remittanceid}
  ,$P{amount}
  ,$P{voided}
)


[insertRemittanceFund]
INSERT INTO remittance_fund(
  objid
 ,remittanceid
 ,fund_objid
 ,fund_title
 ,amount
)
VALUES(
 $P{objid}
 ,$P{remittanceid}
 ,$P{fund_objid}
 ,$P{fund_title}
 ,$P{amount}
)



[updateAFSerialControl]
UPDATE afserial_control SET 
   currentseries = $P{currentseries}
  ,qtyissued = $P{qtyissued}
  ,active = $P{active}
 WHERE controlid = $P{controlid} 


[updateAfSerialInventory]
UPDATE afserial_inventory SET 
	 startseries = $P{startseries}
	,endseries = $P{endseries}
	,currentseries = $P{currentseries}
	,qtyin = $P{qtyin}
	,qtyout = $P{qtyout}
	,qtycancelled = $P{qtycancelled}
	,qtybalance = $P{qtybalance}
	,currentlineno = $P{currentlineno}
 WHERE objid = $P{objid}


[insertAfSerialInventoryDetail]
INSERT INTO afserial_inventory_detail(
       objid
      ,controlid
      ,[lineno]
      ,refid
      ,refno
      ,reftype
      ,refdate
      ,txndate
      ,txntype
      ,receivedstartseries
      ,receivedendseries
      ,beginstartseries
      ,beginendseries
      ,issuedstartseries
      ,issuedendseries
      ,endingstartseries
      ,endingendseries
      ,cancelledstartseries
      ,cancelledendseries
      ,qtyreceived
      ,qtybegin
      ,qtyissued
      ,qtyending
      ,qtycancelled
      ,remarks
)
VALUES (
       $P{objid}
      ,$P{controlid}
      ,$P{lineno}
      ,$P{refid}
      ,$P{refno}
      ,$P{reftype}
      ,$P{refdate}
      ,$P{txndate}
      ,$P{txntype}
      ,$P{receivedstartseries}
      ,$P{receivedendseries}
      ,$P{beginstartseries}
      ,$P{beginendseries}
      ,$P{issuedstartseries}
      ,$P{issuedendseries}
      ,$P{endingstartseries}
      ,$P{endingendseries}
      ,$P{cancelledstartseries}
      ,$P{cancelledendseries}
      ,$P{qtyreceived}
      ,$P{qtybegin}
      ,$P{qtyissued}
      ,$P{qtyending}
      ,$P{qtycancelled}
      ,$P{remarks}
)



[insertCashReceipt]
INSERT INTO cashreceipt (
  objid
  ,state
  ,txndate
  ,receiptno
  ,receiptdate
  ,txnmode
  ,payer_objid
  ,payer_name
  ,paidby
  ,paidbyaddress
  ,amount
  ,collector_objid
  ,collector_name
  ,collector_title
  ,totalcash
  ,totalnoncash
  ,cashchange
  ,totalcredit
  ,org_objid
  ,org_name
  ,formno
  ,series
  ,controlid
  ,collectiontype_objid
  ,collectiontype_name
  ,user_objid
  ,user_name
  ,remarks
  ,subcollector_objid
  ,subcollector_name
  ,subcollector_title
  ,formtype
  ,stub
)
VALUES (
   $P{objid}
  ,$P{state}
  ,$P{txndate}
  ,$P{receiptno}
  ,$P{receiptdate}
  ,$P{txnmode}
  ,$P{payer_objid}
  ,$P{payer_name}
  ,$P{paidby}
  ,$P{paidbyaddress}
  ,$P{amount}
  ,$P{collector_objid}
  ,$P{collector_name}
  ,$P{collector_title}
  ,$P{totalcash}
  ,$P{totalnoncash}
  ,$P{cashchange}
  ,$P{totalcredit}
  ,$P{org_objid}
  ,$P{org_name}
  ,$P{formno}
  ,$P{series}
  ,$P{controlid}
  ,$P{collectiontype_objid}
  ,$P{collectiontype_name}
  ,$P{user_objid}
  ,$P{user_name}
  ,$P{remarks}
  ,$P{subcollector_objid}
  ,$P{subcollector_name}
  ,$P{subcollector_title}
  ,$P{formtype}
  ,$P{stub}
)


[insertCashReceiptItem]
INSERT INTO cashreceiptitem(
  objid
  ,receiptid
  ,item_objid
  ,item_code
  ,item_title
  ,amount
  ,remarks
)
VALUES(
  $P{objid}
  ,$P{receiptid}
  ,$P{item_objid}
  ,$P{item_code}
  ,$P{item_title}
  ,$P{amount}
  ,$P{remarks}
)


[insertCheckPayment]
INSERT INTO cashreceiptpayment_check(
  objid
  ,receiptid
  ,bank
  ,checkno
  ,checkdate
  ,amount
  ,particulars
)
VALUES(
   $P{objid}
  ,$P{receiptid}
  ,$P{bank}
  ,$P{checkno}
  ,$P{checkdate}
  ,$P{amount}
  ,$P{particulars}
)



[insertVoidReceipt]
INSERT INTO cashreceipt_void(
  objid
  ,receiptid
  ,txndate
  ,postedby_objid
  ,postedby_name
  ,reason
)
VALUES (
   $P{objid}
  ,$P{receiptid}
  ,$P{txndate}
  ,$P{postedby_objid}
  ,$P{postedby_name}
  ,$P{reason}
)





[updateCashTicketInventory]
UPDATE cashticket_inventory SET 
       qtyout = $P{qtyout}
      ,qtycancelled = $P{qtycancelled}
      ,qtybalance = $P{qtybalance}
      ,currentlineno = $P{currentlineno}
 WHERE objid = $P{objid}


[updateCashTicketControl]
UPDATE cashticket_control SET 
      qtyissued = $P{qtyissued}
      ,qtybalance = $P{qtybalance}
 WHERE objid = $P{objid}


[insertCashTicketInventoryDetail]
INSERT INTO cashticket_inventory_detail (
   objid
  ,controlid
  ,[lineno]
  ,refid
  ,refno
  ,reftype
  ,refdate
  ,txndate
  ,txntype
  ,qtyreceived
  ,qtybegin
  ,qtyissued
  ,qtyending
  ,qtycancelled
  ,remarks
  ,remittanceid
)
VALUES (
  $P{objid}
  ,$P{controlid}
  ,$P{lineno}
  ,$P{refid}
  ,$P{refno}
  ,$P{reftype}
  ,$P{refdate}
  ,$P{txndate}
  ,$P{txntype}
  ,$P{qtyreceived}
  ,$P{qtybegin}
  ,$P{qtyissued}
  ,$P{qtyending}
  ,$P{qtycancelled}
  ,$P{remarks}
  ,$P{remittanceid}
)
