drop table #TMP_APPS
SELECT Account_No, [Ind_Code], MIN(Req_Loan_Amt) MIN_Req_Loan_Amount
INTO  #TMP_APPS
FROM [GRCR_DEV].[dbo].[BPFWH_APPFILE_JUL2015]
WHERE Bus_decision = 'ACCEPT'
and len(Account_No) > 0
AND Open_Month <> ''
group by Account_No, [Ind_Code]
  --AND pay_plan_m127 <> 2



SELECT app.[Ind_Code], chg.chargeoff_date, chg.Balance, kn.*,
case when app.Ind_Code = '50' Then
	'Motor'
 when app.Ind_Code in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22) then 'Retail'
 else'Unknown'
 END ProductGRp,
 DATEDIFF(month, dateadd(mm, -1, cast(kn.krfbdt as date)), cast('31JUL2015' as date)) MOB
 FROM [dbo].[BPF_CHGOFF_DATA] chg
  JOIN #TMP_APPS  app
  ON app.Account_No = chg.account_no
  JOIN [dbo].[KNTRSKPF] kn
  ON kn.krkntn = chg.account_no
  JOIN [dbo].[vntg_payplan_book_noyr] pp
  ON pp.account_no = chg.account_no
 -- INNER JOIN dbo.vntg_arrslvlgrip_book_noyr_m125_m129 arrs on app.Account_No = arrs.account_no
  --WHERE try_convert(date, chg.chargeoff_date) not in( '20150801', '20150901')
  WHERE try_convert(date, chg.chargeoff_date) <= '20150731'
  -- WHERE chg.chargeoff_date not in ('01AUG2015','01SEP2015') 
   and LEN(LTRIM(RTRIM(kn.krfbdt))) > 0
  AND DATEADD(month, -1, kn.krfbdt) >= '20140701'
  AND DATEADD(month, -1, kn.krfbdt) < '20140801'
  --where  try_convert(date, chg.chargeoff_date) <= '20150731'
  --AND app.Bus_decision = 'ACCEPT'
  --AND app.Open_Month <> ''
  AND pay_plan_m127 <> 2
  --and arrs.arrears_level_m127 = 3
  -- and app.Account_No = '0449070095363463' 
  --group by app.Account_No
 -- having count(*) > 1
