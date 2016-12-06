

alter procedure Phil.NewIntoForbearanceAccountsChargeOffBasedOnSourceIntoConsolidatedFact ( @P_AnchorDate DATE)
as


--
-- Consolidate fact population
--
-- Select the AnchorDate to populate
--
-- NOTE: Phil.NewIntoForbearanceChargeOffAccountsBasedOnSource must be run first for the 
-- correct COBDATES. 
-- NewIntoForbearanceAccountsBasedOnSource clears down the base fact tables
-- and loads data for the COBDate(s) specified in this script
-- @DateAnchor here must match to the COBDate's used in NewIntoForbearanceAccountsBasedOnSource

  -- exec  Phil.NewIntoForbearanceAccountsChargeOffBasedOnSourceIntoConsolidatedFact '31 Dec 2015'
  -- exec  Phil.NewIntoForbearanceAccountsChargeOffBasedOnSourceIntoConsolidatedFact '31 Jan 2016'
  -- exec  Phil.NewIntoForbearanceAccountsChargeOffBasedOnSourceIntoConsolidatedFact '29 Feb 2016'

	DECLARE @DateAnchor DATE = @P_AnchorDate
			--,
			--@MOB INT = 18,
			--@ArrearsLevelFP INT = 4,
			--@ArrearsLevelChargeOff INT = 0 ---- always 0?


		if OBJECT_ID('tempdb..#MOBs') IS NOT NULL
			drop table  #MOBs

		if OBJECT_ID('tempdb..#jobruns') IS NOT NULL
			drop table  #jobruns

		if OBJECT_ID('tempdb..#ChargeOffMOB') IS NOT NULL
			drop table  #ChargeOffMOB


			select x.*
		into #jobruns
			from


			(select j.JobDefinitionCode, j.CobDate, DATEADD(day, -1, DATEADD(month, DATEDIFF(month, 0, j.CobDate), 0)) prevcob, max(jr.Run) Run
					from
					loader.JobRun jr
					inner join loader.Job j
					on j.JobId = jr.JobId
					where j.JobDefinitionCode IN ('BCARD_N9DEBTP', 'BCARD_TCDEBTP','BCARD_G1DEBTP',
					'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR', 'BPF_JAY_BPF_FP_ACC', 'BPF_CHARGEOFF_DATA_INITAL', 'BCARD_XX_BARCLAYCARD_IMPAIR_BASE', 'BPF_VNTG_ARRSLVLGRIP_BOOK')
					and j.CobDate in    (@DateAnchor)
					and jr.RunStatus = 'S'
					group by j.JobDefinitionCode, j.CobDate
					) x
			


	 SELECT 
	 
					  @DateAnchor AnchorDate,
					 -- jr.Run, 
					  --j.CobDate, 
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
					  (18, 'FPs >90 Days past due at 18 MOB (incl. charge-offs)', 4)
			   ) as mob (MonthOnBook, Metric, ArrearsLevel)
			  
			  SELECT 
			    --div.BPFDivisionAttrKeyID, 
				-- div.Division, 
				--jr.Run, 
				--j.CobDate, 
				DATEADD(month, DATEDIFF(month, 0, @DateAnchor) - mob.MonthOnBook, 0) BookDate,
				DATEADD(month, DATEDIFF(month, 0, @DateAnchor), 0) MonthStart,
				mob.Metric,
				mob.MonthOnBook
				INTO #ChargeOffMOB
			--FROM bi.BPFDivisionAttrSCD div
			FROM (VALUES
				(12, 'FPs Charge-Off at 12 MOB'),
				(24, 'FPs Charge-Off at 24 MOB'),
				(36, 'FPs Charge-Off at 36 MOB')
				--,(3, 'FPs Charge-Off at 3 MOB')
			) as mob (MonthOnBook, Metric)

	
	--select * from #ChargeOffMOB
	-- truncate table Phil.FPAccountsBI

	-- Get Accounts in FP
	delete Phil.FPAccountsBI where AnchorDate = @DateAnchor
	delete Phil.FPAccountsChargeOffBI where AnchorDate = @DateAnchor
	delete Phil.ChargeOffAccountsBI where AnchorDate = @DateAnchor
	delete Phil.FPAccountsOriginalBalanceBI where AnchorDate = @DateAnchor

	
	
	INSERT INTO Phil.FPAccountsBI (Anchordate,PlanCreateDateCalculated,Division,NetBalanceFinance,MOBStartDate,MOBEndDate,MOBArrearsLevel,Arrears_Level,AccountNumber,Datasource, N9Run, MOB, Metric, Account_Open_Balance)
	select @DateAnchor ,x.PlanCreateDateCalculated, x.Division, IIF(len(y.netbalance_finance) = 0,null, y.netbalance_finance), m.MOBStartDate,m.MOBEndDate,m.ArrearsLevel, z.Arrears_Level, x.AccountNumber, x.DataSource, x.N9Run, m.MonthOnBook, m.Metric, x.Account_Open_Balance
	--select  @DateAnchor AnchorDate, m.MonthOnBook, x.*, y.netbalance_finance, z.Arrears_Level
	from Phil.ForbearanceAccountsStageExtra x
	inner join #MOBs m
	on x.PlanCreateDateCalculated between m.MOBStartDate and m.MOBEndDate
	inner join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y
	on y.account_no = x.AccountNumber
    inner join #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
	and jr.Run = y.Run and jr.CobDate = @DateAnchor
	left join stg.VNTG_ARRSLVLGRIP_BOOK  z
	on z.account_no = x.AccountNumber
	 inner join #jobruns jr2 on jr2.JobDefinitionCode = 'BPF_VNTG_ARRSLVLGRIP_BOOK'
	and jr2.Run = z.Run and jr2.CobDate = @DateAnchor
	--where z.Arrears_Level >= @ArrearsLevelFP and m.MonthOnBook = @MOB
	-- and x.PlanCreateDateCalculated between '01 Dec 2015' and '31 Dec 2015'
	order by x.AccountNumber asc 
	
	
	
	-- Get ChargeOff data for accounts in FP
	INSERT INTO Phil.FPAccountsChargeOffBI (Anchordate,PlanCreateDateCalculated,Division,NetBalanceFinance,MOBStartDate,MOBEndDate,MOBArrearsLevel,Arrears_Level,AccountNumber,Datasource, Charge_OffDate, MOB, Metric)
	select @DateAnchor, fp.PlanCreateDateCalculated, fp.Division, IIF(len(y.netbalance_finance) = 0,null, y.netbalance_finance), m.MOBStartDate, m.MOBEndDate, m.ArrearsLevel, z.Arrears_Level, x.Account_no, x.DataSource, x.ChargeOff_Date, m.MonthOnBook, m.Metric
	from Phil.ChargeOffStageExtra x
	inner join #MOBs m
	on x.ChargeOff_Date between m.MOBStartDate and  @DateAnchor
	inner join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y
	on y.account_no = x.Account_no
    inner join #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
	and jr.Run = y.Run and jr.CobDate =  @DateAnchor
	inner join Phil.ForbearanceAccountsStageExtra fp
	on fp.AccountNumber = x.Account_no

	left join stg.VNTG_ARRSLVLGRIP_BOOK  z
	on z.account_no = x.Account_no
	 inner join #jobruns jr2 on jr2.JobDefinitionCode = 'BPF_VNTG_ARRSLVLGRIP_BOOK'
	and jr2.Run = z.Run and jr2.CobDate =  @DateAnchor

	where 1 = 1
	--and m.MonthOnBook = @MOB 
	and x.ChargeOff_Date >= fp.PlanCreateDateCalculated
	and fp.PlanCreateDateCalculated between m.MOBStartDate and m.MOBStartDate
	--and z.Arrears_Level = @ArrearsLevelChargeOff
	order by x.Account_no



	-- Charge-OFF
	INSERT INTO Phil.ChargeOffAccountsBI ([Anchordate],	[PlanCreateDateCalculated],[Division],[Charge_OffBalance],[Charge_OffDate],[BookDate],[MonthStart],[Arrears_Level],[AccountNumber],[RunChargeOff],Datasource,COBDateChargeOff,MOB,Metric)
	select @DateAnchor, fp.PlanCreateDateCalculated, fp.Division, x.ChargeOff_Balance, x.ChargeOff_Date, m.BookDate, m.MonthStart,  z.Arrears_Level, x.Account_no, x.Run, x.DataSource, x.COBDate, m.MonthOnBook, m.Metric
	-- ,x.Account_no, x.Run, x.DataSource, x.COBDate, m.MonthOnBook, m.Metric
	from Phil.ChargeOffStageExtra x
	--inner join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y
	--on y.account_no = x.Account_no
 --   inner join #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
	--and jr.Run = y.Run and jr.CobDate =  @DateAnchor
	inner join Phil.ForbearanceAccountsStageExtra fp
	on fp.AccountNumber = x.Account_no
	inner join #ChargeOffMOB m
	on x.ChargeOff_Date between fp.PlanCreateDateCalculated and m.MonthStart
	and fp.PlanCreateDateCalculated = m.BookDate
	left join stg.VNTG_ARRSLVLGRIP_BOOK  z
	on z.account_no = x.Account_no
	inner join #jobruns jr2 on jr2.JobDefinitionCode = 'BPF_VNTG_ARRSLVLGRIP_BOOK'
	and jr2.Run = z.Run and jr2.CobDate =  @DateAnchor
	-- and z.Arrears_Level = @ArrearsLevelChargeOff
	-- where m.Metric = 'FPs Charge-Off at 36 MOB'
	order by x.Account_no

	--



	--  Original Balance of FPS
	insert into Phil.FPAccountsOriginalBalanceBI (Anchordate,[PlanCreateDateCalculated],[Division],	[NetBalanceFinance],[AccountNumber],[Datasource],[Metric],	[Account_Open_Balance])
	select @DateAnchor, x.PlanCreateDateCalculated, x.Division, IIF(len(y.netbalance_finance) = 0,null, y.netbalance_finance), x.AccountNumber, x.DataSource, 'Original Balance of FPs', x.Account_Open_Balance
	from Phil.ForbearanceAccountsStageExtra x
	inner join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y
	on y.account_no = x.AccountNumber
	inner join #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
	and jr.Run = y.Run and jr.CobDate =  @DateAnchor
	where x.COBdate = @DateAnchor
	


	-- Or charge off   '0575020113208659

	--select top 100 * from Phil.ChargeOffStageExtra where Account_no = '0575020113208659'
	--select * from Phil.ForbearanceAccountsStageExtra where AccountNumber= '0575020113208659'
	 
	-- select jr.CobDate, y.* 
	-- from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y 
	-- inner join #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
	--and jr.Run = y.Run and jr.CobDate = '31 Mar 2016'
	-- where y.account_no =  '0575020113208659'
	-- order by jr.CobDate desc
	


	--select * from Phil.ForbearanceAccountsStageExtra where AccountNumber = '0683840117111560'
	--select j.CobDate, c.* 
	--from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR c (nolock) 
	--inner join loader.JobRun jr
	--on jr.Run = c.Run
	--inner join loader.Job j
	--on j.JobId = jr.JobId
	--where account_no = '0683840117111560'
	--order by j.CobDate desc

	-- '0683840117111560'
	--where 





