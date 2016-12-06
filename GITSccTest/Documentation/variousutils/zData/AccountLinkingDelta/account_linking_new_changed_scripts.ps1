$ServerName = "LDNPSM050000145\PLN000000018T"
$DatabaseName = "BCARD_TST"

$path = "C:\P4wks\depot\CreditRiskIT\Projects\NDS\branches\_DEV04.br\Databases\NDSWarehouse.Database\"

$files = @(    '76_BCBS239/Scripts/LoaderJobDef_PROD/loader.JobDefinition_ACCOUNT_LINKING_DELTA_Loader.sql'  #*
                # , '76_BCBS239/Scripts/LoaderJobDef_PROD/loader.JobDefinition_ACCOUNT_LINKING_STG_Loader.sql' leave, load file twice. wastefull but for parallel run only
            
          # , '76_BCBS239/StoredProcedures/ref.uspProcessBarclaycardTDTAMetricAtomiseChunk.sql' -- leave unchanged
          
          , '76_BCBS239/StoredProcedures/ref.uspProcessBarclaycardTDTAMetricAtomiseDeltaChunk.sql'   #*
          , '77_BCBS239/Tables/stg.BARCLAYCARD_ACCOUNT_LINKING_DELTA.sql'                           #*
          , '77_BCBS239/Tables/bi.FDSF_TDTAAccLinkingFactDataDelta.sql'                            #*
            , '77_BCBS239/Functions/entity.tfnActiveAccountEndDateDeltaAttr.sql'                    #*
            , '77_BCBS239/Functions/entity.tfnActiveAccountStartDateDeltaAttr.sql'                  #*
             , '77_BCBS239/Functions/entity.tfnLinkingCounterpartyIDDeltaAttr.sql'                  #*
              , '77_BCBS239/Functions/entity.tfnLogicalAccountPurgeDateDeltaAttr.sql'               #*
           , '77_BCBS239/Functions/entity.tfnOriginalAccountStartDateDeltaAttr.sql'                 #*
           , '77_BCBS239/StoredProcedures/entity.uspLinkingCounterpartyIDDeltaAttr.sql'             #*
   
		  , '77_BCBS239/Scripts/MAR_Barclaycard_Account_Linking_Delta.sql'  #--- check with Ian new config for delta  #*
          
          , '74_BCBS239/Scripts/Incoming_CommonScript_07_CreateAtomParticleTypes.sql' # add CUDtype to atomise   #*
          
		  # , '75_BCBS239/StoredProcedures/bi.uspLoad-FactData/bi.uspLoadFDSF_TDTAAccLinkingFactDataChunk.sql' -- leave unchanged
          ,'75_BCBS239/StoredProcedures/bi.uspLoad-FactData/bi.uspLoadFDSF_TDTAAccLinkingFactDataDeltaChunk.sql'  #*
		  
          #Check with Ian - clustered index change
         #  , '75_BCBS239/Tables/stg/stg.BARCLAYCARD_ACCOUNT_LINKING_ALTER.sql'
           
          ,'77_BCBS239/Views/bi.vwFDSF_TDTAAccLinkingFactDataDelta.sql'                             #*
          #Might already be in prod - 
          , '77_BCBS239/Tables_DataScripts/util.TableValuedFunctionToProcedureMap.sql'              #*   
          ,'77_BCBS239/Views/stg.vwFDSF_TDTAAccLinkingFactDataDelta.sql'  
            , '77_BCBS239/StoredProcedures/stg.uspLoadFDSF_TDTAAccLinkingStageDataDelta.sql'        #*

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