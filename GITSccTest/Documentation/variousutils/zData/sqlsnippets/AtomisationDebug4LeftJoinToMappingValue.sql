select * from entity.EntityType
where EntityTypeCode = 'AccountBPF'
or EntityTypeCode = 'Division'


select * from dictionary.Item 
where DictionaryItemCode like '%AccountBPF%'
or DictionaryItemCode like '%Division%'


SELECT  ParticleTypeId
			FROM   ref.ParticleType pt
			WHERE  pt.ParticleTypeCode = 'AccountBPF'

SELECT  ParticleTypeId
			FROM   ref.ParticleType pt
			WHERE  pt.ParticleTypeCode = 'Division'


			select top 100 * from ref.AtomValueType
			where AtomValueTypeID = 505
			order by AtomValueTypeID desc

			select * from ref.AtomValueCategoryExtent
			where AtomValueCategoryID = 6

			select * from ref.AtomValueExtent
			where AtomValueExtentID in (1,2)

select * from dictionary.Item where DictionaryItemKey in (680,706,709)

select * from dictionary.Item where DictionaryItemCode like '%AccountBP%'
select top 10 * from ref.AtomValueType where AtomValueTYpeCode = 'ChargeOffBalanceBPF' 

select top 10 * from dbo.JAY_BPF_CHGOFF_DATA chg
where chg.account_no = '0009910027242362'

select * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA
	where Run=33 
	--(and RowID in (1348, 2091, 180) -- 2091 missing)
	and  Logical_Account_key_Num in (4929534824525, 4929534822750.00000000)
	order by RowID

select top 7000000  mv.ValueVarChar particlevalue, av.Value, av.AppliedFromDateTime, av.EffectiveFromDateTime,  avt.AtomValueTypeCode, av.AtomID, av.run, av.SourceRowID, atp.ParticleKey, atp.ParticleTYpeID,
pt.EntityTypeID
, et.EntityTypeCode, eh.HistoryKey,
cppa.DECDATE, ae.ENTITY, im.[Month]
-- select count(*)
from ref.AtomValue (NOLOCK) av
JOIN ref.AtomValueType (NOLOCK)  avt 
ON av.AtomValueTypeId = avt.AtomValueTypeId
inner join ref.Atom (NOLOCK) ra
on ra.AtomID = av.AtomID
inner join ref.AtomParticle (NOLOCK) atp
on atp.AtomID = av.AtomID
inner join ref.ParticleType (NOLOCK) pt on pt.ParticletypeID = atp.ParticleTYpeID
inner join  entity.EntityType (NOLOCK) et on et.EntityTypeID = pt.EntityTypeID
left join entity.History (NOLOCK) eh on eh.EntityKey = atp.ParticleKey
left join [entity].[DecDate_Attr] (NOLOCK) cppa
on cppa.HistoryKey = eh.HistoryKey
left join [entity].[AccountEntity_Attr] (NOLOCK) ae
on ae.HistoryKey = eh.HistoryKey
left join [entity].[IncomeMonth_Attr] (NOLOCK) im
on im.HistoryKey = eh.HistoryKey
left join mapping.Mapping (NOLOCK) mm
on mm.EntityKey = atp.ParticleKey
left join mapping.MappingValue (NOLOCK) mv
on mv.MappingKey = mm.MappingKey
-- where ra.AtomTypeId = 407 and av.run = 5001324 -- 5000033--2147483641 BBC  devo4
where ra.AtomTypeId = 310  and av.run = 226 -- dev05   or atomtypeid=410 or 418
--and av.AtomValueTypeID = 501
-- and eh.HistoryKey = 5074387
-- and mv.ValueVarChar = '4929534822750'
--and ( av.Value = 4929534829995
--or mv.ValueVarChar = '4929534829995' )
-- and avt.AtomValueTypeCode = 'AuditTimestamp'
-- order by  avt.AtomValueTypeCode, av.Value desc   
--and mv.ValueVarChar = '4929534824525'
--and av.Value = 4929970548596
--and av.SourceRowID = 30848718
order by av.AtomID, atp.ParticleTYpeID, eh.HistoryKey

ActiveAccountStartDateAttr-CounterPartyIdAttr-OriginalAccountStartDateAttr

select * from rf
select top 10 * 
from ref.AtomType 
where AtomTypeCode like '%EraScre%'
-- or AtomTypeCode like '%Logical%'
-- or AtomTypeID=410

select top 100 * 
from ref.AtomType 
where UPPER(AtomTypeCode) like '%COUNTERPARTYIDATTR%'


select top 10 * 
from ref.AtomType where AtomTypeId in (410,418)


select top 10 * from ref.AtomValueType  where AtomValueTypeCode like '%Latest%'


select * from ref.AtomValue where Run=1

select max(Run) from ref.AtomValue where AtomTypeID=340

select * from entity.History where HistoryKey in (1683805,4747482,8621009,14439565)

select top 10 * from ref.AtomType where AtomTypeCode like '%OriginalAccountStartDateAttr%'
select top 10 * from ref.AtomValueType where AtomValueTYpeCode = 'BPFAccountFPOpenBalance' 
select top 100 * from ref.AtomValue
where AtomValueTypeID=345
order by Run desc

sp_help 'mapping.Mapping'

select * from ref.AtomType (NOLOCK) where AtomTypeCode like '%AccountBPF%'

select * from ref.AtomValue where AtomID=5731242
select * from ref.AtomParticle where AtomID=5731242
select * from ref.Atom where AtomID=5731242


select * from mapping.MappingValue where EntityTypeID=261


select * from mapping.Mapping where EntityKey=7324827

select top 100 * from vntg_payplan_book_noyr

select top 100 * from vntg_arrslvlgrip_book_noyr_m125_m129

select account_no, count(*) 
from vntg_payplan_book_noyr
where pay_plan_m127 <> '' and  pay_plan_m126 <> ''
and pay_plan_m125 <> '' and  pay_plan_m128 <> ''
and  pay_plan_m129 <> ''
group by account_no 
having count(*) > 1

select * from vntg_payplan_book_noyr where account_no =  '012062001953327'



select top 100 * from log.log where run =1086
order by CreateDate desc
exec sp_who2 'active'


select * from ref.AtomType where AtomTypeCode like '%Division%'



select * from entity.History where HistoryKey in (2406766, 5463417, 13386355)



select * from dictionary.Item where DictionaryItemKey in (680,706)
