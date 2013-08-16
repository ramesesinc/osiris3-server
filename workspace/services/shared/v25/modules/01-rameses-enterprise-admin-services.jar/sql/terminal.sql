[getList]
SELECT * FROM sys_terminal 

[list]
select * from sys_terminal

[list-all]
select * from sys_terminal 

[find-macaddress]
select * from sys_terminal where macaddress = $P{macaddress}

[find-terminal]
select * from sys_terminal where terminalid = $P{terminalid}

[find-clientid]
select * from sys_terminal where terminalid=$P{terminal}

[unregister-terminal]
update sys_terminal set macaddress=null,dtregistered=null,registeredby=null  where terminalid=$P{terminalid}
