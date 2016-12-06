


-- <SqlCommand>bi.uspLoadFDFS_ImpairmentFactData @p_SourceCobdate='[[CobDate|ddMMMyyyy]]',@p_SourceJobDefinitionCode='BCARD_TCP_01_BARCLAYCARD_Impairment_All'</SqlCommand>
SELECT TOP 1000 [HistoryKey]
      ,[CounterpartyProduct]
  FROM [JUNO_DEV05].[entity].[CounterpartyProduct_Attr]
  where CounterpartyProduct = 'sey'



  select top 10 * from entity.History 
  where HistoryKey in (1719,39761,39885,40012,40886)

  select * from entity.CounterpartyProduct_Attr cpa where  cpa.HistoryKey = 1735

  -- 224 anchor
  select * from dictionary.Object
  where ObjectKey in ( 224, 210)

  select * from entity.EntityType where EntityTypeID = 132

 select * from dictionary.Item where DictionaryItemKey =  524


 select * from dictionary.ObjectColumn where [Name] like '%product%'
 select top 1000 * from mapping.MappingType
 where MappingTypeCode like '%CounterParty%'


 select top 1000 * from entity.EntityType where EntityTypeName like '%CounterPartyProduct%'

 select * from dictionary.Item
 where DictionaryItemCode = 'CounterpartyProductAttr'


 select * from routing.DataSet where DataSetName like '%CounterpartyPro%'

 -- segment start
 select * from dictionary.Object where [Name] like '%Segment_Attr%'
 select * from routing.DataSet where DataSetName like '%SegmentAttrEntity%'
 select * from routing.DataSet where DataSetName like '%SegmentAttrStage%' or Datasetkey in (257, 297)
 select * from routing.DataSetRouting where TargetDataSetKey = 256
 select * from dictionary.Item where DictionaryItemKey = 563
 select * from entity.EntityType where EntityTypeID = 160
 select * from dictionary.Object where ObjectKey = 311
 select * from dictionary.ObjectColumn where ObjectKey = 311
 -- segment end

 -- CounterPartyProduct start
 select * from dictionary.Item where DictionaryItemCode like '%counterPartyPr%'
 select * from entity.EntityType where EntityTypeCode like '%counterParty%'
select * from dictionary.Object where [Name] like '%CounterpartyProduct_Attr%'
select * from dictionary.ObjectColumn where [Name] like '%CounterpartyProduct%'
 select * from routing.DataSet where DataSetName like '%partyProduct%'
 select * from dictionary.Object where ObjectKey = 216
 select * from dictionary.ObjectColumn where ObjectKey = 216

 select * from dictionary.Object where [Name] like '%partyProduct%'
 select * from routing.DataSetColumnType

select * from dictionary.Object (nolock) where ObjectKey in (216,466)
select * from dictionary.Object (nolock) where ObjectKey in (305)
select * from dictionary.Item (nolock) where DictionaryItemKey = 524


 select top 100 * from [util].[UTSystemMetadata]

select top 100 * 
from [util].[UTEntitiesMetadata]
where StagingTable like '%Impair%'

select * from entity.EntityType where EntityTypeCode like 'CounterPart%'
select * from loader.JobDefinition
where JobDefinitionCode like '%TCP%'

SELECT *
		FROM ref.ParticleType pt (NOLOCK)
		WHERE pt.ParticleTypeCode like '%CounterpartyProduct%'

declare @x INT = (SELECT TOP 1 CounterpartyProductAttrKeyID FROM [bi].[CounterpartyProductAttrSCD] WHERE [CounterpartyProduct] = 'BLANK' ORDER BY [CounterpartyProductAttrKeyID] DESC)
select @x

SELECT TOP 1 [SegmentAttrKeyID] FROM [bi].[SegmentAttrSCD] WHERE [segment] = 'BLANK' ORDER BY [SegmentAttrKeyID] DESC
select * from [entity].[CounterpartyProduct_Attr]
where [CounterpartyProduct] like '%Little%'

select top 100 * from [bi].[CounterpartyProductAttrSCD] where [CounterpartyProduct] like '%Little%'


select * from [stg].[BARCLAYCARD_Impairment_All]

select top 100 * from ref.AtomValue where run = 2147483627

select * from ref.AtomType where AtomTypeID = 779


select * from ref.Atom where AtomTypeId = 779

5074414:79;3307:113;3361:114;3393:115;


