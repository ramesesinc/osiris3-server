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

[getSerialReceiptsByRemittanceFund]
select 
  cr.formno as afid, cr.receiptno as serialno, cr.txndate, ri.fund_title as fundname, 
  cr.paidby as payer, cri.item_title as particulars, 
  case when cv.objid is null then cri.amount else 0.0 end as amount 
from remittance_cashreceipt rem 
   inner join cashreceipt cr on cr.objid = rem.objid 
   left join cashreceipt_void cv on cv.receiptid = cr.objid 
   inner join af a on a.objid = cr.formno 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid 
   inner join revenueitem ri on ri.objid = cri.item_objid
where rem.remittanceid=$P{remittanceid}
  and ri.fund_objid like $P{fundid}
  and a.aftype='serial'
ORDER BY afid, particulars, serialno 

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

[getDistinctAccountSRE]
select 
  distinct sre.objid, sre.code as acctcode, sre.title as accttitle 
from remittance_cashreceipt rem 
   inner join cashreceipt cr on cr.objid = rem.objid 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid 
   inner join revenueitem ri on ri.objid = cri.item_objid 
   left join revenueitem_sreaccount rs on rs.objid = ri.objid 
   left join sreaccount sre on sre.objid = rs.acctid 
where rem.remittanceid=$P{remittanceid} 
ORDER BY acctcode

[getSummaryOfCollectionSRE]
select 
  cr.formno as afid, cr.receiptno as serialno, 
  case when crv.objid is null then cr.paidby else '*** VOIDED ***' end as paidby, 
  cr.txndate, ${columnsql} 
  case when crv.objid is null then 0 else 1 end as voided 
from remittance_cashreceipt rem 
   inner join cashreceipt cr on cr.objid = rem.objid 
   left join cashreceipt_void crv on crv.receiptid = cr.objid 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid 
   inner join revenueitem ri on ri.objid = cri.item_objid 
   left join revenueitem_sreaccount rs on rs.objid = ri.objid 
   left join sreaccount a on a.objid = rs.acctid 
where rem.remittanceid=$P{remittanceid}
GROUP BY afid, serialno, paidby,paidby, voided 
ORDER BY afid, serialno 

[getDistinctAccountNGAS]
select 
  distinct n.objid, n.code as acctcode, n.title as accttitle 
from remittance_cashreceipt rem 
   inner join cashreceipt cr on cr.objid = rem.objid 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid 
   inner join revenueitem ri on ri.objid = cri.item_objid 
   left join revenueitem_account rs on rs.objid = ri.objid 
   left join account n on n.objid = rs.acctid 
where rem.remittanceid=$P{remittanceid}
ORDER BY acctcode

[getSummaryOfCollectionNGAS]
select 
  cr.formno as afid, cr.receiptno as serialno, 
  case when crv.objid is null then cr.paidby else '*** VOIDED ***' end as paidby, 
  cr.txndate, ${columnsql}
  case when crv.objid is null then 0 else 1 end as voided 
from remittance_cashreceipt rem 
   inner join cashreceipt cr on cr.objid = rem.objid 
   left join cashreceipt_void crv on crv.receiptid = cr.objid 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid 
   inner join revenueitem ri on ri.objid = cri.item_objid 
   left join revenueitem_account rs on rs.objid = ri.objid 
   left join account a on a.objid = rs.acctid 
where rem.remittanceid=$P{remittanceid}
GROUP BY afid, serialno, paidby,paidby, voided 
ORDER BY afid, serialno 

[getFundlist]
select 
  distinct ri.fund_objid as objid, ri.fund_title as title 
from remittance_cashreceipt rc 
  inner join cashreceipt cr on rc.objid = cr.objid 
  inner join cashreceiptitem cri on cri.receiptid = cr.objid 
  inner join revenueitem ri on ri.objid = cri.item_objid 
where rc.remittanceid=$P{remittanceid}

[getCollectionType]
select 
  distinct ct.objid, ct.title 
from remittance_cashreceipt rc 
  inner join cashreceipt cr on rc.objid = cr.objid 
  inner join collectiontype ct on ct.objid = cr.collectiontype_objid 
where rc.remittanceid=$P{remittanceid}  