UPDATE STATISTICS bi.FDSF_TDTAAccLinkingFactDataDelta;
select * from loader.JobDefinition
select top 100 * from log.log
where Run=1
order by CreateDate desc


select top 100 * from log.log
where LogID > 5882211
and SPID=288
order by CreateDate desc



select * 
from bi.FDSF_TDTAAccLinkingFactDataDelta (nolock)
where RunID=32 and LogicalAccountKeyNo = 4929534822750



select RunID, count(*)
from bi.FDSF_TDTAAccLinkingFactDataDelta (nolock)
group By RunID

select * from bi.FDSF_TDTAAccLinkingFactDataDelta where RunID=31
order by LogicalAccountKeyNo


delete bi.FDSF_TDTAAccLinkingFactDataDelta where RunID in (12,129019)



RunID	(No column name)
12			167
374			47540013
18539		47675198
129019		544631


select top 100 cp.CounterpartyID, fct.* 
from bi.FDSF_TDTAAccLinkingFactDataDelta fct
left join bi.CounterpartyIDAttrSCD cp
on cp.CounterpartyIDAttrKeyID = fct.CounterpartyIDKey
and cp.ChangeListId = fct.CounterpartyIDChangeListId
where fct.LogicalAccountKeyNo = 4929510664952 -- 4929534822750



update bi.FDSF_TDTAAccLinkingFactDataDelta
set EffectiveToDateTime = '31 Dec 9999'
where RunId=374

-- Add NCLI on LogicalAccountKeyNo and CounterpartyIDKey  
IF NOT EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IX_NCLI_FDSF_TDTAAccLinkingFactDataDelta_LogAccCPIDKey') 
    CREATE NONCLUSTERED INDEX IX_NCLI_FDSF_TDTAAccLinkingFactDataDelta_LogAccCPIDKey 
    ON bi.FDSF_TDTAAccLinkingFactDataDelta (LogicalAccountKeyNo, CounterpartyIDKey)INCLUDE (EffectiveToDateTime) 



USE [JUNO_DEV05]
GO

/****** Object:  Index [PK_bi_FDSF_TDTAAccLinkingFactDataDelta]    Script Date: 04/02/2016 12:38:43 ******/
ALTER TABLE [bi].[FDSF_TDTAAccLinkingFactDataDelta] DROP CONSTRAINT [PK_bi_FDSF_TDTAAccLinkingFactDataDelta]
GO

