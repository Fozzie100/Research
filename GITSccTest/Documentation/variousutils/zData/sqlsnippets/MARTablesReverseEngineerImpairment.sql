/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [AtomValueTypeID]
      ,[AtomValueTypeCode]
      ,[AtomValueTypeName]
      ,[AtomValueCategoryID]
      ,[IsDeleted]
  FROM [JUNO_DEV05].[ref].[AtomValueType]
  where AtomValueTypeCode  like '%Stock%'



  select  top 100 ty.AtomValueTypeCode, at.AtomTypeName, ty.AtomValueTypeName, avc.AtomValueCategoryName, a.ParticleString,  ty.AtomValueTypeID, x.* 
  from [ref].[AtomValue] x
  inner join [ref].[AtomValueType] ty
  on ty.AtomValueTypeID = x.AtomValueTypeID
  inner join ref.AtomType at
  on at.AtomTypeID = x.AtomTypeID
  inner join ref.AtomValueCategory avc
  on avc.AtomValueCategoryID = x.AtomValueCategoryID
  inner join ref.Atom a
  on a.AtomID = x.AtomID
  where ty.AtomValueTypeCode = 'UI_Tot_Imp_GBP'


  select * from ref.AtomParticle where AtomParticleID in (3303, 113)

  3303:113;3360:114;3372:115;

  select top 100 * from [util].[UTEntitiesMetadata]
  where StagingTable = 
  select top 100 * from ref.AtomType

  select top 100 * from ref.AtomValueType where AtomValueTypeCode = 'II_Tot_Imp_GBP'
  select * from ref.ParticleType where ParticleTypeID In (113,114,115)

  select * from entity.Entity where EntityKey in (3303,3360)

  select * from entity.EntityType where EntityTypeName like '%product%'


  --select top 100 * from bi.DimensionType
  --where Code like 'Metric%'
  select top 100 et.* , d.DictionaryItemKey, d.DictionaryItemCode, d.Description, do.*
  from entity.EntityType et 
  left join mapping.MappingType mt
  on mt.EntityTypeID = et.EntityTypeID
  left join mapping.Mapping m
  on m.MappingTypeKey = mt.MappingTypeKey
  and m.EntityTypeID = mt.EntityTypeID
  left join mapping.MappingTypeDataDictionary mtd
  on mtd.MappingTypeKey = m.MappingTypeKey
  and mtd.EntityTypeID = m.EntityTypeID
  left join dictionary.Item d 
  on d.DictionaryItemKey = mtd.DictionaryItemKey
  	left join dictionary.Object do
	on do.EntityContextDictionaryItemKey = d.DictionaryItemKey
    where et.EntityTypeCode like '%Imp%'
	-- and do.Name = 'tfnEggMetricNameAttr(@COBDATE)'  -- ObjectKey=442 for Egg file


	select d.*, dsc.*, dsr.DictionaryItemKey dsrDictionaryItemKey, 
	dsr.TargetDataSetKey dsrTargetDataSetKey,
	targd.*,
	targo.Name targetObjectName, targo.[Schema] targetObjectSchema
	from routing.Dataset d
	left join routing.DatasetColumn dsc
	on dsc.DataSetKey = d.DataSetKey
	left join routing.DataSetRouting dsr
	on dsr.SourceDataSetKey = d.DataSetKey
	left join routing.Dataset targd
	on targd.DataSetKey = dsr.TargetDatasetKey
	left join dictionary.Object targo
	on targo.ObjectKey = targd.ObjectKey
	where d.DataSetName = 'EggMetricNameAttrStage'
	and d.ObjectKey = 442



	select * 


	select * from dictionary.ObjectColumn where ObjectColumnKey = 1057

	select * from entity.Association where DictionaryItemKey = 625
	select top 100 * from routing.AssociationRelationship where DictionaryItemKey = 625
	
	select * from dictionary.Object where ObjectKey in (441,442)

	select * from dictionary.ObjectColumn where ObjectKey in (441)
	select * from entity.EntityType et
	where et.EntityTypeCode like 'Metric%'

	select * from entity.Entity where EntityTypeID = 196


  select top 100 * from util.UTEntitiesMetadata where EntityFunctionName_override like '%tfnBukMetricNam%'



