[getList]
SELECT * FROM collectiontype


[getAvailableFormTypes]
SELECT DISTINCT formno FROM collectiontype

[getListByFormType]
SELECT * FROM collectiontype WHERE formno=$P{formno}