/****** Object:  Index [PK_bi_FDSF_TDTAAccLinkingFactDataDelta]    Script Date: 04/02/2016 12:38:43 ******/
ALTER TABLE [bi].[FDSF_TDTAAccLinkingFactDataDelta] ADD  CONSTRAINT [PK_bi_FDSF_TDTAAccLinkingFactDataDelta] PRIMARY KEY NONCLUSTERED 
(
	[LogicalAccountKeyNo] ASC,
	[CounterpartyIDKey] ASC,
	RunID
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO





select top 1000 * from #Account_linking_fact where LogicalAccountKeyNo=4929510664952

drop table #Account_linking_fact

select  LogicalAccountKeyNo
              ,OriginalAccountStartDateIDKey
             --  ,Original_Account_End_Date
              ,CounterPartyIDKey
              ,ActiveAccountStartDateKey
              ,ActiveAccountEndDatePrevKey
              ,LogicalAccountPurgeDateKey
			 
INTO #Account_linking_fact
from bi.FDSF_TDTAAccLinkingFactDataDelta (nolock)
where RunID = 18539
EXCEPT
select  LogicalAccountKeyNo
              ,OriginalAccountStartDateIDKey
             --  ,Original_Account_End_Date
              ,CounterPartyIDKey
              ,ActiveAccountStartDateKey
              ,ActiveAccountEndDatePrevKey
              ,LogicalAccountPurgeDateKey
from bi.FDSF_TDTAAccLinkingFactDataDelta (nolock)
where RunID = 374

select top 400000 * 
INTO #Account_linking_fact
from  bi.FDSF_TDTAAccLinkingFactDataDelta (nolock)
where RunID = 18539


select top 100 * from #Account_linking_fact


update bi.FDSF_TDTAAccLinkingFactDataDelta
set EffectiveToDateTime = '29 Jun 2015'
FROM
(select fct.RunId, jun30.LogicalAccountKeyNo, jun30.CounterpartyIDKey
from bi.FDSF_TDTAAccLinkingFactDataDelta fct
inner join #Account_linking_fact jun30
on jun30.LogicalAccountKeyNo = fct.LogicalAccountKeyNo
and jun30.CounterpartyIDKey = fct.CounterpartyIDKey
and fct.RunId=374
) x
where bi.FDSF_TDTAAccLinkingFactDataDelta.RunID = x.RunID
and bi.FDSF_TDTAAccLinkingFactDataDelta.LogicalAccountKeyNo = x.LogicalAccountKeyNo
and bi.FDSF_TDTAAccLinkingFactDataDelta.CounterpartyIDKey = x.CounterpartyIDKey


declare @now DATETIME = getdate()
insert into bi.FDSF_TDTAAccLinkingFactDataDelta(SourceRowId, RunId, EffectiveFromDateTime, EffectiveToDateTime, LogicalAccountKeyNo, CounterpartyIDKey,
												CounterpartyIDChangeListId, OriginalAccountStartDateIDKey, OriginalAccountStartChangeListId, ActiveAccountStartDateKey,
												ActiveAccountStartDateChangeListId, ActiveAccountEndDatePrevKey, ActiveAccountEndDatePrevChangeListId, LogicalAccountPurgeDateKey,
												LogicalAccountPurgeDateChangeListId, Latest_Account_Number, AppliedFromDateTime)

select x.SourceRowId, 20000, '30 Jun 2015', '31 Dec 9999', x.LogicalAccountKeyNo, x.CounterPartyIDKey, x.CounterpartyIDChangeListId,
	x.OriginalAccountStartDateIDKey, x.OriginalAccountStartChangeListId, x.ActiveAccountStartDateKey,
	x.ActiveAccountStartDateChangeListId, x.ActiveAccountEndDatePrevKey, x.ActiveAccountEndDatePrevChangeListId, x.LogicalAccountPurgeDateKey,
	x.LogicalAccountPurgeDateChangeListId, x.Latest_Account_Number, @now
from #Account_linking_fact x


-- now delete the 'full file of data
DECLARE @Cnt BIGINT = 1
DoAgain:

	SET @Cnt = @Cnt + 1
	IF @Cnt > 1000000
		GOTO NormalEnd
    DELETE TOP (100000)
    FROM bi.FDSF_TDTAAccLinkingFactDataDelta WITH (TABLOCKX)
	WHERE RunID=18539
    IF @@ROWCOUNT > 0
    GOTO DoAgain
NormalEnd:
select 'rows deleted ' + convert(varchar(32), @Cnt)

DELETE top (100) bi.FDSF_TDTAAccLinkingFactDataDelta WHERE RunID=18539

select top 1000 * from bi.FDSF_TDTAAccLinkingFactDataDelta where RunID=20000
and LogicalAccountKeyNo in (4929010002364,
4929010003610,
4929010008296)

select * from bi.FDSF_TDTAAccLinkingFactDataDelta where RunID=374
and LogicalAccountKeyNo in (4929010002364,
4929010003610,
4929010008296)


select count(*) from bi.FDSF_TDTAAccLinkingFactDataDelta
where EffectiveTodateTime >= getdate()



select top 1000 * from bi.FDSF_TDTAAccLinkingFactDataDelta
where EffectiveTodateTime >= getdate()
and LogicalAccountKeyNo in (4929010002364,
4929010003610,
4929010008296)


select top 100000 * from bi.FDSF_TDTAAccLinkingFactDataDelta
where EffectiveTodateTime >= '31 Jul 2015'
and LogicalAccountKeyNo in (4929010002364,
4929010003610,
4929010008296)


drop table #Account_linking_fact  
select * 
INTO #Account_linking_fact
from bi.FDSF_TDTAAccLinkingFactDataDelta
where '10 Jul 2015' BETWEEN EffectiveFromdateTime and EffectiveTodateTime
and LogicalAccountKeyNo in (4929010002364,
4929010003610,
4929010008296)


select top 10000000 * 

from bi.FDSF_TDTAAccLinkingFactDataDelta
-- where ( EffectiveTodateTime = '30 Jul 2015' or EffectiveTodateTime = '31 Dec 9999')
where '10 Sep 2015' between EffectiveFromdateTime and EffectiveTodateTime 
and LogicalAccountKeyNo in (4929010002364,
4929010003610,
4929010008296)

select count(*) from bi.FDSF_TDTAAccLinkingFactDataDelta
where ( EffectiveTodateTime = '29 Jun 2015' or EffectiveTodateTime = '31 Dec 9999')

select count(*) from bi.FDSF_TDTAAccLinkingFactDataDelta
where ( EffectiveFromdateTime = '31 May 2015' or EffectiveTodateTime = '31 Dec 9999')

select LogicalAccountKeyNo, CounterpartyIDKey
INTO #Linking_Data_performance
from bi.FDSF_TDTAAccLinkingFactDataDelta
where EffectiveTodateTime >= '30 Jun 2015'


select top 1000 * from  #Account_linking_fact2 -- bi.FDSF_TDTAAccLinkingFactDataDelta
where LogicalAccountKeyNo in (4929010002364,
4929010003610,
4929010008296,
4929010003610)

drop table #Account_linking_fact2

select top 50000000   SourceRowId,RunId,EffectiveFromDateTime,AppliedFromDateTime,LogicalAccountKeyNo,CounterpartyIDKey
						--,
					 --  CounterpartyIDChangeListId,OriginalAccountStartDateIDKey,OriginalAccountStartChangeListId,ActiveAccountStartDateKey,
					 --  ActiveAccountStartDateChangeListId,ActiveAccountEndDatePrevKey,ActiveAccountEndDatePrevChangeListId

into #Account_linking_fact2
from bi.FDSF_TDTAAccLinkingFactDataDelta
-- where '10 Sep 2015' between EffectiveFromDateTime and EffectiveToDateTime
where EffectiveTodateTime >= '10 Sep 2015'


select top 100 * from #Linking_Data_performance


exec sp_help 'bi.FDSF_TDTAAccLinkingFactDataDelta'



--and LogicalAccountKeyNo in (4929010002364,
--4929010003610,
--4929010008296)

UPDATE STATISTICS bi.FDSF_TDTAAccLinkingFactDataDelta;


select RunId, EffectiveFromDateTime, count(*)
 from bi.FDSF_TDTAAccLinkingFactDataDelta
 group by RunId, EffectiveFromDateTime




 -- add for EffectiveFrom = '31 Jul 2015'

 drop table #Account_linking_fact x

 declare @now DATETIME = getdate()
insert into bi.FDSF_TDTAAccLinkingFactDataDelta(SourceRowId, RunId, EffectiveFromDateTime, EffectiveToDateTime, LogicalAccountKeyNo, CounterpartyIDKey,
												CounterpartyIDChangeListId, OriginalAccountStartDateIDKey, OriginalAccountStartChangeListId, ActiveAccountStartDateKey,
												ActiveAccountStartDateChangeListId, ActiveAccountEndDatePrevKey, ActiveAccountEndDatePrevChangeListId, LogicalAccountPurgeDateKey,
												LogicalAccountPurgeDateChangeListId, Latest_Account_Number, AppliedFromDateTime)

select x.SourceRowId, 25000, '31 Jul 2015', '31 Dec 9999', x.LogicalAccountKeyNo, x.CounterPartyIDKey, x.CounterpartyIDChangeListId,
	x.OriginalAccountStartDateIDKey, x.OriginalAccountStartChangeListId, x.ActiveAccountStartDateKey,
	x.ActiveAccountStartDateChangeListId, x.ActiveAccountEndDatePrevKey, x.ActiveAccountEndDatePrevChangeListId, x.LogicalAccountPurgeDateKey,
	x.LogicalAccountPurgeDateChangeListId, x.Latest_Account_Number, @now
from #Account_linking_fact x

 --where LogicalAccountKeyNo >  40 and RunID = 20000 


 -- enddate the previous '400000'

update bi.FDSF_TDTAAccLinkingFactDataDelta
set EffectiveToDateTime = '30 Jul 2015'
FROM
(select fct.RunId, jun30.LogicalAccountKeyNo, jun30.CounterpartyIDKey
from bi.FDSF_TDTAAccLinkingFactDataDelta fct
inner join #Account_linking_fact jun30
on jun30.LogicalAccountKeyNo = fct.LogicalAccountKeyNo
and jun30.CounterpartyIDKey = fct.CounterpartyIDKey
and fct.RunId=20000
) x
where bi.FDSF_TDTAAccLinkingFactDataDelta.RunID = x.RunID
and bi.FDSF_TDTAAccLinkingFactDataDelta.LogicalAccountKeyNo = x.LogicalAccountKeyNo
and bi.FDSF_TDTAAccLinkingFactDataDelta.CounterpartyIDKey = x.CounterpartyIDKey



-- now add for EffectiveFrom = '31 Aug 2015' 
-- drop table #Account_linking_fact 
select  top 1000 * 
into #Account_linking_fact
from bi.FDSF_TDTAAccLinkingFactDataDelta where RunID=25000

select * from #Account_linking_fact

declare @now DATETIME = getdate()
insert into bi.FDSF_TDTAAccLinkingFactDataDelta(SourceRowId, RunId, EffectiveFromDateTime, EffectiveToDateTime, LogicalAccountKeyNo, CounterpartyIDKey,
												CounterpartyIDChangeListId, OriginalAccountStartDateIDKey, OriginalAccountStartChangeListId, ActiveAccountStartDateKey,
												ActiveAccountStartDateChangeListId, ActiveAccountEndDatePrevKey, ActiveAccountEndDatePrevChangeListId, LogicalAccountPurgeDateKey,
												LogicalAccountPurgeDateChangeListId, Latest_Account_Number, AppliedFromDateTime)

select x.SourceRowId, 30000, '31 Aug 2015', '31 Dec 9999', x.LogicalAccountKeyNo, x.CounterPartyIDKey, x.CounterpartyIDChangeListId,
	x.OriginalAccountStartDateIDKey, x.OriginalAccountStartChangeListId, x.ActiveAccountStartDateKey,
	x.ActiveAccountStartDateChangeListId, x.ActiveAccountEndDatePrevKey, x.ActiveAccountEndDatePrevChangeListId, x.LogicalAccountPurgeDateKey,
	x.LogicalAccountPurgeDateChangeListId, x.Latest_Account_Number, @now
from #Account_linking_fact x


delete top (50000) FROM bi.FDSF_TDTAAccLinkingFactDataDelta where RunId = 30000

update bi.FDSF_TDTAAccLinkingFactDataDelta
set EffectiveToDateTime = '30 Aug 2015'
FROM
(select fct.RunId, jun30.LogicalAccountKeyNo, jun30.CounterpartyIDKey
from bi.FDSF_TDTAAccLinkingFactDataDelta fct
inner join #Account_linking_fact jun30
on jun30.LogicalAccountKeyNo = fct.LogicalAccountKeyNo
and jun30.CounterpartyIDKey = fct.CounterpartyIDKey
and fct.RunId=25000
) x
where bi.FDSF_TDTAAccLinkingFactDataDelta.RunID = x.RunID
and bi.FDSF_TDTAAccLinkingFactDataDelta.LogicalAccountKeyNo = x.LogicalAccountKeyNo
and bi.FDSF_TDTAAccLinkingFactDataDelta.CounterpartyIDKey = x.CounterpartyIDKey


 ALTER TABLE bi.FDSF_TDTAAccLinkingFactDataEx ADD [RunIDUpdated] [INT] NULL

exec sp_rename '[bi].[bic.FDSF_TDTAAccLinkingFactDataDelta]', 'FDSF_TDTAAccLinkingFactDataDelta', TABLE

exec sp_rename '[bi].[FDSF_TDTAAccLinkingFactDataDelta]', '[bi].[FDSF_TDTAAccLinkingFactDataDeltaTesting]', TABLE
exec sp_rename '[bi].[FDSF_TDTAAccLinkingFactDataDeltaTesting]', '[bi].[FDSF_TDTAAccLinkingFactDataDelta]', TABLE

exec sp_rename '[bi].[[bi]].[FDSF_TDTAAccLinkingFactDataDeltaTesting]]]', 'FDSF_TDTAAccLinkingFactDataDelta'
exec sp_rename 'FDSF_TDTAAccLinkingFactDataDelta', 'FDSF_TDTAAccLinkingFactDataDeltax'

exec sp_rename '[stg].[BARCLAYCARD_ACCOUNT_LINKING]' , 'BARCLAYCARD_ACCOUNT_LINKING_PP'
exec sp_rename '[stg].[BARCLAYCARD_ACCOUNT_LINKING_PP]' , 'BARCLAYCARD_ACCOUNT_LINKING'


select * from  ref.AtomValueType

[bi].[[bi]].[FDSF_TDTAAccLinkingFactDataDeltaTesting]]]
[bi].[FDSF_TDTAAccLinkingFactDataDelta]
select top 10 * from bi.FDSF_TDTAAccLinkingFactDataDelta (nolock)
select top 10 * from bi.FDSF_TDTAAccLinkingFactData (nolock)

select * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA
select runID, count(*) 
from [bi].[FDSF_TDTAAccLinkingFactDataDelta]
group by RunID

alter table [bi].[FDSF_TDTAAccLinkingFactDataDelta] add CUDType INT NULL

select * from [bi].[FDSF_TDTAAccLinkingFactDataDelta] where RunIDUpdated is not null

delete from [bi].[FDSF_TDTAAccLinkingFactDataDelta] where RunID=23

update loader.JobDefinition
set JobDefinitionName = 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_PHIL',
	JobDefinitionCode = 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_PHIL'
where jobDefinitionId=178


begin tran
update loader.JobDefinition
set Enabled=0
where JobDefinitionId in (7,178)

commit

select top 10 * from loader.JobDefinition where JobDefinitionCode like 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKIN%'
select top 10 * from loader.JobDefinition where JobDefinitionCode = 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_PHIL' --_PHIL'
select * from loader.Job where JobDefinitionCode = 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING'
select * from loader.JobRun where JobID=32
select top 10 * from loader.JobTask

WITH [JobsDefinedCTE] AS 
(
 SELECT MAX(jr.Run) as Run 
 FROM [loader].[Job] j INNER JOIN [loader].[JobDefinition] jd 
 ON j.JobDefinitionCode=jd.JobDefinitionCode 
 INNER JOIN  [loader].[JobRun] jr ON j.JobId=jr.JobId 
 WHERE (jr.RunStatus='S' OR jr.RunStatus='W' OR jr.RunStatus='I') 
 AND CobDate= '20150531'  
 AND JobDefinitionConfig.value('(/ConductorConfiguration/Processes/IProcessTask/DataEngineFactory/DataEngineConfiguration/EngineConfiguration/Destination/TableName)[1]', 'varchar(50)') = 'stg.BARCLAYCARD_ACCOUNT_LINKING' 
 ) 

 SELECT COUNT(1) as NumRows FROM stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA s 
 INNER JOIN [JobsDefinedCTE] c ON c.Run = s.Run

