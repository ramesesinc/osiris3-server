[updateRemittanceAF]
UPDATE afserial_inventory_detail ad, afserial_inventory ai
SET ad.remittanceid = $P{remittanceid}
WHERE ad.controlid = ai.objid
AND ad.remittanceid IS NULL 
AND ai.respcenter_objid = $P{collectorid}

[updateRemittanceCashTicket]
UPDATE cashticket_inventory_detail ad, cashticket_inventory ai
SET ad.remittanceid = $P{remittanceid}
WHERE ad.controlid = ai.objid
AND ad.remittanceid IS NULL 
AND ai.respcenter_objid = $P{collectorid}

[getRemittanceForBalanceForward]
SELECT 
controlid,
MAX(ad.endingstartseries) AS startseries,
MAX(ad.endingendseries) AS endseries
FROM afserial_inventory_detail ad 
WHERE ad.remittanceid = $P{remittanceid}
GROUP BY ad.controlid

[getCashTicketRemittanceForBalanceForward]
SELECT controlid, (SUM(qtyreceived)+SUM(qtybegin)-SUM(qtyissued)-SUM(qtycancelled)) AS qty
FROM cashticket_inventory_detail 
WHERE remittanceid=$P{remittanceid}
GROUP BY controlid


[getRemittedAFSerial]
SELECT a.*, 
    (a.receivedendseries-a.receivedstartseries+1) AS qtyreceived,
    (a.beginendseries-a.beginstartseries+1) AS qtybegin,
    (a.issuedendseries-a.issuedstartseries+1) AS qtyissued,
    (a.endingendseries-a.endingstartseries+1) AS qtyending
FROM
(SELECT 
   ai.afid AS formno,		
   MIN( ad.receivedstartseries ) AS receivedstartseries,
   MAX( ad.receivedendseries ) AS receivedendseries,
   MAX( ad.beginstartseries ) AS beginstartseries,
   MAX( ad.beginendseries ) AS beginendseries,
   MAX( ad.issuedstartseries ) AS issuedstartseries,
   MAX( ad.issuedendseries ) AS issuedendseries,
   MAX( ad.endingstartseries ) AS endingstartseries,
   MAX( ad.endingendseries ) AS endingendseries
FROM afserial_inventory_detail ad 
INNER JOIN afserial_inventory ai ON ad.controlid=ai.objid
WHERE ad.remittanceid = $P{objid}
GROUP BY ai.afid, ad.controlid) a

[getRemittedCashTickets]
SELECT a.*, 
    a.qtyreceived+a.qtybegin-a.qtyissued-a.qtycancelled AS qtyending
FROM
(SELECT 
   ai.afid AS formno,   
   SUM( ad.qtyreceived ) AS qtyreceived,
   SUM( ad.qtybegin ) AS qtybegin,
   SUM( ad.qtyissued ) AS qtyissued,
   SUM( ad.qtycancelled ) AS qtycancelled
FROM cashticket_inventory_detail ad 
INNER JOIN cashticket_inventory ai ON ad.controlid=ai.objid
WHERE ad.remittanceid = $P{objid}
GROUP BY ai.afid) a


[collectAFControl]
INSERT INTO remittance_af (objid, remittanceid)
SELECT ad.objid, $P{remittanceid} 
FROM afcontrol_activedetail av 
INNER JOIN afcontrol_detail ad ON ad.objid=av.detailid 
WHERE ad.collector_objid = $P{collectorid} 

[getRemittedAFControlIdsForPosting]
SELECT av.controlid 
FROM afcontrol_activedetail av 
INNER JOIN afcontrol_detail ad ON ad.objid=av.detailid 
WHERE ad.collector_objid = $P{collectorid}

[getSummary]
SELECT af.af, af.stub, min(receiptno), max(receiptno),
  SUM(CASE WHEN v.objid IS NULL THEN c.amount ELSE 0 END) AS summary 
FROM cashreceipt c 
INNER JOIN afcontrol af ON c.controlid=af.objid
LEFT JOIN remittanceitem r ON c.objid=r.receiptid
LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE r.receiptid IS NULL
AND c.collector_objid = $P{collectorid}
GROUP by af.af, af.stub 