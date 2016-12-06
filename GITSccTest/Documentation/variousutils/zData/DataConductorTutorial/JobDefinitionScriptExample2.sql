select * from loader.JobDefinition where JobDefinitionCode like 'PP_%'
--WITH JobDefCTE
--         ( JobDefinitionCode ,
--           JobDefinitionName ,           
--           [Trigger] ,
--           DaysToRun ,
--           JobRetryRate ,
--           EffectiveFrom ,
--           EffectiveTo ,
--           Enabled 
--         ) AS (
--		  SELECT N'PP_TEST', N'PP_TEST', 'DaysToRun', 'YYYYYNN', 5, '20150101', '20790101', 1 )
		  

INSERT 	 INTO loader.JobDefinition  (JobDefinitionCode ,
           JobDefinitionName ,           
           [Trigger] ,
           DaysToRun ,
           JobRetryRate ,
           EffectiveFrom ,
           EffectiveTo ,
           [Enabled] 	
		   )

VALUES	   (  N'PP_TEST2_DC_DEBUGGING', N'PP_TEST2_DEBUGGING', 'DaysToRun', 'YYYYYNN', 5, '20150101', '20790101', 1
		   );	

UPDATE loader.JobDefinition
Set JobDefinitionConfig = N'<ConductorConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 
  <Processes>
	<IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.RunDatabaseCommand, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <RunDatabaseCommand>
        <TaskName>BPF Load Application Fact Table Populate</TaskName>
        <ConnectionString>[[ConnectionString]]</ConnectionString>
        <SqlCommand>bi.uspLoadGRCR_BPFApplicationSummaryFactData @p_Run=[[run]]</SqlCommand>
      </RunDatabaseCommand>
    </IProcessTask>
	 <IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.Executable, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <Executable>
        <ExecutablePath>C:\Barclays\ProgramFiles\ChunkManager</ExecutablePath>
        <ExecutableName>ChunkManager.exe</ExecutableName>
        <Parameters>ConnectionString=[[ConnectionString]] @p_run=[[run]] @p_cobdate=[[CobDate|yyyyMMdd]] Span=500000 ChunkingProcess=bi.PP_TEST_CHUNK1 StagingTable=stg.BARCLAYCARD_New_accs_summy_BBC1 MaxThreads=1</Parameters>
        <ExitCode>1</ExitCode>
      </Executable>
    </IProcessTask>
	<IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.Executable, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <Executable>
        <ExecutablePath>C:\Barclays\ProgramFiles\ChunkManager</ExecutablePath>
        <ExecutableName>ChunkManager.exe</ExecutableName>
        <Parameters>ConnectionString=[[ConnectionString]] @p_run=[[run]] @p_cobdate=[[CobDate|yyyyMMdd]] Span=500000 ChunkingProcess=bi.PP_TEST_CHUNK55 StagingTable=stg.BARCLAYCARD_New_accs_summy_BBC55 MaxThreads=1</Parameters>
        <ExitCode>1</ExitCode>
      </Executable>
    </IProcessTask>
	<IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.RunDatabaseCommand, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <RunDatabaseCommand>
        <TaskName>PP task name here to be re-run</TaskName>
        <ConnectionString>[[ConnectionString]]</ConnectionString>
        <SqlCommand>bi.PPProcNotRunThroughChunkMan @p_Run=[[run]]</SqlCommand>
      </RunDatabaseCommand>
    </IProcessTask>
  </Processes>
</ConductorConfiguration>'                            
WHERE JobDefinitionCode = 'PP_TEST2_DC_DEBUGGING'

