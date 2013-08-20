[getList]
SELECT * 
FROM ris 
WHERE risno LIKE $P{searchtext}
  OR requester_name LIKE $P{searchtext}
ORDER BY risno DESC 

[getItems]
SELECT * FROM risitem WHERE parentid=$P{objid}


[changeState-approved]
UPDATE ris SET state='APPROVED' WHERE objid=$P{objid}

[getRISInfo]
select 
    risno, txntype, dtfiled, requester_name, 
    requester_title, approver_name, approver_title 
from ris     
where objid=$P{risid}

[getRISAFIssueItem]
select 
  ri.item_objid, ri.unit, ri.qty as qtyrequested, 
  afi.endseries, afi.startseries, afi.startstub, afi.endstub, afi.qty as qtyreceived 
from risitem ri 
  left join afissue af on ri.parentid = af.risid 
  left join afissueitem afi on afi.parentid = af.objid and ri.item_objid = afi.af
where ri.parentid=$P{risid} 

[getRISReceiptItem]
select 
  ri.item_objid, ri.unit, ri.qty as qtyrequested, 
  afi.endseries, afi.startseries, afi.startstub, afi.endstub, afi.qty as qtyreceived 
from risitem ri 
  left join afreceipt af on ri.parentid = af.risid 
  left join afreceiptitem afi on afi.parentid = af.objid and ri.item_objid = afi.af
where ri.parentid=$P{risid}