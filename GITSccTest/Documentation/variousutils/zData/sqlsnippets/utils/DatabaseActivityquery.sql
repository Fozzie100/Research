SELECT x.blocking_session_id, ss.login_name, x.session_id, cc.text, x.*,
(SELECT TOP 1 SUBSTRING(cc.text,statement_start_offset / 2+1 , 
      ( (CASE WHEN statement_end_offset = -1 
         THEN (LEN(CONVERT(nvarchar(max),cc.text)) * 2) 
         ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement
FROM sys.dm_exec_requests x
inner join sys.dm_exec_sessions ss
on ss.session_id = x.session_id
cross apply sys.dm_exec_sql_text(x.sql_handle) cc
 where ss.login_name = 'INTRANET\pullingp_aps'  -- or x.session_id = 30
where x.session_id in (383)

select top 100 * from sys.dm_exec_query_stats
exec sp_who2

select count(*) from [bi].[GRCR_BPF_ForbearanceFactDataBase]
where RunID=120123
select count(*) from bi.GRCR_BPF_ChargeOffFactDataBase
where RunID=120123

 
 kill 210
sp_who2 210
select top 1000 AP.ApplicationId, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta (nolock) x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
and x.IsDeleted=0
and  x.EffectiveFromDateTime = '29 Feb 2016'

select top 1000 AP.ApplicationId, convert(datetime, x.AuditTimeStamp) audit, x.* 
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta (nolock) x
inner join bi.ApplicationIdSCD ap on ap.ApplicationIdAttrKeyID = X.ApplicationIdAttrKey
--and x.IsDeleted=0
 --and  x.RunIDUpdated=119181
 -- and CUDTYpe <> 3
 and AP.ApplicationId in (  '53040781', '53063123', '6698857')
 and RunID <> 117889

  select top 100 * from stg.SDS_IF023_APP_DELTA
 where Run IN (118704, 119181)  and Application_ID IN (  '53063123', '6698857', '53040781')
 order by Application_ID, CUDType DESC, Audit_Timestamp DESC

 select top 100 * from stg.SDS_IF023_APP
 where Run=65214 and Application_ID IN ( '53063123', '6698857')
 order by Application_ID, Audit_Timestamp DESC

  select top 100 * from stg.SDS_IF023_APP
 where Run=24072 and Application_ID IN (  '53063123', '6698857')
 order by Application_ID, Audit_Timestamp DESC




  select  * from stg.SDS_IF023_APP_DELTA
 where Run=119100 


 select * from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta
 where RunID=119100

 
 select count(*) from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta
 where RunID=119100  -- and RunID <> 118704

 begin tran
 --update bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta
 --set CUDType=1,
 --EffectiveToDateTime = '31 Dec 9999',
 --RunIDUpdated = null
 --where RunIDUpdated=119100 

 delete bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta where RunID=119100
 commit

where 1 = 1

truncate table stg.SDS_IF023_APP_DELTA

select top 100 * from stg.SDS_IF023_APP_DELTA (nolock) 
order by RowIDFullOriginal desc 

select top 100 * from stg.SDS_IF023_APP_DELTA (nolock) 
order by RowID desc 

SELECT count(*) cnt from stg.SDS_IF023_APP_DELTA (nolock)    -- 15497537

SELECT MIN(roWid) MINROW, MAX(ROWID) MAXROW FROM stg.SDS_IF023_APP_DELTA (nolock)


select top 10000 * from log.log(nolock) 
where 1 = 1
-- and Run= 120062 -- 118704 117889
and CreateDate > '06 Apr 2016'
and LogID >  65808205 -- 61643971 -- 61627346 --61553278    -- 61508853 -- initial lofs with deadlocks
and ( LogCategory like 'PROC.ERR%' or LogMessage like '%deadlock%')
-- and SPID=164
-- order by LogMessage desc
-- and LogMessage like '%row(s) into bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta Table%'
order by CreateDate desc


select * from 


SELECT Application_ID, count(*) cnt
from stg.SDS_IF023_APP_DELTA (nolock)
group by Application_ID having count(*) > 1

sp_help 'bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta'
truncate table bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta
select 9999995 + 500000
select count(*) from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta (nolock) 
where  1 = 1 
and IsDeleted=0
and RunId=117889 --118704 -- 117889

select RunID,count(*) cnt from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta (nolock) group by RunID
where  1 = 1 and RunIDUpdated=118704 -- 117889
select top 100 * from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta (nolock) 
where  1 = 1 and RunID=117889 and ApplicationIdAttrKey in (263557839,263559392)

116549
update Top (500000) bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta
set IsDeleted=0,
RunIDUpdated = NULL
where RunIDUpdated = 118704

select top 100 * from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta where ApplicationIdAttrKey=263520437
where 1 = 1
and ApplicationIdAttrKey=170986973
and IsDeleted=1
delete top (500000) from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta 
where  1 = 1 and RunId=118704

select count(*) from stg.SDS_IF023_APP_DELTA where Run=118704 -- 117889
and SourceRowId between 5500001  and 6000000    -- spid209
or SourceRowId between 13000001  and 13500000
or SourceRowId between 8000001   and 8500000
or SourceRowId between 10500001 and 11000000
or SourceRowId between 13500001  and 14000000
or SourceRowId between 11000001 and 11500000
or SourceRowId between 3000001 and 3500000
or SourceRowId between 3500001 and 4000000
or SourceRowId between 14500001 and 15000000
or SourceRowId between 15000001 and 15497537
or SourceRowId between 1500001 and 2000000
-- or SourceRowId between 2000001 and 2500000
-- or SourceRowId between 4500001 and 5000000
-- or SourceRowID between 4000001 and 4500000
-- or SourceRowId between 9500001 and 10000000
-- or SourceRowId between 12000001 and 12500000
-- or SourceRowID between 1000001 and 1500000
-- or SourceRowId between 7000001 and 7500000
-- or SourceRowId between 9000001 and 9500000
-- or SourceRowID between 11500001 and 12000000
-- or SourceRowID between 6500001 and 7000000
-- or SourceRowId between 500001 and 1000000
-- or SourceRowId between 14000001  and 14500000
-- or SourceRowId between 6000001   and 6500000
-- or SourceRowId between 8500001 and 9000000

select count(*) from stg.SDS_IF023_APP_DELTA (nolock)
where RowID between 5500001  and 6000000
order by SourceRowId

select top 10 * from stg.SDS_IF023_APP_DELTA where Application_ID = '6738136'

select top 1000000 zz.ApplicationID, z.* 
from stg.SDS_IF023_APP_DELTA  z
left join 
(
select  y.ApplicationID, x.* 
from bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta x
inner join bi.ApplicationIDSCD y
on y.ApplicationIDAttrKeyID = x.ApplicationIDAttrKey
) zz
on zz.ApplicationID = z.Application_ID
where zz.ApplicationID is null


--  where ApplicationIDAttrKey = 167481803
select top 100 * from bi.ApplicationIDSCD where [ApplicationId] = '6738136'

select * from stg.SDS_IF023_APP_DELTA where RowID in (14492992,14492993)


select * from stg.SDS_IF023_APP where Application_ID in ( '6738136', '6698857', '6921158', '7137223', '94924')
and Run=24072
order by Application_ID, Audit_Timestamp

select * from stg.SDS_IF023_APP_DELTA where Application_ID in ( '6738136', '6698857', '6921158', '7137223', '94924')
and Run=116290




commit
declare @pbit BIT = 5

select 'forcedfull:= '+ convert(char(1), @pbit)
sp_who2 537

DBCC page (59, 9, 2654818) 
select * from sys.sysdatabases
5227970	3465916	317212567

rollback
exec sp_who2 304
exec ref.uspDeleteAtomValue @Run=154

select top 100 * FROM ref.AtomValue (nolock) WHERE Run = 116549
 select top 100 * from [stg].[BARCLAYCARD_ACCOUNT_LINKING_DELTA] (nolock)
 where Run=83 and Logical_Account_Key_Num=4929970548596

select top 1000 * from log.log(nolock) where Run=116290
and CreateDate > '21 Mar 2016'
order by CreateDate desc

kill 317


select count(*) from stg.SDS_IF023_RES1_DELTA
select * from stg.SDS_IF023_RES1_DELTA
where
1 = 1
and Run=65233
order by Audit_Timestamp desc

select top 100000 * from log.log(nolock) where Spid=509
and LogID > 3767125
order by CreateDate asc

UPDATE m
				SET m.EntityKey = mm.EntityKey
				,m.CreateMapping = 0
			FROM
				#MappingType mt
				, #Mapping m 
				JOIN [mapping].Mapping mm
					ON m.ValueStringChecksum = mm.ValueStringChecksum
				WHERE 
					mt.MappingTypeKey = mm.MappingTypeKey
					AND mt.EntityTypeID = mm.EntityTypeID


			



