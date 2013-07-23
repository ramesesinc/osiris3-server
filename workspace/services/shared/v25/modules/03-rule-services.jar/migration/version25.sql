CREATE TABLE `rule` (
  `objid` varchar(50) NOT NULL,
  `docstate` varchar(25) NOT NULL,
  `rulename` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL,
  `packagename` varchar(100) NOT NULL,
  `author` varchar(50) NOT NULL,
  `salience` int(11) NOT NULL,
  `agendagroup` varchar(25) NOT NULL,
  `ruleset` varchar(50) default NULL,
  `effectivefrom` date default NULL,
  `effectiveto` date default NULL,
  `conditions` text,
  `actions` text,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1


CREATE TABLE `rule_package` (
  `ruleset` varchar(50) NOT NULL,
  `rulegroup` varchar(50) NOT NULL,
  `packagename` varchar(255) NOT NULL,
  `orderindex` int(11) default NULL,
  `type` varchar(10) default NULL,
  `content` text,
  `lastmodified` datetime default NULL,
  PRIMARY KEY  (`ruleset`,`rulegroup`,`packagename`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1