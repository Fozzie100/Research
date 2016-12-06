/*

drop index IX_NCLI_RUN_APPLICATION_ID_PP ON dbo.SDS_IF023_APP_PhilP

CREATE NONCLUSTERED INDEX [IX_NCLI_RUN_APPLICATION_ID_PP]
ON [dbo].[SDS_IF023_APP_PhilP] ([Application_ID], [Run])
INCLUDE ([Audit_Timestamp])

CREATE NONCLUSTERED INDEX [IX_NCLI_RUN_APPLICATION_ID_PP]
ON [dbo].[SDS_IF023_APP_PhilP] ([Run],[Application_ID])
INCLUDE ([Audit_Timestamp])

CREATE NONCLUSTERED INDEX [IX_NCLI_RUN_APPLICATION_ID_PP]
ON [dbo].[SDS_IF023_APP_PhilP] ([Application_ID])
  INCLUDE ([Audit_Timestamp], Run)
*/

/*

drop index IX_CLI_SDS_IF023_APP_PhilP_ApplicationID ON dbo.SDS_IF023_APP_PhilP

CREATE UNIQUE CLUSTERED INDEX [IDX_SDS_IF023_APPLICATION_clust_PP] ON [dbo].[SDS_IF023_APP_PhilP]
(
	[Run] ASC,
	[RowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
GO
*/

sp_help 'dbo.SDS_IF023_APP_PhilP'


--select * from #DeltaRowstest1
--select * from #DeltaRowstest2
drop table #DeltaRowstest1
drop table #DeltaRowstest2
select y.*
into #DeltaRowstest1
from
(
SELECT  mast.Application_ID, case when SUBSTRING(Audit_timestamp, 3,1) LIKE '[A-Z]' THEN 
			 convert (varchar(32), convert(date, substring(Audit_timestamp, 1, 9)), 120) + ' ' + substring(Audit_timestamp, 11, 9)
			 ELSE
			 Audit_timestamp
			END Audit, 
			 ROW_NUMBER() OVER(PARTITION BY mast.Application_ID ORDER BY case when SUBSTRING(Audit_timestamp, 3,1) LIKE '[A-Z]' THEN 
			 convert (varchar(32), convert(date, substring(Audit_timestamp, 1, 9)), 120) + ' ' + substring(Audit_timestamp, 11, 9)
			 ELSE
			 Audit_timestamp
			END DESC) rownum
			, RowId
		FROM  dbo.SDS_IF023_APP_PhilP mast
		where Run=    24072    --- 160 synthetic DEV_05
		-- and Application_ID in( '37295759', '1416315')
) y
where y.rownum = 1		


select 24072 Run, y.Application_ID, y.Audit , de.RowId
into #DeltaRowstest2
from
(
SELECT mast.Application_ID, MAX(case when SUBSTRING(Audit_timestamp, 3,1) LIKE '[A-Z]' THEN 
			 convert (varchar(32), convert(date, substring(Audit_timestamp, 1, 9)), 120) + ' ' + substring(Audit_timestamp, 11, 9)
			 ELSE
			 Audit_timestamp
			END) Audit
			-- ,(select RowId from dbo.SDS_IF023_RES4_PhilP z where Run = mast.Run and  z.Application_ID = mast.Application_ID) RowID
			
		FROM  dbo.SDS_IF023_APP_PhilP mast
		where Run=    24072    --- 160 synthetic DEV_05
		--and Application_ID in ( '37295759','1416315')
		group by mast.Application_ID   -- , MAX(Audit_timestamp)
) y
inner join dbo.SDS_IF023_APP_PhilP de on de.Application_ID  = y.Application_ID
and de.Run=24072 and case when SUBSTRING(de.Audit_timestamp, 3,1) LIKE '[A-Z]' THEN 
			 convert (varchar(32), convert(date, substring(de.Audit_timestamp, 1, 9)), 120) + ' ' + substring(de.Audit_timestamp, 11, 9)
			 ELSE
			 de.Audit_timestamp
			END = y.Audit
where not exists (select top 1 1 from dbo.SDS_IF023_APP_PhilP child
				--where child.APP_TYPE=mast.APP_TYPE
				--and  child.ERA_SCRE =mast.ERA_SCRE
				--and child.MAIN_SCOR_REQD_NODE_ID = mast.MAIN_SCOR_REQD_NODE_ID
				where child.Application_ID = y.Application_ID
				and child.Audit_Timestamp = y.Audit
				and child.Run=25270 -- as of '31 Dec 2015'
				)

select top 100 * from #DeltaRowstest2 where Application_ID = '10048303' -- '37295759'
select top 100 * from dbo.SDS_IF023_APP_PhilP where Application_ID = '10048303' and Run=25270
select top 100 * from dbo.SDS_IF023_APP_PhilP where Application_ID = '10048303' and Run=24072