select Run, count(*)
 from stg.BARCLAYCARD_ACCOUNT_LINKING (nolock)
 group by Run


 select top 100 * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA  where Run=12824

 select Run, count(*)
 from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA (nolock)
 group by Run

  select Run, count(*)
 from stg.BARCLAYCARD_ACCOUNT_LINKING (nolock)
 group by Run


 select top 10 * from log.log 
 where ( Run=13333  )
 -- and CreateDate  > '2016-02-05 17:44:15.857'
 order by CreateDate desc

  select top 100000 * from log.log 
  where LogID > 4624556
  and LOgID < 4719192
   order by CreateDate desc


   exec routing.uspStagingSourceProcess @p_RunId=3, @p_StagingTableName='stg.BARCLAYCARD_ACCOUNT_LINKING'

    select top 100000 * from log.log 
	where Run=3

 select * from entity.tfnOriginalAccountStartDateDeltaAttr('31 May 2015')
 select * from entity.tfnActiveAccountEndDateDeltaAttr('31 May 2015')
 select * from entity.tfnActiveAccountStartDateDeltaAttr('31 May 2015')
  select * from entity.tfnLogicalAccountPurgeDateDeltaAttr('31 May 2015')

  select * from entity.tfnLinkingCounterpartyIDDeltaAttr('31 May 2015')


  select top 100 * from mapping.Mapping(nolock) 
  where EntityTypeID in (133,134)
  order by createddate desc
  


  select * from entity.EntityType where EntityTypeCode like '%Active%'
 SELECT	ROW_NUMBER() OVER (ORDER BY c.[Order]) ExecutionOrder
		  ,c.[Schema]
		  ,c.Name
		  ,et.EntityTypeCode
		  ,c.[ChunkSize]
    FROM	dictionary.[Object] o
    JOIN	dictionary.[Object] c ON c.ParentObjectKey = o.ObjectKey
    JOIN	entity.[EntityType] et ON et.EntityTypeId = c.PrimaryEntityTypeId
    WHERE	o.[Schema]+'.'+o.Name = 'stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA'

	select * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA
	where Logical_Account_key_Num  in (4929949898544, 4929534822750)
	order by Run, Logical_Account_key_Num


	select Logical_Account_Key_Num, Run, count(*)
	 from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA
	 group by Logical_Account_Key_Num, Run


	select * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA where Run=11

	select * from stg.BARCLAYCARD_ACCOUNT_LINKING where Run=11


	exec stg.uspLoadFDSF_TDTAAccLinkingStageDataDelta @p_Run=7

	exec bi.uspLoadFDSF_TDTAAccLinkingFactDataChunk @p_Run=3, @p_cobdate='31 May 2015', 
													@p_stg_table_name='STG.BARCLAYCARD_ACCOUNT_LINKING_DELTA',
													@Startrow = 1, @EndRow=1000000


    exec bi.uspLoadFDSF_TDTAAccLinkingFactDataChunk @p_Run=11, @p_cobdate='30 Jun 2015', 
													@p_stg_table_name='STG.BARCLAYCARD_ACCOUNT_LINKING_DELTA',
													@Startrow = 1, @EndRow=1000000

