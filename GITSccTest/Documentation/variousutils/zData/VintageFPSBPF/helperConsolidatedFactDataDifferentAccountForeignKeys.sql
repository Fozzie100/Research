

SET NOCOUNT ON;

declare @p_RunID INT = 120123
		if OBJECT_ID('tempdb..#MOBs') IS NOT NULL
			drop table  #MOBs

		if OBJECT_ID('tempdb..#jobruns') IS NOT NULL
			drop table  #jobruns

		if OBJECT_ID('tempdb..#ChargeOffMOB') IS NOT NULL
			drop table  #ChargeOffMOB


		DECLARE @DateAnchor DATE,
				@InitiatedTransaction bit = 0,
				@RowCount INT,
				@Retry smallint,
				@StartDate DATE
				
				--,@p_RunID INT = -1
		
		SELECT	@DateAnchor			=	J.CobDate
		FROM loader.JobRun jr
		INNER JOIN loader.Job j
		ON j.JobId = jr.JobId
		WHERE jr.Run = @p_RunID

		-- comment back in for testing
		--SET @DateAnchor = '31 Mar 2016'
		SET @StartDate = DATEADD(month, -48, @DateAnchor)

		-- Get Most recent RunIDS for 'BPF_LOAD_VINTAGE_FPS_FACT_V2' over the last 36 months
		;WITH HistCOBDate As  
		(  
		SELECT @StartDate as TheDate
		UNION ALL  
		SELECT EOMONTH(DATEADD(day, + 4, TheDate)) FROM HistCOBDate  
		WHERE EOMONTH(DATEADD(day,+ 4, TheDate)) <= @DateAnchor
		)
		SELECT x.*
		INTO #jobrunsFPSFact
		FROM
			(		SELECT j.JobDefinitionCode, j.CobDate, max(jr.Run) Run
					FROM
					loader.JobRun jr
					inner join loader.Job j
					ON j.JobId = jr.JobId
					INNER JOIN HistCOBDate hd
					ON hd.TheDate =  j.CobDate 
					WHERE j.JobDefinitionCode IN ('BPF_LOAD_VINTAGE_FPS_FACT_V2')
					AND ( 
							jr.RunStatus = 'S'

							OR ( jr.RunStatus <> 'S' and j.COBdate = @DateAnchor )
						)
					GROUP BY j.JobDefinitionCode, j.CobDate
					--UNION   -- comment back in for testing
					--SELECT 'BPF_LOAD_VINTAGE_FPS_FACT_V2', '31 Jan 2016', -2
					--UNION
					--SELECT 'BPF_LOAD_VINTAGE_FPS_FACT_V2', '29 Feb 2016', -3
					--UNION
					--SELECT 'BPF_LOAD_VINTAGE_FPS_FACT_V2', '31 Mar 2016', -4
			) x

		
		SELECT x.*
		INTO #jobruns
		FROM
					(SELECT j.JobDefinitionCode, j.CobDate, DATEADD(day, -1, DATEADD(month, DATEDIFF(month, 0, j.CobDate), 0)) prevcob, max(jr.Run) Run
					FROM
					loader.JobRun jr
					INNER JOIN loader.Job j
					ON j.JobId = jr.JobId
					WHERE j.JobDefinitionCode IN ('BCARD_N9DEBTP', 'BCARD_TCDEBTP','BCARD_G1DEBTP',
					'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR', 'BPF_JAY_BPF_FP_ACC', 'BPF_CHARGEOFF_DATA_INITAL', 'BCARD_XX_BARCLAYCARD_IMPAIR_BASE', 'BPF_VNTG_ARRSLVLGRIP_BOOK')
					AND j.CobDate in    (@DateAnchor)
					AND jr.RunStatus = 'S'
					GROUP BY j.JobDefinitionCode, j.CobDate
					) x
			

		SELECT 		@DateAnchor AnchorDate,
					DATEADD(month, DATEDIFF(month, 0, @DateAnchor) - mob.MonthOnBook, 0) MOBStartDate,
					EOMONTH(DATEADD(month, DATEDIFF(month, 0, @DateAnchor) - mob.MonthOnBook, 0)) MOBEndDate,
					mob.Metric,
					mob.MonthOnBook,
					mob.ArrearsLevel
					INTO #MOBs
					FROM (VALUES
					  (3, 'FPs >30 Days past due at 3 MOB (incl. charge-offs)', 2),
					  (6, 'FPs >30 Days past due at 6 MOB (incl. charge-offs)', 2),
					  (12, 'FPs >90 Days past due at 12 MOB (incl. charge-offs)', 4),
					  (18, 'FPs >90 Days past due at 18 MOB (incl. charge-offs)', 4),
					  (0, 'Original Balance of FPs)', NULL)
			   ) as mob (MonthOnBook, Metric, ArrearsLevel)
			  
			  -- select * from #MOBs
			  SELECT 
			   	DATEADD(month, DATEDIFF(month, 0, @DateAnchor) - mob.MonthOnBook, 0) BookDate,
				DATEADD(month, DATEDIFF(month, 0, @DateAnchor), 0) MonthStart,
				mob.Metric,
				mob.MonthOnBook
				INTO #ChargeOffMOB
				FROM (VALUES
				(12, 'FPs Charge-Off at 12 MOB'),
				(24, 'FPs Charge-Off at 24 MOB'),
				(36, 'FPs Charge-Off at 36 MOB')
				--,(3, 'FPs Charge-Off at 3 MOB')
			) as mob (MonthOnBook, Metric)


