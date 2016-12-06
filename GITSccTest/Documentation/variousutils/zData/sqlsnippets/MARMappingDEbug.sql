select * from ref.AtomType
where AtomTypeCode like '%Portfolio%'






select top 100 * from util.UTEntitiesMetadata
where EntityTableName_override like '%Portfolio%'



select * from mapping.MappingType
where MappingTypeCode like '%Income%' or MappingTypeCode like '%Portfolio%'

select top 100 * from mapping.MappingType (NOLOCK) where MappingTypeCode like '%PortfolioIdAttrMap%'
select top 100 * from mapping.MappingTypeDataDictionary (NOLOCK)

select top 100 * from dictionary.Object
where [Name] like '%Portfolio%' or [Name] like '%Income%'
or ObjectKey=471


select * from dictionary.ObjectColumn where ObjectKey in (165,522)
select * from dictionary.Item where DictionaryItemCode = 'PortfolioIdAttr'

select * from routing.DataSet where DataSetName = 'CounterpartyProductAttrStage'
select * from routing.DataSet where DataSetName = 'PortfolioIdAttrStage'
CounterpartyProductAttrStage