--	select top 100000 max(RIGHT(PlanCreateDateRaw, 2)) planyearmax, min(RIGHT(PlanCreateDateRaw, 2)) planyearmin  from Phil.ForbearanceAccountsStageExtra where HistoricalRun is not null
--select * from Phil.ChargeOffStageExtra
--where Account_no in
--(
--'0502190077145847',
--'0502190093318246',
--'0502190093574392',
--'0506930140648509',
--'0507630135580936',
--'0510380115683020',
--'0510610094800215',
--'0512800099264875',
--'0516260096108680',
--'0525520097673761',
--'0525540117222662',
--'0525550129133757',
--'0538330116339104',
--'0539680141680792',
--'0543250121960111',
--'0572620110379370',
--'0572620110942128',
--'0573670121444423',
--'0575020110894550',
--'0580990109053207',
--'0586750109332256',
--'0586750110056779',
--'0586750115146195',
--'0586750119885798',
--'0586750126705062',
--'0617790117792334',
--'0625380114351498',
--'0625380131726953',
--'0630700111653377',
--'0638240128577915',
--'0640460113705588',
--'0645280134081529',
--'0652700095430894',
--'0652700118517917',
--'0652700120531617',
--'0655330080138943',
--'0657100109494504',
--'0669960123094358',
--'0669980127245111',
--'0680250127814638',
--'0681010131423530',
--'0681400110248588',
--'0681400135308268',
--'0682160097903220',
--'0701240096409812',
--'0704870112293506',
--'0704950106425080',
--'0294980094321120',
--'0414710110601840',
--'0416650027754746',
--'0447210085796429',
--'0951970123672993',
--'0990180104163078',
--'1003520108327307',
--'1105040120571136',
--'1105350084847731',
--'1400470113061716',
--'1400520106686133',
--'1700070106781697',
--'1700500098981723',
--'1708690128279347',
--'9010380109694658',
--'9020190085385611',
--'9050910116469230'
--)
--and Account_No = '0951970123672993'