rollback
select * from bi.FDSF_TDTAAccLinkingFactDataDelta where LogicalAccountKeyNo = 4929534822750  --- 4929534835190 -- =4929534822750

select * from bi.FDSF_TDTAAccLinkingFactDataDelta where RunIDUpdated is not null
delete bi.FDSF_TDTAAccLinkingFactDataDelta where RunID=11

select top 10 * from ##TDTAAccLinkingFactData_PP
where LOGICALACCOUNT_KEYNO = 4929534822750 

select * from bi.FDSF_TDTAAccLinkingFactDataDelta
where LogicalAccountKeyNo= 4929534822750
and EffectiveToDateTime='31 Dec 9999'

sp_help '##TDTAAccLinkingFactData_PP'

sp_help 'bi.FDSF_TDTAAccLinkingFactDataDelta'



select x.*
		FROM
		(	SELECT		wrk.Run, CONVERT(BIGINT,wrk.LOGICALACCOUNT_KEYNO) LOGICALACCOUNT_KEYNO , CONVERT(BIGINT, wrk.CounterPartyIDAttr) CounterPartyIDAttr , wrk.EffectiveFromDateTime
			FROM		bi.FDSF_TDTAAccLinkingFactDataDelta fct
			INNER JOIN	##TDTAAccLinkingFactData_PP wrk
			ON			CONVERT(BIGINT, wrk.LOGICALACCOUNT_KEYNO) = fct.LogicalAccountKeyNo
			AND			CONVERT(BIGINT,wrk.CounterPartyIDAttr) = fct.CounterpartyIDKey
			AND			fct.EffectiveToDateTime = '31 Dec 9999'
			and          fct.RunID = 3
		) x



