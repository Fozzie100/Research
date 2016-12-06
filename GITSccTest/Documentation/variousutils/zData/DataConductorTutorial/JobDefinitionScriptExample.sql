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

VALUES	   (  N'PP_TEST', N'PP_TEST', 'DaysToRun', 'YYYYYNN', 5, '20150101', '20790101', 1
		   );	

UPDATE loader.JobDefinition
Set JobDefinitionConfig = N'<ConductorConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 
  <Processes>
  <IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.DataEngineFactory, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <DataEngineFactory>
        <TaskName>Load BARCLAYCARD Chargeoff_data File</TaskName>
        <DataEngineType>Delimited</DataEngineType>
        <DataEngineConfiguration>
          <EngineConfiguration>
            <Source>
              <Uri>[[FeedLocation]][[CobDate|yyyyMMdd]]\BCARD\[[PreparedFileName]]</Uri>
              <UseQuotes>true</UseQuotes>
              <FieldTerminator>,</FieldTerminator>
            </Source>
            <Destination>
              <TableName>dbo.PP_BPF_JAY_BPF_FP_ACC</TableName>
              <ConnectionString>[[ConnectionString]]</ConnectionString>
              <BulkCopyTimeout>0</BulkCopyTimeout>
              <BulkCopyBatchSize>40000</BulkCopyBatchSize>
            </Destination>
          </EngineConfiguration>
        </DataEngineConfiguration>
      </DataEngineFactory>
    </IProcessTask>
  	<IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.RunDatabaseCommand, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <RunDatabaseCommand>
        <TaskName>BPF Load Application Fact Table Populate</TaskName>
        <ConnectionString>[[ConnectionString]]</ConnectionString>
        <SqlCommand>bi.uspLoadGRCR_BPFApplicationSummaryFactData @p_run=[[run]]</SqlCommand>
      </RunDatabaseCommand>
    </IProcessTask>
	 <IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.Executable, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <Executable>
	    <TaskName>Second task name</TaskName>
        <ExecutablePath>C:\Barclays\ProgramFiles\ChunkManager</ExecutablePath>
        <ExecutableName>ChunkManager.exe</ExecutableName>
        <Parameters>ConnectionString=[[ConnectionString]] @p_run=[[run]] @p_cobdate=[[CobDate|yyyyMMdd]] Span=500 ChunkingProcess=bi.PP_TEST_CHUNK1 StagingTable=dbo.PP_BPF_JAY_BPF_FP_ACC MaxThreads=1</Parameters>
        <ExitCode>1</ExitCode>
      </Executable>
    </IProcessTask>
	<IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.Executable, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <Executable>
	    <TaskName>Third task name</TaskName>
        <ExecutablePath>C:\Barclays\ProgramFiles\ChunkManager</ExecutablePath>
        <ExecutableName>ChunkManager.exe</ExecutableName>
        <Parameters>ConnectionString=[[ConnectionString]] @p_run=[[run]] @p_cobdate=[[CobDate|yyyyMMdd]] Span=500 ChunkingProcess=bi.PP_TEST_CHUNK55 StagingTable=dbo.PP_BPF_JAY_BPF_FP_ACC MaxThreads=1</Parameters>
        <ExitCode>1</ExitCode>
      </Executable>
    </IProcessTask>
	<IProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.RunDatabaseCommand, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <RunDatabaseCommand>
        <TaskName>Fourth task name</TaskName>
        <ConnectionString>[[ConnectionString]]</ConnectionString>
        <SqlCommand>bi.PP_TEST_NOTCHUNK1 @p_run=[[run]]</SqlCommand>
      </RunDatabaseCommand>
    </IProcessTask>
  </Processes>
   <PostProcesses>
    <IPostProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.RunDatabaseCommand, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <Executable>
		<TaskName>Fifth task name</TaskName>
        <ExecutablePath>C:\Barclays\ProgramFiles\ChunkManager</ExecutablePath>
        <ExecutableName>ChunkManager.exe</ExecutableName>
        <Parameters>ConnectionString=[[ConnectionString]] @p_run=[[run]] @p_cobdate=[[CobDate|yyyyMMdd]] Span=500 ChunkingProcess=bi.PP_TEST_CHUNK2 StagingTable=dbo.PP_BPF_JAY_BPF_FP_ACC MaxThreads=1</Parameters>
        <ExitCode>1</ExitCode>
      </Executable>
    </IPostProcessTask>
    <IPostProcessTask AssemblyQualifiedName="Barcap.CreditRisk.Juno.DataConductor.Configuration.RunDatabaseCommand, Barcap.CreditRisk.Juno.DataConductor.Configuration, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null">
      <RunDatabaseCommand>
        <TaskName>Sixth task name</TaskName>
        <ConnectionString>[[ConnectionString]]</ConnectionString>
        <SqlCommand>bi.PP_TEST_NOTCHUNK2 @p_run=[[run]], @p_cobdate=[[CobDateplusone|dd MMM yyyy]]</SqlCommand>
      </RunDatabaseCommand>
    </IPostProcessTask>
  </PostProcesses>
</ConductorConfiguration>'                            
WHERE JobDefinitionCode = 'PP_TEST'

