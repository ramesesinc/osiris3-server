[getList]
SELECT r.*,
CASE WHEN lr.objid IS NULL THEN 0 ELSE 1 END AS liquidated 
FROM remittance r
LEFT JOIN liquidation_remittance lr ON r.objid=lr.objid
WHERE r.txnno = $P{txnno}
  OR r.collector_name LIKE $P{searchtext} 
ORDER BY r.collector_name, r.txnno DESC 

[getUnremittedForCollector]
SELECT af.af as formno, af.stub as stub, 
  MIN(receiptno) as startseries, 
  MAX(receiptno) as endseries,
  SUM(CASE WHEN v.objid IS NULL THEN c.amount ELSE 0 END) AS amount,
  SUM(CASE WHEN v.objid IS NULL THEN c.totalcash-c.cashchange ELSE 0 END) AS totalcash,
  SUM(CASE WHEN v.objid IS NULL THEN c.totalnoncash ELSE 0 END) AS totalnoncash
FROM cashreceipt c 
INNER JOIN afcontrol af ON c.controlid=af.objid
LEFT JOIN remittance_cashreceipt r ON c.objid=r.objid
LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE r.objid IS NULL
AND c.collector_objid = $P{collectorid}
GROUP by af.af, af.stub , c.collector_objid

[getUnremittedChecks]
SELECT 
crp.objid, crp.checkno, crp.particulars, 
CASE WHEN cv.objid IS NULL THEN crp.amount ELSE 0 END AS amount,
CASE WHEN cv.objid IS NULL THEN 0 ELSE 1 END AS voided
FROM cashreceipt cash 
INNER JOIN cashreceiptpayment_check crp ON crp.receiptid=cash.objid
LEFT JOIN cashreceipt_void cv ON crp.receiptid = cv.receiptid
LEFT JOIN remittance_cashreceipt rc ON rc.objid=cash.objid
WHERE rc.objid IS NULL 
AND cash.collector_objid = $P{collectorid}


[collectReceipts]
INSERT INTO remittance_cashreceipt (objid, remittanceid)
SELECT c.objid, $P{remittanceid} 
FROM cashreceipt c 
LEFT JOIN remittance_cashreceipt r ON c.objid=r.objid
WHERE r.objid IS NULL 
AND c.collector_objid = $P{collectorid}

[collectAFControl]
INSERT INTO remittance_af (objid, remittanceid)
SELECT ad.objid, $P{remittanceid} 
FROM afcontrol_activedetail av 
INNER JOIN afcontrol_detail ad ON ad.objid=av.detailid 
WHERE ad.collector_objid = $P{collectorid} 

[collectChecks]
INSERT INTO remittance_checkpayment (objid, remittanceid, amount, voided )
SELECT 
crp.objid, $P{remittanceid}, crp.amount,   
CASE WHEN cv.objid IS NULL THEN 0 ELSE 1 END AS voided
FROM cashreceipt cash 
INNER JOIN cashreceiptpayment_check crp ON crp.receiptid=cash.objid
LEFT JOIN remittance_cashreceipt rc ON rc.objid=cash.objid
LEFT JOIN cashreceipt_void cv ON crp.receiptid = cv.receiptid
WHERE rc.remittanceid = $P{remittanceid}


[getRemittedAFControlIdsForPosting]
SELECT av.controlid 
FROM afcontrol_activedetail av 
INNER JOIN afcontrol_detail ad ON ad.objid=av.detailid 
WHERE ad.collector_objid = $P{collectorid}

[getRemittedFundTotals]
SELECT cb.fund_objid AS fundid, SUM(( cbe.dr - cbe.cr )) AS amount
FROM remittance_cashreceipt c
LEFT JOIN cashreceipt_void cv ON c.objid = cv.receiptid 
INNER JOIN cashbook_entry cbe ON cbe.refid = c.objid
INNER JOIN cashbook cb ON cb.objid = cbe.parentid
WHERE remittanceid = $P{remittanceid}
AND cv.objid IS NULL
GROUP BY cb.fund_objid

[getRemittedChecks]
SELECT 
   crpc.checkno, crpc.particulars, 
   CASE WHEN rc.voided = 1 THEN 0 ELSE rc.amount END AS amount, 
   rc.voided
FROM remittance_checkpayment rc
INNER JOIN cashreceiptpayment_check crpc ON crpc.objid=rc.objid
WHERE rc.remittanceid  = $P{objid}


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


[getRCDCollectionType]
select  
	formno, min( receiptno) as fromseries, max(receiptno) as toseries, 
	sum( case when crv.objid is null then cr.amount else 0.0 end ) as amount 
from remittance_cashreceipt rc 
   inner join cashreceipt cr on rc.objid = cr.objid 
   left join cashreceipt_void crv on crv.receiptid = cr.objid 
where remittanceid=$P{remittanceid}
group by cr.controlid 


[getRCDCollectionSummaries]
select  
	case 
	    when a.objid in ( '51', '56') and aftype='serial' then CONCAT( 'AF#', a.objid, ': ', ri.fund_title ) 
	    ELSE CONCAT( 'AF#',a.objid, ': ', a.description,' - ', ri.fund_title ) 
	end as particulars, 
	sum( case when crv.objid is null then cri.amount else 0.0 end ) as amount 