select 25270 Run, y.Application_ID, y.Audit , de.RowId
into #DeltaRowstest3
from
(
SELECT mast.Application_ID, MAX(case when SUBSTRING(Audit_timestamp, 3,1) LIKE '[A-Z]' THEN 
			 convert (varchar(32), convert(date, substring(Audit_timestamp, 1, 9)), 120) + ' ' + substring(Audit_timestamp, 11, 9)
			 ELSE
			 Audit_timestamp
			END) Audit
			-- ,(select RowId from dbo.SDS_IF023_RES4_PhilP z where Run = mast.Run and  z.Application_ID = mast.Application_ID) RowID
			
		FROM  dbo.SDS_IF023_APP_PhilP mast
		where Run=    25270    --- 160 synthetic DEV_05
		--and Application_ID in ( '37295759','1416315')
		group by mast.Application_ID   -- , MAX(Audit_timestamp)
) y
inner join dbo.SDS_IF023_APP_PhilP de on de.Application_ID  = y.Application_ID
and de.Run=25270 and case when SUBSTRING(de.Audit_timestamp, 3,1) LIKE '[A-Z]' THEN 
			 convert (varchar(32), convert(date, substring(de.Audit_timestamp, 1, 9)), 120) + ' ' + substring(de.Audit_timestamp, 11, 9)
			 ELSE
			 de.Audit_timestamp
			END = y.Audit


select top 100 * from #DeltaRowstest2 where Application_ID in ( '37295759','1416315')
select top 100 * from #DeltaRowstest1 where Application_ID in ( '37295759','1416315')
--
--
-- INDEX
-- ([Application_ID])
--  INCLUDE ([Audit_Timestamp], Run)
-- Time 8-59 mins partition by query
-- Time 8-33 mins group by query
--
-- INDEX
-- ON [dbo].[SDS_IF023_APP_PhilP] ([Run],[Application_ID])
-- INCLUDE ([Audit_Timestamp])
-- Time 6-21 partition by query -- uses NCLI Index seek, by 96% of time spent in sort operator partition/sort clause
-- Time 5-50 group by query  -- uses NCLI Index seek

--
--
-- INDEX
-- ([Application_ID], [Run])
-- INCLUDE ([Audit_Timestamp])
--
-- Time 10-11 group by query  -- uses NCLI Index seek, wants to ad another NCLI to INCLUDE Audit, RowID
-- Time > 10-44 partition query when cancelled

-- conclusion for moment use NCLI index  ([Run],[Application_ID]) INCLUDE ([Audit_Timestamp]) 
-- and use group by query.

--
-- took 3 minutes
drop table #deltarowsxx
select mast.*
into #deltarowsxx
from dbo.SDS_IF023_APP_PhilP mast
where mast.Run = 24072  -- as of '31 Jan 2016'
and not exists (select top 1 1 from dbo.SDS_IF023_APP_PhilP child
				--where child.APP_TYPE=mast.APP_TYPE
				--and  child.ERA_SCRE =mast.ERA_SCRE
				--and child.MAIN_SCOR_REQD_NODE_ID = mast.MAIN_SCOR_REQD_NODE_ID
				where child.Application_ID = mast.Application_ID
				and child.Audit_Timestamp = mast.Audit_Timestamp
				and child.Run=25270 -- as of '31 Dec 2015'
				)


-- took 1 min 04 on 16 million rows
CREATE NONCLUSTERED INDEX [IX_deltarowsxx_PP]
ON  #deltarowsxx ([Run],[Application_ID])
INCLUDE ([Audit_Timestamp])

-- get the top change  drop table #deltarowsxx2
				select y.Application_ID, y.Audit , de.RowId
into #deltarowsxx2
from
(
SELECT mast.Application_ID, MAX(case when SUBSTRING(Audit_timestamp, 3,1) LIKE '[A-Z]' THEN 
			 convert (varchar(32), convert(date, substring(Audit_timestamp, 1, 9)), 120) + ' ' + substring(Audit_timestamp, 11, 9)
			 ELSE
			 Audit_timestamp
			END) Audit
			-- ,(select RowId from dbo.SDS_IF023_RES4_PhilP z where Run = mast.Run and  z.Application_ID = mast.Application_ID) RowID
			
		FROM  #deltarowsxx mast
		where Run=    24072    --- 160 synthetic DEV_05
		--and Application_ID in ( '37295759','1416315')
		group by mast.Application_ID   -- , MAX(Audit_timestamp)
) y
inner join #deltarowsxx de on de.Application_ID  = y.Application_ID
and de.Run=24072 and case when SUBSTRING(de.Audit_timestamp, 3,1) LIKE '[A-Z]' THEN 
			 convert (varchar(32), convert(date, substring(de.Audit_timestamp, 1, 9)), 120) + ' ' + substring(de.Audit_timestamp, 11, 9)
			 ELSE
			 de.Audit_timestamp
			END = y.Audit

