declare @datetest DATE = '12 Jun 2014'


-- select DATEPART(
declare @month DATE  = '01' + DATENAME(month, @datetest) + DATENAME(year, @datetest)

select @month


-- 12 MOB '0502190032906291'
select top 1000 * from stg.BPF_JAY_BPF_FP_ACC
where Run=2768
-- where 1 = 1
--and Account_Open_Month='AUG14'
-- and Division='Motor'
and Account_Number in( '0502190032906291', '0502190113491148', '0681570105454589', '0680290097643799', '0506810106679914', '0625380106273668')
order by Account_Open_Balance


-- select max(Run) from stg.BPF_CHARGEOFF_DATA
select top 1000 * from stg.BPF_CHARGEOFF_DATA
where Run=1018 
-- and ChargeOff_Date='01 Aug 2014'
and Account_No in ( '0502190032906291', '0502190113491148', '0681570105454589', '0680290097643799', '0506810106679914', '0625380106273668')

select top 1000 x.Run,  j.CobDate,  x.Account_No, x.account_open_month, x.grip, x.grip_arrears_level, x.impair_flag, x.NetBalance, x.coff_flag
-- select top 1000 j.CobDate,  x.*
from stg.BARCLAYCARD_IMPAIR_BASE x
inner join loader.JobRun jr
on jr.Run = x.Run
inner join loader.Job j
on j.JobId = jr.JobId
where x.Account_No in ('0502190113491148', '0502190032906291', '0681570105454589', '0680290097643799', '0506810106679914', '0625380106273668', '0624470026496365')
and jr.RunStatus = 'S'
and x.Run in (4423,4493)
order by Account_No, x.Run desc


-- select all accounts in Aug impair base which are not in Julys file
select y.*
from stg.BARCLAYCARD_IMPAIR_BASE y
where not exists (select top 1 1  from stg.BARCLAYCARD_IMPAIR_BASE g
	where g.Account_No = y.Account_No
	and cast  (g.account_open_month as date)  between '01 Feb 2015' and '28 Feb 2015'
	and g.Run=4423
	)
and y.Run=4493
and cast (y.account_open_month as date) between '01 Feb 2015' and '28 Feb 2015'

-- check also against both runs of impair base
select top 100 * from stg.BPF_JAY_BPF_FP_ACC where Account_Number in ('1400890125408375', '0504160105874187')

-- '0511610071846537' (Motor) new FP for Jul 2015.
--
-- CANNOT GET THIS DATA FROM IMPAIR BASE for account 0511610071846537 - must use the view
-- USE THE VIEW

--
--			FP(PlanCreateDate on Debt files)     CHARGE-OFF
	--		1										0
	--		1										1
	--		0										1			-- impair base only		

-- So union FP view data with existing charge-off data.
-- Where the account exists in both datasets merege (i.e charge-off date and PlanCreateDate
select j.CobDate, x.* from stg.BARCLAYCARD_IMPAIR_BASE x
inner join loader.JobRun jr
on jr.Run = x.Run
inner join loader.Job j
on j.JobId = jr.JobId
where Account_No in (  '0506810106679914' ,'0511610071846537', '0504160105874187', '0681570105454589', '0680290097643799') ---'1400890125408375'
and x.Run in (4423,4493, 4425)
and jr.RunStatus = 'S'
order by x.Account_No, j.CobDate desc

--select top 100 * from [bi].[vwGRCR_BPF_NewFPs_PortfolioFlow_Detail]
--where COBDate='201507'
--and  AccountNumber =  '0511610071846537'

select * from stg.G1DEBTP where G1E5CD='7000023134'
select  * from stg.N9DEBTP  where N9HOTX='0511610071846537'
select * from stg.G1DEBTP where G1E5CD='5000046712'
select  * from stg.N9DEBTP  where N9HOTX='0680290097643799'

select top 1000 * from stg.BPF_JAY_BPF_FP_ACC where Account_Number in ('0511610071846537', '0504160105874187','0506810106679914', '0680290097643799', '1400850092027632')
order by Account_Number
select top 1000 * from stg.BPF_CHARGEOFF_DATA where Account_No in ('0511610071846537', '0504160105874187','0506810106679914', '0680290097643799')

select  * from stg.N9DEBTP  where N9HOTX='0506810106679914'
select * from stg.G1DEBTP where G1E5CD='30000054647'

select  * from stg.N9DEBTP  where N9HOTX='0504160105874187'
select * from stg.G1DEBTP where G1E5CD='21000054097'

select  * from stg.N9DEBTP  
inner join loader.JobRun jr
on jr.Run =  stg.N9DEBTP.Run
inner join loader.Job j
on j.JobId = jr.JobId
where N9HOTX='0681570105454589'

select * 
from stg.G1DEBTP 
inner join loader.JobRun jr
on jr.Run =  stg.G1DEBTP.Run
inner join loader.Job j
on j.JobId = jr.JobId
where G1E5CD='27000053640'

-- '0511610071846537' new FP for Jul 2015.
-- CANNOT GET THIS DATA FROM IMPAIR BASE
-- USE THE VIEW --- END


select j.CobDate, b.* from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR b
inner join loader.JobRun jr
on jr.Run = b.Run
inner join loader.Job j
on j.JobId = jr.JobId
where b.account_no in ('0956790124565573','0414710125384457','9052100124504487')
and j.CobDate= '31 Aug 2015'

select count(*) from stg.BARCLAYCARD_IMPAIR_BASE x where x.A

and y.product_code in ('CLUB','FRREVL','FTRBPL','FTRNBP','FTMSEC','FTMUBL','FTMUNB')


 CASE  WHEN N9AWCE IN ('CLUB','FRREVL','FTRBPL','FTRNBP') THEN 'Retail'
              WHEN N9AWCE IN ('FTMSEC','FTMUBL','FTMUNB') THEN 'Motor'

select top 1000 j.CobDate, x.* from stg.VNTG_ARRSLVLGRIP_BOOK x
inner join loader.JobRun jr
on jr.Run = x.Run
inner join loader.Job j
on j.JobId = jr.JobId
where Account_No in ('0502190113491148', '0502190032906291', '0681570105454589', '0680290097643799', '0506810106679914', '0625380106273668')
and jr.RunStatus = 'S'
order by Account_No, x.Run desc

select fct.* from bi.GRCR_VintageChargeOffFPFactData fct
where AccountNumber in ('0506810106679914', '0625380106273668', '0681570105454589')




select fct.* from bi.GRCR_VintageChargeOffFPFactData fct
where not exists 
( select top 1 1 from 
	stg.BPF_JAY_BPF_FP_ACC y
where  y.Account_Number= fct.AccountNumber
and y.Run=2768
)
and fct.RunId=4500
order by fct.AccountOpenMonth --  fct.AccountNumber

select * from loader.JobRun
where Run in(
197,
25,
1040,
20,
1435
)
select * from loader.Job where JobId=25


select * from stg.BARCLAYCARD_VNTG_NETBALANCE_FINANCE_NOYR
where account_no='0502190032906291'


and Account_Open_Month='AUG14'
and Division='Motor'
order by Account_Open_Balance

and f.ChargeOffDate >= f.AccountOpenMonth

