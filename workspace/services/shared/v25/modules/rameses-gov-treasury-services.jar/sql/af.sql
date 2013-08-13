[getTypes]
SELECT af.objid as af, af.* FROM af

[getAFInfo]
SELECT unitqty, unit,serieslength  FROM af WHERE objid=$P{objid}