[getLiquidationInfo]
select 
  l.txnno, l.dtposted, l.liquidatingofficer_name, l.liquidatingofficer_title, 
  lc.fund_title, lc.cashier_name, 'CASHIER' as cashier_title, lc.amount
from liquidation l  
   inner join liquidation_cashier_fund lc on lc.liquidationid = l.objid 
where l.objid =$P{liquidationid} and lc.fund_objid=$P{fundname} 

[getRCDRemittances]
select 
    r.collector_name as collectorname, r.txnno, r.dtposted, rf.amount 
from liquidation_remittance lr 
inner join remittance r on r.objid = lr.objid
inner join remittance_fund rf ON rf.remittanceid=r.objid 
where lr.liquidationid = $P{liquidationid}  and rf.fund_objid =$P{fundname} 

[getRCDCollectionSummary]
select  
	case 
	    when a.objid in ( '51', '56') and aftype='serial' then CONCAT( 'AF#', a.objid, ': ', ri.fund_title ) 
	    ELSE CONCAT( 'AF#',a.objid, ': ', a.description,' - ', ri.fund_title ) 
	end as particulars, 
	sum( case when crv.objid is null then cri.amount else 0.0 end ) as amount 
from liquidation_remittance  lr 
   inner join remittance_cashreceipt rc  on rc.remittanceid = lr.objid 
   inner join cashreceipt cr on rc.objid = cr.objid 
   left join cashreceipt_void crv on crv.receiptid = cr.objid 
   inner join af a on a.objid = cr.formno 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid
   inner join revenueitem ri on ri.objid = cri.item_objid 
where lr.liquidationid=$P{liquidationid} and ri.fund_objid =$P{fundname}
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
from liquidation_remittance  lr 
   inner join remittance_af ra on ra.remittanceid = lr.objid 
   inner join afcontrol_detail ad on ad.objid = ra.objid 
   inner join afcontrol afc on afc.objid = ad.controlid 
where lr.liquidationid=$P{liquidationid}

[getRCDOtherPayments]
select  "CHECK" as paytype, pc.particulars, sum( cri.amount ) as amount 
from liquidation_remittance  lr 
   inner join remittance_cashreceipt rc  on rc.remittanceid = lr.objid 
   inner join cashreceipt cr on rc.objid = cr.objid 
   inner join cashreceiptpayment_check pc on pc.receiptid = rc.objid 
   left join cashreceipt_void crv on crv.receiptid = cr.objid 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid
   inner join revenueitem ri on ri.objid = cri.item_objid   
where lr.liquidationid=$P{liquidationid} and ri.fund_objid =$P{fundname} 
  and crv.objid is null 
group by ri.fund_objid  


[getLiquidationFundlist]
select fund_objid as fundid, fund_title as fundname 
from liquidation_cashier_fund 
where liquidationid=$P{liquidationid}

[getFundSummaries]
SELECT * FROM liquidation_cashier_fund WHERE liquidationid = $P{liquidationid}

