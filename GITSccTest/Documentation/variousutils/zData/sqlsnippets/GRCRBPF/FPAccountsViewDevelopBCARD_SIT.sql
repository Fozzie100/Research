--select  Run as RunID ,COBDate  = convert(varchar(6), J.CobDate, 112)  , 'BPF' Portfolio 
--from loader.job j 
--inner join loader.JobRun jr on j.JobId = jr.JobId 
--where JobDefinitionCode = 'BARCLAYCARD_LOAD_IMPAIRMENT_FACT' and JobStatus='S' and RunStatus ='S' 
With CommonCTE as ( 

select  Run as RunID ,COBDate  = convert(varchar(6), J.CobDate, 112)  , 'BPF' Portfolio 
from loader.job j 
inner join loader.JobRun jr on j.JobId = jr.JobId 
where JobDefinitionCode = 'BARCLAYCARD_LOAD_IMPAIRMENT_FACT' and JobStatus='S' and RunStatus ='S' 
) ,
BucketCTE as
(
       Select arrears_level , arrears_name,Product,RunID,COBDate from
       (values       
       ('0' ,'Bucket 0: account'),
       ('1' ,'Bucket 1: account'),
       ('2' ,'Bucket 2: account'),
       ('3' ,'Bucket 3: account'),
       ('4' ,'Bucket 4: account'),
       ('5' ,'Bucket 5: account'),
       ('6' ,'Bucket 6: account'),
       ('7' ,'>Bucket 6, not charged-off: account'),
	   ('0' ,'Bucket 0: amount'),
       ('1' ,'Bucket 1: amount'),
       ('2' ,'Bucket 2: amount'),
       ('3' ,'Bucket 3: amount'),
       ('4' ,'Bucket 4: amount'),
       ('5' ,'Bucket 5: amount'),
       ('6' ,'Bucket 6: amount'),
       ('7' ,'>Bucket 6, not charged-off: amount')
       ) 
       as bucket(arrears_level , arrears_name)
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
)
-- select * from BucketCTE
,
mainCTE AS
(
select x.RunID, x.COBdate, x.ProductGroup, x.grip_arrears_level, x.ENR, x.AccountsInENR   --- , bk.arrears_name, bk.Product
from 
(
select tmp.ProductGroup, tmp.grip_arrears_level, 
tmp.coff_flag, 
--cast(tmp.netbalance_finance as decimal(30,10) ) ENR,
--tmp.CounterpartyID,
sum(cast(netbalance_finance as decimal(30,10) )) as ENR, 
------sum(cast(N9UOAM as decimal(30,10) )) as ENR1, 
count(CounterpartyID) as AccountsInENR, 
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
-- and base.RunId = 3622
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
group by RunId, ProductGroup ,coff_flag ,grip_arrears_level 
) x

)
--select y.COBDATE, x.RunID, x.ENR, x.AccountsInENR, x.grip_arrears_level, x.ProductGroup  ,y.arrears_level, y.arrears_name, y.RunID, y.Product
--from MainCTE x
--right join BucketCTE y on y.arrears_level = x.grip_arrears_level
--and y.Product = x.ProductGroup
select up.COBDATE,  Metric Value, up.RunIdx
from
(
select y.COBDATE, x.RunID, x.ENR, x.AccountsInENR, x.grip_arrears_level, x.ProductGroup  ,y.arrears_level, y.arrears_name, y.RunID RunIDx, y.Product,
case when y.arrears_level = 0 then
	ENR
END [FP Bucket 0: amount],
case when y.arrears_level = 1 then
	ENR
END [FP Bucket 1: amount],
case when y.arrears_level = 2 then
	ENR
END [FP Bucket 2: amount],
case when y.arrears_level = 3 then
	ENR
END [FP Bucket 3: amount],
case when y.arrears_level = 4 then
	ENR
END [FP Bucket 4: amount],
case when y.arrears_level = 5 then
	ENR
END [FP Bucket 5: amount],
case when y.arrears_level = 6 then
	ENR
END [FP Bucket 6: amount],
case when y.arrears_level = 0 then
	ENR
END [FP Bucket 0: accounts],
case when y.arrears_level = 1 then
	ENR
END [FP Bucket 1: accounts],
case when y.arrears_level = 2 then
	ENR
END [FP Bucket 2: accounts],
case when y.arrears_level = 3 then
	ENR
END [FP Bucket 3: accounts],
case when y.arrears_level = 4 then
	ENR
END [FP Bucket 4: accounts],
case when y.arrears_level = 5 then
	ENR
END [FP Bucket 5: accounts],
case when y.arrears_level = 6 then
	ENR
END [FP Bucket 6: accounts]

from MainCTE x
right join BucketCTE y on y.arrears_level = x.grip_arrears_level
and y.Product = x.ProductGroup
) cp
UNPIVOT 
(
				Metric FOR Metrics in ([FP Bucket 0: accounts],[FP Bucket 0: amount],
										[FP Bucket 1: accounts],[FP Bucket 1: amount],
										[FP Bucket 2: accounts],[FP Bucket 2: amount],
										[FP Bucket 3: accounts],[FP Bucket 3: amount],
										[FP Bucket 4: accounts],[FP Bucket 4: amount],
										[FP Bucket 5: accounts],[FP Bucket 5: amount],
										[FP Bucket 6: accounts],[FP Bucket 6: amount]
										--,[FP >Bucket 6, not charged-off: accounts], [FP >Bucket 6, not charged-off: amount]

				
				)
				) AS UP






















union 
select COBDate,RunID,ENR,AccountsInENR,grip_arrears_level, ProductGroup  ,arrears3,arrearsname,runid2
from (values ('31-June',8787,0,0,7 , 'ProdGroup', 'arrearslevel3', 'arrearsname',7878))  
as bucket(COBDate,RunID,ENR,AccountsInENR,grip_arrears_level,ProductGroup, arrears3, arrearsname, runid2)
where not exists ( select top 1 1 from 
					MainCTE y where y.grip_arrears_level = grip_arrears_level
					and )
--right join BucketCTE y on y.arrears_level = x.grip_arrears_level
--and y.Product = x.ProductGroup
-- select 'Motor', 0, 0,0,0, '31-June'


--  x.COBdate, x.ProductGroup, x.grip_arrears_level, x.ENR, x.AccountsInENR 