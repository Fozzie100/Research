

select top 10 av.Value, avt.AtomValueTypeCode, av.AtomID, av.run, av.SourceRowID, atp.ParticleKey, atp.ParticleTYpeID,
pt.EntityTypeID
, et.EntityTypeCode
from ref.AtomValue (NOLOCK) av
JOIN ref.AtomValueType  (NOLOCK)  avt 
ON av.AtomValueTypeId = avt.AtomValueTypeId
inner join ref.Atom (NOLOCK) ra
on ra.AtomID = av.AtomID
inner join ref.AtomParticle (NOLOCK) atp
on atp.AtomID = av.AtomID
inner join ref.ParticleType (NOLOCK) pt on pt.ParticletypeID = atp.ParticleTYpeID
inner join  entity.EntityType (NOLOCK) et on et.EntityTypeID = pt.EntityTypeID
where ra.AtomTypeId in (340) and av.run =1148


select top 10 * from ref.AtomValue (NOLOCK) av where av.Run=1148
338,1449




select top 10 av.Value, avt.AtomValueTypeCode, av.AtomID, av.run, av.SourceRowID, atp.ParticleKey, atp.ParticleTYpeID,
pt.EntityTypeID
, et.EntityTypeCode, eh.HistoryKey,
cppa.DECDATE, ae.ENTITY, im.[Month]
-- select count(*)
from ref.AtomValue (NOLOCK) av
JOIN ref.AtomValueType  (NOLOCK)  avt 
ON av.AtomValueTypeId = avt.AtomValueTypeId
inner join ref.Atom (NOLOCK) ra
on ra.AtomID = av.AtomID
inner join ref.AtomParticle (NOLOCK) atp
on atp.AtomID = av.AtomID
inner join ref.ParticleType (NOLOCK) pt on pt.ParticletypeID = atp.ParticleTYpeID
inner join  entity.EntityType (NOLOCK) et on et.EntityTypeID = pt.EntityTypeID
left join entity.History (NOLOCK)eh on eh.EntityKey = atp.ParticleKey
left join [entity].[DecDate_Attr] (NOLOCK) cppa
on cppa.HistoryKey = eh.HistoryKey
left join [entity].[AccountEntity_Attr] (NOLOCK) ae
on ae.HistoryKey = eh.HistoryKey
left join [entity].[IncomeMonth_Attr] (NOLOCK) im
on im.HistoryKey = eh.HistoryKey
-- where ra.AtomTypeId = 407 and av.run = 5001324 -- 5000033--2147483641 BBC  devo4
where ra.AtomTypeId in (340) and av.run =1148 -- 23 for jul 2015, 135 from aug2015 for G1DEBT atom
--where ra.AtomTypeId = 779 and av.run = 5000033
-- and eh.HistoryKey = 5074387
order by av.AtomID, atp.ParticleTYpeID, eh.HistoryKey

-- exec bi.uspLoadFDFS_ImpairmentFactData @p_SourceCobdate='30 Jun 2015',@p_SourceJobDefinitionCode='BCARD_TCP_01_BARCLAYCARD_Impairment_All'
-- select * from [bi].[FDFS_ImpairmentFactData] where runid = 5000033

select top 100 * from bi.GRCR_ImpairmentFactData

select * from ref.AtomType (NOLOCK) where AtomTypeCode like '%AccountBPF%'  --338


select top 100 * from ref.AtomValue (NOLOCK) av where av.Run=1449

use JUNO_DEV05
select * from ref.AtomType (NOLOCK) where AtomTypeCode like '%Inc%'

select * from ref.AtomType (NOLOCK)  where AtomTypeID = 781 --- where AtomTypeCode like '%ECGood%' -- where AtomTypeID = 787
select max(run) from ref.AtomValue (NOLOCK) where AtomTypeID = 340


SELECT * FROM LOADER.JobRun WHERE Run=135
select * from loader.Job where JobId=23
select * from loader.Job where JobDefinitionCode='BCARD_G1DEBTP'

select * from ref.AtomType where AtomTypeCode like 'CounterpartyProductAttr%'