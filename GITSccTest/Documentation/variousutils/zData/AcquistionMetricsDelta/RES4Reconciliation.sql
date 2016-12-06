


select * from bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta


--
-- Jan 2016
--
select top 100 eq.Eq5RiskScre1, ai.ApplicationId, x.* 
from bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta x    --- 50743730
inner join bi.Eq5RiskScre1SCD eq
on x.Eq5RiskScre1AttrKey = eq.Eq5RiskScre1AttrKeyID
inner join bi.ApplicationIdSCD ai
on ai.ApplicationIdAttrKeyID = x.ApplicationIdAttrKey
where not exists ( select top 1 1 from 
					bi.GRCR_SDS_IF023_RESULTS4_FactData z    --- 50743730
					inner join bi.Eq5RiskScre1SCD eq2
					on z.Eq5RiskScre1AttrKey = eq2.Eq5RiskScre1AttrKeyID
					inner join bi.ApplicationIdSCD ai2
					on ai2.ApplicationIdAttrKeyID = z.ApplicationIdAttrKey
					where eq.Eq5RiskScre1 = eq2.Eq5RiskScre1
					and ai.ApplicationId = ai2.ApplicationId
					and z.AuditTimestamp = x.AuditTimestamp
					and z.RunID=25525
				)
and x.IsDeleted=0


select top 100 eq.Eq5RiskScre1, ai.ApplicationId, x.* 
from bi.GRCR_SDS_IF023_RESULTS4_FactData(nolock) x    --- 50743730
inner join bi.Eq5RiskScre1SCD eq
on x.Eq5RiskScre1AttrKey = eq.Eq5RiskScre1AttrKeyID
inner join bi.ApplicationIdSCD ai
on ai.ApplicationIdAttrKeyID = x.ApplicationIdAttrKey
where not exists ( select top 1 1 from 
					bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta (nolock) z    --- 50743730
					inner join bi.Eq5RiskScre1SCD eq2
					on z.Eq5RiskScre1AttrKey = eq2.Eq5RiskScre1AttrKeyID
					inner join bi.ApplicationIdSCD ai2
					on ai2.ApplicationIdAttrKeyID = z.ApplicationIdAttrKey
					where eq.Eq5RiskScre1 = eq2.Eq5RiskScre1
					and ai.ApplicationId = ai2.ApplicationId
					and z.AuditTimestamp = x.AuditTimestamp
					and z.IsDeleted = 0
					-- and z.RunID=25525
				)
and x.RunID=25525

--
-- Jan 2016 END
--



--
-- Feb 2016
--
select top 100 eq.Eq5RiskScre1, ai.ApplicationId, x.* 
from bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta x    --- 50743730
inner join bi.Eq5RiskScre1SCD eq
on x.Eq5RiskScre1AttrKey = eq.Eq5RiskScre1AttrKeyID
inner join bi.ApplicationIdSCD ai
on ai.ApplicationIdAttrKeyID = x.ApplicationIdAttrKey
where not exists ( select top 1 1 from 
					bi.GRCR_SDS_IF023_RESULTS4_FactData z    --- 50743730
					inner join bi.Eq5RiskScre1SCD eq2
					on z.Eq5RiskScre1AttrKey = eq2.Eq5RiskScre1AttrKeyID
					inner join bi.ApplicationIdSCD ai2
					on ai2.ApplicationIdAttrKeyID = z.ApplicationIdAttrKey
					where eq.Eq5RiskScre1 = eq2.Eq5RiskScre1
					and ai.ApplicationId = ai2.ApplicationId
					and z.AuditTimestamp = x.AuditTimestamp
					and z.RunID=65437  --- Feb 2016
				)
--and x.RunID=123976
and x.IsDeleted=0


select top 100 eq.Eq5RiskScre1, ai.ApplicationId, x.* 
from bi.GRCR_SDS_IF023_RESULTS4_FactData(nolock) x    --- 50743730
inner join bi.Eq5RiskScre1SCD eq
on x.Eq5RiskScre1AttrKey = eq.Eq5RiskScre1AttrKeyID
inner join bi.ApplicationIdSCD ai
on ai.ApplicationIdAttrKeyID = x.ApplicationIdAttrKey
where not exists ( select top 1 1 from 
					bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta (nolock) z    --- 50743730
					inner join bi.Eq5RiskScre1SCD eq2
					on z.Eq5RiskScre1AttrKey = eq2.Eq5RiskScre1AttrKeyID
					inner join bi.ApplicationIdSCD ai2
					on ai2.ApplicationIdAttrKeyID = z.ApplicationIdAttrKey
					where eq.Eq5RiskScre1 = eq2.Eq5RiskScre1
					and ai.ApplicationId = ai2.ApplicationId
					and z.AuditTimestamp = x.AuditTimestamp
					and z.IsDeleted=0
					-- and z.RunID=25525
				)
and x.RunID=65437

--
-- Jan 2016 END
--









select count(*) from  bi.GRCR_SDS_IF023_RESULTS4_FactData where RunID = 25525