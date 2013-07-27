[getInfo]
select * from loginaccount where uid=$P{uid} 

[updateLock]
update loginaccount set lockid=$P{lockid} where uid=$P{uid} 

[incrementLoginCount]
update loginaccount set 
	pwdlogincount=$P{pwdlogincount}+1 
where 
	uid=$P{uid} and pwdlogincount=$P{pwdlogincount} 

