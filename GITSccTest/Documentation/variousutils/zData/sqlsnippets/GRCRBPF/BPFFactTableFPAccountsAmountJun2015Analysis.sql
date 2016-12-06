select top 10000 * 
from log.log 
where Run=5025034
order by CreateDate desc



select RunId, count(*)
 from bi.GRCR_ImpairmentFactData
 group by RunID


  select top 100 * from bi.GRCR_ImpairmentFactData
 where RunID = 5025333
 and G1DebtpStatusAttrKey is not null
 and RouterAccountNumberAttrKey is null
 and CounterPartyIdAttrKey is null
 or AccountOpenDateAttrKey is null
 or GripArrearsLevelAttrKey is null
  or ImpairFlagAttrKey is null
   or ProductGrpAttrKey is null
   or InScopeAttrKey is null
   or ChargeoffFlagAttrKey is null
   or CounterPartyIdAttrChangeListId is null
   or AccountOPenDateChangeListID  is null
   or GripArrearsLevelAttrChangeListId is null
   or ImpairFlagAttrChangeListID is null
   or ProductGrpAttrChangeListID is null
   or InScopeAttrChangeListID is null
   or ChargeoffFlagAttrChangeListID is null
 and RunsetID =-1



 select top 100 * from bi.ProductGrpAttrSCD
  select top 100 * from bi.ProductCodeSCD





  select tmp.ProductGroup, tmp.grip_arrears_level, 
tmp.coff_flag, 
--cast(tmp.netbalance_finance_m127 as decimal(30,10) ) ENR,
--tmp.Account_No,
sum(cast(netbalance_finance as decimal(30,10) )) as ENR, 
------sum(cast(N9UOAM as decimal(30,10) )) as ENR1, 
count(CounterPartyIdAttrKey) as AccountsInENR, 
'31-JULY' as COBDATE 
from 
( 
select  -- base.*, 
gr.grip_arrears_level,
co.coff_flag,
base.CounterPartyIdAttrKey,
base.netbalance_finance, 
-- fp.N9UOAM,
--fp.G1PAVC,
case 
when pg.product_grp in ('1','4') then 'Motor' 
when pg.product_grp in ('2','3') then 'Retail' 
else 'Unknown' 
end as ProductGroup 
-- from stg. BARCLAYCARD_IMPAIR_BASE base 
from bi.GRCR_ImpairmentFactData base
inner join [bi].[ProductCodeSCD] pc
on pc.ProductCodeAttrKeyID = base.ProductCodeAttrKey
and pc.ChangeListId = base.ProductCodeAttrChangeListId

inner join bi.G1DebtpStatusAttrSCD g1
on g1.G1DebtpStatusAttrKeyID = base.G1DebtpStatusAttrKey
and g1.ChangeListId =base.G1DebtpStatusAttrChangeListId

inner join bi.FipTypeAttrSCD fp
on fp.[FipTypeAttrKeyID] = base.FipTypeAttrKey
and fp.ChangeListId = base.FipTypeAttrChangeListId

inner join bi.BrokenInstallmentsAttrSCD bins
on bins.BrokenInstallmentsAttrKeyID = base.BrokenInstallmentsAttrKey
and bins.ChangeListId = base.BrokenInstallmentsAttrChangeListId

inner join bi.ChargeoffFlagAttrSCD co
on co.ChargeoffFlagAttrKeyID = base.ChargeoffFlagAttrKey
and co.ChangeListId = base.ChargeoffFlagAttrChangeListId

inner join [bi].[ImpairFlagAttrSCD] ifg
on ifg.ChangeListId = base.ImpairFlagAttrChangeListId
and ifg.ImpairFlagAttrKeyID = base.ImpairFlagAttrKey


left join [bi].[ProductGrpAttrSCD] pg
on pg.ChangeListId = base.ProductGrpAttrChangeListId
and pg.ProductGrpAttrKeyID = base.ProductGrpAttrKey

left join [bi].[GripArrearsLevelAttrSCD] gr
on gr.GripArrearsLevelAttrKeyID = base.GripArrearsLevelAttrKey
and gr.ChangeListId = base.GripArrearsLevelAttrChangeListId
where 1 = 1
and base.netbalance_finance is not null 
-- and base.netbalance_finance <> '' 
and base.RunId = 5025333
and pc.[ProductCode] is not null
and g1.[G1DebtpStatus] = 'L'
and fp.FipType = 'BSR'
and bins.BrokenInstallments = '0'
and co.coff_flag <> 1
and ifg.impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
--and base.in_scope = 1 
--and base.coff_flag <> 1 
-- and base.run = 5000285 -- 2015-06-30 
--and base.run = 1104   -- BARCLAYCARD_IMP_STOCK_ACCT
--and noyr.Run = 1078 
 --and noyr.netbalance_finance_m127 is not null 
 --and noyr.netbalance_finance_m127 <> '' 
-- and base.account_open_month like '%JUN15%'
  --and ( fp.DateG1UEDT like '%JUL2015%' 
--  or  fp.DateG1AIDX like '%JUL2015%' 
 --)
) tmp 
--order by ProductGroup

