

SELECT  top 10 * from  bi.vwGRCR_DLMOpenAccountSubmissionAggrTopLvl
select j.*, jr.* 
from loader.JobRun jr
inner join loader.Job j
on j.JobId = jr.JobId
where jr.Run=171348

SELECT top 100 	* 
		FROM bi.RunSets r (NOLOCK)
where RunsetID=170

select * from bi.RunSetsXRun where RunSetID=236
se
-- where RunsetDescription like '%DelinquencyCycles%'

select top 10  * from bi.JobSets where JobsetID=10

USE [BCARD_TST]
GO

/****** Object:  View [bi].[vwGRCR_DLMOpenAccountSubmissionAggrTopLvl]    Script Date: 09/12/2015 14:01:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [bi].[vwGRCR_DLMOpenAccountSubmissionAggrTopLvl]
AS 

	WITH DLM_LatestRunsetPerCob_CTE
	AS
	(
		SELECT	* 
		FROM bi.RunSets r (NOLOCK)
		INNER JOIN (SELECT DISTINCT RunSetId FROM  bi.GRCR_DLM_FactData (NOLOCK)) f
		ON f.RunSetID = r.RunSetID
		GROUP BY r.CobDate
	),
	RMD_LatestRunsetPerCob_CTE
	AS
	(
		SELECT	top 1000 r.CobDate, RunSetID, *
		FROM BCARD_UAT.bi.RunSets r (NOLOCK)
		INNER JOIN (SELECT DISTINCT RunSetId FROM  BCARD_UAT.bi.GRCR_RMD_FactData (NOLOCK)) f
		ON f.RunSetID = r.RunSetID
		GROUP BY r.CobDate
	),
	ALL_Data_CTE
	AS
	(  
		-- Select "openaccount" metric data from delinquency metrics
		SELECT	
				F.[RunSetID] ,
				F.[RunID] ,
				Category = 'Portfolio Metrics: Stock',
				ISNULL( CONVERT(VARCHAR(6),lr.cobdate ,112), CONVERT(VARCHAR(6), f.cob_date,112)) AS COBDate,			 
				F.[portfolio] AS Portfolio,
				NULL AS Product,
				NULL AS AccountNumber,
				Metric = 'Open Accounts',
				Unit = 'Stock',
				[Value] =  FLOOR(F.[metric]),
				F.[groupingID] AS GroupingID,
				RunSetId_Original = F.[RunSetID]
		FROM    [bi].[GRCR_DLM_FactData] (NOLOCK) AS F
		INNER JOIN DLM_LatestRunsetPerCob_CTE lr ON lr.RunSetID = f.RunSetId
		WHERE GROUPINGid = 103 AND f.metricType = 'openaccount'

		UNION ALL

		-- Add "Recovery Stock: accounts" metric from recovery metrics to give total Open Accounts
		SELECT	ld.RunSetID AS RunSetID,
				F.[RunID] ,
				Category = 'Portfolio Metrics: Stock',
				ISNULL( CONVERT(VARCHAR(6),lr.cobdate ,112), CONVERT(VARCHAR(6), f.cob_date,112)) AS COBDate,			 
				F.[portfolio] AS Portfolio,
				F.product AS Product,
				NULL AS AccountNumber,
				Metric = 'Open Accounts', 
				Unit = 'Stock',
				[Value] = FLOOR(F.[metric]),
				F.[groupingID] AS GroupingID,
				RunSetId_Original = F.[RunSetID]
		FROM    BCARD_UAT.bi.grcr_RMD_FactData (NOLOCK) AS F
		INNER JOIN RMD_LatestRunsetPerCob_CTE lr ON lr.RunSetID = f.RunSetId
		INNER JOIN DLM_LatestRunsetPerCob_CTE ld ON lr.CobDate = ld.CobDate
		WHERE GROUPINGid = 3 AND metricType = 'Recovery Stock: accounts'
	)
	-- Group the data to produce 1 row per portfolio
	SELECT RunSetID, MAX(RunId) AS RunID, Category, COBDate, Portfolio, Product, AccountNumber, Metric, Unit, SUM(Value) Value, MAX(GroupingID) GroupingID
	FROM	ALL_Data_CTE
	GROUP BY RunSetId, Category, COBDate, Portfolio, Product, AccountNumber, Metric, Unit
			 

GO


