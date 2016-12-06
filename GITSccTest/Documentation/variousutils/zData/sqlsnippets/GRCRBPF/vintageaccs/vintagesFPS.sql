drop table #TMP_APPS

IF OBJECT_ID(N'tempdb.dbo.#TMP_APPS') IS NULL
BEGIN
		CREATE TABLE #TMP_APPS
		(
				Account_No VARCHAR(256) NOT NULL,
				Ind_Code VARCHAR(256) NOT NULL,
				MIN_Req_Loan_Amount VARCHAR(256) NULL,
		)
END
-- de-dup duplicate application accounts
SELECT Account_No, [Ind_Code], MIN(Req_Loan_Amt) MIN_Req_Loan_Amount
INTO  #TMP_APPS
FROM [GRCR_DEV].[dbo].[BPFWH_APPFILE_JUL2015]
WHERE Bus_decision = 'ACCEPT'
and len(Account_No) > 0
AND Open_Month <> ''
group by Account_No, [Ind_Code]
  --AND pay_plan_m127 <> 2
  -- select top 100 * from [GRCR_DEV].[dbo].[BPFWH_APPFILE_JUL2015]

INSERT INTO #TMP_APPS (Account_No,Ind_Code, MIN_Req_Loan_Amount)
select s.account_no, case when s.division_type  = 'UK Retail' THEN '22'
					when s.division_type  = 'Motor' THEN '50'
					else '99'
					END,  0
					FROM [dbo].[VNTG_ACCOUNT_DETAILS_BOOK] s
					WHERE NOt EXISTS (select top 1 1 from #TMP_APPS where Account_No = s.account_no)

--434960031634430
--JUL12
select Division, count(*) from [dbo].[JAY_BPF_FP_DATA]
group by Division
select top 100 * from [dbo].[JAY_BPF_FP_DATA] order by cast ('01' + Account_Open_Month as date) desc where Account_Number = '0434960031634430'
select top 100 * from [dbo].JAY_BPF_CHGOFF_DATA where Account_No = '0434960031634430'
select top 100 * from #TMP_APPS where account_no = '0434960031634430'
  select count(*) from [dbo].[VNTG_ACCOUNT_DETAILS_BOOK]
  select top 10 * from #TMP_APPS where account_no in ('0017670001832030',  '0152790000031475')




  drop table #inter3

                     select y.* 
                     into #inter3
                     from

                     (

                       select  x.*, 
                       CASE  WHEN N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail'
              WHEN N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor'
              WHEN N9AWCE IN ('CHGLGY','ACQBK','LITGTN') THEN  'Other'
              ELSE 'Missing'  END AS Division,
              --,
                     tt.G1AIDX DateG1AIDX,
					 tt.G1UEDT DateG1UEDT
                    from dbo.N9DEBTP_201507 x
                     
                     INNER join 
                      (


                        select  zz.* 
                      from dbo.G1DEBTP_201507_SUBSET1 zz
                     where G1R8SW = 'L' and G1ZWCG = 'BSR' and G1NZNE = 0
                     --AND run = 5005627
                     ) tt on tt.G1E5CD = x.N9E5CD
                       where x.N9ADCD = 'BPF'
                       --and x.run = 5005645
                     ) y

-- select top 100 * from [dbo].[JAY_BPF_FP_DATA]
--
-- Original Vintage Open Balance
--
-- select * from [dbo].[vntg_payplan_book_noyr]
-- select top 100 * from  [dbo].[JAY_BPF_FP_DATA]
SELECT  --app.[Ind_Code], 
		--chg.chargeoff_date, 
		--chg.Balance, 
		--chg.account_no,
		--DATEDIFF(month, dateadd(mm, 0, cast ( '01' + jay.Account_Open_Month as date)), cast('31JUL2015' as date)) MOB,
		jay.Division,
		convert (decimal(28,8), sum(convert( decimal(28,8), jay.Account_Open_Balance))) tot
 FROM [dbo].[JAY_BPF_FP_DATA] jay
 
   LEFT JOIN #TMP_APPS  app
  ON app.Account_No = jay.Account_Number
  
  --LEFT JOIN [dbo].[vntg_payplan_book_noyr] pp
  --ON pp.account_no = jay.Account_Number
  LEFT JOIN dbo.JAY_BPF_CHGOFF_DATA chg
  ON jay.Account_Number = chg.account_no
  -- WHERE try_convert(date, '01' + jay.Account_Open_Month) <= '20150731'
  --WHERE try_convert(date, chg.chargeoff_date) <= '20150731'
 WHERE cast ( '01' + jay.Account_Open_Month as date) between '01 Jun 2015' and '30 Jun 2015'   -- 36 month
 group by jay.Division
		-- ,jay.Account_Open_Balance
					 

-- 36 MOB - anchor date Jul 2015
SELECT app.[Ind_Code], chg.chargeoff_date, chg.Balance,  --- , kn.*,
--case when app.Ind_Code = '50' Then
--	'Motor'
-- when app.Ind_Code in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22) then 'Retail'
-- else'Unknown'
 --END ProductGRp,
 jay.Division,
  --'24' MOB,
  chg.account_no,
 DATEDIFF(month, dateadd(mm, 0, cast ( '01' + jay.Account_Open_Month as date)), cast('31JUL2015' as date)) MOB,
 --,
 --zz.Account_No,
 --fpacc.Account_No  impairacc,
 jay.Account_Open_Balance
 FROM [dbo].[JAY_BPF_FP_DATA] jay
 
   LEFT JOIN #TMP_APPS  app
  ON app.Account_No = jay.Account_Number
  --JOIN [dbo].[KNTRSKPF] kn
  --ON kn.krkntn = chg.account_no
  --LEFT JOIN [dbo].[vntg_payplan_book_noyr] pp
 -- ON pp.account_no = jay.Account_Number
  --INNER JOIN dbo.N9DEBTP_201507 x
  --ON x.N9HOTX = chg.account_no
  --and x.N9ADCD = 'BPF'
  LEFT JOIN dbo.JAY_BPF_CHGOFF_DATA chg
  ON jay.Account_Number = chg.account_no
  --INNER JOIN dbo.vntg_arrslvlgrip_book_noyr_m125_m129 arrs on x.N9HOTX = arrs.account_no
  --LEFT JOIN ##julFPAccs fpacc    -- select * from ##julFPAccs
  --on fpacc.Account_No = chg.account_no
  --LEFT join dbo.IMPAIR_BASE_201507 zz
 -- on zz.Account_No =chg.account_no
  --LEFT join #inter3 zz
  --on zz.N9HOTX = chg.account_no
  -- select top 100 * from #inter3
 -- INNER JOIN dbo.vntg_arrslvlgrip_book_noyr_m125_m129 arrs on app.Account_No = arrs.account_no
  --WHERE try_convert(date, chg.chargeoff_date) not in( '20150801', '20150901')
  WHERE try_convert(date, chg.chargeoff_date) <= '20150731'
  -- WHERE chg.chargeoff_date not in ('01AUG2015','01SEP2015') 
   --and LEN(LTRIM(RTRIM(kn.krfbdt))) > 0
  --AND DATEADD(month, -1, kn.krfbdt) >= '20130701'
  --AND DATEADD(month, -1, kn.krfbdt) < '20130801'
  --where  try_convert(date, chg.chargeoff_date) <= '20150731'
  --AND app.Bus_decision = 'ACCEPT'
  --AND app.Open_Month <> ''
  --AND pay_plan_m127 <> 2
  -- and app.Ind_Code = '50'
  --and x.N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB')  -- 'Motor'
  --and arrs.arrears_level_m127 = 3
  -- and app.Account_No = '0449070095363463' 
  --group by app.Account_No
 -- having count(*) > 1
 --and chg.chargeoff_date between '01JUL2013' and '31JUL2013'
 and cast ( '01' + jay.Account_Open_Month as date) between '01 Jul 2013' and '31 Jul 2013'   -- 24 month
 -- and cast ( '01' + jay.Account_Open_Month as date) between '01 Jul 2012' and '31 Jul 2012'   -- 36 month
