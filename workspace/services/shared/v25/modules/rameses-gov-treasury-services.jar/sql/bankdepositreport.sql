[getFundlist]
select 
  lcf.fund_objid as objid , lcf.fund_title as title 
from bankdeposit bd 
  inner join bankdeposit_liquidation bl on bd.objid = bl.bankdepositid 
  inner join liquidation_cashier_fund lcf on lcf.objid = bl.objid  
where bd.objid = $P{bankdepositid}

[getBackAccountList]
select 
     ba.objid, concat( ba.bank_code, ' ( ', ba.code, ' )'  ) as title 
from bankdeposit_entry be 
 inner join bankaccount ba on ba.objid = be.bankaccount_objid 
where parentid=$P{bankdepositid}

[getCollectionSummaryByAFAndFund]
select  
  case 
      when a.objid in ( '51', '56') and aftype='serial' then CONCAT( 'AF#', a.objid, ': ', lcf.fund_title ) 
      ELSE CONCAT( 'AF#',a.objid, ': ', a.description,' - ', lcf.fund_title ) 
  end as particulars, 
  sum( case when crv.objid is null then cri.amount else 0.0 end ) as amount 
from bankdeposit_liquidation bl  
   inner join liquidation_cashier_fund lcf on lcf.objid = bl.objid
   inner join liquidation_remittance lr on lr.liquidationid = lcf.liquidationid 
   inner join remittance_cashreceipt rc on rc.remittanceid = lr.objid 
   inner join cashreceipt cr on rc.objid = cr.objid 
   left join cashreceipt_void crv on crv.receiptid = cr.objid 
   inner join af a on a.objid = cr.formno 
   inner join cashreceiptitem cri on cri.receiptid = cr.objid 
where bl.bankdepositid=$P{bankdepositid}  and lcf.fund_objid = $P{fundname}
group by a.objid, lcf.fund_objid 

[getCashFundSummary]
select 
    bd.cashier_name as cashier, 
    concat(ba.bank_code, ' - Cash D/S: Account ' , be.bankaccount_code ) as depositref, 
    be.totalcash as depositamt 
from bankdeposit bd 
 inner join bankdeposit_entry be on bd.objid = be.parentid 
 inner join bankaccount ba on ba.objid = be.bankaccount_objid 
where bd.objid=$P{bankdepositid} and ba.fund_objid=$P{fundname}
  and be.totalcash > 0.0 


[getCheckFundSummary]
select 
    bd.cashier_name as cashier, 
    concat(ba.bank_code, ' - Check D/S: Account ' , be.bankaccount_code ) as depositref, 
    be.totalnoncash as depositamt 
from bankdeposit bd 
 inner join bankdeposit_entry be on bd.objid = be.parentid 
 inner join bankaccount ba on ba.objid = be.bankaccount_objid 
where bd.objid=$P{bankdepositid} and ba.fund_objid=$P{fundname}
  and be.totalnoncash > 0.0 

[getRemittedForms]
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
from bankdeposit_liquidation bl  
   inner join liquidation_cashier_fund lcf on lcf.objid = bl.objid
   inner join liquidation_remittance lr on lr.liquidationid = lcf.liquidationid 
   inner join remittance_af ra on ra.remittanceid = lr.objid 
   inner join afcontrol_detail ad on ad.objid = ra.objid 
   inner join afcontrol afc on afc.objid = ad.controlid 
where bl.bankdepositid=$P{bankdepositid} 
     and lcf.fund_objid=$P{fundname}
     and afc.af=$P{afid}

[getDepositAmount]
select 
     be.totalcash, be.totalnoncash, ba.bank_code as bankcode, ba.fund_title as fund, be.amount 
from  bankdeposit_entry be 
   inner join bankaccount ba on be.bankaccount_objid = ba.objid 
where be.parentid = $P{bankdepositid} 
  and be.bankaccount_objid=$P{bankaccountid}