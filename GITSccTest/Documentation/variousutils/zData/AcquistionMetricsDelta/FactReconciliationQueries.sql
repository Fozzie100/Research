
exec bi.uspLoadDimensionDataWrapper @p_Run=120351

select top 10000 * from log.log(nolock) 
where 1 = 1
and Run= -140 -- 118704 117889
and CreateDate > '04 Apr 2016'
and LogID >  61929911 -- 61643971 -- 61627346 --61553278    -- 61508853 -- initial lofs with deadlocks
-- and ( LogCategory like 'PROC.ERR%' or LogMessage like '%deadlock%')
--and SPID=209
-- order by LogMessage desc
-- and LogMessage like '%row(s) into bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta Table%'
order by CreateDate desc

select count(*) from ref.AtomValue(nolock)
where Run=117889   --- 61990148
select count(*) from ref.AtomValue(nolock)
where Run=118704

select count(*) from ref.AtomValue (nolock) where Run=116549
select * from loader.JobDefinition where 
 1 = 1 
-- and JobDefinitionCode like '%DELTA%'
and JobDefinitionCode like 'ACQ%'

exec bi.uspLoadDimensionDataWrapper @p_Run=116549

select y.ApplicationIdAttrKey ApplicationIdAttrKeyRes4, AP.ApplicationId, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
inner join bi.GRCR_SDS_IF023_RES1_FactDataDelta y
on y.ApplicationIdAttrKey = x.ApplicationIdAttrKey
and y.AuditTimestamp = x.AuditTimestamp
and y.IsDeleted=0
inner join bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta z
on z.ApplicationIdAttrKey = x.ApplicationIdAttrKey
and z.AuditTimestamp = x.AuditTimestamp
and z.IsDeleted=0
where x.IsDEleted  = 0
and '31 Jan 2016' between x.EffectiveFromDateTime and x.EffectiveToDateTime

select * from stg.SDS_IF023_APP_DELTA
where Run=17

select * from stg.SDS_IF023_APP_DELTA
and '01 Feb 2016' between EffectiveFromDateTime and EffectiveToDateTime

select * from stg.SDS_IF023_APP_DELTA
where Run=17


select * from bi.ApplicationIdSCD where ApplicationId='99999902'
select top 10 * from entity.ApplicationIdAttr where ApplicationId='99999902'

select top 10 * from entity.History (nolock)
select top 20 * from changenotification.Item (nolock) where EntityTypeId=167

select top 20 * from bi.ChangeList where ChangeListId=5


select AP.ApplicationId,
er.EraScre, 
ms.MainScorReqdNodeId,
  apt.AppType, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_RES1_FactDataDelta x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
inner join bi.EraScreSCD er
on er.EraScreAttrKeyID = x.EraScreAttrKey
inner join bi.MainScorReqdNodeIdSCD ms
on ms.MainScorReqdNodeIdAttrKeyID = x.MainScorReqdNodeIdAttrKey
inner join bi.AppTypeSCD apt
on apt.AppTypeAttrKeyID = x.AppTypeAttrKey
--and IsDeleted=0 
order by AP.ApplicationId
where x.ApplicationIdAttrKey = 1837714
and x.RunId=22


select AP.ApplicationId,
apt.Eq5RiskScre1, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
inner join bi.Eq5RiskScre1SCD apt
on apt.Eq5RiskScre1AttrKeyID = x.Eq5RiskScre1AttrKey
and IsDeleted=0 
order by AP.ApplicationId


select y.* 
from stg.SDS_IF023_RES4_DELTA y
where Run = 32

select y.* 
from stg.SDS_IF023_RES1_DELTA y
where Run > 24

select y.* 
from stg.SDS_IF023_APP_DELTA y
where Run > 11


sp_help 'bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta'
sp_help 'bi.GRCR_SDS_IF023_RES1_FactDataDelta'
sp_help 'bi.GRCR_SDS_IF023_APPlication_FactDataDelta'

ONSTRAINT [PK_bi_GRCR_SDS_IF023_RES1_DELTA_FactData] PRIMARY KEY CLUSTERED ([RunId, GRCR_SDS_IF023_RES1_DELTA_KEY] ASC)
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)) 
	
		PRINT 'CREATED bi.GRCR_SDS_IF023_RES1_FactDataDelta'
END

alter table bi.GRCR_SDS_IF023_RES1_FactDataDelta drop constraint PK_bi_GRCR_SDS_IF023_RES1_DELTA_FactData
alter table bi.GRCR_SDS_IF023_RES1_FactDataDelta
add constraint PK_bi_GRCR_SDS_IF023_RES1_DELTA_FactData PRIMARY KEY CLUSTERED (RunId, GRCR_SDS_IF023_RES1_DELTA_KEY ASC)

IF NOT EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'PK_bi_GRCR_SDS_IF023_RES1_DELTA_FactData') 
CREATE PRIMARY KEY CLUSTERED PK_bi_GRCR_SDS_IF023_RES1_DELTA_FactData    ON bi.GRCR_SDS_IF023_RES1_FactDataDelta (ApplicationIdAttrKey, AuditTimestamp);


select * from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta
truncate table bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta


select * from loader.JobRun where Run in (6,7,9)

