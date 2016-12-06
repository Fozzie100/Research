
select top 100 * from bi.GRCR_BARCLAYCARD_APPLICATION_FactData
select top 100 * from [stg].[SDS_IF023_RES1]


select Run, count(*) cnt
from [stg].[SDS_IF023_RES1]
 -- where run in(25273,25524)
group by Run

select 50743765 - 50382185

run=25273;Date=201512, 25524


select Application_ID, count(*) cnt
from [stg].[SDS_IF023_RES1]
where run=25273
group by Application_ID having count(*) > 1

select s.*, j.JobDefinitionCode, j.CobDate
from [stg].[SDS_IF023_RES1] s(nolock)
inner join loader.JobRun jr
on jr.Run = s.Run
inner join loader.Job j
on j.JobId = jr.JobId
where s.run  in (4128,5103,5695,6231,25273, 25524) and s.Application_ID
IN (
41179350,
37295759,
45215726,
8037892,
30857998
)
order by s.Run,  s.Application_ID, s.Audit_Timestamp desc


sp_help 'stg.SDS_IF023_RES1'


select top 10 * from loader.JobDefinition where convert(varchar(max), JobDefinitionConfig) like '%SDS_IF023_RES1%'
select top 10 * from loader.JobDefinition where convert(varchar(max), JobDefinitionConfig) like '%ACCOUNT_LINKING%'


bi.uspLoadGRCR_SDS_IF023_RES1_FactData
ref.uspProcessSDS_IF023_RES1_Atomise
select top 100 * from bi.GRCR_SDS_IF023_APPLICATION_FactData


-- 
-- [stg].[SDS_IF023_RES1] analysis
--
select x.*, j.CobDate
from
(
select Run, count(*) cnt
from [stg].[SDS_IF023_RES1] (nolock)
-- where run in(25273,25524)
group by Run
) x
inner join loader.JobRun jr
on jr.Run = x.Run
inner join loader.Job j
on j.JobId = jr.JobId

select top 100 * from stg.SDS_IF023_RES1 where Run=25273
and Application_ID = '36136390'
and ISNUMERIC(CAST(CONVERT(datetime, Audit_Timestamp + '000', 121) as decimal(28,8))) != 1
--Run	cnt	CobDate
--5103	48611288	2015-07-31
--25273	50382185	2015-12-31   *******
--4128	48611288	2015-06-30
--25524	50743765	2016-01-31   *******
--5695	1063244		2015-12-31
--6231	50382185	2015-12-31  

select s.*, j.JobDefinitionCode, j.CobDate
from [stg].[SDS_IF023_RES1] s(nolock)
inner join loader.JobRun jr
on jr.Run = s.Run
inner join loader.Job j
on j.JobId = jr.JobId
--where s.run  in (4128,5103,5695,6231,25273, 25524, 65233) and s.Application_ID
where s.run  in (25524, 65233) and s.Application_ID
IN (
41179350,
37295759,
45215726,
8037892,
30857998
)
order by s.Run,  s.Application_ID, s.Audit_Timestamp desc

select top 1000 * from [stg].[SDS_IF023_RES1] s (nolock)
where s.Run in (25524, 65233)
and
(
 ( s.APP_TYPE is null or s.Application_ID is null or s.ERA_SCRE is null
		or s.MAIN_SCOR_REQD_NODE_ID is null or s.Audit_Timestamp is null
	) 
or (
s.APP_TYPE = '' or s.Application_ID = '' or s.ERA_SCRE = ''
		or s.MAIN_SCOR_REQD_NODE_ID = '' or s.Audit_Timestamp = ''
)
or ( ISNUMERIC(s.APP_TYPE) = 0 or   ISNUMERIC(s.ERA_SCRE) = 0 or ISNUMERIC(s.MAIN_SCOR_REQD_NODE_ID) = 0 )

)

select top 1000 * from [stg].[SDS_IF023_RES1] s (nolock)
where s.Run in (25524)
and s.Application_ID = '41179350'

select mast.*
into #deltarows
from [stg].[SDS_IF023_RES1] mast
where mast.Run = 25524  -- as of '31 Jan 2016'
and not exists (select top 1 1 from [stg].[SDS_IF023_RES1] child
				where child.APP_TYPE=mast.APP_TYPE
				and  child.ERA_SCRE =mast.ERA_SCRE
				and child.MAIN_SCOR_REQD_NODE_ID = mast.MAIN_SCOR_REQD_NODE_ID
				and child.Application_ID = mast.Application_ID
				and child.Audit_Timestamp = mast.Audit_Timestamp
				and child.Run=25273 -- as of '31 Dec 2015'
				)


				-- 361580 rows


select Application_ID, count(*) cnt
from #deltarows
group by Application_ID
having count(*) = 2

select top 1000 * from #deltarows where Application_ID='52649614' order by Audit_Timestamp desc

select top 1000 * from [stg].[SDS_IF023_RES1] where Application_ID='52649614' and Run = 25524 order by Audit_Timestamp desc
select top 1000 * from [stg].[SDS_IF023_RES1] where Application_ID='52649614' and Run = 25273 order by Audit_Timestamp desc


