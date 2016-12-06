
select Sum(NetbalanceFinance) from Phil.FPAccountsOriginalBalanceBI
where Anchordate = '31 Dec 2015'  and Division='Motor'
and PlanCreateDateCalculated between '01 Dec 2015' and '31 Dec 2015'


select Sum(NetbalanceFinance) from Phil.ForbearanceAccountsStageExtra
where COBDate = '31 Dec 2015'  and Division='Motor'
and PlanCreateDateCalculated between '01 Dec 2015' and '31 Dec 2015'
select top 100 * from Phil.ForbearanceAccountsStageExtra


select  top 100 * from Phil.FPAccountsChargeOffBI
where AccountNumber in ('0531650108674797', '0586750092782319', '0652700102256118','0509080100979762')


select  top 100 * from Phil.FPAccountsBI
where AccountNumber in ('0531650108674797', '0586750092782319', '0652700102256118')

select x.Anchordate, x.MOB, x.Division,  x.Charge_OffBalance summ, x.AccountNumber
from Phil.ChargeOffAccountsBI x
where x.MOB in (12)
and x.Anchordate = '31 Mar 2016'
and Division = 'Motor' 
order by 
and AccountNumber in ('0531650108674797', '0586750092782319', '0652700102256118')


group by x.Anchordate, x.MOB, x.Division

select y.Anchordate, y.MOB, y.Division, Sum(y.NetBalanceFinance) NetBalFin 
from
(
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsChargeOffBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = '31 Mar 2016'
and x.Charge_OffDate >= x.PlanCreateDateCalculated
and x.NetBalanceFinance is not null
union
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = '31 Mar 2016'
and x.Arrears_Level >= x.MOBArrearsLevel
) y
group by y.Anchordate, y.MOB, y.Division, y.Metric




select x.Anchordate, x.MOB, x.Division, x.Metric, sum(x.Charge_OffBalance) summ
from Phil.ChargeOffAccountsBI x
where x.MOB in (12, 24,36)
and x.Anchordate = '31 Mar 2016'
group by x.Anchordate, x.MOB, x.Division, x.Metric

select x.Anchordate, x.MOB, x.Division, x.Metric, x.Charge_OffBalance summ
from Phil.ChargeOffAccountsBI x
where x.MOB in (12, 24,36)
and x.Anchordate = '31 Mar 2016'
and x.MOB=12
-- group by x.Anchordate, x.MOB, x.Division, x.Metric





select y.Anchordate, y.MOB, y.Division, Sum(y.NetBalanceFinance) NetBalFin 
from
(
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsChargeOffBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = '29 Feb 2016'
and x.Charge_OffDate >= x.PlanCreateDateCalculated
and x.NetBalanceFinance is not null
union
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = '29 Feb 2016'
and x.Arrears_Level >= x.MOBArrearsLevel
) y
group by y.Anchordate, y.MOB, y.Division



select y.Anchordate, y.MOB, y.Division, Sum(y.NetBalanceFinance) NetBalFin 
from
(
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsChargeOffBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = '31 Jan 2016'
and x.Charge_OffDate >= x.PlanCreateDateCalculated
and x.NetBalanceFinance is not null
union
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = '31 Jan 2016'
and x.Arrears_Level >= x.MOBArrearsLevel
) y
group by y.Anchordate, y.MOB, y.Division


--
-- Comparison testing start
-- 
DECLARE @DateAnchor DATE = '31 Mar 2016' 
DECLARE @DateAnchorStart DATE = '01 Mar 2016' 
DECLARE @ConsolRunID INT = 120126 --- Dec=120123, Jan=120124(-2), Feb=-3(120125), Mar=-4(120126)
select y.Anchordate, y.MOB, y.Division, Sum(y.NetBalanceFinance) NetBalFin 
from
(
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsChargeOffBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = @DateAnchor
and x.Charge_OffDate >= x.PlanCreateDateCalculated
and x.NetBalanceFinance is not null
union 
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = @DateAnchor
and x.Arrears_Level >= x.MOBArrearsLevel
) y
group by y.Anchordate, y.MOB, y.Division


select y.Anchordate, y.MOB, y.Division, Sum(y.NetBalanceFinance) NetBalFinNew 
from
(
select x.RunID, AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric, x.MOBEndDate
from bi.GRCR_BPF_ForbearanceChargeOffFactDataConsolidated x
where x.MOB in (3,6,12,18)
-- and x.Anchordate = @DateAnchor
and x.RunID=  @ConsolRunID
and x.Charge_OffDate >= x.PlanCreateDateCalculated
and x.NetBalanceFinance is not null
union 
select x.RunID, AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric,x.MOBEndDate
from bi.GRCR_BPF_ForbearanceFactDataConsolidated x
where x.MOB in (3,6,12,18)
-- and x.Anchordate = @DateAnchor
and x.RunID=@ConsolRunID
and x.Arrears_Level >= x.MOBArrearsLevel
) y
group by y.Anchordate, y.MOB, y.Division


select x.Anchordate, x.MOB, x.Division,  sum(x.Charge_OffBalance) summWorkFact
from Phil.ChargeOffAccountsBI x
where x.MOB in (12,24,36)
and x.Anchordate = @DateAnchor
group by x.Anchordate, x.MOB, x.Division

select x.Anchordate, x.MOB, x.Division, sum(x.Charge_OffBalance) summNewFact
from bi.GRCR_BPF_ChargeOffFactDataConsolidated x
where x.MOB in (12,24,36)
-- and x.Anchordate = @DateAnchor
and x.RunID= @ConsolRunID
group by x.Anchordate, x.MOB, x.Division

