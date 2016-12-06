$ServerName = "LDNPSM050000145\PLN000000018T"
$DatabaseName = "BCARD_TST"

$path = "C:\P4wks\depot\CreditRiskIT\Projects\NDS\branches\_DEV04.br\Databases\NDSWarehouse.Database\"

$files = @(     '78_BCBS239_GRCRBPF\Tables\bi.GRCR_BPF_ChargeOffFactDataBase.sql'
                ,'78_BCBS239_GRCRBPF\Tables\bi.GRCR_BPF_ChargeOffFactDataConsolidated.sql'
                ,'78_BCBS239_GRCRBPF\Tables\bi.GRCR_BPF_ForbearanceFactDataConsolidated.sql'
                ,'78_BCBS239_GRCRBPF\Tables\bi.GRCR_BPF_ForbearanceChargeOffFactDataConsolidated.sql'
                ,'78_BCBS239_GRCRBPF\Tables\bi.GRCR_BPF_ForbearanceFactDataBase.sql'
                ,'78_BCBS239_GRCRBPF\StoredProcedures\bi.uspLoadBPFNewIntoForbearanceChargeOffBaseFactData.sql'
                ,'78_BCBS239_GRCRBPF\StoredProcedures\bi.uspLoadBPFNewIntoForbearanceChargeOffConsolidatedFactData.sql'
               # ,'78_BCBS239_GRCRBPF\Tables_DataScripts\loader.JobDefinition_BPF_LOAD_VINTAGE_FPS_FACT_V2.sql'
               ,'78_BCBS239_GRCRBPF\Tables_DataScripts\loader.JobDefinition_BCARD_GRCRBPF_VINTAGEFP_CONS1.sql'
               ,'78_BCBS239_GRCRBPF\Tables_DataScripts\loader.JobDefinition_BCARD_GRCRBPF_VINTAGEFP_CONS2.sql'
               ### ,'75_BCBS239\Scripts\JobDefinition_BCARD_SDS_IF023_APPLICATION_STG.sql' #add delta load process task
              # ,'76_BCBS239\Scripts\LoaderJobDef_PROD\loader.JobDefinition_ACQ_SDS_IF023_APPLICATION.sql'
              ,'78_BCBS239_GRCRBPF\Views\bi.vwGRCR_BPF_Vintage_FPs_PastDue_MOB_Detail.sql'
              ,'78_BCBS239_GRCRBPF\Views\bi.vwGRCR_BPF_Vintage_FPs_PastDue_MOB_Aggregate.sql'
              ,'78_BCBS239_GRCRBPF\Views\bi.vwGRCR_VintageFP_ChargeOffDetail.sql'
             # ,'78_BCBS239_GRCRBPF\Views\bi.vwGRCR_VintageFP_OriginalBalanceOfFpAggregate.sql'
              ,'78_BCBS239_GRCRBPF\Views\bi.vwGRCR_VintageFP_OriginalBalanceOfFpDetail.sql'
         
           
           ,'78_BCBS239_GRCRBPF\Tables\bi.GRCR_BPF_ChargeOffInitialFactData.sql'
           ,'78_BCBS239_GRCRBPF\StoredProcedures\bi.uspLoadGRCR_BPF_ChargeOffInitialFactData.sql'
           
           ,'78_BCBS239_GRCRBPF\Tables\bi.GRCR_BPF_JayFPInitialFactData.sql'
           ,'78_BCBS239_GRCRBPF\StoredProcedures\bi.uspLoadGRCR_BPF_JayFPInitialFactData.sql'
           
             ,'78_BCBS239_GRCRBPF\scripts\RunsetsConfigVintageFPs.sql'
           ,'78_BCBS239_GRCRBPF\scripts\RunsetsImpairmentFactDataPopulate.sql' # convert -ve runsetids to +ve ones via runsetidgenerator
            
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