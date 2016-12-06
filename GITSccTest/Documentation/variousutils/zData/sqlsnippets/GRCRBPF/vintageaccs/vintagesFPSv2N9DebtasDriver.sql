drop table #TMP_APPS
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
					 

-- 12 MOB - anchor date Jul 2015
SELECT x.[N9AWCE] ProductCode , chg.chargeoff_date, chg.Balance,  --- , kn.*,
case when x.[N9AWCE] IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor'
	
  WHEN x.N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail'
 else'Unknown'
 END ProductGRp,
  --'24' MOB,
  chg.account_no,
 DATEDIFF(month, dateadd(mm, 0, cast ( '01' + jay.Account_Open_Month as date)), cast('31JUL2015' as date)) MOB
 --,
 --zz.Account_No,
 --fpacc.Account_No  impairacc
 FROM [dbo].[BPF_CHGOFF_DATA] chg
  --JOIN #TMP_APPS  app
  --ON app.Account_No = chg.account_no
  --JOIN [dbo].[KNTRSKPF] kn
  --ON kn.krkntn = chg.account_no
 -- JOIN [dbo].[vntg_payplan_book_noyr] pp
  -- ON pp.account_no = chg.account_no
  INNER JOIN dbo.N9DEBTP_201507 x
  ON x.N9HOTX = chg.account_no
  and x.N9ADCD = 'BPF'
  INNER JOIN [dbo].[JAY_BPF_FP_DATA] jay
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
  -- and try_convert(date, chg.chargeoff_date) between '01 Jul 2012' and '31 Jul 2012'
  -- WHERE chg.chargeoff_date not in ('01AUG2015','01SEP2015') 
   --and LEN(LTRIM(RTRIM(kn.krfbdt))) > 0
  --AND DATEADD(month, -1, kn.krfbdt) >= '20130701'
  --AND DATEADD(month, -1, kn.krfbdt) < '20130801'
  --where  try_convert(date, chg.chargeoff_date) <= '20150731'
  --AND app.Bus_decision = 'ACCEPT'
  --AND app.Open_Month <> ''
 -- AND pay_plan_m127 <> 2
  -- and app.Ind_Code = '50'
  --and x.N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB')  -- 'Motor'
  --and arrs.arrears_level_m127 = 3
  -- and app.Account_No = '0449070095363463' 
  --group by app.Account_No
 -- having count(*) > 1
 --and chg.chargeoff_date between '01JUL2013' and '31JUL2013'
 -- and cast ( '01' + jay.Account_Open_Month as date) between '01 Jul 2013' and '31 Jul 2013'   -- 24 month
 and cast ( '01' + jay.Account_Open_Month as date) between '01 Jul 2012' and '31 Jul 2012'   -- 36 month
--and cast ( '01' + jay.Account_Open_Month as date) >= '01 Jul 2012'


 select * from [dbo].[JAY_BPF_FP_DATA] 
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
 -- account defined as retail AND Motor: 031240002132015 -- We say Retail(Ind_Code supports this, but Vijay query says Motor'
 --										:0434970031994270
 --										519050030035868
 -- select * from  dbo.N9DEBTP_201507 where N9HOTX like '%519050030035868%'
 select top 100 * from  #TMP_APPS where Account_No in ( '0312400021320150', '0434970031994270')
 select top 100 * from dbo.N9DEBTP_201507 where N9HOTX in( '0312400021320150', '0434970031994270')
 select * from [dbo].[JAY_BPF_FP_DATA] where Account_Number in ('0312400021320150', '0434970031994270')
  select top 100 * from [dbo].[BPF_CHGOFF_DATA] where account_no in ('0312400021320150', '0434970031994270')
    select top 100 * from [dbo].[vntg_payplan_book_noyr] where account_no in ('0312400021320150', '0434970031994270')

 --
 -- Account 0519050030035868 coming in our motor query, but not in Vijay
 --
 select top 100 * from  #TMP_APPS where Account_No =  '0519050030035868'
 select top 100 * from dbo.N9DEBTP_201507 where N9HOTX = ( '0519050030035868')
  select top 100 * from dbo.G1DEBTP_201507_SUBSET1 where G1E5CD = '45000018037'
 select * from [dbo].[JAY_BPF_FP_DATA] where Account_Number in ('0519050030035868')
  select top 100 * from [dbo].[BPF_CHGOFF_DATA] where account_no in ('0519050030035868')
    select top 100 * from [dbo].[vntg_payplan_book_noyr] where account_no in ('0519050030035868')


	--
	-- where in both queries ok '0705770024548964', 0704500022870677
	--  select top 100 * from  #TMP_APPS where Account_No like '%704500022870677%'
	select top 100 * from  #TMP_APPS where Account_No in ( '0705770024548964', '0704500022870677')
 select top 100 * from dbo.N9DEBTP_201507 where N9HOTX in ( '0705770024548964', '0704500022870677')
  select top 100 * from dbo.G1DEBTP_201507_SUBSET1 where G1E5CD in ('10000019911', '26000019939')
 select * from [dbo].[JAY_BPF_FP_DATA] where Account_Number in ('0705770024548964', '0704500022870677')
  select top 100 * from [dbo].[BPF_CHGOFF_DATA] where account_no in ('0705770024548964', '0704500022870677')
    select top 100 * from [dbo].[vntg_payplan_book_noyr] where account_no in ('0705770024548964', '0704500022870677')


	--
	-- accounts which Vijay has and we havent.  i.e. 0434970031994270  Motor
	--												0295870014690317 - Retail
	--                                             0434960031634430 -- REtail
	--0434960031634430
	-- select top 100 * from  #TMP_APPS where Account_No like '%43496003163443%'
	-- alternate account application file. stg.BARCLAYCARD_VNTG_ACCOUNT_DETAILS_BOOK
	-- select top 100 * from stg.BARCLAYCARD_VNTG_ACCOUNT_DETAILS_BOOK  where Account_No like '%295870014690317%'
	-- select top 100 * from dbo.N9DEBTP_201507  where N9HOTX like '%43496003163443%'
	select top 100 * from  #TMP_APPS where Account_No in ( '0434970031994270', '0295870014690317', '0434960031634430')
 select top 100 * from dbo.N9DEBTP_201507 where N9HOTX in ( '0434970031994270', '0295870014690317', '0434960031634430')
 select * from [dbo].[JAY_BPF_FP_DATA] where Account_Number in ('0434970031994270', '0295870014690317', '0434960031634430')
  select top 100 * from [dbo].[BPF_CHGOFF_DATA] where account_no in ('0434970031994270', '0295870014690317', '0434960031634430')
    select top 100 * from [dbo].[vntg_payplan_book_noyr] where account_no in ('0434970031994270', '0295870014690317', '0434960031634430')