DECLARE @DATE datetime = '27 Jan 1900 00:00:05',
		@datedecimal decimal(28,8)


select @datedecimal = convert(decimal(28,8), @DATE)



select mast.*
into #deltarowsdeleted
from [stg].[SDS_IF023_RES1] mast
where mast.Run = 25273 -- as of '31 Dec 2015'  --- 25524  -- as of '31 Jan 2016'
and not exists (select top 1 1 from [stg].[SDS_IF023_RES1] child
				where child.APP_TYPE=mast.APP_TYPE
				and  child.ERA_SCRE =mast.ERA_SCRE
				and child.MAIN_SCOR_REQD_NODE_ID = mast.MAIN_SCOR_REQD_NODE_ID
				and child.Application_ID = mast.Application_ID
				and child.Audit_Timestamp = mast.Audit_Timestamp
				and child.Run= 25524  -- as of '31 Jan 2016' -- 25273 -- as of '31 Dec 2015'
				)



				select mast.* 
				from [stg].[SDS_IF023_RES1] mast
				where mast.Run = 25524

select * from  [stg].[SDS_IF023_RES1] mast
where mast.Run in ( 25273, 25524)
and (
 mast.APP_TYPE is null 
 or mast.ERA_SCRE is null
or mast.MAIN_SCOR_REQD_NODE_ID is null
or mast.Application_ID is null
 or mast.Audit_Timestamp is null
 )


 -- 
 --  RES 4 processing
 --
 select top 1000 * from [stg].[SDS_IF023_RES4]

select x.*, j.CobDate
from
(
select Run, count(*) cnt
from [stg].[SDS_IF023_RES4] (nolock)
-- where run in(25273,25524)
group by Run
) x
inner join loader.JobRun jr
on jr.Run = x.Run
inner join loader.Job j
on j.JobId = jr.JobId

--Run	cnt	CobDate
--5100	48611288	2015-07-31
--25271	50382185	2015-12-31   ***
--6230	50382185	2015-12-31
--25525	50743765	2016-01-31   ***
--2723	48611288	2015-06-30

--Run	cnt	CobDate
--5100	48611288	2015-07-31
--2723	48611288	2015-06-30
--25271	50382185	2015-12-31
--25525	50743765	2016-01-31
--65437	51158793	2016-02-29

select x.*, j.CobDate
from
(
select RunID, count(*) cnt
from [bi].[GRCR_SDS_IF023_RESULTS4_FactData] (nolock)
-- where run in(25273,25524)
group by RunID
) x
inner join loader.JobRun jr
on jr.Run = x.RunID
inner join loader.Job j
on j.JobId = jr.JobId

select Application_ID, count(*) cnt
from [stg].[SDS_IF023_RES4] where Run= 25525
group by Application_ID
having count(*) > 20

select * from [stg].[SDS_IF023_RES4]
where Application_ID = 127220
and Run=25525 
order by Audit_Timestamp desc


select top 100 * from [bi].[GRCR_SDS_IF023_APPLICATION_FactData]

select top 10 * from loader.JobDefinition where CONVERT(varchar(max), JobDefinitionConfig) like '%uspLoadGRCR_SDS_IF023_APPLICATION_FactData%'
select top 10 * from loader.JobDefinition where CONVERT(varchar(max), JobDefinitionConfig) like '%GRCR_SDS_IF023_APPLICATION_FactData%'
select top 10 * from loader.JobDefinition where JobDefinitionCode like '%SDS_IF023_APPLICATION%'
select top 10 * from loader.JobDefinition where JobDefinitionCode like '%ACQ_SDS_IF023_RES1%'

select top 100 * from bi.GRCR_BARCLAYCARD_APPLICATION_FactData


--
-- [stg].[SDS_IF023_APP] analysis
-- 

select top 1  MAX(RunId ) from bi.RunSetsXRun r inner join loader.jobdefinition d on r.JobDefinitionID = d.JobDefinitionID
			where JobDefinitionCode = 'ACQ_SDS_IF023_Application' and  RunsetId =  -1

			select top 100 * from bi.JobSetsXJob where JobDefinitionId=137
			select top 10 * from bi.JobSets where JobSetID=14
			select top 10 * from bi.RunSets where JobSetID=14
			select top 100 * from loader.JobDefinition where JobDefinitionCode = 'ACQ_SDS_IF023_Application'

select x.*, j.CobDate, jr.*, j.JobStatus
from
(
select Run, count(*) cnt
from [stg].[SDS_IF023_APP] (nolock)
-- where run in(25273,25524)
group by Run
) x
inner join loader.JobRun jr
on jr.Run = x.Run
inner join loader.Job j
on j.JobId = jr.JobId
--Run	cnt	CobDate
--4127	48925840	2015-06-30
--5101	48925840	2015-07-31
--24072	50743765	2016-01-31   ****
--25270	34160000	2015-12-31   ***
--5694	34160000	2015-12-31