--select * from Phil.ForbearanceAccountsStageExtra where AccountNumber in
--(
--'0502190077145847',
--'0502190093318246',
--'0502190093574392',
--'0506930140648509',
--'0507630135580936',
--'0510380115683020',
--'0510610094800215',
--'0512800099264875',
--'0516260096108680',
--'0525520097673761',
--'0525540117222662',
--'0525550129133757',
--'0538330116339104',
--'0539680141680792',
--'0543250121960111',
--'0572620110379370',
--'0572620110942128',
--'0573670121444423',
--'0575020110894550',
--'0580990109053207',
--'0586750109332256',
--'0586750110056779',
--'0586750115146195',
--'0586750119885798',
--'0586750126705062',
--'0617790117792334',
--'0625380114351498',
--'0625380131726953',
--'0630700111653377',
--'0638240128577915',
--'0640460113705588',
--'0645280134081529',
--'0652700095430894',
--'0652700118517917',
--'0652700120531617',
--'0655330080138943',
--'0657100109494504',
--'0669960123094358',
--'0669980127245111',
--'0680250127814638',
--'0681010131423530',
--'0681400110248588',
--'0681400135308268',
--'0682160097903220',
--'0701240096409812',
--'0704870112293506',
--'0704950106425080',
--'0294980094321120',
--'0414710110601840',
--'0416650027754746',
--'0447210085796429',
--'0951970123672993',
--'0990180104163078',
--'1003520108327307',
--'1105040120571136',
--'1105350084847731',
--'1400470113061716',
--'1400520106686133',
--'1700070106781697',
--'1700500098981723',
--'1708690128279347',
--'9010380109694658',
--'9020190085385611',
--'9050910116469230'
--)
--and AccountNumber = '0951970123672993'

--	SELECT 
--		MAX(x.Run) Run, x.CobDate, x.MOBStartDate, x.MOBEndDate, x.Metric, x.MonthOnBook, x.ArrearsLevel
--		FROM
--		(
--			   SELECT 
--					  jr.Run, 
--					  j.CobDate, 
--					  DATEADD(month, DATEDIFF(month, 0, j.CobDate) - mob.MonthOnBook, 0) MOBStartDate,
--					  EOMONTH(DATEADD(month, DATEDIFF(month, 0, j.CobDate) - mob.MonthOnBook, 0)) MOBEndDate,
--					  mob.Metric,
--					  mob.MonthOnBook,
--					  mob.ArrearsLevel
--			   FROM loader.Job j 
--			   INNER JOIN loader.JobRun jr on jr.JobId = j.JobId
--			   CROSS JOIN (VALUES
--					  (3, 'FPs >30 Days past due at 3 MOB (incl. charge-offs)', 2),
--					  (6, 'FPs >30 Days past due at 6 MOB (incl. charge-offs)', 2),
--					  (12, 'FPs >90 Days past due at 12 MOB (incl. charge-offs)', 4),
--					  (18, 'FPs >90 Days past due at 18 MOB (incl. charge-offs)', 4)
--			   ) as mob (MonthOnBook, Metric, ArrearsLevel)
--			   WHERE j.JobDefinitionCode = 'BPF_LOAD_VINTAGE_FPS_FACT'
--	   ) x
--	   GROUP BY x.CobDate, x.MOBStartDate, x.MOBEndDate, x.Metric, x.MonthOnBook, x.ArrearsLevel