--
-- main query here to check for atomisation success!!
--
select av.Value, avt.AtomValueTypeCode, av.AtomID, av.run, av.SourceRowID, atp.ParticleKey, atp.ParticleTYpeID,
pt.EntityTypeID
, et.EntityTypeCode, eh.HistoryKey,
cppa.CounterpartyProduct
from ref.AtomValue av
JOIN ref.AtomValueType avt 
ON av.AtomValueTypeId = avt.AtomValueTypeId
inner join ref.Atom ra
on ra.AtomID = av.AtomID
inner join ref.AtomParticle atp
on atp.AtomID = av.AtomID
inner join ref.ParticleType pt on pt.ParticletypeID = atp.ParticleTYpeID
inner join  entity.EntityType et on et.EntityTypeID = pt.EntityTypeID
left join entity.History eh on eh.EntityKey = atp.ParticleKey
left join [entity].[CounterpartyProduct_Attr] cppa
on cppa.HistoryKey = eh.HistoryKey
where ra.AtomTypeId = 779 and av.run = 2147483641 -- 5000033--2147483641
-- and eh.HistoryKey = 5074387
order by av.AtomID, atp.ParticleTYpeID, eh.HistoryKey


select top 100 * from ref.AtomValue where Run = 5001287
select max(run) from ref.AtomValue where AtomTypeID = 407

select * from ref.AtomType where AtomTypeID = 779
select * from entity.History where EntityKey in (5074414)
select * from dictionary.Item where DictionaryItemKey = 524
select * from entity.History where EntityTypeID = 132

select top 100 * from entity.History where EntityKey = 5074394 --5074414
select * from entity.EntityType where EntityTypeID = 161
select * from  ref.ParticleType where ParticleTypeID  = 113

select * from ref.AtomParticle where ParticleKey = 3307
select top 100 * from ref.AtomType where AtomTypeID = 306
where AtomID = 1353848 and run = 2147483641

select * from ref.Atom where AtomId = 1353848
select Atomid, pt.ParticleTypeCode, ap.ParticleKey
from ref.AtomParticle  ap
JOIN ref.ParticleType pt
	ON pt.ParticleTypeID = ap.ParticleTypeID
where AtomId = 1353848

select * from entity.History where EntityKey in (5074414,3357,3360,3398)
select * from entity.Entity where EntityKey = 5074387

select * from entity.CounterpartyProduct_Attr  where HistoryKey IN (5081548, 5081529)

select * from entity.CounterpartyProduct_Attr  where HistoryKey IN (5074394,5074387,5074410)

select * from entity.EntityType where EntityTypeID = 132
select * from entity.ImpairementMonth_Attr where HistoryKey IN (127723,127726,127764)
select * from entity.ImpairementYear_Attr where HistoryKey IN (127723,127726,127764)
select * from entity.Segment_Attr where HistoryKey IN (127723,127726,127764)


select top 1000 * from [bi].[CounterpartyProductAttrSCD]

select count(*) from [bi].[FDFS_ImpairmentFactData] 

select  iy.[year],  im.[Month], cpa.CounterpartyProduct, x.*
from [bi].[FDFS_ImpairmentFactData] x
inner join bi.CounterpartyProductAttrSCD cpa
on cpa.ChangeListId = x.CounterpartyProductAttrChangeListId
and cpa.CounterpartyProductAttrKeyID = x.CounterpartyProductAttrKey
inner join bi.ImpairementMonthAttrSCD im on im.ChangeListId
= x.ImpairementMonthAttrChangeListId
and im.ImpairementMonthAttrKeyID = x.ImpairementMonthAttrKey
inner join bi.ImpairementYearAttrSCD iy
on iy.ImpairementYearAttrKeyID = x.ImpairementYearAttrKey
and iy.ChangeListId = x.ImpairementYearAttrChangeListId
where 1 = 1
-- and RunId = 5000034
and x.CounterpartyProductAttrKey = 5074394
and x.SourceRowID = 767


select top 100 * from bi.CounterpartyProductAttrSCD 
where CounterpartyProductAttrKeyID = 5074394 
or CounterpartyProduct like 'Phi%'

select top 100 * from entity.History where EntityKey in ( 5074394, 5074418, 5074419)
select * from entity.EntityType where EntityTypeID = 132
select * from dictionary.Item where DictionaryItemKey = 524

begin tran
delete [bi].[FDFS_ImpairmentFactData] where RunID in (5000019, 2147483641)
-- <SqlCommand>bi.uspLoadFDFS_ImpairmentFactData @p_SourceCobdate='[[CobDate|ddMMMyyyy]]',@p_SourceJobDefinitionCode='BCARD_TCP_01_BARCLAYCARD_Impairment_All'</SqlCommand>
exec bi.uspLoadFDFS_ImpairmentFactData @p_SourceCobdate='30 Jun 2015', @p_SourceJobDefinitionCode='BCARD_TCP_01_BARCLAYCARD_Impairment_All'

select  * from [bi].[FDFS_ImpairmentFactData] where RunId >= 5000019

rollback


select * from log.log where LogMessage like '%obtain Run%'
and CreateDate > '05 Oct 2015'
