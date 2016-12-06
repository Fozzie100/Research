
alter table routing.BatchControl drop column BatchControlType
SELECT * from routing.BatchControl where Run=1180

begin tran
update routing.BatchControl 
set LogicalDatasetName = 'stg.BARCLAYCARD_New_accs_summy_BBC1',
ChunkProcessName='bi.PP_TEST_CHUNK1'
where Run=1180

commit

select top 100 * from loader.JobDefinition
where convert(nvarchar(max), JobDefinitionConfig) like '%IPostProcess%'
and convert(nvarchar(max), JobDefinitionConfig) like '%IProcess%'