SELECT		wrk.Run, wrk.LOGICALACCOUNT_KEYNO, wrk.CounterPartyIDAttr, wrk.EffectiveFromDateTime, fct.EffectiveToDateTime, convert(BIGINT, wrk.LOGICALACCOUNT_KEYNO) conv
			FROM		bi.FDSF_TDTAAccLinkingFactDataDelta fct
			INNER JOIN	##TDTAAccLinkingFactData_PP wrk
			ON			convert(BIGINT, wrk.LOGICALACCOUNT_KEYNO) = fct.LogicalAccountKeyNo
			AND			convert(BIGINT, wrk.CounterPartyIDAttr) = fct.CounterpartyIDKey
			AND			fct.EffectiveToDateTime = '31 Dec 9999'
			and          fct.RunID = 3

			SELECT		wrk.Run, wrk.LOGICALACCOUNT_KEYNO, wrk.CounterPartyIDAttr, wrk.EffectiveFromDateTime, fct.EffectiveToDateTime
			FROM		bi.FDSF_TDTAAccLinkingFactDataDelta fct
			INNER JOIN	##TDTAAccLinkingFactData_PP wrk
			ON			wrk.LOGICALACCOUNT_KEYNO = fct.LogicalAccountKeyNo
			AND			wrk.CounterPartyIDAttr = fct.CounterpartyIDKey
			AND			fct.EffectiveToDateTime = '31 Dec 9999'
			and          fct.RunID = 3





UPDATE bi.FDSF_TDTAAccLinkingFactDataDelta
		SET EffectiveToDateTime = DATEADD(day, -1, x.EffectiveFromDateTime),
			RunIDUpdated = x.Run
		FROM
		(	SELECT		wrk.Run, wrk.LOGICALACCOUNT_KEYNO, wrk.CounterPartyIDAttr, wrk.EffectiveFromDateTime
			FROM		bi.FDSF_TDTAAccLinkingFactDataDelta fct
			INNER JOIN	#TDTAAccLinkingFactData wrk
			ON			wrk.LOGICALACCOUNT_KEYNO = fct.LogicalAccountKeyNo
			AND			wrk.CounterPartyIDAttr = fct.CounterpartyIDKey
			AND			fct.EffectiveToDateTime = '31 Dec 1999'
		) x
		WHERE bi.FDSF_TDTAAccLinkingFactDataDelta.RunID = x.Run
		AND bi.FDSF_TDTAAccLinkingFactDataDelta.LogicalAccountKeyNo = x.LOGICALACCOUNT_KEYNO
		AND bi.FDSF_TDTAAccLinkingFactDataDelta.CounterpartyIDKey = x.CounterPartyIDAttr


--	ALTER PROCEDURE bi.uspLoadFDSF_TDTAAccLinkingFactDataChunk