--and cast ( '01' + jay.Account_Open_Month as date) >= '01 Jul 2012'




-- 12 MOB - anchor date Jul 2015
-- > past due
'0160200023554118'
select top 10 * from dbo.JAY_BPF_CHGOFF_DATA where account_no = '0160200023554118'
select top 10 * from dbo.JAY_BPF_FP_DATA where Account_number = '0160200023554118'
select top 10 * from #TMP_APPS WHERE account_no = '0160200023554118'
select top 10 * from  dbo.vntg_arrslvlgrip_book_noyr_m125_m129 WHERE account_no = '0160200023554118'

select top 10 * from dbo.VNTG_NETBALANCE_FINANCE_NOYR_201507 noyr  WHERE account_no = '0160200023554118'

exec routing.uspStagingSourceProcess_v4 @p_StagingTableName='stg.BPF_JAY_BPF_FP_ACC',@p_Run=1086
rollback
SELECT  MIN(RowId),
			   MAX(RowId),
			   COUNT(*) 
			   FROM entity.tfnBPFJAYFPAccount('2015-09-30')
SELECT /*app.[Ind_Code],*/ chg.chargeoff_date, chg.Balance,  --- , kn.*,

 jay.Division,
  --'24' MOB,
  jay.account_number,
  arrs.arrears_level_m126,
  noyr.netbalance_finance_m126,
 DATEDIFF(month, dateadd(mm, 0, cast ( '01' + jay.Account_Open_Month as date)), cast('30JUN2015' as date)) MOB
 --,
 --zz.Account_No,
 --fpacc.Account_No  impairacc
 FROM [dbo].[JAY_BPF_FP_DATA] jay
 
   --LEFT JOIN #TMP_APPS  app             ----- back in?
  --ON app.Account_No = jay.Account_Number
  --JOIN [dbo].[KNTRSKPF] kn
  --ON kn.krkntn = chg.account_no
  --LEFT JOIN [dbo].[vntg_payplan_book_noyr] pp    ---- back in?
  --ON pp.account_no = jay.Account_Number
  --INNER JOIN dbo.N9DEBTP_201507 x
  --ON x.N9HOTX = chg.account_no
  --and x.N9ADCD = 'BPF'
  LEFT JOIN dbo.JAY_BPF_CHGOFF_DATA chg
  ON jay.Account_Number = chg.account_no
  LEFT JOIN dbo.vntg_arrslvlgrip_book_noyr_m125_m129 arrs on arrs.account_no = jay.Account_Number
   LEFT JOIN dbo.VNTG_NETBALANCE_FINANCE_NOYR_201507 noyr on noyr.account_no = jay.Account_Number
  --LEFT JOIN ##julFPAccs fpacc    -- select * from ##julFPAccs
  --on fpacc.Account_No = chg.account_no
  --LEFT join dbo.IMPAIR_BASE_201507 zz
 -- on zz.Account_No =chg.account_no
  --LEFT join #inter3 zz
  --on zz.N9HOTX = chg.account_no
  -- select top 100 * from #inter3
 -- INNER JOIN dbo.vntg_arrslvlgrip_book_noyr_m125_m129 arrs on app.Account_No = arrs.account_no
  --WHERE try_convert(date, chg.chargeoff_date) not in( '20150801', '20150901')
  -- WHERE try_convert(date, chg.chargeoff_date) <= '20150731'
  WHERE arrs.arrears_level_m126 <> ''
  -- WHERE chg.chargeoff_date not in ('01AUG2015','01SEP2015') 
   --and LEN(LTRIM(RTRIM(kn.krfbdt))) > 0
  --AND DATEADD(month, -1, kn.krfbdt) >= '20130701'
  --AND DATEADD(month, -1, kn.krfbdt) < '20130801'
  --where  try_convert(date, chg.chargeoff_date) <= '20150731'
  --AND app.Bus_decision = 'ACCEPT'
  --AND app.Open_Month <> ''
  --AND pay_plan_m127 <> 2
  -- and app.Ind_Code = '50'
  --and x.N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB')  -- 'Motor'
  --and arrs.arrears_level_m127 = 3
  -- and app.Account_No = '0449070095363463' 
  --group by app.Account_No
 -- having count(*) > 1
 --and chg.chargeoff_date between '01JUL2013' and '31JUL2013'
 --and cast ( '01' + jay.Account_Open_Month as date) between '01 Jul 2013' and '31 Jul 2013'   -- 24 month
 -- and cast ( '01' + jay.Account_Open_Month as date) between '01 Jul 2014' and '31 Jul 2014'   -- 12 month
  and cast ( '01' + jay.Account_Open_Month as date) between '01 Jun 2014' and '31 Jun 2014'   -- 12 month
 -- and cast ( '01' + jay.Account_Open_Month as date) between '01 Jan 2015' and '31 Jan 2015'   -- 6 month
 -- and cast ( '01' + jay.Account_Open_Month as date) between '01 Apr 2015' and '30 Apr 2015'  --- 3 month
