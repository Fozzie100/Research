
select x.*, j.CobDate, jr.RunStatus, j.JobStatus
from
(
select Run, count(*) cnt
from stg.SDS_IF023_RES4 (nolock)
-- where run in(25273,25524)
group by Run
) x
inner join loader.JobRun jr
on jr.Run = x.Run
inner join loader.Job j
on j.JobId = jr.JobId