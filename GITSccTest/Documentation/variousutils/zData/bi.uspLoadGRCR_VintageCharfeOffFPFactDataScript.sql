





--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'bi.uspLoadGRCR_VintageChargeOffFPFactData'))
--BEGIN
--    EXEC('CREATE PROCEDURE bi.uspLoadGRCR_VintageChargeOffFPFactData AS ')
--END

--GO
--/*************************************************************

--exec [bi].[uspLoadGRCR_uspLoadGRCR_VintageChargeOffFPFactData] @p_Run = 5023479

--Pgmr:	Date:				Ref:							Description

--PP		13.11.2015											Created.
--PP		23.11.2015											Get 48 rolling Atomised new FP accounts using
--															initial 
															
--***************************************************************/
--ALTER PROCEDURE [bi].[uspLoadGRCR_VintageChargeOffFPFactData]
--(
--	 @p_Run int
--	,@Startrow INT = 1 
--	,@EndRow INT = 2000000000
--	,@p_debug bit = 0
--	--,@p_RunSetID INT 
	
--)

--AS

-- BEGIN

 DECLARE @p_Run INT = 15173
		,@Startrow INT = 1 
		,@EndRow INT = 2000000000
		,@p_debug bit = 0
		,@p_RunSetID INT = 15173
     BEGIN TRY;

		SET NOCOUNT ON;

		
		-- BEGIN Log Procedure Start  
		DECLARE @ProcName sysname = coalesce ( app.sfnObjectName(@@PROCID),'bi.uspLoadGRCR_VintageChargeOffFPFactData');

		DECLARE @ProcMessage nvarchar(max) = 'EXEC ' + @ProcName + ' ,@p_run=' + coalesce(convert(varchar(99),@p_run),'NULL') + ' @Startrow=' + CAST(@Startrow AS VARCHAR(20)) + ' @EndRow='  + CAST(@EndRow AS VARCHAR(20))
		EXEC log.uspLogInsertDB  @p_LogCategory = 'PROC.BEGIN',@p_LogObject = @ProcName,@p_LogMessage = @ProcMessage,@p_LogLevel = 5,@p_Run = @p_Run
		IF @p_debug=1 print ''+ @ProcName  + ' - ' + @ProcMessage
		-- END Log Procedure Start    

		-- BEGIN Standard Procedure Block - Pre Business Logic - based on app.uspStoredProcedureWithoutRetryTemplate
		DECLARE
			@InitiatedTransaction bit = 0
		   ,@Retry smallint -- Keep, so catch block is the same
		   ,@Trancount smallint;
		-- END Standard Procedure Block - Pre Business Logic - based on app.uspStoredProcedureWithoutRetryTemplate


		-- BEGIN Business Logic
		
		DECLARE @RunSetID INT = @p_Run * -1
		DECLARE @MaxSystemDate DATE = app.sfnConfigurationGet('MaxSystemDate');
		DECLARE	@rowcount INT;

		--IF OBJECT_ID(N'tempdb.dbo.#refAtomValue') IS NULL
		--BEGIN

		--	CREATE TABLE #refAtomValue
		--	(
		--		AtomID INT NOT NULL,
		--		AtomValueTypeID INT NOT NULL,
		--		AtomTypeID INT NOT NULL,
		--		Value decimal(28, 8) NOT NULL,
		--		Run int NOT NULL,
		--		SourceRowID int NOT NULL,
		--		EffectiveFromDate DATE NULL
		--	)

			
		--END

		-- get latest run for COBDate from both BPF_JAY_BPF_Acc atoms
		DECLARE @COBdate DATE,
				@COBDateHistoricalFPFileRunDate DATE,
				@COBDateHistoricalFPFileRun BIGINT

		SELECT @COBdate = j.CobDate
						FROM loader.JobRun JR 
						INNER JOIN loader.Job J ON JR.JobId = J.JobID
						WHERE JR.Run = @p_Run

		
		
		IF OBJECT_ID(N'dbo.#GRCR_VintageChargeOffFPFactData') IS NOT NULL
			DROP TABLE dbo.#GRCR_VintageChargeOffFPFactData

		

		CREATE TABLE #GRCR_VintageChargeOffFPFactData
		(
			SourceRowID INT
			,RunId INT NOT NULL
			,RunSetId INT NOT NULL
			,ParticleKey BIGINT  NULL
			,AccountOpenMonth DATE  NULL
			,BPFDivisionAttrKeyID  BIGINT  NULL
			,ChargeOffDate DATE NULL
			,ArrearsLevel INT NULL
			,AccountOpenBalance DECIMAL(28,8)  NULL
			,ChargeOffBalance DECIMAL(28,8)  NULL
			,NetBalanceFinance DECIMAL(28,8)  NULL
			,AccountNumber VARCHAR(16) NULL

			,ProductGrpAttrKey INT NULL
			,ProductGrpAttrChangeListId INT NULL
			,ProductGroup VARCHAR(8)
			,AccountOpenDateAttrKey INT NULL
			,AccountOpenDateChangeListId INT NULL
			,CounterpartyIDAttrKeyID INT NULL
			,CounterpartyIDChangeListId INT NULL
			,HistoricalOrIncremental CHAR(1)


		)
		CREATE CLUSTERED INDEX IX_GRCR_VintageChargeOffFPFactData_Account_Month
			 ON #GRCR_VintageChargeOffFPFactData (AccountNumber, AccountOpenMonth);
		
		IF object_id(N'tempdb.dbo.#Atomtemp') is NOT NULL
			DROP TABLE #Atomtemp
		/* Populate FP Account Data - into #GRCR_VintageChargeOffFPFactData historical and this months data */
		exec [bi].[uspLoadGRCR_FP_Account_FactData]		@p_Run = @p_Run
														,@Startrow = @Startrow
														,@EndRow = @EndRow
														,@p_debug  = @p_debug

		
		/*
			Populate Vintage Arrears Level Grip Data
		*/
		IF object_id(N'dbo.#Atomtemp') is NOT NULL
			DROP TABLE #Atomtemp

		IF OBJECT_ID(N'dbo.#ArrearsLevelFactData') IS NOT NULL
			DROP TABLE dbo.#ArrearsLevelFactData
		CREATE TABLE #ArrearsLevelFactData
		(
			Run INT NOT NULL,
			SourceRowID INT NOT NULL,
			AccountNumber VARCHAR(30) NOT NULL CONSTRAINT pk_ArrearsLevelFactData PRIMARY KEY CLUSTERED,
			ArrearsLevel TINYINT NULL
		)

		IF object_id(N'dbo.#Atomtemp') is NOT NULL
			DROP TABLE #Atomtemp
		exec bi.usp_Sub_LoadArrearsLevelGripFactData @RunId = @p_Run

		IF OBJECT_ID(N'dbo.#GRCR_ChargeOffFPFactData2') IS NOT NULL
			DROP TABLE dbo.#GRCR_ChargeOffFPFactData2
		CREATE TABLE #GRCR_ChargeOffFPFactData2
			(
				SourceRowID INT
				,RunId INT NOT NULL
				,RunSetId INT NOT NULL
				,AccountNumber VARCHAR(16) NOT NULL
				,ChargeOffDate DATE NULL
				,ChargeOffBalance DECIMAL(28,8)  NULL
				
			)
		
		ALTER TABLE #GRCR_ChargeOffFPFactData2 ADD PRIMARY KEY CLUSTERED (AccountNumber)
		-- Get Charge Off Data
		IF object_id(N'dbo.#Atomtemp') is NOT NULL
			DROP TABLE #Atomtemp
				
		EXEC [bi].[uspLoadGRCR_FP_ChargeOff_FactData] @p_Run = @p_Run
		

  
		/*
			Populate Vintage Net Balance
		*/
		IF OBJECT_ID(N'dbo.#VintageNetBalance') IS NOT NULL
			DROP TABLE dbo.#VintageNetBalance
		CREATE TABLE #VintageNetBalance
		(
			RunID INT NOT NULL,
			SourceRowID INT NOT NULL,
			AccountNumber VARCHAR(30) NOT NULL,  --- CONSTRAINT pk_VintageNetBalanceTemp PRIMARY KEY CLUSTERED,
			NetBalance DECIMAL(28,2) NOT NULL,
			ParticleKey INT NOT NULL
		)

		ALTER TABLE #VintageNetBalance ADD PRIMARY KEY CLUSTERED (AccountNumber)

		IF object_id(N'dbo.#Atomtemp') is NOT NULL
			DROP TABLE #Atomtemp
		EXEC bi.usp_Sub_LoadVintageNetBalance @p_Run = @p_Run


		/*
			Populate fact table
		*/

		INSERT bi.GRCR_VintageChargeOffFPFactData
		(
			RunId,
			RunSetId,
			AccountNumber,
			AccountOpenMonth,
			BPFDivisionAttrKeyID,
			ArrearsLevel,
			AccountOpenBalance,
			NetBalanceFinance,
			ChargeOffBalance,
			ChargeOffDate
			
		)
		SELECT @p_Run,
			@p_Run * -1 as RunSetId,
			f.AccountNumber,
			f.AccountOpenMonth,
			f.BPFDivisionAttrKeyID,
			af.ArrearsLevel,
			f.AccountOpenBalance,
			vnb.NetBalance,
			f.ChargeOffBalance,
			f.ChargeOffDate
		FROM #GRCR_VintageChargeOffFPFactData f
		LEFT JOIN #ArrearsLevelFactData af on af.AccountNumber = f.AccountNumber
		LEFT JOIN #VintageNetBalance vnb on vnb.AccountNumber = f.AccountNumber
		--LEFT JOIN #GRCR_ChargeOffFPFactData2 co ON co.AccountNumber = f.AccountNumber

		SET @ProcMessage = 'Loaded ' + cast(@rowcount as varchar) + ' row(s) of fact data into bi.GRCR_VintageChargeOffFPFactData Table'
		EXEC log.uspLogInsertDB @p_LogMessage = @ProcMessage, @p_LogLevel = 5, @p_LogCategory = 'PROC.MESSAGE', @p_LogObject = @ProcName, @p_Run = @p_Run;
		IF @p_debug <> 0 PRINT CONVERT(VARCHAR(128), @ProcName) +  'Loaded ' + cast(@rowcount as varchar) + ' row(s) of fact data into bi.GRCR_VintageChargeOffFPFactData Table';


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

	
  
		-- BEGIN Log Procedure End 
	EXEC log.uspLogInsertDB  @p_LogCategory = 'PROC.END',@p_LogObject = @ProcName,@p_LogMessage = NULL,@p_LogLevel = 5,@p_Run = @p_Run

		-- END Log Procedure End 
                     