declare @COBDate DATE = '31 Dec 2015',
		@p_Run INT = 9999,
		@JobDefinitionCode VARCHAR(64) = 'ACQ_SDS_IF023_APPLICATION_DELTA'

begin tran
update loader.JobRun
set RunStatus = 'F'
where Run in (6,7,9)


commit

 SELECT Top 1  jr.Run
		 FROm loader.JobRun jr
		 INNER JOIN loader.Job j
		 ON j.JobId = jr.JobId
		 and j.JobDefinitionCode = @JobDefinitionCode
		 where jr.RunStatus = 'F'
		-- and j.JobStatus = 'S'   -- pick up previous file with same asofdate if necessary 
		 and j.CobDate <= @COBDate
		 and jr.Run <> @p_Run
		 order by j.Cobdate DESC, jr.Run DESC

		 rollback


		 	select * from log.log where Run=19
	order by Createdate desc


select top 1000 AP.ApplicationId, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
and x.IsDeleted=0
and Getdate() between x.EffectiveFromDateTime and x.EffectiveToDateTime
and RunID <> 116549


select ap.ApplicationId, count(*) cnt
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
where x.IsDeleted=0
and Getdate() between x.EffectiveFromDateTime and x.EffectiveToDateTime
and RunID <> 116549
group by ap.ApplicationId
having count(*) > 1

select top 1000 AP.ApplicationId, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
-- and x.IsDeleted=0
and Getdate() between x.EffectiveFromDateTime and x.EffectiveToDateTime
-- and RunID <> 116549
and ap.ApplicationId in (51613311,51485904,51454607)

select top 10 * from entity.EntityType where EntityTypeCode like '%Application%'
select * from mapping.Mapping where EntityTypeID=198
and ValueString = '51613311;'
--263557839
--263559392

select * from entity.History where EntityKey in  (263557839,
263559392)


begin tran
update bi.GRCR_SDS_IF023_APPLICATION_FactData
set ApplicationIdAttrKey = -5
where ApplicationIdAttrKey in (165579667)
and AuditTimestamp = 41402.90106481
and RunId = 24072



--
--
-- Reconciliation reports
--
SELECT z.*, apx.ApplicationId
into #prevAppfact
from 
					bi.GRCR_SDS_IF023_APPLICATION_FactData (nolock) z
					inner join bi.ApplicationIdSCD apx
					on apx.ApplicationIdAttrKeyID = z.ApplicationIdAttrKey
					where RunID = 24072     --- Jan 2016

CREATE NONCLUSTERED INDEX IX_App_ID_SCD ON bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta (ApplicationIdAttrKey)
drop index  IX_App_ID ON #prevAppfact
CREATE CLUSTERED INDEX IX_App_CLUST_ID ON #prevAppfact (ApplicationId)

select top 1000 AP.ApplicationId, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta (nolock) x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
and x.IsDeleted=0
and '31 Jan 2016' between x.EffectiveFromDateTime and x.EffectiveToDateTime
where 1 = 1
-- and  x.ApplicationIdAttrKey = 165579667
-- and  x.ApplicationIdAttrKey = 263480358
-- and x.ApplicationIdAttrKey = 263480134
 and not exists (	select top 1 1 
					from 
					#prevAppfact (nolock) z
					where z.ApplicationID = AP.ApplicationId
					and ABS(CAST(x.AuditTimestamp as decimal(28,8))) - ABS(CAST(z.AuditTimestamp as decimal(28,8))) < 0.0000001
					-- and x.ApplicationIdAttrKey = z.ApplicationIdAttrKey
					and RunID = 24072
				)

alter table bi.GRCR_SDS_IF023_APPLICATION_FactData drop constraint PK_bi_GRCR_SDS_IF023_APPLICATION_FactData
create CLUSTERED INDEX PK_bi_GRCR_SDS_IF023_APPLICATION_FactData ON bi.GRCR_SDS_IF023_APPLICATION_FactData (RunID,  ApplicationIdAttrKey)
ALTER TABLE stg.#SDS_IF023_APP_Work ADD  CONSTRAINT pk_SDSIF023APPWork_RowID PRIMARY KEY(RowID)

				sp_help 'bi.GRCR_SDS_IF023_APPLICATION_FactData'


--263557839
--263559392



select  top 10
z.ApplicationIdAttrKey ApplicationIdAttrKeyprod, 
AP.ApplicationId, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
and x.IsDeleted=0
and '31 Jan 2016' between x.EffectiveFromDateTime and x.EffectiveToDateTime
left join bi.GRCR_SDS_IF023_APPLICATION_FactData z
on z.ApplicationIdAttrKey = x.ApplicationIdAttrKey
and x.AuditTimestamp = z.AuditTimestamp
and  z.RunId = 24072
inner join bi.ApplicationIdSCD ap2 on ap2.ApplicationIdAttrKeyID = z.ApplicationIdAttrKey
-- where x.ApplicationIdAttrKey = 165579667
where   z.ApplicationIdAttrKey is  null

--41402.90106481
--41402.90106481

select g.* from bi.GRCR_SDS_IF023_APPLICATION_FactData g
where g.RunId=24072
and g.ApplicationIdAttrKey=165579667

commit
rollback					
-- and RunID <> 116549
-- and ap.ApplicationId in (51613311,51485904,51454607)