group by ProductGroup ,coff_flag ,grip_arrears_level 







--
-- Total new FPS for Jun
--
select tmp.ProductGroup, tmp.grip_arrears_level, 
tmp.coff_flag, 
cast(tmp.netbalance_finance as decimal(30,10) ) ENR,
tmp.CounterpartyID,
--sum(cast(netbalance_finance as decimal(30,10) )) as ENR, 
------sum(cast(N9UOAM as decimal(30,10) )) as ENR1, 
--count(CounterPartyIdAttrKey) as AccountsInENR, 
'31-June' as COBDATE 
from 
( 
select  -- base.*, 
gr.grip_arrears_level,
co.coff_flag,
cpt.[CounterpartyID],
base.netbalance_finance, 
-- fp.N9UOAM,
--fp.G1PAVC,
case 
when pg.product_grp in ('1','4') then 'Motor' 
when pg.product_grp in ('2','3') then 'Retail' 
else 'Unknown' 
end as ProductGroup 
-- from stg. BARCLAYCARD_IMPAIR_BASE base 
from bi.GRCR_ImpairmentFactData base
inner join [bi].[ProductCodeSCD] pc
on pc.ProductCodeAttrKeyID = base.ProductCodeAttrKey
and pc.ChangeListId = base.ProductCodeAttrChangeListId

inner join bi.G1DebtpStatusAttrSCD g1
on g1.G1DebtpStatusAttrKeyID = base.G1DebtpStatusAttrKey
and g1.ChangeListId =base.G1DebtpStatusAttrChangeListId

inner join bi.FipTypeAttrSCD fp
on fp.[FipTypeAttrKeyID] = base.FipTypeAttrKey
and fp.ChangeListId = base.FipTypeAttrChangeListId

inner join bi.BrokenInstallmentsAttrSCD bins
on bins.BrokenInstallmentsAttrKeyID = base.BrokenInstallmentsAttrKey
and bins.ChangeListId = base.BrokenInstallmentsAttrChangeListId

inner join bi.ChargeoffFlagAttrSCD co
on co.ChargeoffFlagAttrKeyID = base.ChargeoffFlagAttrKey
and co.ChangeListId = base.ChargeoffFlagAttrChangeListId

inner join [bi].[ImpairFlagAttrSCD] ifg
on ifg.ChangeListId = base.ImpairFlagAttrChangeListId
and ifg.ImpairFlagAttrKeyID = base.ImpairFlagAttrKey


left join [bi].[ProductGrpAttrSCD] pg
on pg.ChangeListId = base.ProductGrpAttrChangeListId
and pg.ProductGrpAttrKeyID = base.ProductGrpAttrKey

left join [bi].[GripArrearsLevelAttrSCD] gr
on gr.GripArrearsLevelAttrKeyID = base.GripArrearsLevelAttrKey
and gr.ChangeListId = base.GripArrearsLevelAttrChangeListId


left join bi.CounterpartyIDAttrSCD cpt
on cpt.CounterpartyIDAttrKeyID = base.CounterPartyIdAttrKey
and cpt.ChangeListId = base.CounterPartyIdAttrChangeListId



left Join bi.PlanCreateDateAttrSCD pcd
on pcd.PlanCreateDateAttrKeyID = base.PlanCreateDateAttrKey
and pcd.ChangeListId = base.PlanCreateDateAttrChangeListId
where 1 = 1
and base.netbalance_finance is not null 
-- and base.netbalance_finance <> '' 
and base.RunId = 5025586
and pc.[ProductCode] is not null
and g1.[G1DebtpStatus] = 'L'
and fp.FipType = 'BSR'
and bins.BrokenInstallments = '0'
and co.coff_flag <> '1'
and ifg.impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
--and base.in_scope = 1 
--and base.coff_flag <> 1 
-- and base.run = 5000285 -- 2015-06-30 
--and base.run = 1104   -- BARCLAYCARD_IMP_STOCK_ACCT
--and noyr.Run = 1078 
 --and noyr.netbalance_finance_m127 is not null 
 --and noyr.netbalance_finance_m127 <> '' 
-- and base.account_open_month like '%JUN15%'
  and ( pcd.[PlanCreateDate] like '%JUN2015%' 
--  or  fp.DateG1AIDX like '%JUL2015%' 
 )
) tmp 
order by ProductGroup