-- and cast ( '01' + jay.Account_Open_Month as date) >= '01 Jul 2012'
 -- and cast ( '01' + jay.Account_Open_Month as date) between '01 Jan 2014' and '31 Jan 2014'   -- 18 month
 --and cast ( '01' + jay.Account_Open_Month as date) between '01 Dec 2013' and '31 Dec 2013'   -- 18 month
order by jay.Account_Number

select * from dbo.vntg_arrslvlgrip_book_noyr_m125_m129 where account_no = '0160200023554118'
select top 100 * from #TMP_APPS where account_no = '0160200023554118'
select top 100 * from [dbo].[JAY_BPF_FP_DATA] where Account_Number = '0160200023554118'

 select top 10 * from [dbo].[JAY_BPF_FP_DATA] 
 select top 10 * from dbo.IMPAIR_BASE_201507

  select top 10 * from dbo.JAY_BPF_CHGOFF_DATA
 where Account_Number like '%1767000183203%'
 or Account_Number like '%15279000003147%'

 '0017670001832030'
 '0152790000031475'

 select * from dbo.IMPAIR_BASE_201507 zz 
 where zz.Account_No =  '0502190027406497'

 -- accounts which are not in application or vintage application file. '0017670001832030',  '0152790000031475'
 -- mail sent to Vijay: 09 Nov 2015
 select top 100 * from dbo.N9DEBTP_201507 where N9HOTX in( '0017670001832030',  '0152790000031475')


 select y.* from dbo.G1DEBTP_201507_SUBSET1 y 
 where y.G1E5CD in ( '16000005396', '44000002995')
 and G1ZWCG = 'BSR'


 select top 100 * from [dbo].[BPF_CHGOFF_DATA] where account_no in ('0017670001832030',  '0152790000031475')
 select top 100 * from #TMP_APPS where Account_No in ('0017670001832030', '0152790000031475')
 select * from [dbo].[KNTRSKPF] kn  where kn.krkntn in ('0017670001832030', '0152790000031475')
 select top 100 * from [dbo].[vntg_payplan_book_noyr] where account_no in ('0017670001832030', '0152790000031475')


 select top 100 * from dbo.IMPAIR_BASE_201507 zz where Account_No in ( '0017670001832030', '0152790000031475')
 select * from dbo.vntg_arrslvlgrip_book_noyr_m125_m129 where Account_No in ('0017670001832030', '0152790000031475')
 select * from [dbo].[JAY_BPF_FP_DATA] where Account_Number in (  '0017670001832030', '0152790000031475')

 select top 100 * from 	stg.BARCLAYCARD_VNTG_ACCOUNT_DETAILS_BOOK where  Account_No in (  '0017670001832030', '0152790000031475')

 --
 --
 -- account defined as retail AND Motor: 31240002132015 -- We say Retail(Ind_Code supports this, but Vijay query says Motor'
 --
 select top 100 * from  #TMP_APPS where Account_No = '0312400021320150'
 select top 100 * from dbo.N9DEBTP_201507 where N9HOTX in( '0312400021320150')
 select * from [dbo].[JAY_BPF_FP_DATA] where Account_Number in ('0312400021320150')
  select top 100 * from [dbo].[BPF_CHGOFF_DATA] where account_no in ('0312400021320150')
    select top 100 * from [dbo].[vntg_payplan_book_noyr] where account_no in ('0312400021320150')

 --
 -- Account 0519050030035868 coming in our motor query, but not in Vijay
 --
 select top 100 * from  #TMP_APPS where Account_No like '%519050030035868%'
 select top 100 * from dbo.N9DEBTP_201507 where N9HOTX like ( '%519050030035868%')
 select * from [dbo].[JAY_BPF_FP_DATA] where Account_Number in ('0519050030035868')
  select top 100 * from [dbo].[BPF_CHGOFF_DATA] where account_no in ('0519050030035868')
    select top 100 * from [dbo].[vntg_payplan_book_noyr] where account_no in ('0519050030035868')


	--
	-- where in both queries ok
	--
	select top 100 * from  #TMP_APPS where Account_No like '%519050030035868%'
 select top 100 * from dbo.N9DEBTP_201507 where N9HOTX like ( '%519050030035868%')
 select * from [dbo].[JAY_BPF_FP_DATA] where Account_Number in ('0519050030035868')
  select top 100 * from [dbo].[BPF_CHGOFF_DATA] where account_no in ('0519050030035868')
    select top 100 * from [dbo].[vntg_payplan_book_noyr] where account_no in ('0519050030035868')
