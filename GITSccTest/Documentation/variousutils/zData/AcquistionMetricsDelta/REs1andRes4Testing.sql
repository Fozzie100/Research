
-- sp_help 'tempdb..#SDS_IF023_RES1_Work'
declare @CurrentRunID INT = 65233,
		@PreviousRunID INT = 25524

		
drop table #SDS_IF023_RES1_Work
CREATE TABLE  #SDS_IF023_RES1_Work ( WorkIDKey INT IDEntity(1,1) NOT NULL,
									Run BIGINT,
									Application_ID VARCHAR(32),
									Audit_TimeStamp VARCHAR(32),
									RowIDFullOriginal INT,
									RunFullOriginal BIGINT,
									CUDType INT,
									RowID INT NOT NULL DEFAULT(-1),
									[APP_TYPE] VARCHAR(32),
									[ERA_SCRE] VARCHAR(32),
									[MAIN_SCOR_REQD_NODE_ID] VARCHAR(32),
									RowIDDup INT NOT NULL
									CONSTRAINT pk_SDSIF023RES1Work_RowIDxx PRIMARY KEY(WorkIDKey)
									)
-- CREATE  INDEX IDX_Application_RES1 ON #SDS_IF023_RES1_Work(Application_ID)
CREATE  INDEX IDX_Application_RES1 ON #SDS_IF023_RES1_Work(Application_ID, Audit_timestamp)

--
-- delta code START
--

INSERT INTO #SDS_IF023_RES1_Work (Run,Application_ID,Audit_TimeStamp,RowIDFullOriginal, RunFullOriginal, CUDType, APP_TYPE, ERA_SCRE, MAIN_SCOR_REQD_NODE_ID,RowIDDup)

	SELECT @CurrentRunID, x.Application_ID, x.Audit_Timestamp, x.RowID,  x.RunFullOriginal, x.CUDType
	-- ,ROW_NUMBER() OVER (ORDER BY x.Application_ID, x.CUDType DESC) AS RowID  -- Deletes before Inserts. Fact then populated with correct CUDType on the update statement
	, x.APP_TYPE,x.ERA_SCRE,x.MAIN_SCOR_REQD_NODE_ID
	,ROW_NUMBER() OVER (PARTITION BY x.Application_ID, x.CUDType, x.Audit_Timestamp ORDER BY x.Audit_Timestamp) RowIDDup
	FROM
	(
		SELECT @CurrentRunID Run, y.Application_ID, y.Audit_Timestamp , y.RowId, 1 CUDType, @CurrentRunID RunFullOriginal,
				y.APP_TYPE, y.ERA_SCRE, y.MAIN_SCOR_REQD_NODE_ID
		FROM  stg.SDS_IF023_RES1 y
		WHERE Run=    @CurrentRunID 
		AND NOT EXISTS (
							SELECT TOP 1 1 
							FROM stg.SDS_IF023_RES1 child
							WHERE child.Application_ID = y.Application_ID
							AND SUBSTRING(RTRIM(LTRIM(child.Audit_timestamp)), 1,23) = SUBSTRING(RTRIM(LTRIM(y.Audit_Timestamp)), 1,23)
							AND LTRIM(RTRIM(child.ERA_SCRE)) = LTRIM(RTRIM(y.ERA_SCRE))
							AND LTRIM(RTRIM(child.APP_TYPE)) = LTRIM(RTRIM(y.APP_TYPE))
							AND LTRIM(RTRIM(child.MAIN_SCOR_REQD_NODE_ID)) = LTRIM(RTRIM(y.MAIN_SCOR_REQD_NODE_ID))
							AND child.Run=@PreviousRunID -- as of '31 Dec 2015'
						)
		UNION ALL
	SELECT @CurrentRunID Run, y.Application_ID, y.Audit_Timestamp , y.RowId, 3 CUDType, @PreviousRunID RunFullOriginal
			,y.APP_TYPE, y.ERA_SCRE, y.MAIN_SCOR_REQD_NODE_ID
	
	FROM  stg.SDS_IF023_RES1 y
	WHERE y.Run = @PreviousRunID 
	AND NOT EXISTS (
						SELECT TOP 1 1 
						FROM stg.SDS_IF023_RES1 child
						-- FROM dbo.SDS_IF023_RES1_Phil child
						WHERE child.Application_ID = y.Application_ID
						AND SUBSTRING(RTRIM(LTRIM(child.Audit_timestamp)), 1,23) = SUBSTRING(RTRIM(LTRIM(y.Audit_Timestamp)), 1,23)
						AND LTRIM(RTRIM(child.ERA_SCRE)) = LTRIM(RTRIM(y.ERA_SCRE))
						AND LTRIM(RTRIM(child.APP_TYPE)) = LTRIM(RTRIM(y.APP_TYPE))
						AND LTRIM(RTRIM(child.MAIN_SCOR_REQD_NODE_ID)) = LTRIM(RTRIM(y.MAIN_SCOR_REQD_NODE_ID))
						AND child.Run=@CurrentRunID -- as of '31 Dec 2015'
					)
	) x

