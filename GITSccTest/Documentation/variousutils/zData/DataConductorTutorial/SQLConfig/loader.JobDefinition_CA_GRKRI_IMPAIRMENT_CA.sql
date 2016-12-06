SET NOCOUNT ON

-- Change the values at the top, they are applied below.
DECLARE @JobDefinitionCode		NVARCHAR(64)	= N'GRCR_Application_Input'
DECLARE @JobDefinitionName		NVARCHAR(64)	= N'GRCR_Application_Input'
DECLARE @DataProvider			NVARCHAR(64)	= N'SAS'
DECLARE @JobType				NVARCHAR(64)	= N'Data'
DECLARE @SubjectName			NVARCHAR(64)	= N'CA Data'
DECLARE @Trigger				VARCHAR(20)		= 'Daily'
DECLARE @DaysToRun				VARCHAR(10)		= 'NNNNNNN'
DECLARE @JobRetryRate			INT				= 5
DECLARE @EffectiveFrom			DATE			= '20121031'
DECLARE @EffectiveTo			DATE			= '20790101'
DECLARE @Enabled				BIT				= 1;
DECLARE @JobDefinitionConfig	NVARCHAR(MAX)	= 
N'<ConductorConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Gates>
    <IGateTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.IsFileReady, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <IsFileReady>
        <TaskName>Is Application File Ready</TaskName>
        <SourceFileLocation>C:\GRCR\Feed\in</SourceFileLocation>
        <DestinationFileLocation>C:\GRCR\Feed\out</DestinationFileLocation>
        <FileName>mop_application_input_20150918.txt</FileName>
		<ControlFileName>mop_application_input_20150918.ctl</ControlFileName>
        <PatternSelect>Newest</PatternSelect>
      </IsFileReady>
    </IGateTask>
  </Gates>
  
</ConductorConfiguration>'                            

-- MERGE CARRIED OUT BELOW USING BOILERPLATE CODE

MERGE INTO [loader].[JobDefinition] tgt
USING 
	(
		SELECT	@JobDefinitionCode		AS [JobDefinitionCode]
				,@JobDefinitionName		AS [JobDefinitionName]
				,@DataProvider			AS [DataProvider]
				,@JobType				AS [JobType]
				,@SubjectName			AS [SubjectName]
				,@Trigger				AS [Trigger]
				,@DaysToRun				AS [DaysToRun]
				,@JobRetryRate			AS [JobRetryRate]
				,@EffectiveFrom			AS [EffectiveFrom]
				,@EffectiveTo			AS [EffectiveTo]
				,@Enabled				AS [Enabled] 
				,@JobDefinitionConfig	AS [JobDefinitionConfig]
	) src
	ON		src.[JobDefinitionCode]		= tgt.[JobDefinitionCode]
		AND src.[EffectiveFrom]			= tgt.[EffectiveFrom]
WHEN MATCHED THEN
	UPDATE	
	SET		tgt.[JobDefinitionCode]		= src.[JobDefinitionCode] 
			,tgt.[JobDefinitionName]	= src.[JobDefinitionName]            
			,tgt.[DataProvider]			= src.[DataProvider]
			,tgt.[JobType]				= src.[JobType]
			,tgt.[SubjectName]			= src.[SubjectName]            
			,tgt.[Trigger]				= src.[Trigger] 
			,tgt.[DaysToRun]			= src.[DaysToRun] 
			,tgt.[JobRetryRate]			= src.[JobRetryRate] 
			,tgt.[EffectiveFrom]		= src.[EffectiveFrom] 
			,tgt.[EffectiveTo]			= src.[EffectiveTo] 
			,tgt.[Enabled] 				= src.[Enabled]
			,tgt.[JobDefinitionConfig]	= src.[JobDefinitionConfig]
WHEN NOT MATCHED THEN	
	INSERT 	  
		(
			[JobDefinitionCode]
			,[JobDefinitionName]
			,[DataProvider]
			,[JobType]
			,[SubjectName]
			,[Trigger]
			,[DaysToRun]
			,[JobRetryRate]
			,[EffectiveFrom]
			,[EffectiveTo]
			,[Enabled] 
			,[JobDefinitionConfig]	
		)
	VALUES	  
		(
			[JobDefinitionCode]
			,[JobDefinitionName]
			,[DataProvider]
			,[JobType]
			,[SubjectName]
			,[Trigger]
			,[DaysToRun]
			,[JobRetryRate]
			,[EffectiveFrom]
			,[EffectiveTo]
			,[Enabled] 	
			,[JobDefinitionConfig]
		);	
