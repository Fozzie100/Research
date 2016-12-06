

USE JUNO_DEV05
GO


-- 
select top 100 * from dbo.FDSF_TDTAAccLinkingFactDataDelta
-- where LogicalAccountKeyNo=9999999992078
order by LogicalAccountKeyNo



--select * from dbo.FDSF_TDTAAccLinkingFactDataDelta
--order by  LogicalAccountKeyNo, CounterpartyIDKey
-- insert into dbo.FDSF_TDTAAccLinkingFactDataDelta (SourceRowId, RunId, EffectiveFromDateTime,  EffectiveToDateTime, AppliedFromDateTime,  LogicalAccountKeyNo,  CounterpartyIDKey,    CounterpartyIDChangeListId, OriginalAccountStartDateIDKey, 
--				OriginalAccountStartChangeListId, ActiveAccountStartDateKey, ActiveAccountStartDateChangeListId, 
--				ActiveAccountEndDatePrevKey, ActiveAccountEndDatePrevChangeListId, LogicalAccountPurgeDateKey, LogicalAccountPurgeDateChangeListId, Latest_Account_Number, RunIDUpdated, IsDeleted, CUDType
--				)
--				select SourceRowId, 9999, EffectiveFromDateTime,  EffectiveToDateTime, AppliedFromDateTime,  LogicalAccountKeyNo,  CounterpartyIDKey,    CounterpartyIDChangeListId, OriginalAccountStartDateIDKey, 
--				OriginalAccountStartChangeListId, ActiveAccountStartDateKey, ActiveAccountStartDateChangeListId, 
--				ActiveAccountEndDatePrevKey, ActiveAccountEndDatePrevChangeListId, LogicalAccountPurgeDateKey, LogicalAccountPurgeDateChangeListId, Latest_Account_Number, RunIDUpdated, IsDeleted, CUDType
--				from  dbo.FDSF_TDTAAccLinkingFactDataDelta where RunID=139 and SourceRowID=5

 begin tran
 update dbo.FDSF_TDTAAccLinkingFactDataDelta
 set EffectiveFromDateTime = '12 Oct 2015' -- '05 Sep 2015' --'28 Aug 2015'
 --set EffectiveToDateTime = '25 Aug 2015'  -- '05 Sep 2015' --'28 Aug 2015'
 where 1 = 1
 --where LogicalAccountKeyNo=9999999992078
 -- and RunId=139 and SourceRowID=4
 and RunId=9999 and SourceRowID=5
 --and CounterpartyIDKey = 48441699


 update dbo.FDSF_TDTAAccLinkingFactDataDelta
 -- set EffectiveFromDateTime = '12 Oct 2015' -- '05 Sep 2015' --'28 Aug 2015'
 set EffectiveToDateTime = '25 Aug 2015'  -- '05 Sep 2015' --'28 Aug 2015'
 where 1 = 1
 --where LogicalAccountKeyNo=9999999992078
 and RunId=139 and SourceRowID=5
 -- and RunId=9999 and SourceRowID=5
 --and CounterpartyIDKey = 48441699

 rollback


 -- 
 -- query uses LAG to determine if previous row 'EffectiveToDateTime' value is contiguous with 
 -- current row 'EffectiveFromDateTime' for the LogicalAccountKeyNo, CounterpartyIDKey partition
 -- 'Diff' = 1 for an overlap/gap else 0
 -- possibe include in 'BCARD_TDTA_06_BARCLAYCARD_ACCOUNT_LINKING_DELTA' Jobdefinition
 -- could run off the delta table/atoms in fact population sproc to check the LogicalAccountKeyNo, CounterpartyIDKey
 -- just for that delta
 --
        SELECT 
			LogicalAccountKeyNo,
			CounterpartyIDKey,
            EffectiveFromDateTime, 
            EffectiveToDateTime, 
            CASE WHEN ABS(DATEDIFF("dd", LAG(EffectiveToDateTime) OVER (PARTITION BY LogicalAccountKeyNo, CounterpartyIDKey ORDER BY EffectiveFromDateTime), EffectiveFromDateTime)) > 1 
			THEN 1 
			ELSE 0 
			END AS diff 
        FROM dbo.FDSF_TDTAAccLinkingFactDataDelta
		where 1 = 1
		--and LogicalAccountKeyNo=9999999992078
		and IsDeleted=0
		-- group by LogicalAccountKeyNo, CounterpartyIDKey, EffectiveFromDateTime, EffectiveToDateTime
		order by LogicalAccountKeyNo, CounterpartyIDKey, EffectiveFromDateTime, EffectiveToDateTime
		
   