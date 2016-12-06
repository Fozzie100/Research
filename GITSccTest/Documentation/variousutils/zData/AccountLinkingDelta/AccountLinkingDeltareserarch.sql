

select count(*) from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA
select * from loader.JobRun where Run in (374, 18539)
select * from loader.Job where JobId In (25,30)

select count(*) from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA (nolock)
where Run=18539
drop table #Account_linking2
select  Logical_Account_Key_Num
              ,Original_Account_Start_Date
              ,Original_Account_End_Date
              ,Active_Account_Number
              ,Active_Account_Start_Date
              ,Active_Account_End_Date
              ,Target_Account_Number
              ,Target_Account_Start_Date
              ,Target_Account_End_Date
              ,Latest_Account_Number
              ,Latest_Account_Start_Date
              ,Logical_Account_Purge_Date
INTO #Account_linking2
from stg.BARCLAYCARD_ACCOUNT_LINKING mast (nolock)
where run = 18539
and not 
exists (select TOP 1 1
			  FROM stg.BARCLAYCARD_ACCOUNT_LINKING (nolock) child
			  where ( child.Logical_Account_Key_Num = mast.Logical_Account_Key_Num OR child.Logical_Account_Key_Num IS NULL and mast.Logical_Account_Key_Num is NULL)
              and (child.Original_Account_Start_Date = mast.Original_Account_Start_Date OR child.Original_Account_Start_Date IS NULL and mast.Original_Account_Start_Date IS NULL)
              and (child.Original_Account_End_Date = mast.Original_Account_End_Date OR child.Original_Account_End_Date IS NULL AND mast.Original_Account_End_Date IS NULL)
              and (child.Active_Account_Number = mast.Active_Account_Number OR child.Active_Account_Number IS NULL AND mast.Active_Account_Number IS NULL)
              and (child.Active_Account_Start_Date = mast.Active_Account_Start_Date OR child.Active_Account_Start_Date IS NULL AND mast.Active_Account_Start_Date IS NULL)
              and (child.Active_Account_End_Date = mast.Active_Account_End_Date OR child.Active_Account_End_Date IS NULL AND mast.Active_Account_End_Date IS NULL)
              and (child.Target_Account_Number = mast.Target_Account_Number OR child.Target_Account_Number IS NULL AND mast.Target_Account_Number IS NULL)
              and (child.Target_Account_Start_Date = mast.Target_Account_Start_Date OR child.Target_Account_Start_Date IS NULL AND mast.Target_Account_Start_Date IS NULL)
              and (child.Target_Account_End_Date = mast.Target_Account_End_Date OR child.Target_Account_End_Date IS NULL AND mast.Target_Account_End_Date IS NULL)
              and (child.Latest_Account_Number = mast.Latest_Account_Number OR child.Latest_Account_Number IS NULL and mast.Latest_Account_Number IS NULL)
              and (child.Latest_Account_Start_Date = mast.Latest_Account_Start_Date OR child.Latest_Account_Start_Date IS NULL AND mast.Latest_Account_Start_Date IS NULL)
              and (child.Logical_Account_Purge_Date = mast.Logical_Account_Purge_Date OR child.Logical_Account_Purge_Date IS NULL and mast.Logical_Account_Purge_Date IS NULL)
and child.run = 374
)




--
-- two way pass
-- return accounts not on current run compared to previousr
select  Logical_Account_Key_Num
              ,Original_Account_Start_Date
              ,Original_Account_End_Date
              ,Active_Account_Number
              ,Active_Account_Start_Date
              ,Active_Account_End_Date
              ,Target_Account_Number
              ,Target_Account_Start_Date
              ,Target_Account_End_Date
              ,Latest_Account_Number
              ,Latest_Account_Start_Date
              ,Logical_Account_Purge_Date
INTO #Account_linking99
from stg.BARCLAYCARD_ACCOUNT_LINKING mast (nolock)
where run = 374
and not 
exists (select TOP 1 1
			  FROM stg.BARCLAYCARD_ACCOUNT_LINKING (nolock) child
			  where ( child.Logical_Account_Key_Num = mast.Logical_Account_Key_Num OR child.Logical_Account_Key_Num IS NULL and mast.Logical_Account_Key_Num is NULL)
              --and (child.Original_Account_Start_Date = mast.Original_Account_Start_Date OR child.Original_Account_Start_Date IS NULL and mast.Original_Account_Start_Date IS NULL)
              --and (child.Original_Account_End_Date = mast.Original_Account_End_Date OR child.Original_Account_End_Date IS NULL AND mast.Original_Account_End_Date IS NULL)
              and (child.Active_Account_Number = mast.Active_Account_Number OR child.Active_Account_Number IS NULL AND mast.Active_Account_Number IS NULL)
              --and (child.Active_Account_Start_Date = mast.Active_Account_Start_Date OR child.Active_Account_Start_Date IS NULL AND mast.Active_Account_Start_Date IS NULL)
              --and (child.Active_Account_End_Date = mast.Active_Account_End_Date OR child.Active_Account_End_Date IS NULL AND mast.Active_Account_End_Date IS NULL)
              --and (child.Target_Account_Number = mast.Target_Account_Number OR child.Target_Account_Number IS NULL AND mast.Target_Account_Number IS NULL)
              --and (child.Target_Account_Start_Date = mast.Target_Account_Start_Date OR child.Target_Account_Start_Date IS NULL AND mast.Target_Account_Start_Date IS NULL)
              --and (child.Target_Account_End_Date = mast.Target_Account_End_Date OR child.Target_Account_End_Date IS NULL AND mast.Target_Account_End_Date IS NULL)
             -- and (child.Latest_Account_Number = mast.Latest_Account_Number OR child.Latest_Account_Number IS NULL and mast.Latest_Account_Number IS NULL)
              --and (child.Latest_Account_Start_Date = mast.Latest_Account_Start_Date OR child.Latest_Account_Start_Date IS NULL AND mast.Latest_Account_Start_Date IS NULL)
              --and (child.Logical_Account_Purge_Date = mast.Logical_Account_Purge_Date OR child.Logical_Account_Purge_Date IS NULL and mast.Logical_Account_Purge_Date IS NULL)
and child.run = 18539
)



select count(*) 
select top 100 * from #Account_linking2 where Logical_Account_Key_Num = 4929534822750

select * from stg.BARCLAYCARD_ACCOUNT_LINKING where Run=374
and Logical_Account_Key_Num=4929534822750
select * from stg.BARCLAYCARD_ACCOUNT_LINKING where Run=18539
and Logical_Account_Key_Num=4929534822750

select * from stg.BARCLAYCARD_ACCOUNT_LINKING where Run=374
and Logical_Account_Key_Num=4929510664952
select * from stg.BARCLAYCARD_ACCOUNT_LINKING where Run=18539
and Logical_Account_Key_Num=4929510664952
select top 100 * from #Account_linking2 where Logical_Account_Key_Num =4929510664952


select count(*) from bi.FDSF_TDTAAccLinkingFactData where RunId=18539


-- no rows, so could be a primary key candidate??
select Run, Logical_Account_Key_Num, Active_Account_Number, count(*) cnt
from stg.BARCLAYCARD_ACCOUNT_LINKING (nolock)
group by Run, Logical_Account_Key_Num, Active_Account_Number
having count(*) > 1