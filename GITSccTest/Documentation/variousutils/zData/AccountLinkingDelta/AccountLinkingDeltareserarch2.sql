-- 47675198
select Count(*)from stg.BARCLAYCARD_ACCOUNT_LINKING 
where run = 18539


-- 47540013
select Count(*)from stg.BARCLAYCARD_ACCOUNT_LINKING 
where run = 374


select * from loader.JobRun where run in (374,18539)
select * from loader.Job where JobID in (25,30)


select top 100 * from loader.JobDefinition
where convert(varchar(max), JobDefinitionConfig) like '%stg.BARCLAYCARD_ACCOUNT_LINKING%'

drop table #Account_linking

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
			 
INTO #Account_linking
from stg.BARCLAYCARD_ACCOUNT_LINKING (nolock)
where run = 18539
EXCEPT
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
from stg.BARCLAYCARD_ACCOUNT_LINKING (nolock)
where run = 374


select top 100 * from #Account_linking where Logical_Account_Key_Num = 4929534822750

select * from stg.BARCLAYCARD_ACCOUNT_LINKING where Run=374
and Logical_Account_Key_Num=4929534822750
select * from stg.BARCLAYCARD_ACCOUNT_LINKING where Run=18539
and Logical_Account_Key_Num=4929534822750

-- should be no rows.
select * from stg.BARCLAYCARD_ACCOUNT_LINKING 
where Run=374 
and ( Active_Account_Number=4929107239565008 or Logical_Account_Key_Num=4929107239565 or Latest_Account_Number=4929107239565)
select HASHBYTES('SHA1', (SELECT * FROM stg.BARCLAYCARD_ACCOUNT_LINKING where Run=374 and RowID=29090666 FOR XML RAW))

SELECT o1.object_id, HASHBYTES('SHA1', (SELECT * FROM sys.objects o2 WHERE o2.object_id = o1.object_id FOR XML RAW))
FROM sys.objects o1


-- no rows, so could be a primary key candidate??
select Run, Logical_Account_Key_Num, Active_Account_Number, Latest_Account_Number, count(*) cnt
from stg.BARCLAYCARD_ACCOUNT_LINKING
group by Run, Logical_Account_Key_Num, Active_Account_Number, Latest_Account_Number
having count(*) > 1