[getRulesets]
SELECT * FROM sys_ruleset

[getAgendagroups]
SELECT * FROM sys_ruleagendagroup WHERE ruleset = $P{ruleset} ORDER BY sortorder

[getFactsList]
SELECT * FROM sys_rulefact WHERE ruleset = $P{ruleset} ORDER BY sortorder

[getActionsList]
SELECT * FROM sys_ruleaction WHERE ruleset = $P{ruleset} ORDER BY sortorder