-- group by ProductGroup ,coff_flag ,grip_arrears_level 









--
-- FPS to date for COB June
--
select tmp.ProductGroup, tmp.grip_arrears_level, 
tmp.coff_flag, 
--cast(tmp.netbalance_finance as decimal(30,10) ) ENR,
--tmp.CounterpartyID,
sum(cast(netbalance_finance as decimal(30,10) )) as ENR, 
------sum(cast(N9UOAM as decimal(30,10) )) as ENR1, 
count(CounterpartyID) as AccountsInENR, 
'31-June' as COBDATE 
from 
( 
select  -- base.*, 
gr.grip_arrears_level,
co.coff_flag,
cpt.[CounterpartyID],
base.netbalance_finance, 
-- fp.N9UOAM,
--fp.G1PAVC,
case 
when pg.product_grp in ('1','4') then 'Motor' 
when pg.product_grp in ('2','3') then 'Retail' 
else 'Unknown' 
end as ProductGroup 
-- from stg. BARCLAYCARD_IMPAIR_BASE base 
from bi.GRCR_ImpairmentFactData base
inner join [bi].[ProductCodeSCD] pc
on pc.ProductCodeAttrKeyID = base.ProductCodeAttrKey
and pc.ChangeListId = base.ProductCodeAttrChangeListId

inner join bi.G1DebtpStatusAttrSCD g1
on g1.G1DebtpStatusAttrKeyID = base.G1DebtpStatusAttrKey
and g1.ChangeListId =base.G1DebtpStatusAttrChangeListId

inner join bi.FipTypeAttrSCD fp
on fp.[FipTypeAttrKeyID] = base.FipTypeAttrKey
and fp.ChangeListId = base.FipTypeAttrChangeListId

inner join bi.BrokenInstallmentsAttrSCD bins
on bins.BrokenInstallmentsAttrKeyID = base.BrokenInstallmentsAttrKey
and bins.ChangeListId = base.BrokenInstallmentsAttrChangeListId

inner join bi.ChargeoffFlagAttrSCD co
on co.ChargeoffFlagAttrKeyID = base.ChargeoffFlagAttrKey
and co.ChangeListId = base.ChargeoffFlagAttrChangeListId

inner join [bi].[ImpairFlagAttrSCD] ifg
on ifg.ChangeListId = base.ImpairFlagAttrChangeListId
and ifg.ImpairFlagAttrKeyID = base.ImpairFlagAttrKey


left join [bi].[ProductGrpAttrSCD] pg
on pg.ChangeListId = base.ProductGrpAttrChangeListId
and pg.ProductGrpAttrKeyID = base.ProductGrpAttrKey

left join [bi].[GripArrearsLevelAttrSCD] gr
on gr.GripArrearsLevelAttrKeyID = base.GripArrearsLevelAttrKey
and gr.ChangeListId = base.GripArrearsLevelAttrChangeListId


left join bi.CounterpartyIDAttrSCD cpt
on cpt.CounterpartyIDAttrKeyID = base.CounterPartyIdAttrKey
and cpt.ChangeListId = base.CounterPartyIdAttrChangeListId



left Join bi.PlanCreateDateAttrSCD pcd
on pcd.PlanCreateDateAttrKeyID = base.PlanCreateDateAttrKey
and pcd.ChangeListId = base.PlanCreateDateAttrChangeListId
where 1 = 1
and base.netbalance_finance is not null 
-- and base.netbalance_finance <> '' 
and base.RunId = 3622
and pc.[ProductCode] is not null
and g1.[G1DebtpStatus] = 'L'
and fp.FipType = 'BSR'
and bins.BrokenInstallments = '0'
and co.coff_flag <> '1'
and ifg.impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
--and base.in_scope = 1 
--and base.coff_flag <> 1 
-- and base.run = 5000285 -- 2015-06-30 
--and base.run = 1104   -- BARCLAYCARD_IMP_STOCK_ACCT
--and noyr.Run = 1078 
 --and noyr.netbalance_finance_m127 is not null 
 --and noyr.netbalance_finance_m127 <> '' 
-- and base.account_open_month like '%JUN15%'
  --and ( pcd.[PlanCreateDate] like '%JUN2015%' 
--  or  fp.DateG1AIDX like '%JUL2015%' 
 --)
) tmp 
--order by ProductGroup

group by ProductGroup ,coff_flag ,grip_arrears_level 