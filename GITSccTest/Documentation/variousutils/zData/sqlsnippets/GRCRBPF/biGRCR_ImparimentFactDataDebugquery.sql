select RunId, count(*) 
from bi.GRCR_ImpairmentFactData 
-- where RunId=5023479
group by RunID


select x.Run, x.JobDefinitionID, x.JobDefinitionCode
		from
		(
		select  ROW_NUMBER() OVER(partition by jd.JobDefinitionId order by jr.Run desc) rownum,
		jr.Run, jr.RunStatus, jd.JobDefinitionId, jd.JobDefinitionCode   --,  -- , j.*
		
		from loader.JobDefinition jd
		inner join loader.Job j
		ON j.JobDefinitionCode = jd.JobDefinitionCode
		inner join loader.JobRun jr
		on jr.JobID  = j.JobID
		where	( 
					jd.JobDefinitionCode =  'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
					or 
					jd.JobDefinitionCode =  'BCARD_XX_BARCLAYCARD_IMPAIR_BASE'
					
				)
		and j.CobDate = '30JUn2015'
		and jr.RunStatus = 'S' --- Success
		) x
		WHERE x.rownum =  1


select top 100 * from bi.GRCR_ImpairmentFactData

SELECT   av.AtomID, av.AtomValueTypeID, av.AtomTypeID, av.Value, av.Run, av.SourceRowID
		FROM ref.atomvalue av (NOLOCK)
		where Run = 5000285
		order by AtomID
alter table bi.GRCR_ImpairmentFactData drop column RunId, RunsetId

truncate table bi.GRCR_ImpairmentFactData

select top 100 cp.CounterpartyID, accdate.account_open_month, 
gr.grip_arrears_level, im.impair_flag, pg.product_grp, 
ins.In_Scope, coff.coff_flag, impd.* 
from bi.GRCR_ImpairmentFactData impd
inner join [bi].[CounterpartyIDAttrSCD] cp
on cp.CounterpartyIDAttrKeyID = impd.CounterPartyIDAttrKey
inner join [bi].[AccountOpenDateAttrSCD] accdate
on accdate.[AccountOpenDateAttrKeyID] = impd.AccountOpenDateAttrKey
and accdate.[ChangeListId] = impd.AccountOpenDateChangeListId
inner join bi.GripArrearsLevelAttrSCD gr
on gr.[GripArrearsLevelAttrKeyID] = impd.GripArrearsLevelAttrKey
and gr.ChangeListId = impd.GripArrearsLevelAttrChangeListId
inner join [bi].[ImpairFlagAttrSCD] im
on im.ImpairFlagAttrKeyID = impd.ImpairFlagAttrKey
and im.ChangeListId = impd.ImpairFlagAttrChangeListId
inner join bi.ProductGrpAttrSCD pg
on pg.ChangeListId = impd.ProductGrpAttrChangeListId
and pg.[ProductGrpAttrKeyID] = impd.ProductGrpAttrKey
inner join [bi].[InScopeAttrSCD] ins
on ins.InScopeAttrKeyID = impd.InScopeAttrKey
and ins.ChangeListId = impd.InScopeAttrChangeListId
inner join [bi].[ChargeoffFlagAttrSCD] coff
on coff.[ChargeoffFlagAttrKeyID] = impd.ChargeoffFlagAttrKey
and coff.[ChangeListId] = impd.ChargeoffFlagAttrChangeListId
 where cp.CounterpartyID in ('1206490104778694', '0953480101569680', 
 '0414710104756311', '0414710114998929', '0414710126896020', '0930810092322798'
 
)
-- where cp.CounterpartyID =   '0953480101569680'
--  '1206490104778690'

 select top 100 * from  bi.GRCR_ImpairmentFactData  where netbalance_finance is not null
 
 where cp.CounterpartyID in ('1206490104778694', '0953480101569680')




 select top 100  pg.product_grp, coff.coff_flag, gr.grip_arrears_level,
sum(impd.netbalance_finance),
sum(impd.CounterPartyIDAttrKey)
from bi.GRCR_ImpairmentFactData impd
inner join [bi].[CounterpartyIDAttrSCD] cp
on cp.CounterpartyIDAttrKeyID = impd.CounterPartyIDAttrKey
inner join [bi].[AccountOpenDateAttrSCD] accdate
on accdate.[AccountOpenDateAttrKeyID] = impd.AccountOpenDateAttrKey
and accdate.[ChangeListId] = impd.AccountOpenDateChangeListId
inner join bi.GripArrearsLevelAttrSCD gr
on gr.[GripArrearsLevelAttrKeyID] = impd.GripArrearsLevelAttrKey
and gr.ChangeListId = impd.GripArrearsLevelAttrChangeListId
inner join [bi].[ImpairFlagAttrSCD] im
on im.ImpairFlagAttrKeyID = impd.ImpairFlagAttrKey
and im.ChangeListId = impd.ImpairFlagAttrChangeListId
inner join bi.ProductGrpAttrSCD pg
on pg.ChangeListId = impd.ProductGrpAttrChangeListId
and pg.[ProductGrpAttrKeyID] = impd.ProductGrpAttrKey
inner join [bi].[InScopeAttrSCD] ins
on ins.InScopeAttrKeyID = impd.InScopeAttrKey
and ins.ChangeListId = impd.InScopeAttrChangeListId
inner join [bi].[ChargeoffFlagAttrSCD] coff
on coff.[ChargeoffFlagAttrKeyID] = impd.ChargeoffFlagAttrKey
and coff.[ChangeListId] = impd.ChargeoffFlagAttrChangeListId
group by pg.product_grp ,coff.coff_flag ,gr.grip_arrears_level 





