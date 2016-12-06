$ServerName = "LDNPCM05094V05B\PLN000000152L"
$DatabaseName = "BCARD_PROD"

$path = "C:\P4wks\depot\CreditRiskIT\Projects\NDS\branches\_DEV04.br\Databases\NDSWarehouse.Database\"

$files = @(    '75_BCBS239\Tables\stg\stg.SDS_IF023_APPLICATION.sql'
               ### ,'75_BCBS239\Scripts\JobDefinition_BCARD_SDS_IF023_APPLICATION_STG.sql' #add delta load process task
              # ,'76_BCBS239\Scripts\LoaderJobDef_PROD\loader.JobDefinition_ACQ_SDS_IF023_APPLICATION.sql'
            ,'76_BCBS239\Scripts\LoaderJobDef_PROD\loader.JobDefinition_ACQ_SDS_IF023_APPLICATION_DELTA.sql'
            ,'77_BCBS239\Tables\stg.SDS_IF023_APP_DELTA.sql' 
            ,'77_BCBS239\Tables\bi.GRCR_SDS_IF023_APPLICATION_FactDataDelta.sql'
            ,'77_BCBS239\StoredProcedures\ref.uspProcessSDS_IF023_APPLICATION_AtomiseDeltaChunk.sql'
            , '77_BCBS239\StoredProcedures\stg.uspLoadSDS_IF023AppStageDataDelta.sql'        #*
            ,'75_BCBS239\StoredProcedures\bi.uspLoad-FactData\bi.uspLoadGRCR_SDS_IF023_APPLICATION_FactDataDeltaChunk.sql'
            ,'77_BCBS239\Functions\entity.tfn_SDS_APP_ApplicationIdDeltaAttr.sql'
            ,'77_BCBS239\StoredProcedures\entity.usp_SDS_App_ApplicationIdDeltaAttr.sql'
            ,'75_BCBS239\Scripts\Incoming-MAR\Incoming_SDS_IF023_APPLICATION_MARConfig.sql' # add delta config and objects
            
            
            ,'76_BCBS239\Scripts\LoaderJobDef_PROD\loader.JobDefinition_ACQ_SDS_IF023_RES1_DELTA.sql'
            ,'75_BCBS239\Tables\stg\stg.SDS_IF023_RES1.sql'
            ,'77_BCBS239\Tables\stg.SDS_IF023_RES1_DELTA.sql'
            ,'77_BCBS239\Tables\bi.GRCR_SDS_IF023_RES1_FactDataDelta.sql'
            ,'77_BCBS239\StoredProcedures\stg.uspLoadSDS_IF023RES1StageDataDelta.sql'
            ,'77_BCBS239\Functions\entity.tfn_SDS_RES1_ApplicationIdDeltaAttr.sql'
            ,'77_BCBS239\StoredProcedures\entity.usp_SDS_RES1_ApplicationIdDeltaAttr.sql'
            ,'77_BCBS239\Functions\entity.tfn_SDS_RES1_AppTypeDeltaAttr.sql'
            ,'77_BCBS239\Functions\entity.tfn_SDS_RES1_EraScreDeltaAttr.sql'
            ,'77_BCBS239\Functions\entity.tfn_SDS_RES1_MainScorReqdNodeIdDeltaAttr.sql'
            ,'77_BCBS239\StoredProcedures\ref.uspProcessSDS_IF023_RES1_AtomiseDeltaChunk.sql'
            ,'77_BCBS239\StoredProcedures\ref.uspProcessSDS_IF023_RES1_PreAtomiseDelta.sql'
            ,'77_BCBS239\StoredProcedures\bi.uspLoadGRCR_SDS_IF023_RES1_FactDataDeltaChunk.sql'
            
            ,'75_BCBS239\Scripts\Incoming-MAR\Incoming_SDS_IF023_RES1_MARConfig.sql' #add _DELTA table changes
            
            ,'77_BCBS239\Tables_DataScripts\util.TableValuedFunctionToProcedureMap.sql'  # add entity.usp_SDS_RES1_ApplicationIdDeltaAttr mapping
            
            #RES 4 objects
            ,'76_BCBS239\Scripts\LoaderJobDef_PROD\loader.JobDefinition_ACQ_SDS_IF023_RESULTS4_DELTA.sql'
            ,'75_BCBS239\Tables\stg\stg.SDS_IF023_RESULTS4.sql'
            ,'77_BCBS239\Tables\stg.SDS_IF023_RES4_DELTA.sql'
            ,'77_BCBS239\Tables\bi.GRCR_SDS_IF023_RESULTS4_FactDataDelta.sql'
            ,'77_BCBS239\StoredProcedures\stg.uspLoadSDS_IF023RESULTS4StageDataDelta.sql'
            ,'77_BCBS239\StoredProcedures\ref.uspProcessSDS_IF023_RESULTS4_PreAtomiseDelta.sql'
            ,'77_BCBS239\StoredProcedures\ref.uspProcessSDS_IF023_RESULTS4_AtomiseDeltaChunk.sql'
            ,'77_BCBS239\Functions\entity.tfn_SDS_RES4_Eq5RiskScre1DeltaAttr.sql'
            ,'75_BCBS239\Scripts\Incoming-MAR\Incoming_SDS_IF023_RESULTS4_MARConfig.sql'
            ,'77_BCBS239\StoredProcedures\bi.uspLoadGRCR_SDS_IF023_RESULTS4_FactDataDeltaChunk.sql'
            
           # ref].[uspProcessSDS_IF023_RESULTS4_PreAtomiseDelta
            # ref.uspProcessSDS_IF023_RESULTS4_AtomiseDeltaChunk
            # entity].[tfn_SDS_RES4_Eq5RiskScre1DeltaAttr
            
            # 75_BCBS239/Scripts/Incoming-MAR/Incoming_SDS_IF023_RESULTS4_MARConfig.sql
            #bi.uspLoadGRCR_SDS_IF023_RESULTS4_FactDataDeltaChunk
            
          ) ;
		  
# Truncate the table before merging in the data to save on duplicates being added. 
#& sqlcmd.exe -S $ServerName -d $DatabaseName -Q "TRUNCATE TABLE [reporting].[GRCRReportCategoryMetricUnitOutput]"
		  
foreach ($file in $files)
{
    $cmdPath = Join-Path $path $file ;

	$CurrentDateTime = Get-Date
	
	Write-Host "$CurrentDateTime executing script ""$cmdPath"" `r`nServer: ""$ServerName"" `r`nDatabase:""$DatabaseName""" -ForegroundColor Green -BackgroundColor Black ;
	& sqlcmd.exe -S $ServerName -d $DatabaseName -i $cmdPath
	
}		  