select Application_ID, count(*) cnt
from [stg].[SDS_IF023_APP](nolock) where Run= 24072
group by Application_ID
having count(*) > 20



select top 10 * from [stg].[SDS_IF023_APP](nolock) 
where 1 = 1
and Run=  25270  -- 24072 Jan 2016   25270 Dec 2015
and Application_ID = 37295759 --37295759  -- 1416315
-- and (Application_ID is null or Audit_Timestamp is null)
order by Audit_Timestamp desc

select top 10  * from [stg].[SDS_IF023_RES4]
where 1 =1
and Application_ID = 37295759 --37295759 -- 1416315
and Run=   25271 -- 25525  Jan 2016  25271 Dec 2015
-- and ( EQ5_RISK_SCRE_1 is null or Application_ID is null or Audit_Timestamp is null)
order by Audit_Timestamp desc

select * from [stg].[SDS_IF023_RES1]
where Application_ID = 37295759 --37295759 --- 1416315
and Run=  6231 -- 25524  Jan 2016    6231 Dec 2015
order by Audit_Timestamp desc


-- 
-- Get all  Application_ID from SDS_IF023_APP which dont exist on RES1 or res 4
-- for Dec 2015 run
select x.Application_ID, x.Audit_TimestampMax
from 
(
select Application_ID, MAX(Audit_Timestamp) Audit_TimestampMax
from [stg].[SDS_IF023_APP](nolock) 
where 1 = 1
and Run=  25270 
group by Application_ID
) x
where not exists (select top 1 1 from [stg].[SDS_IF023_RES4](nolock)  z where z.Application_ID = x.Application_ID and z.Audit_Timestamp = x.Audit_TimestampMax and Run=25271)
or not exists (select top 1 1 from [stg].[SDS_IF023_RES1](nolock)  z where z.Application_ID = x.Application_ID and z.Audit_Timestamp = x.Audit_TimestampMax and Run=6231)


--
-- [bi].[GRCR_BARCLAYCARD_APPLICATION_FactData ] analysis
-- 

select x.*, j.CobDate
from
(
select RunID, count(*) cnt
from [bi].[GRCR_BARCLAYCARD_APPLICATION_FactData] (nolock)
-- where run in(25273,25524)
group by RunID
) x
inner join loader.JobRun jr
on jr.Run = x.RunID
inner join loader.Job j
on j.JobId = jr.JobId

--RunID	cnt			CobDate
--5105	15017689	2015-07-31
--20556	15551884	2016-01-31
--12755	15482940	2015-12-31
--4122	15017689	2015-06-30



select top 10  * from [bi].[GRCR_BARCLAYCARD_APPLICATION_FactData](nolock) 
where 1 = 1
and RunID=  12755  -- 20556 Jan 2016   12755 Dec 2015
and ApplicationID = 37295759 --37295759  -- 1416315
-- order by Audit_Timestamp desc

select top 10  * from [bi].[GRCR_BARCLAYCARD_APPLICATION_FactData](nolock) 
where 1 = 1
and RunID=  20556  -- 20556 Jan 2016   12755 Dec 2015
-- and ApplicationID = 37295759 --37295759  -- 1416315
and RunSetId <> -1


--
-- [bi].[GRCR_SDS_IF023_RES1_FactData] analysis
-- 

select x.*, j.CobDate, jr.RunStatus, j.JobStatus
from
(
select RunID, count(*) cnt
from [bi].[GRCR_SDS_IF023_RES1_FactData] (nolock)
-- where run in(25273,25524)
group by RunID
) x
inner join loader.JobRun jr
on jr.Run = x.RunID
inner join loader.Job j
on j.JobId = jr.JobId

--RunID	cnt	CobDate
--4128	48611288	2015-06-30
--25524	50743765	2016-01-31
--25273	50382185	2015-12-31
--6231	50382185	2015-12-31
--5103	48611288	2015-07-31

select top 10  * from [bi].[GRCR_SDS_IF023_RES1_FactData](nolock) 
where 1 = 1
and RunID=  25273  -- 25524 Jan 2016   25273 Dec 2015
-- and ApplicationID = 37295759 --37295759  -- 1416315
and RunSetId = -1

--
-- [bi].[GRCR_SDS_IF023_RESULTS4_FactData] analysis
-- 

select x.*, j.CobDate
from
(
select RunID, count(*) cnt
from [bi].[GRCR_SDS_IF023_RESULTS4_FactData] (nolock)
-- where run in(25273,25524)
group by RunID
) x
inner join loader.JobRun jr
on jr.Run = x.RunID
inner join loader.Job j
on j.JobId = jr.JobId

--RunID	cnt	CobDate
--2723	48611288	2015-06-30
--6230	50382185	2015-12-31
--25271	50382185	2015-12-31
--25525	50743765	2016-01-31
--5100	48611288	2015-07-31

select top 10  * from [bi].[GRCR_SDS_IF023_RESULTS4_FactData](nolock) 
where 1 = 1
and RunID=  25271  -- 25525 Jan 2016   25271 Dec 2015
-- and ApplicationID = 37295759 --37295759  -- 1416315
and RunSetId = -1