--@p_Run int,
--@p_cobdate datetime,
--@p_stg_table_name nvarchar(128),
--@Startrow INT = 0,
--@EndRow INT = 0,
--@p_debug bit = 0
--,@p_RunSetID INT = 0



	select RunID, count(*)
	from bi.FDSF_TDTAAccLinkingFactDataDelta 
	group by RunID



	select * from bi.FDSF_TDTAAccLinkingFactDataDelta(nolock) where CUDType <> 1


	select * from bi.FDSF_TDTAAccLinkingFactDataDelta(nolock) where RunID=75 or RunIDUpdated=75

	select * from bi.FDSF_TDTAAccLinkingFactDataDelta(nolock) where LogicalAccountKeyNo =   4929534842824

	select  LogicalAccountKeyNo, CounterpartyIDKey, Latest_Account_Number, count(*)
	from bi.FDSF_TDTAAccLinkingFactDataDelta
	where getdate() BETWEEN EffectiveFRomDatetime and EffectiveToDatetime
	and IsDeleted = 0
	group by LogicalAccountKeyNo, CounterpartyIDKey, Latest_Account_Number
	having count(*) > 1


		select *
	from bi.FDSF_TDTAAccLinkingFactDataDelta
	where getdate() BETWEEN EffectiveFRomDatetime and EffectiveToDatetime
	and IsDeleted = 0
	order by LogicalAccountKeyNo


		select * from bi.FDSF_TDTAAccLinkingFactDataDelta where RunID=75
		select * from bi.FDSF_TDTAAccLinkingFactDataDelta(nolock) 
		where  1 = 1 
		and (RunIDUpdated is not null or IsDeleted = 1 or CUDType <> 1 or EffectiveToDateTime <> '31 Dec 9999')
		and  LogicalAccountKeyNo = 4929534822750 
		order by RunID, LogicalAccountKeyNo
		or (LogicalAccountKey= 4929534822750 and 
		delete bi.FDSF_TDTAAccLinkingFactDataDelta where RunId=33

		begin tran
		update bi.FDSF_TDTAAccLinkingFactDataDelta
		set EffectiveToDateTime = '31 Dec 9999',
		RunIDUpdated =null,
		CUDtype = 1
		where RunID=32 and EffectiveToDateTime = '29 Jun 2015'


		commit
	truncate table bi.FDSF_TDTAAccLinkingFactDataDelta 

	select top 100 cp.CounterpartyID, x.* 
	from bi.FDSF_TDTAAccLinkingFactDataDelta x
	inner join bi.CounterPartyIDAttrSCD cp
	on cp.CounterPartyIDAttrKeyID = x.CounterPartyIDKey
	where LogicalAccountKeyNo=4929534824525
	--where RunIDUpdated is not null


	select top 100 cp.CounterpartyID, x.* 
	from bi.FDSF_TDTAAccLinkingFactDataDelta x
	inner join bi.CounterPartyIDAttrSCD cp
	on cp.CounterPartyIDAttrKeyID = x.CounterPartyIDKey
	where LogicalAccountKeyNo=4929534824525 -- 4929534822750
	order by RunID

	select * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA
	where Run=45  --- and Logical_Account_key_Num=4929534824525
	order by RowID





	exec 



	select top 100 * from sys.all_objects
	order by create_date desc



	select top 100 * from log.log where Run=25
	order by createdate desc

	select top 100 * from log.log where Spid=148
	order by createdate desc

	select top 10000 * from log.log 
	where LogID > 88445
	order by createdate asc


--
-- Run in this order after getting run number from '_PHIL
-- 31 May
exec stg.uspLoadFDSF_TDTAAccLinkingStageDataDelta @p_Run=40
exec routing.uspStagingSourceProcess @p_RunId=40, @p_StagingTableName='stg.BARCLAYCARD_ACCOUNT_LINKING'

exec ref.uspProcessBarclaycardTDTAMetricAtomiseChunk @p_Run=40, @p_StartRow=1, @p_EndRow=1000000
exec bi.uspLoadDimensionDataWrapper @p_Run=40
EXEC [bi].[uspLoadFDSF_TDTAAccLinkingFactDataChunk] @p_cobdate='20150531' ,@p_stg_table_name ='stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA' ,@p_RunSetID=-1 ,@p_run=40, @Startrow =1, @EndRow=500000

select * from bi.FDSF_TDTAAccLinkingFactDataDelta


-- 
-- 30 June
--

exec stg.uspLoadFDSF_TDTAAccLinkingStageDataDelta @p_Run=45
exec routing.uspStagingSourceProcess @p_RunId=45, @p_StagingTableName='stg.BARCLAYCARD_ACCOUNT_LINKING'

exec ref.uspProcessBarclaycardTDTAMetricAtomiseChunk @p_Run=45, @p_StartRow=1, @p_EndRow=1000000
exec bi.uspLoadDimensionDataWrapper @p_Run=45
EXEC [bi].[uspLoadFDSF_TDTAAccLinkingFactDataChunk] @p_cobdate='20150630' ,@p_stg_table_name ='stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA' ,@p_RunSetID=-1 ,@p_run=45, @Startrow =1, @EndRow=500000




-- 
-- 30 June
--

select * from loader.Job where JobDefinitionCode in ( 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING', 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_PHIL')
and COBDate = '30 Jun 2015'
SELECT J.CobDate,   J.JobDefinitionCode, j.JobID
	 FROM loader.JobRun jr
	 INNER JOIN loader.Job j
	 ON j.JobId = jr.JobId
	 WHERE jr.Run = 75

	 select * from loader.Job where JobID=7 

	 select * from loader.Job where JobDefinitionCode in ( 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING', 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_PHIL')
and COBDate = '30 Jun 2015'

	 begin tran 
	 update loader.Job 
	 set JobDefinitionCode = 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_PHILx'
	 where JobID=11

	 update loader.Job 
	 set JobDefinitionCode = 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING'
	 where JobID=7

	  update loader.Job 
	 set JobDefinitionCode = 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_PHIL'
	 where JobID=11


	 select * from loader.Job where JobDefinitionCode in ( 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING', 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_PHIL')
and COBDate = '30 Jun 2015'
	 rollback
	 commit
	  SELECT Top 1  jr.Run
	 FROm loader.JobRun jr
	 INNER JOIN loader.Job j
	 ON j.JobId = jr.JobId
	 and j.JobDefinitionCode = 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING'
	 where jr.RunStatus = 'S'
	 and j.JobStatus = 'S'
	 and j.CobDate = EOMONTH('30 Jun 2015', -1 )
	 order by jr.Run DESC

select top 10000 * from log.log where Run=75 order by CreateDate desc


exec stg.uspLoadFDSF_TDTAAccLinkingStageDataDelta @p_Run=75   -- select Run, count(*) from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA group by Run

exec routing.uspStagingSourceProcess @p_RunId=75, @p_StagingTableName='stg.BARCLAYCARD_ACCOUNT_LINKING'

exec ref.uspProcessBarclaycardTDTAMetricAtomiseChunk @p_Run=75, @p_StartRow=1, @p_EndRow=1000000
exec bi.uspLoadDimensionDataWrapper @p_Run=75
EXEC [bi].[uspLoadFDSF_TDTAAccLinkingFactDataChunk] @p_cobdate='20150630' ,@p_stg_table_name ='stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA' ,@p_RunSetID=-1 ,@p_run=75, @Startrow =1, @EndRow=500000



ALTER TABLE bi.FDSF_TDTAAccLinkingFactDataDelta
ADD CONSTRAINT chkEffectiveFromTo CHECK (EffectiveToDateTime >= EffectiveFromDateTime);
GO



select top 100* from [entity].[ActiveAccount_Attr]

select top 100 * from entity.AccountLinking_Attr

select top 100 * from [entity].[ActiveAccountEndDate_Attr]

select top 100 * from [entity].[ActiveAccountStartDate_Attr]

select top 100 * from [entity].[tfnLinkingCounterpartyIDDeltaAttr]('30 Jun 2015')

exec routing.uspStagingSourceProcess @p_RunId=76, @p_StagingTableName='stg.BARCLAYCARD_ACCOUNT_LINKING' 


--
-- Run in this order after getting run number from '_PHIL
-- 31 May
exec stg.uspLoadFDSF_TDTAAccLinkingStageDataDelta @p_Run=40
exec routing.uspStagingSourceProcess @p_RunId=40, @p_StagingTableName='stg.BARCLAYCARD_ACCOUNT_LINKING'

-- run this on command line - chunk manager
exec ref.uspProcessBarclaycardTDTAMetricAtomiseChunk @p_Run=76, @p_StartRow=1, @p_EndRow=1000000
exec bi.uspLoadDimensionDataWrapper @p_Run=40
EXEC [bi].[uspLoadFDSF_TDTAAccLinkingFactDataChunk] @p_cobdate='20150531' ,@p_stg_table_name ='stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA' ,@p_RunSetID=-1 ,@p_run=40, @Startrow =1, @EndRow=500000