

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'bi.uspLoadGRCR_ImpairmentFactDataChunk'))
BEGIN
    EXEC('CREATE PROCEDURE bi.uspLoadGRCR_ImpairmentFactDataChunk AS ')
END

GO
/*************************************************************



Pgmr:	Date:				Ref:							Description

PP		06.10.2015				Created.

***************************************************************/
ALTER PROCEDURE [bi].[uspLoadGRCR_ImpairmentFactDataChunk]
(
	 @p_Run int
	,@Startrow INT = 1
	,@EndRow INT = 2000000000
	,@p_debug bit = 0
	,@p_RunSetID INT = -1
	,@p_COBDate DATE = '30 Jun 2015'
)

AS

--DECLARE @p_Run INT = 1
--	,@Startrow INT = 500001
--	,@EndRow INT = 500011
--	,@p_debug bit = 0

 BEGIN
     BEGIN TRY;

		SET NOCOUNT ON;

		-- BEGIN Log Procedure Start  
		DECLARE @ProcName sysname = coalesce ( app.sfnObjectName(@@PROCID),'bi.uspLoadGRCR_CapitalFactDataChunk');

		DECLARE @ProcMessage nvarchar(max) = 'EXEC ' + @ProcName + ' ,@p_run=' + coalesce(convert(varchar(99),@p_run),'NULL') + ' @Startrow=' + CAST(@Startrow AS VARCHAR(20)) + ' @EndRow='  + CAST(@EndRow AS VARCHAR(20))
		-- EXEC log.uspLogInsertDB  @p_LogCategory = 'PROC.BEGIN',@p_LogObject = @ProcName,@p_LogMessage = @ProcMessage,@p_LogLevel = 5,@p_Run = @p_Run
		IF @p_debug=1 print ''+ @ProcName  + ' - ' + @ProcMessage
		-- END Log Procedure Start    

		-- BEGIN Standard Procedure Block - Pre Business Logic - based on app.uspStoredProcedureWithoutRetryTemplate
		DECLARE
			@InitiatedTransaction bit = 0
		   ,@Retry smallint -- Keep, so catch block is the same
		   ,@Trancount smallint;
		-- END Standard Procedure Block - Pre Business Logic - based on app.uspStoredProcedureWithoutRetryTemplate


		-- BEGIN Business Logic
		--EXEC log.uspLogInsertDB @p_LogMessage = 'Loading #AtomTemp Table', @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run;
		--IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) + ' : Loading #AtomTemp Table';

		DECLARE @MaxSystemDate DATE = app.sfnConfigurationGet('MaxSystemDate');
		DECLARE	@rowcount INT;

		IF OBJECT_ID(N'tempdb.dbo.#refAtomValue') IS NOT NULL
		DROP TABLE #refAtomValue

		CREATE TABLE #refAtomValue(
			AtomValueID int  NOT NULL,
			AtomID int NOT NULL,
			AtomTypeID smallint NULL,
			AtomValueTypeID int NOT NULL,
			AtomValueCategoryID int NOT NULL,
			AtomValueExtentID int NOT NULL,
			EffectiveFromDateTime datetime NULL,
			AppliedFromDateTime datetime NOT NULL,
			CurrencyCode char(3) NOT NULL,
			Value decimal(28, 8) NOT NULL,
			Run int NOT NULL,
			SourceRowID int NOT NULL)

		-- get latest run for COBDate from both IMPAIR BASE and VNTG_NETBALANCE_NORY atoms

		--select top 100 * from loader.Job j
		--select top 100 * from loader.JobRun

		DECLARE @RunNos TABLE (Run INT primary key, JobDefintionId INT, JobDefinitionCode VARCHAR(64))
		INSERT INTO @RunNos (Run, JobDefintionId, JobDefinitionCode)
		select x.Run, x.JobDefinitionID, x.JobDefinitionCode
		from
		(
		select  ROW_NUMBER() OVER(partition by jd.JobDefinitionId order by jr.Run desc) rownum,
		jr.Run, jr.RunStatus, jd.JobDefinitionId, jd.JobDefinitionCode   --,  -- , j.*
		
		from loader.JobDefinition jd
		inner join loader.Job j
		ON j.JobDefinitionCode = jd.JobDefinitionCode
		inner join loader.JobRun jr
		on jr.JobID  = j.JobID
		where	( 
					jd.JobDefinitionCode =  'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
					or 
					jd.JobDefinitionCode =  'BCARD_XX_BARCLAYCARD_IMPAIR_BASE'
					
				)
		and j.CobDate = @p_COBDate
		and jr.RunStatus = 'S' --- Success
		) x
		WHERE x.rownum =  1

		-- select * from @RunNos 
		-- order by j.JobId, jr.Run desc



		INSERT INTO #refAtomValue
		SELECT   av.*
		FROM ref.atomvalue av (NOLOCK)
		INNER JOIN @RunNos rn
		ON rn.Run= av.Run
		--WHERE av.Run = @p_Run 
		AND SourceRowID BETWEEN @Startrow AND @EndRow


		--select top 100 * from #refAtomValue
		--group by AtomTypeID

		--select * from ref.AtomType where AtomTypeID in (402,311,403)
		-- select * from bi.

		CREATE CLUSTERED INDEX #refAtomValue_ix ON #refAtomValue (AtomID,AtomValueTypeID)

		DECLARE @DesiredParticles TABLE (ParticleTypeId int,EntityTypeId int, PRIMARY KEY (ParticleTypeID ASC, EntityTypeID ASC))

		INSERT INTO @DesiredParticles
		SELECT ParticleTypeID,EntityTypeID
		FROM ref.ParticleType pt (NOLOCK)
		WHERE pt.ParticleTypeCode in 
		('CounterPartyIDAttr', 'AccountOPenDateAttr','GripArrearsLevelAttr', 'ImpairFlagAttr', 'ProductGrpAttr', 'InScopeAttr', 'ChargeoffFlagAttr')

		DECLARE @DesiredAtoms TABLE (AtomValueTypeId INT PRIMARY KEY,AtomValueTypeCode VARCHAR(100))

		-- Get the impair base and VintageAtoms
		INSERT INTO @DesiredAtoms(AtomValueTypeId,AtomValueTypeCode)
		SELECT AtomValueTypeId,AtomValueTypeCode
		FROM ref.AtomValueType (NOLOCK)
		WHERE AtomValueTypeCode in ('account_no', 'netbalance_finance')
	-- possible add 'AccountOpenDateAttr-ChargeoffFlagAttr-ImpairFlagAttr-InScopeAttr-ProductGrpAttr'
	-- some data has no GripArrearsLevelAttr values
		IF object_id(N'tempdb.dbo.#Atomtemp') is NOT NULL
		DROP TABLE #Atomtemp

		CREATE TABLE #AtomTemp
		(
			EntityTypeName	VARCHAR(64)
			,value  DECIMAL(28,8)
			,CurrencyCode CHAR(3)
			,AtomValueTypeCode VARCHAR(256)
			,Run	INT
			,SourceRowID	INT
			,ParticleKey	INT
			,AtomTypeCode VARCHAR(512)
		)

		INSERT INTO #AtomTemp 
		(
			EntityTypeName
			,value
			,CurrencyCode
			,AtomValueTypeCode
			,Run
			,SourceRowID
			,ParticleKey
			,AtomTypeCode
		)

		SELECT EntityTypeName
			   ,value
			   ,CurrencyCode
			   ,avt.AtomValueTypeCode
			   ,av.Run
			   ,SourceRowID
			   ,ParticleKey
			   ,at.AtomTypeCode
		FROM #refAtomValue av 
			   INNER JOIN ref.AtomParticle ap (NOLOCK)
			   ON av.AtomID = ap.AtomID
			   INNER JOIN @DesiredParticles pt 
			   ON pt.ParticleTypeID = ap.ParticleTypeID 
			   INNER JOIN entity.EntityType et (NOLOCK)
			   ON et.EntityTypeID = pt.EntityTypeID
			   INNER JOIN @DesiredAtoms avt 
			   ON avt.AtomValueTypeID = av.AtomValueTypeID 
			   INNER JOIN ref.AtomType at
			   ON at.AtomTypeID = av.AtomTypeID
	   
		SET @rowcount  = @@ROWCOUNT 
		

		-- select * from #refAtomValue
		--SET @ProcMessage = 'Loaded ' + cast(@rowcount as varchar) + ' row(s) Or Atom Values into #AtomTemp Table'
		--EXEC log.uspLogInsertDB @p_LogMessage = @ProcMessage, @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run
		--IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) +  ' : Loaded ' + cast(@rowcount as varchar) + ' row(s) Or Atom Values into #AtomTemp Table';
		
		-- Create NON clustered index on Particlekey
		CREATE NONCLUSTERED INDEX NIX_ParticleKey_#Atomtemp ON #AtomTemp(ParticleKey) 

		-- Create NON clustered index on Value
		CREATE NONCLUSTERED INDEX NIX_Value_#Atomtemp ON #AtomTemp(Value) 

		-- CREATE CLUSTERED INDEX ON SourceROWID
		CREATE CLUSTERED INDEX CIX_SourceRowID_#AtomTemp ON #AtomTemp(SourceRowID)

		--SET @ProcMessage = 'Indexed #AtomTemp Table'
		--EXEC log.uspLogInsertDB @p_LogMessage = @ProcMessage, @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run
		--IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) +  ' : Indexed #AtomTemp Table';

		-- 'ECGoodBadFlagAttr', 'PortfolioIdAttr','ReportingPeriodAttr')
		--  Get Attibute Key for 'BLANK' values
		DECLARE		@BlankCounterPartyIDAttrkey INT = (SELECT TOP 1 [CounterpartyIDAttrKeyID] FROM [bi].[CounterpartyIDAttrSCD] WHERE [CounterpartyID] = 'BLANK' ORDER BY [CounterpartyIDAttrKeyID] DESC)
					,@BlankAccountOpenDateAttrKey INT = (SELECT TOP 1 [AccountOpenDateAttrKeyID] FROM [bi].[AccountOpenDateAttrSCD] WHERE [account_open_month] = 'BLANK' ORDER BY [AccountOpenDateAttrKeyID] DESC)
					,@BlankGripArrearsLevelAttrKey INT = (SELECT TOP 1 [GripArrearsLevelAttrKeyID] FROM [bi].[GripArrearsLevelAttrSCD] WHERE [grip_arrears_level] = 'BLANK' ORDER BY [GripArrearsLevelAttrKeyID] DESC)
					,@BlankImpairFlagAttrKey INT = (SELECT TOP 1 [ImpairFlagAttrKeyID] FROM [bi].[ImpairFlagAttrSCD] WHERE [impair_flag] = 'BLANK' ORDER BY [ImpairFlagAttrKeyID] DESC)
					,@BlankProductGroupAttrKey INT = (SELECT TOP 1 [ProductGrpAttrKeyID] FROM [bi].[ProductGrpAttrSCD] WHERE [product_grp] = 'BLANK' ORDER BY [ProductGrpAttrKeyID] DESC)
					,@BlankInScopeAttrKey INT = (SELECT TOP 1 [InScopeAttrKeyID] FROM [bi].[InScopeAttrSCD] WHERE [In_Scope] = 'BLANK' ORDER BY [InScopeAttrKeyID] DESC)
					,@BlankChargeoffFlagAttrKey INT = (SELECT TOP 1 [ChargeoffFlagAttrKeyID] FROM [bi].[ChargeoffFlagAttrSCD] WHERE [coff_flag] = 'BLANK' ORDER BY [ChargeoffFlagAttrKeyID] DESC)
					

		-- populate #FactData
		-- select top 100 * from #AtomTemp
		IF OBJECT_ID(N'tempdb.dbo.#FactDataImpair') IS NOT NULL
		DROP TABLE #FactDataImpair
		
		SELECT 
			t1.SourceRowID
			,t1.Run
			,@p_RunSetID AS RunSetId
			,ISNULL(t1.AccountOpenDateAttr, @BlankAccountOpenDateAttrKey ) AS AccountOpenDateAttrKey 
			,ISNULL(t1.GripArrearsLevelAttr, @BlankGripArrearsLevelAttrKey) AS GripArrearsLevelAttrKey
			,ISNULL(t1.ImpairFlagAttr, @BlankImpairFlagAttrKey) AS ImpairFlagAttrKey
			,ISNULL(t1.ProductGrpAttr, @BlankProductGroupAttrKey) AS ProductGrpAttrKey
			,ISNULL(t1.InScopeAttr, @BlankInScopeAttrKey) AS InScopeAttrKey
			,ISNULL(t1.ChargeoffFlagAttr, @BlankChargeoffFlagAttrKey) AS ChargeoffFlagAttrKey
			,CAST(NULL AS INT)  AS AccountOpenDateChangeListId
			,CAST(NULL AS INT)  AS GripArrearsLevelAttrChangeListId
			,CAST(NULL AS INT)  AS ImpairFlagAttrChangeListId
			,CAST(NULL AS INT)  AS ProductGrpAttrChangeListId
			,CAST(NULL AS INT)  AS InScopeAttrChangeListId
			,CAST(NULL AS INT)  AS ChargeoffFlagAttrChangeListId
			
			-- ,CASE WHEN ISNUMERIC(t1.EconomicCapitalGroupC) = 1 THEN CAST(t1.EconomicCapitalGroupC AS DECIMAL(38,10)) ELSE CAST(0 AS DECIMAL(38,10)) END AS EconomicGroupCapitalAmt
			,account_no
			,RIGHT(concat('0000000000000000', CONVERT( varchar(32), convert(BIGINT,  account_no))), 16) account_no_string
			 
		INTO #FactDataImpair 
			FROM
				(
					SELECT  * FROM 
				(
					SELECT  EntityTypeName
							,value
							,CurrencyCode
							,AtomValueTypeCode
							,Run
							,SourceRowID
							,ParticleKey
					FROM #AtomTemp
					WHERE AtomTypeCode = 'AccountOpenDateAttr-ChargeoffFlagAttr-GripArrearsLevelAttr-ImpairFlagAttr-InScopeAttr-ProductGrpAttr'
			) AS t
		PIVOT 
				( AVG(t.ParticleKey)
			FOR
					EntityTypeName IN
				(
					
					AccountOpenDateAttr
					,GripArrearsLevelAttr
					,ImpairFlagAttr
					,ProductGrpAttr
					,InScopeAttr
					,ChargeoffFlagAttr
					
					
				)
			) AS pv
		PIVOT
				( AVG(value)
			FOR
					AtomValueTypeCode IN
				(
					account_no
				)      
			) AS pv2
		) AS t1


		SET @rowcount  = @@ROWCOUNT 

		--SET @ProcMessage = 'Loaded ' + cast(@rowcount as varchar) + ' row(s) into FactData'
		--EXEC log.uspLogInsertDB @p_LogMessage = @ProcMessage, @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run;
		--IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) +  ' : Loaded #FactData table';
		-- select top 100 * from #FactData
		-- select top 100 * from #AtomTemp
		-- Create Index's on #FactData
		CREATE CLUSTERED INDEX CIX_#FactData_Clustered ON #FactDataImpair	(SourceRowID) 
		CREATE NONCLUSTERED INDEX idx_#FactData_account_no ON #FactDataImpair (account_no_string)
		CREATE NONCLUSTERED INDEX idx_#FactData_AccOpen ON #FactDataImpair (AccountOpenDateAttrKey)
		CREATE NONCLUSTERED INDEX idx_#FactData_GripArrears ON #FactDataImpair (GripArrearsLevelAttrKey)
		CREATE NONCLUSTERED INDEX idx_#FactData_ImpairFlag ON #FactDataImpair (ImpairFlagAttrKey)
		CREATE NONCLUSTERED INDEX idx_#FactData_ProductGrp ON #FactDataImpair (ProductGrpAttrKey)
		

		-- Now get the Vintage Netbalance numbers

		IF OBJECT_ID(N'tempdb.dbo.#FactDataVntgNetBalance') IS NOT NULL
		DROP TABLE #FactDataVntgNetBalance

		SELECT 
			t1.SourceRowID
			,t1.Run
			,@p_RunSetID AS RunSetId
			,ISNULL(t1.CounterPartyIDAttr, @BlankCounterPartyIDAttrkey) AS CounterPartyIDAttrKey
			,CAST(NULL AS INT)  AS CounterPartyIDChangeListId
			
			
			-- ,CASE WHEN ISNUMERIC(t1.EconomicCapitalGroupC) = 1 THEN CAST(t1.EconomicCapitalGroupC AS DECIMAL(38,10)) ELSE CAST(0 AS DECIMAL(38,10)) END AS EconomicGroupCapitalAmt
			,netbalance_finance
			,CAST(NULL AS VARCHAR(16))  account_no_string
		INTO #FactDataVntgNetBalance 
			FROM
				(
					SELECT  * FROM 
							(
								SELECT  EntityTypeName
								,value
								,CurrencyCode
								,AtomValueTypeCode
								,Run
								,SourceRowID
								,ParticleKey
								FROM #AtomTemp
								where AtomTypeCode  = 'CounterPartyIdAttr'
							) AS t
					PIVOT 
					(	AVG(t.ParticleKey)
						FOR
						EntityTypeName IN
						( CounterPartyIDAttr )
					) AS pv
					PIVOT
						(	AVG(value)
							FOR
							AtomValueTypeCode IN (	netbalance_finance	)      
						) AS pv2
				) AS t1
			
		CREATE CLUSTERED INDEX CIX_#FactDataVntg_Clustered ON #FactDataVntgNetBalance	(SourceRowID) 
		CREATE NONCLUSTERED INDEX idx_#FactDataVntg_AccountOpenDateAttrKey ON #FactDataVntgNetBalance (account_no_string)
		CREATE NONCLUSTERED INDEX idx_#FactDataVntg_CounterpartyIDAttrKey ON #FactDataVntgNetBalance (CounterPartyIDAttrKey)
		
		--SET @ProcMessage = 'Indexed #FactData Table'
		--EXEC log.uspLogInsertDB @p_LogMessage = @ProcMessage, @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run;
		--IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) +  ' : Indexed #FactData Table';

		-- drop table #cp
		-- set CounterPartyIDChangeListId
		;WITH DIM_CTE AS (SELECT CounterpartyID, CounterpartyIDAttrKeyID, ChangeListId, ROW_NUMBER() OVER (PARTITION BY CounterpartyIDAttrKeyID ORDER BY ChangeListId DESC) AS RowNum  FROM bi.CounterpartyIDAttrSCD)
		--create table #cp (CounterpartyID varchar(32), CounterpartyIDAttrKeyID BIGINT PRIMARY KEY, ChangeListId BIGINT, RowNum INT)

		--insert into #cp(CounterpartyID , CounterpartyIDAttrKeyID , ChangeListId , RowNum )
		--SELECT 
		--CounterpartyID, CounterpartyIDAttrKeyID, ChangeListId, ROW_NUMBER() OVER (PARTITION BY CounterpartyIDAttrKeyID ORDER BY ChangeListId DESC) AS RowNum  
		--into #cp
		--FROM bi.CounterpartyIDAttrSCD
		

		UPDATE #FactDataVntgNetBalance
		SET CounterPartyIDChangeListId = D.ChangeListId,
		account_no_string = D.CounterpartyID
		FROM #FactDataVntgNetBalance F
		INNER JOIN bi.CounterpartyIDAttrSCD D
		ON F.CounterPartyIDAttrKey = D.CounterpartyIDAttrKeyID
		--WHERE D.RowNum = 1



		-- set AccountOpenDateChangeListId
		;WITH DIM_CTE AS (SELECT AccountOpenDateAttrKeyID, ChangeListId, ROW_NUMBER() OVER (PARTITION BY AccountOpenDateAttrKeyID ORDER BY ChangeListId DESC) AS RowNum  FROM bi.AccountOpenDateAttrSCD)
		UPDATE #FactDataImpair
		SET AccountOpenDateChangeListId = D.ChangeListId
		FROM #FactDataImpair F
		INNER JOIN DIM_CTE D
		ON F.AccountOpenDateAttrKey = D.AccountOpenDateAttrKeyID
		WHERE D.RowNum = 1

		-- set GripArrearsLevelAttrChangeListId
		;WITH DIM_CTE AS (SELECT GripArrearsLevelAttrKeyID, ChangeListId, ROW_NUMBER() OVER (PARTITION BY GripArrearsLevelAttrKeyID ORDER BY ChangeListId DESC) AS RowNum  FROM bi.GripArrearsLevelAttrSCD)
		UPDATE #FactDataImpair
		SET GripArrearsLevelAttrChangeListId = D.ChangeListId
		FROM #FactDataImpair F
		INNER JOIN DIM_CTE D
		ON F.GripArrearsLevelAttrKey = D.GripArrearsLevelAttrKeyID
		WHERE D.RowNum = 1

		-- set ImpairFlagAttrChangeListId
		;WITH DIM_CTE AS (SELECT ImpairFlagAttrKeyID, ChangeListId, ROW_NUMBER() OVER (PARTITION BY ImpairFlagAttrKeyID ORDER BY ChangeListId DESC) AS RowNum  FROM bi.ImpairFlagAttrSCD)
		UPDATE #FactDataImpair
		SET ImpairFlagAttrChangeListId = D.ChangeListId
		FROM #FactDataImpair F
		INNER JOIN DIM_CTE D
		ON F.ImpairFlagAttrKey = D.ImpairFlagAttrKeyID
		WHERE D.RowNum = 1

		-- set ProductGrpAttrChangeListId
		;WITH DIM_CTE AS (SELECT ProductGrpAttrKeyID, ChangeListId, ROW_NUMBER() OVER (PARTITION BY ProductGrpAttrKeyID ORDER BY ChangeListId DESC) AS RowNum  FROM bi.ProductGrpAttrSCD)
		UPDATE #FactDataImpair
		SET ProductGrpAttrChangeListId = D.ChangeListId
		FROM #FactDataImpair F
		INNER JOIN DIM_CTE D
		ON F.ProductGrpAttrKey = D.ProductGrpAttrKeyID
		WHERE D.RowNum = 1

		-- set InScopeAttrChangeListId
		;WITH DIM_CTE AS (SELECT InScopeAttrKeyID, ChangeListId, ROW_NUMBER() OVER (PARTITION BY InScopeAttrKeyID ORDER BY ChangeListId DESC) AS RowNum  FROM bi.InScopeAttrSCD)
		UPDATE #FactDataImpair
		SET InScopeAttrChangeListId = D.ChangeListId
		FROM #FactDataImpair F
		INNER JOIN DIM_CTE D
		ON F.InScopeAttrKey = D.InScopeAttrKeyID
		WHERE D.RowNum = 1

		-- set ChargeoffFlagAttrChangeListId  drop table #FactData
		;WITH DIM_CTE AS (SELECT ChargeoffFlagAttrKeyID, ChangeListId, ROW_NUMBER() OVER (PARTITION BY ChargeoffFlagAttrKeyID ORDER BY ChangeListId DESC) AS RowNum  FROM bi.ChargeoffFlagAttrSCD)
		UPDATE #FactDataImpair
		SET ChargeoffFlagAttrChangeListId = D.ChangeListId
		FROM #FactDataImpair F
		INNER JOIN DIM_CTE D
		ON F.ChargeoffFlagAttrKey = D.ChargeoffFlagAttrKeyID
		WHERE D.RowNum = 1

		--select top 100 * from ref.AtomType where AtomTypeID in ( 311, 402)
		--select top 10000 * from #refAtomValue where AtomTYpeID != 311


		--select count(*) from #FactDataVntgNetBalance
		--select count(*) from #FactDataImpair	


		--select top 10000 * from #FactDataVntgNetBalance	
		--select top 10000 * from #FactDataImpair	


		--select base.SourceRowId, base.Run, base.RunsetID, noyr.SourceRowID, noyr.Run, noyr.RunsetID, noyr.CounterPartyIDAttrKey, noyr.CounterPartyIDChangeListId,
		--base.AccountOpenDateAttrKey, base.GripArrearsLevelAttrKey, base.ImpairFlagAttrKey,
		--base.ProductGrpAttrKey, base.InScopeAttrKey, base.ChargeoffFlagAttrKey,
		--base.AccountOpenDateChangeListId, base.GripArrearsLevelAttrChangeListId,
		--base.ImpairFlagAttrChangeListId, base.ProductGrpAttrChangeListId, base.InScopeAttrChangeListId,
		--base.ChargeoffFlagAttrChangeListId,	
		--noyr.netbalance_finance
		--from #FactDataImpair base
		--left join #FactDataVntgNetBalance noyr
		--on noyr.account_no_string = base.account_no_string
				

		--SET @ProcMessage = 'Set ChangeListIds in #FactData for all Key values'
		--EXEC log.uspLogInsertDB @p_LogMessage = @ProcMessage, @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run;
		--IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) +  ' : Set ChangeListIds in #FactData for all Key values';

		--SET @ProcMessage = 'Loading bi.GRCR_CapitalFactData Table'
		--EXEC log.uspLogInsertDB @p_LogMessage = @ProcMessage, @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run;
		--IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) +  ' : Loading bi.GRCR_CapitalFactData Table';

		SET @Trancount = @@TRANCOUNT;
		IF @Trancount = 0
		BEGIN
			BEGIN TRAN
			SET @InitiatedTransaction = 1;
		END    
		SAVE TRANSACTION @ProcName;

		-- Load bi.GRCR_CapitalFactData
		INSERT INTO  bi.GRCR_ImpairmentFactData
		(
		[RunID]
		,[RunSetId]
		,[SourceRowIdBase] 
		,[RunIdBase]
		,[RunSetIdBase]
		,[SourceRowIdVntgNetBal]
		,[RunIdVntgNetBal]
		,[RunSetIdVntgNetBal] 
		,[CounterPartyIdAttrKey] 
		,[CounterPartyIdAttrChangeListId]
		,[AccountOpenDateAttrKey]
		,[GripArrearsLevelAttrKey]
		,[ImpairFlagAttrKey]
		,[ProductGrpAttrKey] 
		,[InScopeAttrKey]
		,[ChargeoffFlagAttrKey]
		,[AccountOpenDateChangeListId]
		,[GripArrearsLevelAttrChangeListId]
		,[ImpairFlagAttrChangeListId]
		,[ProductGrpAttrChangeListId] 
		,[InScopeAttrChangeListId] 
		,[ChargeoffFlagAttrChangeListId] 
		,[netbalance_finance] 

		,[RunIdG1Debtp]
		,[RunSetIdG1Deptp]
		,[RunIdN9Debtp]
		,[RunSetN9Debtp]
		,[RouterAccountNumberAttrKey]
		,[PortfolioIdAttrKey]
		,[G1DebtpStatusAttrKey]
		,[FipTypeAttrKey]
		,[BrokenInstallmentsAttrKey]
		,[RouterAccountNumberAttrChangeListId]
		,[PortfolioIdAttrChangeListId]
		,[G1DebtpStatusAttrChangeListId]
		,[FipTypeAttrChangeListId]
		,[BrokenInstallmentsAttrChangeListId]

	
		)

		select
		@p_Run,
		@p_RunSetID,
		base.SourceRowId, 
		base.Run, 
		base.RunsetID, 
		noyr.SourceRowID, 
		noyr.Run, 
		noyr.RunsetID, 
		noyr.CounterPartyIDAttrKey, 
		noyr.CounterPartyIDChangeListId,
		base.AccountOpenDateAttrKey, 
		base.GripArrearsLevelAttrKey, 
		base.ImpairFlagAttrKey,
		base.ProductGrpAttrKey, 
		base.InScopeAttrKey, 
		base.ChargeoffFlagAttrKey,
		base.AccountOpenDateChangeListId, 
		base.GripArrearsLevelAttrChangeListId,
		base.ImpairFlagAttrChangeListId, 
		base.ProductGrpAttrChangeListId, base.InScopeAttrChangeListId,
		base.ChargeoffFlagAttrChangeListId,	
		noyr.netbalance_finance,

		-1,
		-1,
		-1,
		-1,
		-1,
		-1,
		-1,
		-1,
		-1,
		-1,
		-1,
		-1,
		-1,
		-1

		from #FactDataImpair base
		left join #FactDataVntgNetBalance noyr
		on noyr.account_no_string = base.account_no_string

		SET @rowcount = @@rowcount

		SET @ProcMessage = 'Loaded ' + cast(@rowcount AS VARCHAR) + ' row(s) into bi.GRCR_ImpairmentFactData Table' + ', @p_run=' + coalesce(convert(varchar(99),@p_run),'NULL') + ' @Startrow=' + CAST(@Startrow AS VARCHAR(20)) + ' @EndRow='  + CAST(@EndRow AS VARCHAR(20))
		EXEC log.uspLogInsertDB @p_LogMessage = @ProcMessage, @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run ;
		IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) +  ' : Loaded ' + cast(@rowcount AS VARCHAR) + ' row(s) into  bi.GRCR_ImpairmentFactData Table';

		-- BEGIN Standard Procedure Block - Post Business Logic - based on app.uspStoredProcedureWithoutRetryTemplate
		IF (@InitiatedTransaction = 1 AND XACT_STATE() = 1)
		BEGIN
			COMMIT TRAN; -- If there is an active committable transaction, initiated in this procedure, then Commit Transaction
		END
	END TRY
	BEGIN CATCH
		-- BEGIN STANDARD CATCH BLOCK
		-- Avoid Error app 266 -- Transaction count after EXECUTE indicates a mismatching number of BEGIN and COMMIT statements
		IF @p_debug <> 0
		BEGIN
			PRINT 'Error in proc: ' + CONVERT(VARCHAR(128), @ProcName)
			PRINT 'Error number : ' + CONVERT(VARCHAR(30), ERROR_NUMBER())
		END
		
		BEGIN TRY EXEC app.uspStandardCatchBlock @ProcID = @@PROCID, @InitiatedTransaction = @InitiatedTransaction, @Retry = @Retry OUTPUT; END TRY BEGIN CATCH IF (ERROR_NUMBER() <> 266) THROW; END CATCH;
		-- END STANDARD CATCH BLOCK
	END CATCH
	 -- END Standard Procedure Block - Post Business Logic - based on app.uspStoredProcedureWithoutRetryTemplate

	-- Clear the temp tables here
	IF object_id(N'tempdb.dbo.#Atomtemp') is NOT NULL
	DROP TABLE #Atomtemp

	IF OBJECT_ID(N'tempdb.dbo.#FactDataImpair') IS NOT NULL
	DROP TABLE #FactDataImpair

	IF OBJECT_ID(N'tempdb.dbo.#FactDataVntgNetBalance') IS NOT NULL
	DROP TABLE #FactDataVntgNetBalance
  
		-- BEGIN Log Procedure End 
	EXEC log.uspLogInsertDB  @p_LogCategory = 'PROC.END',@p_LogObject = @ProcName,@p_LogMessage = NULL,@p_LogLevel = 5,@p_Run = @p_Run

		-- END Log Procedure End 
                     
END 
-- rollback tran