from remittance_cashreceipt rc 
   inner join cashreceipt cr on rc.objid = cr.objid 
   left join cashreceipt_void crv on crv.receiptid = cr.objid 
   inner join af a on a.objid = cr.formno 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid
   inner join revenueitem ri on ri.objid = cri.item_objid 
where remittanceid=$P{remittanceid}
group by a.objid, ri.fund_objid 

[getRCDRemittedForms]
select 
  afc.af, 
  case when ad.qtybegin > 0 then concat(ad.qtybegin, '') else '' end as beginqty,
  case when ad.qtybegin > 0 then concat(ad.startseries, '') else '' end as beginfrom,  
  case when ad.qtybegin > 0 then concat(ad.endseries, '') else '' end as beginto,
  case when ad.qtyissued > 0 then concat(ad.startseries, '')   else '' end as issuedfrom, 
  case when ad.qtyissued > 0 then concat(ad.currentseries - 1, '') else '' end as issuedto, 
  case when ad.qtyissued > 0 then concat(ad.qtyissued ,'') else '' end as issuedqty, 
  case when ad.qtyreceived > 0 then concat(ad.startseries, '')   else '' end as receivedfrom, 
  case when ad.qtyreceived > 0 then concat(ad.endseries, '') else '' end as receivedto, 
  case when ad.qtyreceived > 0 then concat(ad.qtyreceived ,'') else '' end as receivedqty, 
  case when ad.qtybalance = 50 then concat(ad.startseries,'')  else concat(ad.currentseries, '') end as endingfrom,
  concat(ad.qtybalance,'') as endingqty,  concat(ad.endseries,'') as endingto 
from remittance_af ra 
   inner join afcontrol_detail ad on ad.objid = ra.objid 
   inner join afcontrol afc on afc.objid = ad.controlid 
where ra.remittanceid=$P{remittanceid}

[getRCDOtherPayment]
select  pc.particulars, pc.amount 
from remittance_cashreceipt rc 
   inner join cashreceipt cr on rc.objid = cr.objid 
   inner join cashreceiptpayment_check pc on pc.receiptid = rc.objid 
   left join cashreceipt_void crv on crv.receiptid = cr.objid 
where remittanceid=$P{remittanceid}
	and crv.objid is null 


[getNonCashPayments]
SELECT cc.*
FROM remittance r
	INNER JOIN remittance_cashreceipt rc ON r.objid = rc.remittanceid
	INNER JOIN cashreceiptpayment_check cc ON rc.objid = cc.receiptid 
WHERE r.objid = $P{remittanceid}
  AND NOT EXISTS(SELECT * FROM cashreceipt_void WHERE receiptid = cc.receiptid)
ORDER BY cc.bank, cc.checkno   
  

[getReceiptsByRemittanceCollectionType]
select 
  cr.formno as afid, cr.receiptno as serialno, cr.txndate, paidby,
  case when cv.objid is null then IFNULL( ct.title, cr.collectiontype_name) else '***VOIDED***' END AS collectiontype, 
  case when cv.objid is null then cr.amount else 0.0 END AS amount
from remittance_cashreceipt rem 
   inner join cashreceipt cr on cr.objid = rem.objid 
   left join cashreceipt_void cv on cv.receiptid = cr.objid 
   left join collectiontype ct on ct.objid = cr.collectiontype_objid 
where rem.remittanceid=$P{remittanceid} and cr.collectiontype_objid  like $P{collectiontypeid}
ORDER BY afid, serialno 

[getReceiptsByRemittanceFund]
select 
  cr.formno as afid, cr.receiptno as serialno, cr.txndate, ri.fund_title as fundname, cr.remarks as remarks, 
  case when cv.objid is null then cr.paidby else '***VOIDED***' END AS payer,
  case when cv.objid is null then cri.item_title else '***VOIDED***' END AS particulars,
  case when cv.objid is null then cr.paidbyaddress else '' END AS payeraddress,
  case when cv.objid is null then cri.amount else 0.0 END AS amount
from remittance_cashreceipt rem 
   inner join cashreceipt cr on cr.objid = rem.objid 
   left join cashreceipt_void cv on cv.receiptid = cr.objid 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid 
   inner join revenueitem ri on ri.objid = cri.item_objid
where rem.remittanceid=$P{remittanceid} and ri.fund_objid like $P{fundid}
ORDER BY afid, serialno, payer 


[getRevenueItemSummaryByFund]
select 
  ri.fund_title as fundname, cri.item_objid as acctid, cri.item_title as acctname,
  sum( cri.amount ) as amount 
from remittance_cashreceipt rem 
   inner join cashreceipt cr on cr.objid = rem.objid 
   left join cashreceipt_void cv on cv.receiptid = cr.objid 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid 
   inner join revenueitem ri on ri.objid = cri.item_objid
where rem.remittanceid=$P{remittanceid} 
  and ri.fund_objid like $P{fundid} and cv.objid is null 
group by fundname, acctid, acctname 
order by fundname, acctname 
