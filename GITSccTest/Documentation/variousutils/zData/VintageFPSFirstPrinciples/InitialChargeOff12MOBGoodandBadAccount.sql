

----
--- Account in charge-off not coming through
---
select count(*) from bi.GRCR_VintageChargeOffFPFactData where RunID=98642


--select top 100 * from bi.GRCR_ImpairmentFactData x
--inner join bi.CounterPartyIDSCD cp on


select top 100 z.* 
from stg.BPF_JAY_BPF_FP_ACC z
where z.Account_Number = '0531650108674797'

select top 100 j.CobDate, f.* 
from bi.GRCR_VintageChargeOffFPFactData f
INNER JOIN loader.JobRun JR (NOLOCK) 
				ON f.RunId = Jr.run
			INNER JOIN loader.Job J (NOLOCK) 
				ON JR.JobId = J.JobID
where f.AccountNumber = '0531650108674797'

 select top 100 j.CobDate, x.* 
 from stg.BARCLAYCARD_IMPAIR_BASE(nolock) x 
 inner join loader.JobRun jr
 on jr.Run = x.Run
 inner join loader.Job j
 on j.JobId = jr.JobId
 where Account_No in ( '0531650108674797', '0525540113616867')
 order by j.CobDate desc


 --select top 100 j.COBDate, cp.CounterpartyID, pcd.PlanCreateDate, aod.account_open_month, x.* 
 --from bi.GRCR_ImpairmentFactData x
 --inner join bi.CounterpartyIDAttrSCD cp
 --on cp.CounterpartyIDAttrKeyID = x.CounterPartyIdAttrKey
 -- inner join loader.JobRun jr
 --on jr.Run = x.RunID
 --inner join loader.Job j
 --on j.JobId = jr.JobId
 --inner join  bi.PlanCreateDateAttrSCD pcd
 --on pcd.PlanCreateDateAttrKeyID = x.PlanCreateDateAttrKey
 --inner join bi.AccountOpenDateAttrSCD aod
 --on aod.AccountOpenDateAttrKeyID = x.AccountOpenDateAttrKey
 --where cp.CounterpartyID in ( '0531650108674797', '0525540113616867')
 --order by cp.CounterpartyID, j.COBDate desc

 select top 10 j.CobDate, x.* 
 from stg.BPF_JAY_BPF_FP_ACC x
 inner join loader.JobRun jr
 on jr.Run = x.Run
 inner join loader.Job j
 on j.JobId = jr.JobId
 where x.Account_Number in ( '0531650108674797', '0525540113616867')


  select top 100 j.CobDate, x.* 
 from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR(nolock) x
 inner join loader.JobRun jr
 on jr.Run = x.Run
 inner join loader.Job j
 on j.JobId = jr.JobId
 where Account_No in ( '0531650108674797', '0525540113616867')
 order by j.CobDate desc, x.Account_No

 select j.CobDate, t.* 
 from stg.BPF_CHARGEOFF_DATA  t
 inner join loader.JobRun jr
 on jr.Run = t.Run
 inner join loader.Job j
 on j.JobId = jr.JobId
 where Account_No in ( '0531650108674797', '0525540113616867')
 order by j.CobDate desc, t.Account_No
 





  select top 100 j.CobDate, x.* 
 from bi.GRCR_ImpairmentFactData x 
 inner join loader.JobRun jr
 on jr.Run = x.Run
 inner join loader.Job j
 on j.JobId = jr.JobId
 where Account_No in ( '0531650108674797')
 order by j.CobDate desc

 -- 11688






0531650108674797

	Select top 100
		--RunID ,
		----CTE.ProductGroupDescription,
		--CounterpartyID as AccountNumber,
		--convert(Varchar(6),J.CobDate,112) as COBDate,
		--netbalance_finance as Value,
		--J.CobDate as CurrentReportingMonth,
		----Convert(Date,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,J.CobDate),0))) as PreviousReportingMonth
		--, PRODESC.ProductDescription
		j.COBDate, FACT.*
	from bi.GRCR_ImpairmentFactData FACT
	
			INNER JOIN loader.JobRun JR (NOLOCK) 
				ON FACT.RunId = Jr.run
			INNER JOIN loader.Job J (NOLOCK) 
				ON JR.JobId = J.JobID
				/*
			INNER JOIN bi.ImpairFlagAttrSCD IMPF
				on FACT.ImpairFlagAttrKey = IMPF.ImpairFlagAttrKeyID
					AND FACT.ImpairFlagAttrChangeListId = IMPF.ChangeListId
					AND IMPF.impair_flag not in ('Cetelem','HLC','Euro','5','4','3')
			INNER JOIN bi.ChargeoffFlagAttrSCD CHRF
				on FACT.ChargeoffFlagAttrKey = CHRF.ChargeoffFlagAttrKeyID
					AND FACT.ChargeoffFlagAttrChangeListId = CHRF.ChangeListId
					AND CHRF.coff_flag='1'
			INNER JOIN [bi].[ProductGrpAttrSCD] PGRP
				on FACT.ProductGrpAttrKey = PGRP.ProductGrpAttrKeyID
					AND FACT.ProductGrpAttrChangeListId = PGRP.ChangeListId
			INNER JOIN CTE_ProdGroupLookup CTE
				on PGRP.product_grp = CTE.ProductCode
		*/
			INNER JOIN bi.CounterpartyIDAttrSCD CPTY
				on FACT.CounterpartyIdAttrKey = CPTY.CounterpartyIDAttrKeyID
					AND FACT.CounterpartyIdAttrChangeListId = CPTY.ChangeListId
			--LEFT JOIN bi.AccountProductDescriptionAttrSCD PRODESC
			--	ON CPTY.CounterpartyID  = PRODESC.AccountNumber
			--LEFT JOIN entity.History HIS
			--	ON HIS.EntityKey = PRODESC.ApplicationBPFAttrKeyID
			--	AND HIS.EffectiveFromDateTime <= J.CobDate
			--	AND HIS.EffectiveToDateTime >= J.CobDate	
where --runid=119967
	--and 
	CounterpartyID='0531650108674797'


	--61570926

	Select top 100 * from bi.ChargeoffFlagAttrSCD

	/*
	61570925	0	96
	61570926	1	96
	*/

Select max(runid) from bi.GRCR_ImpairmentFactData 