-- select * from #jobrunsFPSFact
-- distinct required for counterparty id duplicates

drop table #consol1
declare @DateAnchor DATE =  '31 Dec 2015'
select  distinct  x.*, coalesce(cp.CounterPartyID, acbpf.AccountNo) Account
--,
into #consol1

	--,

	--(
	--	select   y.netbalance_finance  
	--	From bi.CounterPartyIDAttrSCD cp2
	--	INNER JOIN #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
	--	and jr.COBDate = x.COBdate
	--	LEFT JOIN bi.FDSF_VntgNetBalanceFinanceFactData (nolock) y
	--	ON y.CounterPartyIdAttrKey = cp2.CounterpartyIDAttrKeyID
	--	AND y.CounterPartyIdAttrChangeListId = cp2.ChangeListId
	--	and y.RunId=jr.Run
	--	WHERE cp2.CounterpartyID = coalesce(cp.CounterPartyID, acbpf.AccountNo)

	--	--select y.netbalance_finance 
	--	--from bi.FDSF_VntgNetBalanceFinanceFactData (nolock) y
	--	--INNER JOIN #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
	--	--AND jr.Run = y.RunId and jr.CobDate = @DateAnchor
	--	--INNER JOIN  bi.CounterPartyIDAttrSCD cp2
	--	--ON cp2.CounterpartyIDAttrKeyID = y.CounterPartyIdAttrKey
	--	--WhERE cp2.CounterpartyID = coalesce(cp.CounterPartyID, acbpf.AccountNo)
	--) Netbalfin
from bi.GRCR_BPF_ForbearanceFactDataBase x
INNER JOIN #jobrunsFPSFact fpruns
	ON fpruns.Run = x.RunID
	INNER JOIN #MOBs m
	ON x.PlanCreateDateCalculated between m.MOBStartDate and m.MOBEndDate
left join bi.CounterPartyIDAttrSCD (nolock) cp
on cp.CounterpartyIDAttrKeyID = x.CounterpartyIdAttrKey
and x.CounterpartyIdAttrKey is not null
left join bi.AccountBPFAttrSCD (nolock) acbpf
on acbpf.BPFKNTRSKPFAttrKeyID= x.BPFKNTRSKPFAttrKeyID
and x.BPFKNTRSKPFAttrKeyID is not null


--
-- now get netbalnave finance
--

declare @DateAnchor DATE =  '31 Dec 2015'

select  jr.COBDate, c.*  , y.netbalance_finance  
FROM #consol1 c
INNER JOIN bi.CounterPartyIDAttrSCD cp2
ON cp2.CounterpartyID = c.Account
INNER JOIN #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
and jr.COBDate = c.COBdate
LEFT JOIN bi.FDSF_VntgNetBalanceFinanceFactData (nolock) y
ON y.CounterPartyIdAttrKey = cp2.CounterpartyIDAttrKeyID
AND y.CounterPartyIdAttrChangeListId = cp2.ChangeListId
and y.RunId=jr.Run
--INNER JOIN #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
--AND jr.Run = y.RunId and jr.CobDate = @DateAnchor AND y.RunID is not null

select * from #consol1
select * from #jobruns

select aid.CounterpartyID, x.* 
from bi.FDSF_VntgNetBalanceFinanceFactData x
inner join bi.CounterpartyIDAttrSCD aid
on aid.CounterpartyIDAttrKeyID = x.CounterPartyIdAttrKey
and aid.ChangeListId = x.CounterPartyIdAttrChangeListId
where x.RunId=5569 and  aid.CounterpartyID = '0160640031689408'


sp_help 'bi.CounterPartyIDAttrSCD'

select c.*, y.netbalance_finance 
		from bi.FDSF_VntgNetBalanceFinanceFactData (nolock) y
		INNER JOIN #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
		AND jr.Run = y.RunId and jr.CobDate = @DateAnchor
		INNER JOIN  bi.CounterPartyIDAttrSCD cp2
		ON cp2.CounterpartyIDAttrKeyID = y.CounterPartyIdAttrKey
		INNER JOIN #consol1 c
		ON c.Account = cp2.CounterpartyID
		WHERE cp2.CounterpartyID is NULL 


select x.* 
from bi.GRCR_BPF_ForbearanceFactDataBase x
where x.BPFKNTRSKPFAttrKeyID is not null and x.CounterpartyIdAttrKey is not null

