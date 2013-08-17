[getTypes]
SELECT af.objid as af, af.* FROM af ORDER BY af.objid

[getAFInfo]
SELECT unitqty, unit,serieslength  FROM af WHERE objid=$P{objid}

[getList]
SELECT af.objid as objid, af.objid as code, af.description, af.unit 
FROM af WHERE af.objid LIKE $P{searchtext}