-- original accs bal
select Division, Sum(NetBalanceFinance) origbal
from Phil.FPAccountsOriginalBalanceBI x
where  1 = 1
and x.PlanCreateDateCalculated between @DateAnchorStart and @DateAnchor
and x.Anchordate =@DateAnchor
group by Division


select Division, Sum(NetBalanceFinance) origbalnew
from bi.GRCR_BPF_ForbearanceFactDataConsolidated x
where  1 = 1
and x.PlanCreateDateCalculated between @DateAnchorStart and @DateAnchor
-- and x.Anchordate = @DateAnchor
and x.MOB=0
and x.RunID=@ConsolRunID
group by Division

--
--  Comparison testing end
--




select x.Anchordate, x.MOB, x.Division,  sum(x.Charge_OffBalance) summ
from Phil.ChargeOffAccountsBI x
where x.MOB in (12,24,36)
and x.Anchordate = '29 Feb 2016'
group by x.Anchordate, x.MOB, x.Division

select x.Anchordate, x.MOB, x.Division,  sum(x.Charge_OffBalance) summ
from Phil.ChargeOffAccountsBI x
where x.MOB in (12,24,36)
and x.Anchordate = '31 Jan 2016'
group by x.Anchordate, x.MOB, x.Division

select x.Anchordate, x.MOB, sum(x.Charge_OffBalance) summ
from Phil.ChargeOffAccountsBI x
where x.MOB in (12,24,36)
and x.Anchordate = '31 Mar 2016'
group by x.Anchordate, x.MOB

select x.Anchordate, x.MOB, x.Division,  sum(x.Charge_OffBalance) summ
from Phil.ChargeOffAccountsBI x
where x.MOB in (12,24,36)
and x.Anchordate = '31 Dec 2015'
group by x.Anchordate, x.MOB, x.Division



select count(*) from Phil.ChargeOffAccountsBI
select count(*) from Phil.FPAccountsChargeOffBI
 select count(*) from Phil.FPAccountsBI


 select y.Anchordate, y.MOB, y.Division, Sum(y.NetBalanceFinance) NetBalFin 
from
(
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsChargeOffBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = '31 Jan 2016'
and x.Charge_OffDate >= x.PlanCreateDateCalculated
and x.NetBalanceFinance is not null
union
select AnchorDate, PlanCreateDateCalculated, Division, NetBalanceFinance, AccountNumber, MOB, Metric
from Phil.FPAccountsBI x
where x.MOB in (3,6,12,18)
and x.Anchordate = '31 Jan 2016'
and x.Arrears_Level >= x.MOBArrearsLevel
) y
group by y.Anchordate, y.MOB, y.Division





--
--  Original Balance of FPs
--

-- this works START
select Division, Sum(NetBalanceFinance) origbal
from Phil.FPAccountsOriginalBalanceBI x
where  1 = 1
and x.PlanCreateDateCalculated between '01 Dec 2015' and '31 Dec 2015'
and x.Anchordate = '31 Dec 2015'
group by Division


select Division, Sum(NetBalanceFinance) origbal
from bi.GRCR_BPF_ForbearanceFactDataConsolidated x
where  1 = 1
and x.PlanCreateDateCalculated between '01 Dec 2015' and '31 Dec 2015'
and x.Anchordate = '31 Dec 2015'
and x.MOB=0
group by Division
-- this works END

select * from Phil.FPAccountsOriginalBalanceBI
 select * from bi.GRCR_BPF_ForbearanceFactDataConsolidated
select Division, Sum(NetBalanceFinance) origbal
from bi.GRCR_BPF_ForbearanceFactDataConsolidated x
where  1 = 1
and x.PlanCreateDateCalculated between '01 Dec 2015' and '31 Dec 2015'
--and x.Anchordate = '31 Dec 2015'
group by Division
-- and Division = 'Motor'


select Sum(Account_Open_Balance)
from Phil.FPAccountsBI x
where  1 = 1
and x.PlanCreateDateCalculated between '31 Dec 2015' and '31 Dec 2015'
--and x.Anchordate = '31 Dec 2015'
and Division = 'Motor'

select x.*
from Phil.ForbearanceAccountsStageExtra x
where  1 = 1
  -- and x.AccountNumber in ('0500280152274968')
-- and x.DataSource = 'N9'
and x.PlanCreateDateCalculated between '01 Dec 2015' and '31 Dec 2015'
and x.Division = 'Motor'



select * from Phil.FPAccountsChargeOffBI where AccountNumber= '0500280152274968'

select * from Phil.FPAccountsChargeOffBI where AccountNumber= '0500280152274968'


select * from Phil.FPAccountsBI where AccountNumber = '1400470113061716'
select top 100 x.* from Phil.FPAccountsBI x 
where Datasource='N9'

	SELECT div.BPFDivisionAttrKeyID, 
		div.Division, 
		jr.Run, 
		j.CobDate, 
		DATEADD(month, DATEDIFF(month, 0, j.CobDate), 0) as MonthStart
	FROM bi.BPFDivisionAttrSCD div
	CROSS JOIN loader.Job j 
	INNER JOIN loader.JobRun jr on jr.JobId = j.JobId
	and j.CobDate='31 Dec 2015'
	WHERE j.JobDefinitionCode = 'BPF_LOAD_VINTAGE_FPS_FACT'
	AND jr.RunStatus = 'S'
