USE GRCR_DEV

select * from loader.JobDefinition
where JobDefinitionCode like '%IMPAIR%'
select * from loader.Job where JobDefinitionCode = 'BARCLAYCARD_BPF_APPLICATION'

 exec [loader].[RestartRunDetailGet] @p_Run= 1180
select * from loader.Job where JobID=30
select * from loader.JobRun where run=1180
-- select * from loader.JobRun where JobID=30
select * from loader.JobTask where run=1180


select * from loader.Job where JobID=30
select * from loader.JobRun where run=1186
-- select * from loader.JobRun where JobID=30
select * from loader.JobTask where run=1186

select top 100 * from  routing.BatchControl where Run=1180

update routing.BatchControl 
set StartDateTime=null,
EndDateTime=null,
BatchIdStatus='P'
where Run=1180 and BatchId NOT in (1,2)

update routing.BatchControl
set StartDateTime = getdate(),
EndDateTime = getdate(),
BatchIdStatus = 'S'
where Run=1180 and BatchId = 1

update routing.BatchControl
set StartDateTime = getdate(),
EndDateTime = getdate(),
BatchIdStatus = 'F'
where Run=1180 and BatchId = 2


select top 10000 * from log.Log where Run=1180
order by CreateDate desc

update loader.JobRun 
set RunStatus='W'
where run=1180
begin tran
delete log.Log where Run=1180

commit

sp_help 'loader.Job'

select * from loader.JobRun where JobID=30

-- start   ---
delete loader.JobTask where JobTaskId in (5578,5577) -- ,5520)

update loader.JobTask
set TaskStatus='F',
EndTime=null
where JobTaskId=5521

-- delete loader.JobTask where JobTaskId=3519
 update loader.JobTask set TaskStatus='S' where JobTaskId=1412
update loader.JobRun 
set RunStatus='W'
where run=1180

update loader.Job 
set JobStatus='R'
where JobID=30

update routing.BatchControl
set BatchIdStatus='F'
where Run=1180 and BatchID=2
AND ChunkProcessName='bi.PP_TEST_CHUNK55'
-- end   --- 

declare @TaskID INT
 exec [loader].[uspJobTaskGetIDByTaskName]	@Run =1180, @TaskName='Fourth task name',	@TaskID=@TaskID OUT

 print @TaskID

 declare @TaskID INT
 exec [loader].[uspJobTaskGetIDByTaskName]	@Run =1180, @TaskName='Second task name',	@TaskID=@TaskID OUT

 print @TaskID

INSERT INTO loader.JobTask (Run, TaskName, TaskStatus, StartTime)
values (1180, 'Second task name', 'F', getdate())

select * from loader.JobTask where TaskData is not null
and Run=1175
order by StartTime desc

select * from loader.JobRun where Run=1175
select * from loader.Job where JobId=2
select * from loader.JobDefinition
where JobDefinitionCode = 'BARCLAYCARD_BPF_APPLICATION'



select 
delete routing.BatchControl where Run=318 

use JUNO_DEV05
select top 100 * from  routing.BatchControl   -- where Run=318 
use GRCR_DEV
select top 100 * from  routing.BatchControl order by Run desc where Run=1180


insert
update routing.BatchControl
set ChunkProcessName = 'Unknown',
	IsBatchControlTypeMar= 1

select * from  routing.BatchControl order by Run desc
select * from  routing.BatchControl where Run=1180
update routing.BatchControl
set StartDateTime = getdate(),
	EndDateTime = null,
	BatchIdStatus = 'F'
where Run=1180 and BatchId=2

begin tran
update routing.BatchControl
set Run=1180
where Run=1138
commit

exec [routing].[uspBatchControlInsertStart] 

				@p_Run = 1180
				,@p_StagingTableName =   'stg.BPF_JAY_BPF_FP_ACC' --'stg.BPF_JAY_BPF_FP_ACC' -- 'stg.BARCLAYCARD_BPF_APPLICATION'
				,@p_Span = 500
				,@p_BatchControlType = 'ATM'
	            , @p_Debug = 0




exec [routing].[uspBatchControlInsertStart] 

				@p_Run = 318
				,@p_StagingTableName =   'stg.BARCLAYCARD_BPF_APPLICATION' --'stg.BPF_JAY_BPF_FP_ACC' -- 'stg.BARCLAYCARD_BPF_APPLICATION'
				,@p_Span = 500000
				,@p_ChunkProcessName = 'ref.uspMyAtomiseChunk'
	            , @p_Debug = 0


exec [routing].[uspBatchControlUpdate] 	@p_Run = 1138
										,@p_BatchID = 9911
										,@p_BatchIDStatus = 'R'

exec [routing].[uspBatchControlLookUp] @p_Run = 318, @p_PostedAndFailedOnly = 1
select * FROM routing.BatchControl where Run= 1138   --- 318

declare @mybit bit = 67.89

if (@mybit=0)
	print 'mybit=0'
else
	print 'mybit !=0'

if ((@mybit = False))
	print 'mybit true'
else
	print 'mybit false'

select @mybit

select *   FROM routing.BatchControl where Run=1138

update routing.BatchControl
	set BatchIdStatus = 'S'
where Run=318 and BatchId=1

update routing.BatchControl
	set BatchIdStatus = 'F',
	StartDateTime = getdate()
where Run=318 and BatchId=2
select count(*) from stg.BPF_JAY_BPF_FP_ACC where Run=1138

delete routing.BatchControl where Run=318
select top 100 * from log.log where SPID=214
order by CreateDate desc

select top 100 * from log.log 
order by CreateDate desc

drop procedure [routing].[uspBatchControlInsert]



select TOP 100 * from routing.BatchControl WHERE [Run]= 318

select top 100  * from util.UTEntitiesMetadata


select * FROM 

exec [routing].[uspBatchControlLookUp] @p_Run = 318, @p_PostedAndFailedOnly = 1  


alter table routing.BatchControl drop column BatchControlType
select top 100 *  from routing.BatchControl
sp_helptext 'routing.BatchControl'


select * from loader.JobDefinition
where convert(nvarchar(max),JobDefinitionConfig) like 
'%uspProcessBARCLAYCARD_Impairment_AllMetricAtomise%'

select top 100 * from loader.Job where JobDefinitionCode like 'BCARD_TCP_01_BARCLAYCARD_Impairment_All%'
select top 10 * from loader.JobRun where JobId=17

select top 200 * from loader.JobTask where Run=23

select * from loader.JobDefinition
where convert(nvarchar(max),JobDefinitionConfig) like 
'%ChunkManager%'

select * from loader.JobDefinition
where convert(nvarchar(max),JobDefinitionConfig) like 
'%taskID%'

 SELECT	ROW_NUMBER() OVER (ORDER BY c.[Order]) ExecutionOrder
		  ,c.[Schema]
		  ,c.Name
		  ,et.EntityTypeCode
		  ,c.[ChunkSize]
    FROM	dictionary.[Object] o
    JOIN	dictionary.[Object] c ON c.ParentObjectKey = o.ObjectKey
    JOIN	entity.[EntityType] et ON et.EntityTypeId = c.PrimaryEntityTypeId
    WHERE	o.[Schema]+'.'+o.Name = 'stg.BARCLAYCARD_ACCOUNT_HEADER'
