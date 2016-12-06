--
-- Jun 30 2015 full run
--
-- select top 100 * from stg.BARCLAYCARD_ACCOUNT_LINKING where Run=83
-- select top 100 * from stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA where Run=83
 exec [stg].[uspLoadFDSF_TDTAAccLinkingStageDataDelta] @p_Run=83

 --
 -- DO WE Have to run? Always ask it takes a long time
 exec routing.uspStagingSourceProcess @p_RunId=83, @p_StagingTableName='stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA'

 -- 
 -- run thru chunk manager - atomise
 --
-- C:\Applications\ChunkManager>ChunkManager.exe ConnectionString="data source=LDNDCM05330V05B\LF6_MAIN2_DEV;initial catalog=JUNO_DEV05;integrated security=True;" @p_run=76 Span=500000 ChunkingProcess=ref.uspProcessBarclaycardTDTAMetricAtomiseChunk  StagingTable=stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA MaxThreads=4 @p_cobdate=20150531 @p_stg_table_name=stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA

exec bi.uspLoadDimensionDataWrapper @p_Run=83

 -- 
 -- run thru chunk manager -- fact
 --
--C:\Applications\ChunkManager>ChunkManager.exe ConnectionString="data source=LDNDCM05330V05B\LF6_MAIN2_DEV;initial catalog=JUNO_DEV05;integrated security=True;" @p_run=76 Span=500000 ChunkingProcess=bi.uspLoadFDSF_TDTAAccLinkingFactDataChunk  StagingTable=stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA MaxThreads=4 @p_cobdate=20150531 @p_stg_table_name=stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA