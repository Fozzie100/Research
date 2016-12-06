


alter procedure Phil.NewIntoForbearanceChargeOffAccountsBasedOnSource
AS
--
--  Get latest job runs for jobs 
-- at present 31 Dec 2015 to 31 Mar 2016 COBDate only
-- and inserts data into BASE fact tables 
-- Phil.ChargeOffStageExtra and Phil.ForbearanceAccountsStageExtra
--  
--  select * from Phil.ForbearanceAccountsStageExtra
-- select top 100 * from stg.BPF_JAY_BPF_FP_ACC
-- exec Phil.NewIntoForbearanceChargeOffAccountsBasedOnSource

--
-- v2 get division from impair base
-- 

		if OBJECT_ID('tempdb..#jobruns') IS NOT NULL
			drop table  #jobruns
		if OBJECT_ID('tempdb..#n9') IS NOT NULL
			drop table  #n9
		if OBJECT_ID('tempdb..#n9g1') IS NOT NULL
			drop table  #n9g1
		if OBJECT_ID('tempdb..#chargeoff') IS NOT NULL
			drop table  #chargeoff
		if OBJECT_ID('tempdb..#forbearance') IS NOT NULL
			drop table  #forbearance

	

		select x.*, t.Run prevrun
		into #jobruns
			from


			(select j.JobDefinitionCode, j.CobDate, DATEADD(day, -1, DATEADD(month, DATEDIFF(month, 0, j.CobDate), 0)) prevcob, max(jr.Run) Run
					from
					loader.JobRun jr
					inner join loader.Job j
					on j.JobId = jr.JobId
					where j.JobDefinitionCode IN ('BCARD_N9DEBTP', 'BCARD_TCDEBTP','BCARD_G1DEBTP',
					'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR', 'BPF_JAY_BPF_FP_ACC', 'BPF_CHARGEOFF_DATA_INITAL', 'BCARD_XX_BARCLAYCARD_IMPAIR_BASE', 'BPF_VNTG_ARRSLVLGRIP_BOOK')
					and j.CobDate in    ('31 Dec 2015', '31 Jan 2016', '29 Feb 2016', '31 Mar 2016')
					and jr.RunStatus = 'S'
					group by j.JobDefinitionCode, j.CobDate
					) x
			left join 
			(
			select j.JobDefinitionCode, j.CobDate, max(jr.Run) Run
					from
					loader.JobRun jr
					inner join loader.Job j
					on j.JobId = jr.JobId
					where j.JobDefinitionCode IN ('BCARD_N9DEBTP', 'BCARD_TCDEBTP','BCARD_G1DEBTP',
					'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR', 'BPF_JAY_BPF_FP_ACC', 'BPF_CHARGEOFF_DATA_INITAL', 'BCARD_XX_BARCLAYCARD_IMPAIR_BASE')
					and j.CobDate in    ('31 Dec 2015', '31 Jan 2016', '29 Feb 2016', '31 Mar 2016')
					and jr.RunStatus = 'S'
					group by j.JobDefinitionCode, j.CobDate


			) t
			on t.JobDefinitionCode = x.JobDefinitionCode and x.prevcob = t.CobDate

	
		-- select * from #jobruns
		--select j.JobDefinitionCode, j.CobDate, max(jr.Run) Run
		--into #jobruns
		--from
		--loader.JobRun jr
		--inner join loader.Job j
		--on j.JobId = jr.JobId
		--where j.JobDefinitionCode IN ('BCARD_N9DEBTP', 'BCARD_TCDEBTP','BCARD_G1DEBTP',
		--'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR', 'BPF_JAY_BPF_FP_ACC', 'BPF_CHARGEOFF_DATA_INITAL', 'BCARD_XX_BARCLAYCARD_IMPAIR_BASE')
		--and j.CobDate in    ('31 Dec 2015', '31 Jan 2016', '29 Feb 2016', '31 Mar 2016')
		--and jr.RunStatus = 'S'
		--group by j.JobDefinitionCode, j.CobDate


		--select * from #jobruns
		

	-- Job Starting:BCARD_XX_BARCLAYCARD_IMPAIR_BASE CobDate: 31/12/2015 00:00:00

		 select x.[N9E5CD],x.[N9ADCD], x.[N9AWCE], x.[N9HOTX], x.[N9UOAM], x.Run N9Run,
						jr.COBDate N9COBdate,
                       CASE  WHEN N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail'
						WHEN N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor'
						WHEN N9AWCE IN ('CHGLGY','ACQBK','LITGTN') THEN  'Other'
						ELSE 'Missing'  
						END AS Division
						into #n9
                     from [stg].[N9DEBTP] x
					 INNER JOIN #jobruns jr
					  on jr.Run = x.Run and jr.JobDefinitionCode = 'BCARD_N9DEBTP'
		
		CREATE NONCLUSTERED INDEX IX_dIVision     ON #n9 (Division); 

		-- select Division, count(*) cnt from  #n9 group by Division
		-- drop table #n9g1
		select x.[N9E5CD],x.[N9ADCD], x.[N9AWCE], x.[N9HOTX], x.[N9UOAM], x.N9Run, x.N9COBdate,
		zz.Run G1Run, zz.G1UEDT, TC.Run TCRun, case when ib.product_grp in (1,4) Then 'Motor' when ib.product_grp in (2,3) then 'Retail' else 'Unknown' END Division , 
		ib.NetBalance Account_Open_Balance -- , ib.Account_No
		into #n9g1
		from #n9 x
		inner join [stg].[G1DEBTP] (nolock) zz
		on zz.G1E5CD = x.N9E5CD
		INNER JOIN #jobruns jr
		on jr.Run = zz.Run and jr.JobDefinitionCode = 'BCARD_G1DEBTP'
		and jr.CobDate = x.N9COBdate
			INNER JOIN [stg].[TCDEBTP] (nolock) TC
			ON TC.TCE5CD = x.N9E5CD
			INNER JOIN #jobruns jr2
			on jr2.Run = TC.Run and jr2.JobDefinitionCode = 'BCARD_TCDEBTP'
			and jr2.CobDate = x.N9COBdate
		LEFT JOIN stg.BARCLAYCARD_IMPAIR_BASE (nolock) ib
		ON ib.Account_No = x.N9HOTX
		INNER join  #jobruns jr3
		ON jr3.Run = ib.Run and jr3.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_IMPAIR_BASE'
		and jr3.CobDate = x.N9COBdate
		where zz.G1R8SW = 'L' and zz.G1ZWCG = 'BSR' and zz.G1NZNE = 0
		-- and x.Division in ('Motor', 'Retail')

		--select * from [stg].[N9DEBTP] where N9HOTX = '0502090133709588' and Run=119462
		select top 100 * from #n9 where N9HOTX = '0653320092785908'
		select top 100 j.CobDate,  x.* 
		from [stg].[G1DEBTP] x 
		inner join loader.JobRun jr
		on jr.Run = x.Run
		inner join loader.Job j
		on j.JobId = jr.JobId
		where x.G1E5CD = '44000041612'
		and G1UEDT = '29FEB2016'
		-- and j.CobDate = '29 Feb 2016'
		
		--select  top 100 * from stg.BARCLAYCARD_IMPAIR_BASE where Account_No = '0502090133709588'   -- and Run=119444
		--select  * from #n9g1 where N9HOTX = '0653320092785908'
		--select j.CobDate,  x.* from stg.barclaycard_vntg_netbalance_finance_noyr x 
		--inner join loader.JobRun jr
		--on jr.Run = x.Run
		--inner join loader.Job j
		--on j.JobId = jr.JobId
		--where x.account_no = '0502090133709588'
	
		-- select * from #n9g1 where G1UEDT like '%MAR2016%' and Division='Motor' and N9COBdate='31 Dec 2015' order by N9HOTX 
		-- select * from Phil.ForbearanceAccountsStageExtra where PlanCreateDateCalculated between '01 Dec 2015' and '31 Dec 2015' 
		-- and Division = 'Motor'
		-- order by AccountNumber
		 
		
		--select * from #n9 where N9HOTX = '0500280152274968'
		--select * from [stg].[G1DEBTP] where G1E5CD = '36000082090'
		--select * from [stg].[TCDEBTP] where TCE5CD = '36000082090'

		--select * from stg.BARCLAYCARD_IMPAIR_BASE where Account_No in('0681890097097158', '0500280152274968')
		--select top 100 * from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR where Account_No= '0500280152274968'

		--select * from #n9g1 where N9HOTX = '0500280152274968' order by N9HOTX

		--select * from #forbearance where AccountNumber = '0652700110880552' order by AccountNumber

		-- drop table #forbearance
		-- get all accounts in forberance on going with historical
		select p.*
		into #forbearance
		from
		(
		select x.N9HOTX AccountNumber, x.N9COBdate COBDate, x.G1UEDT PlanCreateDate, 'N9' DataSource, null NetBalanceFinance, x.G1Run, x.TCRun, x.N9Run, null HistoricalRun, x.Division, x.Account_Open_Balance
		from #n9g1  x
		where  1 = 1
		AND EOMONTH(cast(  x.G1UEDT as date)) = EOMONTH(x.N9COBDate)
		UNION ALL
		select y.Account_Number, jr.CobDate cobdate, y.Account_Open_Month, 'JAY',null,null,null, null, jr.Run, y.Division, y.Account_Open_Balance
		from stg.BPF_JAY_BPF_FP_ACC y
		INNER JOIN  #jobruns jr
		ON jr.JobDefinitionCode = 'BPF_JAY_BPF_FP_ACC'
		and y.Run= jr.Run 
		) p
		-- where p.AccountNumber = '6304600013089606'
		
		--select * from #forbearance where COBDate <> '31 Dec 2015'

		--
		--
		-- GET ALL ACCOUNTS IN CHARGE OFF
		--
		--
		
		select t.*
		into #chargeoff
		From
		(
		select jr.CobDate, 
				-- x.*, 
				x.Run, x.Account_no, x.ChargeOff_date, x.ChargeOff_Balance,
				'INIT' Datasource, NULL VntgNetBalFinanceRunIDChargeOffUpdate
		from stg.BPF_CHARGEOFF_DATA x
		INNER JOIN  #jobruns jr
		ON jr.JobDefinitionCode = 'BPF_CHARGEOFF_DATA_INITAL'
		and x.Run= jr.Run
		UNION ALL
		-- get charege off ongoing
		select jr.CobDate, 
				curr.Run, curr.Account_No, DATEADD(month, DATEDIFF(month, 0, jr.CobDate), 0) ChargeOffDate, null chargeoff_balance,
				-- curr.*, prev.coff_flag 
				'ONGOING' Datasource, NULL
		from stg.BARCLAYCARD_IMPAIR_BASE curr
		inner join  #jobruns jr
		ON jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_IMPAIR_BASE'
		and curr.Run= jr.Run
		and jr.CobDate <> '31 Dec 2015'
		inner join stg.BARCLAYCARD_IMPAIR_BASE prev
		on prev.Run = jr.prevrun
		and prev.Account_No = curr.Account_No
		where prev.coff_flag <> curr.coff_flag
		-- and jr.CobDate = '29 Feb 2016'
		-- and curr.Account_No = '0531650108674797'
		) t

		
		-- potentially delete duplicate charge off records
		-- which are on historical file an calculated going forward

		DELETE c
		FROM #chargeoff c
		INNER JOIN
		(
		select Account_No, count(*) cnt
		from #chargeoff
		group by Account_No 
		having count(*) > 1
		) x
		ON x.Account_No = c.Account_No
		AND c.Datasource = 'ONGOING'

		select 'Deleted: ' + RTRIM(LTRIM(STR(@@ROWCOUNT))) + ' duplicate charge-off rows Historical/Ongoing overlap. Ongoing has been deleted'  DeleteMessage

		
		-- Now update Charge_Off balance from VNTG_NETBALANCE_FINANCE data
		-- for on-going charge off calculations

		-- begin tran
		UPDATE c
			set ChargeOff_Balance = n.netbalance_finance,
			VntgNetBalFinanceRunIDChargeOffUpdate = n.Run
		
		FROM #chargeoff c
		inner join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR n
		on n.account_no = c.Account_No
		inner join #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
		and jr.Run = n.Run
		and c.CobDate = jr.COBDate
		where c.ChargeOff_Balance is null
		


		-- select top 100 * from Phil.ChargeOffStageExtra

		truncate table [Phil].[ForbearanceAccountsStageExtra]
		truncate table [Phil].[ChargeOffStageExtra]

		INSERT INTO Phil.ChargeOffStageExtra (Run, Account_No, ChargeOff_Date, ChargeOff_Balance, DataSource, COBDate, VntgNetBalFinanceRunIDChargeOffUpdate)
		Select Run, Account_No, ChargeOff_Date, ChargeOff_Balance, DataSource, COBDate, VntgNetBalFinanceRunIDChargeOffUpdate FROM #chargeoff

		
		INSERT INTO Phil.ForbearanceAccountsStageExtra (N9Run,[COBdate],[AccountNumber],[PlanCreateDateRaw],[DataSource],[NetBalanceFinance],[G1Run],[TCRun], HistoricalRun, Division, Account_Open_Balance)
		SELECT N9Run,[COBdate],[AccountNumber],[PlanCreateDate],[DataSource],[NetBalanceFinance],[G1Run],[TCRun], HistoricalRun, Division, IIF(len(Account_Open_Balance) = 0,null, Account_Open_Balance) FROM #forbearance

		-- convert string date to date type, easy date arithmetic thereafter
		update z
		set PlanCreateDateCalculated = case when len(z.PlanCreateDateRaw) = 5 THEN
											convert(date, '01' + LEFT(PlanCreateDateRaw, 3) + '20' + RIGHT(PlanCreateDateRaw, 2))
										else
											cast (PlanCreateDateRaw as DATE)
										END
		FROM Phil.ForbearanceAccountsStageExtra z





	--select * from Phil.ForbearanceAccountsStageExtra where PlanCreateDateCalculated between '01 Mar 2016' and '31 Mar 2016'
	--and Division='Motor'
	--and AccountNumber = '0502090133709588'

	--select top 10000 * from Phil.FPAccountsBI 
	---- where Anchordate = '31 Mar 2016'
	--	where AccountNumber = '0502090133709588'
	--and PlanCreateDateCalculated between '01 Mar 2016' and '31 Mar 2016'

----		select * from Phil.ChargeOffStageExtra 
--	select  * from Phil.ForbearanceAccountsStageExtra where AccountNumber='0701940113491376'
--	select * from Phil.ChargeOffStageExtra where Account_no='0701940113491376'
--	select j.CobDate, y.* 
--	from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y 
--	inner join loader.JobRun jr
--	on jr.Run = y.Run
--	inner join loader.Job j on j.JobId = jr.JobId
--	where y.Account_No = '0612350075849652'
--	order by j.CobDate desc

--	select j.CobDate, z.* 
--	from stg.VNTG_ARRSLVLGRIP_BOOK  z
--	inner join loader.JobRun jr
--	on jr.Run = z.Run
--	inner join loader.Job j on j.JobId = jr.JobId
--	where z.Account_No = '0612350075849652'
--	order by j.CobDate desc





--		-- select CAST ('16DEC2015' as date)

--		select top 100 * from #forbearance
--		-- Charge off 12 MOB - debug START - MAR 2015 anchor
--		-- NOTE: Account went into charge-off in Feb 2016
--		-- so use '29 Feb 2016' vntg netbalance as charge off amount
--		select top 10 * from Phil.ChargeOffStageExtra where Account_no in( '0531650108674797', '0525540113616867', '0652830115192776', '0652700102256118')
--		select top 10 * from Phil.ForbearanceAccountsStageExtra where AccountNumber in ( '0531650108674797', '0525540113616867', '0652830115192776', '0652700102256118')
		

--		select top 100000 jr.COBDate, y.*
--		 from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y
--		 inner join #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
--		 and jr.Run = y.Run
--		 where account_no in ( '0531650108674797', '0525540113616867', '0652830115192776', '0652700102256118')
--		 order by account_no, jr.CobDate
--		 -- Charge off 12 MOB - debug MAR 2015 anchor END


		 --
		 --  FP 3 MOB 30 days past due - DEBUG START  MAR 2015 anchor
		 --
			--select top 10 * from #chargeoff where Account_no in( '0502190077145847', '0502190093318246')
			--select top 10 * from #forbearance where AccountNumber in ( '0502190077145847', '0502190093318246')
		--	select top 10 * from Phil.ChargeOffStageExtra where Account_no in( '0502190077145847', '0502190093318246')
		--	select top 10 * from Phil.ForbearanceAccountsStageExtra where AccountNumber in ( '0502190077145847', '0502190093318246')

		-- select top 100000 jr.COBDate, y.*
		-- from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y
		-- inner join #jobruns jr on jr.JobDefinitionCode = 'BCARD_XX_BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR'
		-- and jr.Run = y.Run
		-- where account_no in ( '0502190077145847', '0502190093318246', '0951970123672993')
		-- order by account_no, jr.CobDate
		
		--select top 100000 jr.COBDate, x.* from stg.VNTG_ARRSLVLGRIP_BOOK x
		-- inner join #jobruns jr on jr.JobDefinitionCode = 'BPF_VNTG_ARRSLVLGRIP_BOOK'
		-- and jr.Run = x.Run
		-- where account_no in ( '0502190077145847', '0502190093318246', '0951970123672993')
		-- order by account_no, jr.CobDate
		 --
		 --  FP 3 MOB 30 days past due - DEBUG END  MAR 2015 anchor
		 --






--		select * from #chargeoff where Account_No = '9150010109948479'

--		select * from stg.BPF_CHARGEOFF_DATA where Run=29799
--		and Account_No = '0052190116003514'

--		-- Jan 2016
--		select * from stg.BARCLAYCARD_IMPAIR_BASE
--		where Run=20615 and Account_No = '0052190116003514'

--		-- dec 2015
--		select * from stg.BARCLAYCARD_IMPAIR_BASE
--		where Run=5573 and Account_No = '0052190116003514'
		
--		select * from #jobruns
--		-- and N9HOTX = '0502190129240059'





--		select y.* 
--					  from stg.BPF_JAY_BPF_FP_ACC y
--					  Where  1 = 1
--					  and Account_Number IN ('0652700110880552')
--					  and Run=11688 

--		--select * from [stg].[G1DEBTP] where G1E5CD = '43000050729'


--		select * from #jobruns where JobDefinitionCode =  'BCARD_N9DEBTP'


--		if OBJECT_ID('tempdb..#inter') IS NOT NULL
--			drop table  #inter
		
--					 --drop table #inter
--                     select distinct y.* into #inter from

--                     (

--                       select x.[N9E5CD],x.[N9ADCD], x.[N9AWCE], x.[N9HOTX], x.[N9UOAM], x.Run N9Run,
--						jr.COBDate N9COBdate,
--                       CASE  WHEN N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail'
--						WHEN N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor'
--						WHEN N9AWCE IN ('CHGLGY','ACQBK','LITGTN') THEN  'Other'
--						ELSE 'Missing'  
--						END AS Division,
--                       tt.*
--                     from [stg].[N9DEBTP] x
--							--inner join loader.JobRun jr
--							-- on jr.Run = x.Run
--							-- inner join loader.Job j
--							-- on j.JobId = jr.JobId
--							 INNER JOIN #jobruns jr
--					  on jr.Run = x.Run and jr.JobDefinitionCode = 'BCARD_N9DEBTP'
                     
--							 INNER join 
--							  (

--									select  zz.*, jr.CobDate
--									from [stg].[G1DEBTP] zz
--									--inner join loader.JobRun jr
--									-- on jr.Run = zz.Run
--									-- inner join loader.Job j
--									-- on j.JobId = jr.JobId
--									 INNER JOIN #jobruns jr
--									on jr.Run = zz.Run and jr.JobDefinitionCode = 'BCARD_G1DEBTP'
--									where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0
--							 ) tt on tt.G1E5CD = x.N9E5CD and tt.CobDate = jr.CobDate
							 
--                       where x.N9ADCD = 'BPF'
--                     ) y
--                     inner join 
--					 (	select TC.*, jr.CobDate
--						FROM [stg].[TCDEBTP] TC
--						--inner join loader.JobRun jr
--						--on jr.Run = TC.Run
--						--inner join loader.Job j
--						--on j.JobId = jr.JobId
--						INNER JOIN #jobruns jr
--						ON jr.Run = TC.Run and jr.JobDefinitionCode = 'BCARD_TCDEBTP'

--                      ) z
--					  on z.TCE5CD = y.N9E5CD
--					  and z.CobDate = y.N9COBDate
					 
--					  -- where y.N9COBdate in ('31 Dec 2015')
--					  where y.N9Run IN (5571, 28327, 75613,119462) -- (Dec2015=5571, Jan2016=28327, Feb2016=75613, Mar2016=119462



--					  select top 100 * from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR

--					  select * from #inter where N9HOTX IN ( '0294980094321120', '0414710110601840')
--					  select count(*) from #inter 
--					  where  1 = 1
--					  and
--					  (
--					  ( G1UEDT like '%MAR2016%' )   -- G1UEDT = PlanCreateDate)
--					  or G1UEDT like '%FEB2016%'    -- G1UEDT = PlanCreateDate)
--					  or G1UEDT like '%JAN2016%'    -- G1UEDT = PlanCreateDate)
--					  or G1UEDT like '%DEC2015%'    -- G1UEDT = PlanCreateDate)
--					  )


--					   select top 100 * from #inter where N9HOTX IN ('0502190077145847')
--					  select y.* 
--					  from stg.BPF_JAY_BPF_FP_ACC y
--					  Where  1 = 1
--					  and Account_Number IN ('0531650108674797', '0525540113616867', '0502190077145847')
--					  and Run=11688   -- COB=DEc2015
--					  and Account_Number = '0502190077145847'

--					  select x.* 
--					  from stg.BPF_CHARGEOFF_DATA x
--					  where Run=29799  -- -- COB=DEc2015
--					  and Account_No IN ('0531650108674797', '0525540113616867', '0502190077145847')
--					  and account_no = '0502190077145847'



--					  select  top 100 j.CobDate, y.* 
--					  from stg.BARCLAYCARD_IMPAIR_BASE y
--					  inner join loader.JobRun jr
--					  on jr.Run = y.Run
--					  inner join loader.Job j
--					  on j.JobId = jr.JobId
--					  WHERE Account_No IN ('0531650108674797', '0525540113616867', '0502190077145847')
--					  and account_no = '0502190077145847'
--					  order by j.CobDate desc, y.Account_No

--					  select  top 100 j.CobDate, y.* 
--					  from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR y
--					  inner join loader.JobRun jr
--					  on jr.Run = y.Run
--					  inner join loader.Job j
--					  on j.JobId = jr.JobId
--					  WHERE Account_No IN ('0531650108674797', '0525540113616867', '0502190077145847')
--					  and account_no = '0502190077145847'
--					  order by j.CobDate desc, y.Account_No

	


					 


                     
--                      select top 100 * FROM #inter --group by division
--					  select top 1000 * FROM #inter2  where Division  <> 'Motor' and Division <> 'Retail'
--					  and DateG1UEDT like '%JUN2015%' 
--					  where  1 = 1
--					  -- and dateG1AIDX like '%JUN2015%' --group by division
--					  and DateG1UEDT like '%JUN2015%' --group by division


--					   select top 100 * FROM dbo.KFDEBTP_201507_SUBSET1
--					   select top 100 * from  dbo.KEDEBTP201507_SUBSET1
--                     SELECT top 100  KFP1ND
--                                      ,KFWFVA as Opening_Balance
--                         --,case when input(KFWNVA,2.) not in (0,1,2,3,4,5,6) then 7
--                        --else input(KFWNVA,2.) end AS NO_CYCLES_DOWN
--                FROM dbo.KFDEBTP_201507_SUBSET1 f
--                           INNER JOIN dbo.KEDEBTP201507_SUBSET1 e
--                           on 
                           
--                           where KFWTCF = 'ACCT01' and KFMISV ='TC' AS CYCLES
                     


--					 --drop table #inter2

--                     select y.* 
--                     into #inter2
--                     from

--                     (

--                       select  x.*, 
--                       CASE  WHEN N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail'
--              WHEN N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor'
--              WHEN N9AWCE IN ('CHGLGY','ACQBK','LITGTN') THEN  'Other'
--              ELSE 'Missing'  END AS Division,
--              --,
--                     tt.G1AIDX DateG1AIDX,
--					 tt.G1UEDT DateG1UEDT
--                    from [stg].[N9DEBTP] x
                     
--                     INNER join 
--                      (


--                        select  zz.* 
--                      from [stg].[G1DEBTP] zz
--                     where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0
--                     AND run = 5005627
--                     ) tt on tt.G1E5CD = x.N9E5CD
--                       where x.N9ADCD = 'BPF'
--                       and x.run = 5005645
--                     ) y
----                     ) tmp
                     
                     
                     
--                     inner join [dbo].[TCDEBTP_201507_SUBSET1] TC
--                     on TC.TCE5CD = y.N9E5CD
                     
--                      select * FROM #inter2 where N9HOTX not in (SELECT N9HOTX from #inter)
--                      select * FROM #inter2 where N9HOTX in (SELECT N9HOTX from #inter)
--                      select * FROM #inter where N9HOTX not in (SELECT N9HOTX from #inter2)
--                      select * FROM #inter where N9HOTX in (SELECT N9HOTX from #inter2)

--                      EXCEPT 
--                      SELECT * FROM #inter
--                            --group by division

--                     SELECT top 100  KFP1ND
--                                      ,KFWFVA as Opening_Balance
--                         --,case when input(KFWNVA,2.) not in (0,1,2,3,4,5,6) then 7
--                        --else input(KFWNVA,2.) end AS NO_CYCLES_DOWN
--                FROM dbo.KFDEBTP_201507_SUBSET1 f
--                           INNER JOIN dbo.KEDEBTP201507_SUBSET1 e
--                           on 
                           
--                           where KFWTCF = 'ACCT01' and KFMISV ='TC' AS CYCLES
                     














--                      select ',''' + N9HOTX + ''''

--                      FROM #inter2 --group by division


--select top 100 * from stg.BARCLAYCARD_IMPAIR_BASE where coff_flag <> '1' and  coff_flag <> '0'

--select COUNT(*) from stg.BARCLAYCARD_IMPAIR_BASE where run = 5000285 and account_no in (select N9HOTX from #inter)
--select COUNT(*) from [stg].[BARCLAYCARD_IMP_STOCK_ACCT] where run = 1104 and account_no in (select N9HOTX from #inter)

--select * from loader.JobRun jr INNER JOIN loader.Job j on jr.JobId = j.JobId where jr.run in (5000554,5000610,1104)

----
---- start of query analysis
----
--select * from #inter2 where N9HOTX = '0930810092322798'


--where N9HOTX in
--(
--'436210122315384',
--'414710104756311',
--'1206490104778690',
--'166810095251585',
--'1700200101051570',
--'9020690089877570',
--'930810092322798',
--'9020010107134970',
--'9020990104495840',
--'1400400080342840'

--)



--select * from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR noyr 
--where run =1078
--and account_no in 
--(
--'0436210122315384',
--'0414710104756311',
--'1206490104778694',
--'0166810095251585',
--'1700200101051578',
--'9020690089877570',
--'0930810092322798',
--'9020010107134971',
--'9020990104495840',
--'1400400080342849'
--)
--select top 100 * from stg.BARCLAYCARD_IMPAIR_BASE
--where run = 5000285
--and Account_No in ('9020990104495840', '9020690089877570')




--select ProductGroup, grip_arrears_level, 
--coff_flag, 
--sum(cast(netbalance_finance as decimal(30,10) )) as ENR, 
---- sum(cast(N9UOAM as decimal(30,10) )) as ENR1NOTREQUIRED, 
----sum(cast(G1PAVC as decimal(30,10) )) as ENR2, 
--count(Account_No) as AccountsInENR, 
--'30-JUNE' as COBDATE
----,tmp.DateG1AIDX
----,tmp.N9HOTX
----,DATENAME(mm, tmp.DateG1AIDX) mthName
--, count(*) cnt
--from 
--( 
--select  -- base.*, 
--base.grip_arrears_level,
--base.coff_flag,
--base.Account_No,
--noyr.netbalance_finance, 
--fp.N9UOAM,
--fp.DateG1AIDX,
--fp.N9HOTX,
----fp.G1PAVC,
--case 
--when product_grp in (1,4) then 'Motor' 
--when product_grp in (2,3) then 'Retail' 
--else 'Unknown' 
--end as ProductGroup 
--from stg.BARCLAYCARD_IMPAIR_BASE base 
---- from stg.BARCLAYCARD_IMP_STOCK_ACCT base 
--INNER join #inter2 fp
--    on base.account_no = fp.N9HOTX 
--left join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR noyr 
--    on base.account_no = noyr.account_no 
--where 1 = 1
--and NetBalance is not null 
--and NetBalance <>'' 
---- and impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
--and in_scope = 1 
--and coff_flag <> 1 
--and base.run = 5000285 -- 2015-06-30 
---- and base.run = 1104   -- BARCLAYCARD_IMP_STOCK_ACCT
--and noyr.Run = 1078 
--and noyr.netbalance_finance is not null 
--and noyr.netbalance_finance <> '' 
-- -- and base.account_open_month like '%JUN15%'
--  --and ( fp.DateG1UEDT like '%JUN2015%'   --- or fp.DateG1AIDX like '%JUN2015%'
--  -- )
-- and fp.DateG1UEDT like '%JUN2015%'
--) tmp 
--group by ProductGroup ,coff_flag ,grip_arrears_level   -- , tmp.DateG1AIDX, tmp.N9HOTX

---- select top 100 * from stg.BARCLAYCARD_IMP_STOCK_ACCT
---- select top 100 * from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR 

---- select * from stg.BARCLAYCARD_IMPAIR_BASE


--select  base.*, 
--noyr.netbalance_finance,
----fp.N9UOAM,
----fp.G1PAVC,
--case 
--when product_grp in (1,4) then 'Motor' 
--when product_grp in (2,3) then 'Retail' 
--else null 
--end as ProductGroup 
--from stg. BARCLAYCARD_IMPAIR_BASE base 
----INNER join #inter2 fp
----    on base.account_no = fp.N9HOTX 
--left outer join stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR noyr 
--    on base.account_no = noyr.account_no 
--where NetBalance is not null 
--and NetBalance <>'' 
--and impair_flag in ('Core Non-repayment','Core Repayment','Out-of_scope-other') 
--and in_scope = 1 
---- and coff_flag <> 1 
--and base.run = 5000285 -- 2015-06-30 
--and noyr.Run = 1078 
--and noyr.netbalance_finance is not null 
--and noyr.netbalance_finance <> '' 
--and isnumeric(noyr.netbalance_finance)=1 and CONVERT(DECIMAL(38,10), isnull(noyr.netbalance_finance,0)) = 95.34

--select top 10 *
--from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR noyr 
--WHERE isnumeric(noyr.netbalance_finance)=1 and CONVERT(DECIMAL(38,10), isnull(noyr.netbalance_finance,0)) = 95.34
--AND  noyr.Run = 1078 



--                        select  * 
--                      from [stg].[N9DEBTP] x
--                     INNER join 
--					  [stg].[G1DEBTP] zz
--					  ON x.N9E5CD = zz.G1E5CD
--                     where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0
--                     AND zz.run = 5005627
--					 and x.Run =5005645
--					   and ( G1UEDT like '%JUN2015%' ) 
					   
					   
					   
--					    and ( fp.DateG1UEDT like '%JUN2015%' 
--  or fp.DateG1AIDX like '%JUN2015%' )
--  or G1AIDX like '%JUN2015%' )