--
-- delta code END
-- select count(*) from #SDS_IF023_RES1_Work where RowIDDup > 1 = 415028 
	--select top 100 * from #SDS_IF023_RES1_Work where Application_ID = '51202887' order by Audit_TimeStamp desc
	--select * from stg.SDS_IF023_RES1 where Application_ID = '51202887' and Run= 25524 order by Audit_TimeStamp desc

	--select * from stg.SDS_IF023_RES1 where Application_ID in ('109588', '6738136') and Run=65233 order by Application_ID, Audit_Timestamp
	--select * from stg.SDS_IF023_RES1 where Application_ID in ('109588', '6738136') and Run=25524 order by Application_ID, Audit_Timestamp
	--select * from Phil.IF023_RES1_Jan2016duplicates x where Application_ID in ('109588', '6738136') order by Application_ID, Audit_Timestamp
	--select * from #SDS_IF023_RES1_Work where Application_ID in ('109588', '6738136') order by Application_ID, Audit_Timestamp
	--	where exists ( select top 1 1 from #SDS_IF023_RES1_Work t where t.Application_ID = x.Application_ID)

					INSERT INTO #SDS_IF023_RES1_Work with (tablock) (Run,Application_ID,Audit_TimeStamp,RowIDFullOriginal, RunFullOriginal, CUDType, APP_TYPE, ERA_SCRE, MAIN_SCOR_REQD_NODE_ID,RowIDDup)
					SELECT         -55 Run
				  ,Application_ID
				  ,SUBSTRING(Audit_timestamp, 1,23)
				  ,RowID RowIDFullOriginal
				  ,@CurrentRunID RunFullOriginal
				  ,1 CUDType
				  ,APP_TYPE
				  ,ERA_SCRE
				  ,MAIN_SCOR_REQD_NODE_ID
				  ,ROW_NUMBER() OVER (PARTITION BY Application_ID, Audit_timestamp  ORDER BY Audit_timestamp) RowIDDup 
	FROM stg.SDS_IF023_RES1   
	WHERE Run = @CurrentRunID
	and RowId between 1 and 60000000


	-- (50743765 row(s) affected)   20 minutes
	-- ,-34  RowIDDup --  --

	-- CREATE  INDEX IDX_Application_RES1 ON #SDS_IF023_RES1_Work(Application_ID, Audit_timestamp)



	--select Application_ID, Audit_timestamp, count(*)
	--from #SDS_IF023_RES1_Work
	--group by Application_ID, Audit_timestamp
	--having count(*) > 1
	


	select * 
	into Phil.IF023_RES1_Jan2016duplicates
	from stg.#SDS_IF023_RES1_Work WHERE RowIDDup > 1
	delete stg.#SDS_IF023_RES1_Work WHERE RowIDDup > 1
	-- (35 row(s) affected)   10 seconds

	UPDATE stg.#SDS_IF023_RES1_Work
	SET RowID= x.RowNum
	FROM
	( select CUDType, Application_ID, Audit_timestamp, RowIDFullOriginal,  ROW_NUMBER() OVER (ORDER BY x.Application_ID, x.CUDType DESC) RowNum 
			FROM stg.#SDS_IF023_RES1_Work x
	) x
	WHERE stg.#SDS_IF023_RES1_Work.Application_ID = x.Application_ID
	AND stg.#SDS_IF023_RES1_Work.CUDType = x.CUDType
	AND  stg.#SDS_IF023_RES1_Work.Audit_timestamp = x.Audit_timestamp
	--AND stg.#SDS_IF023_RES1_Work.RowIDFullOriginal = x.RowIDFullOriginal
	-- (50743730 row(s) affected)  30 minutes

	CREATE  INDEX IDX_Application_RowID ON #SDS_IF023_RES1_Work(RowID)
	-- *******************   30 seconds *********************************

	select top 1000 * from #SDS_IF023_RES1_Work where RowID between 30000000 and 35000000

	select * from stg.#SDS_IF023_RES1_Work where RowID=1 or RowID=50743730
	select * from stg.#SDS_IF023_RES1_Work2 where RowNum=1 or RowNum=50743730


	select * from #SDS_IF023_RES1_Work where RowID > 50743730
	select * from #SDS_IF023_RES1_Work2 where RowNum > 50743730
	-- alternately insert after delete statement into stg.#SDS_IF023_RES1_Work possibly
	-- with ROW_NUMBER() OVER (ORDER BY CUDType DESC) RowNum  --- i.e '3's deletes before the '1's deletes
	SELECT y.*, ROW_NUMBER() OVER (ORDER BY y.CUDType DESC) RowNum
	INTO #SDS_IF023_RES1_Work2 
	 from stg.#SDS_IF023_RES1_Work y
	 -- (50743730 row(s) affected) 20 minutes - quicker than doing update



	select top 10 * from stg.#SDS_IF023_RES1_Work Where RowID > 19999995
	select top 10 * from stg.#SDS_IF023_RES1_Work Where RowIDDup <> 1
	select * from stg.#SDS_IF023_RES1_Work where Application_ID= '109588'
	order by Audit_TimeStamp


	UPDATE stg.#SDS_IF023_RES1_Work
	SET RowIDDup= x.RowNum
	FROM
	( select CUDType, Application_ID, Audit_timestamp, RowIDFullOriginal,  ROW_NUMBER() OVER (PARTITION BY Application_ID, Audit_timestamp  ORDER BY RowIDFullOriginal) RowNum 
			FROM stg.#SDS_IF023_RES1_Work x
	) x


	select count(*) from bi.GRCR_SDS_IF023_RES1_FactDataDelta


	select top 100 
	ap.ApplicationId, 
	atype.AppType
	, 
	esc.EraScre, 
	man.MainScorReqdNodeId, 
	y.* 
	from bi.GRCR_SDS_IF023_RES1_FactDataDelta (nolock) y
	inner join bi.ApplicationIdSCD ap
	on ap.ApplicationIdAttrKeyID = y.ApplicationIdAttrKey
	inner join bi.AppTypeSCD atype
	on atype.AppTypeAttrKeyID = y.AppTypeAttrKey
	inner join bi.EraScreSCD esc
	on esc.EraScreAttrKeyID = y.EraScreAttrKey
	inner join bi.MainScorReqdNodeIdSCD man
	on man.MainScorReqdNodeIdAttrKeyID = y.MainScorReqdNodeIdAttrKey

	CREATE  INDEX IDX_GRCR_SDS_IF023_RES1_FactDataDelta_Application ON bi.GRCR_SDS_IF023_RES1_FactDataDelta(ApplicationIdAttrKey)
	CREATE  INDEX IDX_GRCR_SDS_IF023_RES1_FactDataDelta_AppType ON bi.GRCR_SDS_IF023_RES1_FactDataDelta(AppTypeAttrKey)

	CREATE  INDEX IDX_GRCR_SDS_IF023_RES1_FactDataDelta_EraScre ON bi.GRCR_SDS_IF023_RES1_FactDataDelta(EraScreAttrKey)
	CREATE  INDEX IDX_GRCR_SDS_IF023_RES1_FactDataDelta_MainScorReqdNodeId ON bi.GRCR_SDS_IF023_RES1_FactDataDelta(MainScorReqdNodeIdAttrKey)

	drop index IDX_GRCR_SDS_IF023_RES1_FactDataDelta_Application ON bi.GRCR_SDS_IF023_RES1_FactDataDelta



	select y.ApplicationIdAttrKey
	from bi.GRCR_SDS_IF023_RES1_FactDataDelta y
	inner join
	(
	select top 100 ApplicationIdAttrKey, RunID  -- , count(*)
	from bi.GRCR_SDS_IF023_RES1_FactDataDelta
	where RunId=120352
	group By RunID, ApplicationIdAttrKey
	having count(*) > 1
	) x
	on y.ApplicationIdAttrKey = x.ApplicationIdAttrKey
	where y.RunId=120351

	

	select * from bi.GRCR_SDS_IF023_RES1_FactDataDelta where ApplicationIdAttrKey =  165741439
	order by RunId, AuditTimestamp

	sp_help 'bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta'


	DROP INDEX IX_App_ID_SCD ON bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta

