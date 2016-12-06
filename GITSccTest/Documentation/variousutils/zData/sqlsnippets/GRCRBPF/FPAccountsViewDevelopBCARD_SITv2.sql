With CommonCTE as ( 

select  Run as RunID ,COBDate  = convert(varchar(6), J.CobDate, 112)  , 'BPF' Portfolio 
from loader.job j 
inner join loader.JobRun jr on j.JobId = jr.JobId 
where JobDefinitionCode = 'BARCLAYCARD_LOAD_IMPAIRMENT_FACT' and JobStatus='S' and RunStatus ='S' 
) ,
BucketCTE as
(
       Select arrears_level , arrears_name, buckettype,Product,RunID,COBDate from
       (values       
       ('0' ,'FP Bucket 0: accounts', 'FPBucketAccount'),
       ('1' ,'FP Bucket 1: accounts', 'FPBucketAccount'),
       ('2' ,'FP Bucket 2: accounts', 'FPBucketAccount'),
       ('3' ,'FP Bucket 3: accounts', 'FPBucketAccount'),
       ('4' ,'FP Bucket 4: accounts', 'FPBucketAccount'),
       ('5' ,'FP Bucket 5: accounts', 'FPBucketAccount'),
       ('6' ,'FP Bucket 6: accounts', 'FPBucketAccount'),
       ('7' ,'FP >Bucket 6, not charged-off: account', 'FPBucketAccount'),
	   ('0' ,'FP Bucket 0: amount', 'FPBucketAmount'),
       ('1' ,'FP Bucket 1: amount', 'FPBucketAmount'),
       ('2' ,'FP Bucket 2: amount', 'FPBucketAmount'),
       ('3' ,'FP Bucket 3: amount', 'FPBucketAmount'),
       ('4' ,'FP Bucket 4: amount', 'FPBucketAmount'),
       ('5' ,'FP Bucket 5: amount', 'FPBucketAmount'),
       ('6' ,'FP Bucket 6: amount', 'FPBucketAmount'),
       ('7' ,'FP >Bucket 6, not charged-off: amount', 'FPBucketAmount')
       ) 
       as bucket(arrears_level , arrears_name,buckettype)
       CROSS JOIN (VALUES 
       ('Motor'),
       ('Retail')
		) AS p (Product)
		CROSS JOIN
		(SELECT RunID, COBDate from  CommonCTE) as x (RunID, COBDate)
		-- CROSS JOIN (VALUES 
  --     (3611),
  --     (3622)
		--) AS x (RunID)
),
mainCTE as
(

select z.RunId, z.Value, z.Metric,z.MetricBucketx,z.ProductGroup, z.grip_arrears_level
-- , y.arrears_name, y.Product, y.arrears_level, y.RunID
from
(
select up.RunID,Metric Value, Metrics AS Metric, up.grip_arrears_level
,
case when Metrics = 'FPBucketAmount'    and up.grip_arrears_level = 'BLANK' THEN
	'FP Bucket 0: amount'
when Metrics = 'FPBucketAmount'    and up.grip_arrears_level = 0 THEN
	'FP Bucket 0: amount'
when Metrics = 'FPBucketAmount' and up.grip_arrears_level = 1 THEN
	'FP Bucket 1: amount'
when Metrics = 'FPBucketAmount' and up.grip_arrears_level = 2 THEN
	'FP Bucket 2: amount'
when Metrics = 'FPBucketAmount' and up.grip_arrears_level = 3 THEN
	'FP Bucket 3: amount'
when Metrics = 'FPBucketAmount' and up.grip_arrears_level = 4 THEN
	'FP Bucket 4: amount'
when Metrics = 'FPBucketAmount' and up.grip_arrears_level = 5 THEN
	'FP Bucket 5: amount'
when Metrics = 'FPBucketAmount' and up.grip_arrears_level = 6 THEN
	'FP Bucket 6: amount'
when Metrics = 'FPBucketAmount' and up.grip_arrears_level > 6 THEN
	'FP >Bucket 6, not charged-off: amount'
when Metrics = 'FPBucketAccount'    and up.grip_arrears_level = 'BLANK' THEN
	'FP Bucket 0: accounts'
when Metrics = 'FPBucketAccount' and up.grip_arrears_level = 0 THEN
	'FP Bucket 0: accounts'
when Metrics = 'FPBucketAccount' and up.grip_arrears_level = 1 THEN
	'FP Bucket 1: accounts'
when Metrics = 'FPBucketAccount' and up.grip_arrears_level = 2 THEN
	'FP Bucket 2: accounts'
when Metrics = 'FPBucketAccount' and up.grip_arrears_level = 3 THEN
	'FP Bucket 3: accounts'
when Metrics = 'FPBucketAccount' and up.grip_arrears_level = 4 THEN
	'FP Bucket 4: accounts'
when Metrics = 'FPBucketAccount' and up.grip_arrears_level = 5 THEN
	'FP Bucket 5: accounts'
when Metrics = 'FPBucketAccount' and up.grip_arrears_level = 6 THEN
	'FP Bucket 6: accounts'
when Metrics = 'FPBucketAccount' and up.grip_arrears_level > 6 THEN
	'FP >Bucket 6, not charged-off: accounts'
end MetricBucketx,
up.ProductGroup
--,
--y.arrears_name, y.arrears_level, y.buckettype
FROM
(
select x.RunID, x.COBdate, x.ProductGroup, x.grip_arrears_level grip_arrears_level, x.FPBucketAmount, x.FPBucketAccount   --- , bk.arrears_name, bk.Product

from 
(
select tmp.ProductGroup, tmp.grip_arrears_level, 
tmp.coff_flag, 
--cast(tmp.netbalance_finance as decimal(30,10) ) ENR,
--tmp.CounterpartyID,
cast(sum(cast(netbalance_finance as decimal(28,8) )) as decimal(28,8)) as FPBucketAmount, 
------sum(cast(N9UOAM as decimal(30,10) )) as ENR1, 
cast(count(CounterpartyID) as decimal(28,8)) as FPBucketAccount, 
'31-June' as COBDATE ,
tmp.RunID
from 
( 
select  base.RunID,
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

--inner join bi.G1DebtpStatusAttrSCD g1
--on g1.G1DebtpStatusAttrKeyID = base.G1DebtpStatusAttrKey
--and g1.ChangeListId =base.G1DebtpStatusAttrChangeListId

--left join bi.FipTypeAttrSCD fp
--on fp.[FipTypeAttrKeyID] = base.FipTypeAttrKey
--and fp.ChangeListId = base.FipTypeAttrChangeListId

--left join bi.BrokenInstallmentsAttrSCD bins
--on bins.BrokenInstallmentsAttrKeyID = base.BrokenInstallmentsAttrKey
--and bins.ChangeListId = base.BrokenInstallmentsAttrChangeListId

inner join bi.ChargeoffFlagAttrSCD co
on co.ChargeoffFlagAttrKeyID = base.ChargeoffFlagAttrKey
and co.ChangeListId = base.ChargeoffFlagAttrChangeListId

left join [bi].[ImpairFlagAttrSCD] ifg
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
-- and base.RunId = 3622
and pc.[ProductCode] is not null
and base.RunIdG1Debtp is null 
--and g1.[G1DebtpStatus]  <> 'L' -- = 'L'
--and fp.FipType <> 'BSR' -- = 'BSR'
--and bins.BrokenInstallments <> '0' --  = '0'
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
group by RunId, ProductGroup ,coff_flag ,grip_arrears_level 
) x
) cp
	UNPIVOT
				(
				Metric FOR Metrics in ([FPBucketAmount],[FPBucketAccount])
				) AS UP
) z
)
select ss.*, y.RunID, y.Product, y.arrears_name, y.arrears_level
from mainCTE ss
right join BucketCTE y on y.arrears_level = ss.grip_arrears_level
and y.Product = ss.ProductGroup
and y.arrears_name = ss.MetricBucketx
 and y.RunID = ss.RunID
 where y.RunID is not null
 and exists (select top 1 1 from mainCTE tt where tt.RunID = y.RunID)
 -- and z.Metric is not null
 -- and z.RunId is not null