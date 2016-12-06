select top 100 * from routing.BatchControl
where Run=6164
order by StartDateTime desc

select top 100 * from routing.JobTask 
where 1 = 1
and [TaskStatus] <> 'S' 
-- and [TaskStatus] <> 'F'

select top 100 * from routing.Job 
where [Status] <> 'S' and [Status] <> 'F'
select * from routing.Job where run=1507
select * from routing.BatchControl where run=1507
select top 10000 * from routing.JobTask where JobID=55

-- all tables together -- START
select top 100 * from routing.BatchControl
where Run=4222

select top 100 * from routing.Job where JobID=79

--begin tran 
--update routing.Job set [Status] = null
--where JobID=79
--rollback

--begin tran
--update routing.JobTask 
--set TaskStatus = 'Z'
--where JobTaskID=960

select top 10000 * from routing.JobTask 
where JobID=79
order by TaskName, StartDateTime desc


-- all tables together -- END


select * 
from routing.JobTask jt
inner join routing.Job rj on rj.JobID = jt.JobID 
inner join loader.JobRun jr
on jr.Run = rj.Run
inner join loader.Job j
on j.JobId = jr.JobId
where jt.JobID = 79


 FROM loader.Job j 
       INNER JOIN loader.JobRun jr on jr.JobId = j.JobId


select * from dictionary.Item where DictionaryItemKey=627
select * from entity.Entity where EntityKey=627


select * from entity.EntityType where EntityTypeCode like '%Metric%'
or EntityTypeID=232


select top 100 * from mapping.Mapping 
select * from mapping.MappingType where MappingTypeKey=66